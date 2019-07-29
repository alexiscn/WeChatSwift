//
//  ContactInfoViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/29.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class ContactInfoViewController: ASViewController<ASTableNode> {
    
    private let contact: ContactModel
    
    private var dataSource: [ContactInfoGroup] = []
    
    init(contact: ContactModel) {
        self.contact = contact
        super.init(node: ASTableNode(style: .grouped))
        setupDataSource()
        node.dataSource = self
        node.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = Colors.backgroundColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDataSource() {
        dataSource.append(ContactInfoGroup(items: [.profile, .remark]))
        dataSource.append(ContactInfoGroup(items: [.moments, .more]))
        dataSource.append(ContactInfoGroup(items: [.sendMessage, .voip]))
    }
}

extension ContactInfoViewController: ASTableDelegate, ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return dataSource.count
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].items.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let info = dataSource[indexPath.section].items[indexPath.row]
        let block: ASCellNodeBlock = { [weak self] in
            guard let strongSelf = self else { return ASCellNode() }
            switch info {
            case .profile:
                return ContactInfoProfileCellNode(contact: strongSelf.contact)
            case .sendMessage, .voip:
                return ContactInfoButtonCellNode(info: info)
            case .remark, .moments, .more:
                return ContactInfoCellNode(info: info)
            }
        }
        return block
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}

class ContactInfoProfileCellNode: ASCellNode {
    
    private let contact: ContactModel
    
    private let avatarNode = ASImageNode()
    
    private let nicknameNode = ASTextNode()
    private let wechatIDNode = ASTextNode()
    private let regionNode = ASTextNode()
    
    init(contact: ContactModel) {
        self.contact = contact
        super.init()
        automaticallyManagesSubnodes = true
        
        avatarNode.image = contact.image
        
        let nameAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22, weight: .medium),
            NSAttributedString.Key.foregroundColor: Colors.black
        ]
        nicknameNode.attributedText = NSAttributedString(string: contact.name, attributes: nameAttributes)
        
        let wechatIDAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
            NSAttributedString.Key.foregroundColor: UIColor(white: 0, alpha: 0.5)
        ]
        wechatIDNode.attributedText = NSAttributedString(string: "微信号：", attributes: wechatIDAttributes)
        
        regionNode.attributedText = NSAttributedString(string: "国家：", attributes: wechatIDAttributes)
    }
    
    override func didLoad() {
        super.didLoad()
        backgroundColor = Colors.white
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        avatarNode.style.preferredSize = CGSize(width: 64.0, height: 64.0)
        
        let vertical = ASStackLayoutSpec.vertical()
        vertical.spacing = 3.0
        vertical.children = [nicknameNode, wechatIDNode, regionNode]
        
        let horizontal = ASStackLayoutSpec.horizontal()
        horizontal.spacing = 16.0
        horizontal.children = [avatarNode, vertical]
        
        let insets = UIEdgeInsets(top: 10, left: 16, bottom: 28, right: 16)
        return ASInsetLayoutSpec(insets: insets, child: horizontal)
    }
    
}

class ContactInfoCellNode: ASCellNode {
    
    private let titleNode = ASTextNode()
    
    private let arrowNode = ASImageNode()
    
    init(info: ContactInfo) {
        super.init()
        automaticallyManagesSubnodes = true
        
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17),
            NSAttributedString.Key.foregroundColor: Colors.DEFAULT_TEXT_COLOR
        ]
        titleNode.attributedText = NSAttributedString(string: info.title, attributes: attributes)
        arrowNode.image = UIImage.SVGImage(named: "icons_outlined_arrow")
    }
    
    override func didLoad() {
        super.didLoad()
        backgroundColor = Colors.white
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        arrowNode.style.preferredSize = CGSize(width: 12, height: 24)
        
        let spacer = ASLayoutSpec()
        spacer.style.flexGrow = 1.0
        
        let stack = ASStackLayoutSpec.horizontal()
        stack.children = [titleNode, spacer, arrowNode]
        
        let insets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        return ASInsetLayoutSpec(insets: insets, child: stack)
    }
}

class ContactInfoButtonCellNode: ASCellNode {
    
    private let buttonNode = ASButtonNode()
    
    init(info: ContactInfo) {
        super.init()
        automaticallyManagesSubnodes = true
        
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .semibold),
            NSAttributedString.Key.foregroundColor: Colors.DEFAULT_LINK_COLOR
        ]
        let attrbutedText = NSAttributedString(string: info.title, attributes: attributes)
        buttonNode.setAttributedTitle(attrbutedText, for: .normal)
        buttonNode.setImage(info.image, for: .normal)
        buttonNode.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(Colors.DEFAULT_LINK_COLOR)
        buttonNode.imageNode.style.preferredSize = CGSize(width: 20, height: 20)
    }
    
    override func didLoad() {
        super.didLoad()
        backgroundColor = Colors.white
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        buttonNode.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 56)
        return ASInsetLayoutSpec(insets: .zero, child: buttonNode)
    }
}

enum ContactInfo {
    case profile
    case remark
    case moments
    case more
    case sendMessage
    case voip
    
    var title: String {
        switch self {
        case .profile:
            return ""
        case .remark:
            return "设置备注和标签"
        case .moments:
            return "朋友圈"
        case .more:
            return "更多信息"
        case .sendMessage:
            return "发消息"
        case .voip:
            return "音视频通话"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .sendMessage:
            return UIImage.SVGImage(named: "icons_outlined_chats")
        case .voip:
            return UIImage.SVGImage(named: "icons_outlined_videocall")
        default:
            return nil
        }
    }
}

struct ContactInfoGroup {
    var items: [ContactInfo]
}
