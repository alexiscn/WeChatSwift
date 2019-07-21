//
//  AboutViewController.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/7/21.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class AboutViewController: ASViewController<ASTableNode> {
    
    private var dataSource: [AboutTableModel] = []

    init() {
        super.init(node: ASTableNode())
        node.dataSource = self
        node.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let header = UIView()
        header.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 232)
        let headerNode = AboutHeaderNode()
        headerNode.frame = header.bounds
        header.addSubnode(headerNode)
        
        node.backgroundColor = Colors.white
        node.view.separatorStyle = .none
        node.view.tableHeaderView = header
        
        dataSource = AboutTableModel.allCases
        node.reloadData()
    }
    
}

extension AboutViewController: ASTableDelegate, ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let model = dataSource[indexPath.row]
        let block: ASCellNodeBlock = {
            return AboutCellNode(model: model)
        }
        return block
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: false)
    }
}

class AboutCellNode: ASCellNode {
    
    private let titleNode: ASTextNode
    
    private let arrowNode: ASImageNode
    
    private let separatorLine: ASDisplayNode
    
    init(model: AboutTableModel) {
        titleNode = ASTextNode()
        arrowNode = ASImageNode()
        separatorLine = ASDisplayNode()
        super.init()
        automaticallyManagesSubnodes = true
        titleNode.attributedText = model.attributedString()
        arrowNode.image = UIImage.SVGImage(named: "icons_outlined_arrow")
        separatorLine.backgroundColor = UIColor(hexString: "#ECECEC")
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        titleNode.style.spacingBefore = 36
        arrowNode.style.preferredSize = CGSize(width: 12, height: 24)
        arrowNode.style.spacingAfter = 36
        
        separatorLine.style.preferredSize = CGSize(width: Constants.screenWidth - 72, height: Constants.lineHeight)
        separatorLine.style.layoutPosition = CGPoint(x: 36, y: 56 - Constants.lineHeight)
        
        let spacer = ASLayoutSpec()
        spacer.style.flexGrow = 1.0
        
        let stack = ASStackLayoutSpec.horizontal()
        stack.alignItems = .center
        stack.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 56)
        stack.children = [titleNode, spacer, arrowNode]
        
        let layout = ASAbsoluteLayoutSpec(children: [stack, separatorLine])
        return layout
    }
}

class AboutHeaderNode: ASDisplayNode {
    
    private let logoButton: ASButtonNode
    
    private let nameNode: ASTextNode
    
    private let versionNode: ASTextNode
    
    override init() {
        
        logoButton = ASButtonNode()
        
        nameNode = ASTextNode()
        
        versionNode = ASTextNode()
        
        super.init()
        
        automaticallyManagesSubnodes = true
        
        logoButton.setImage(UIImage(named: "About_WeChat_AppIcon_64x64_"), for: .normal)
        nameNode.attributedText = NSAttributedString(string: "微信 WeChat", attributes: [
            .font: UIFont.systemFont(ofSize: 22, weight: .medium),
            .foregroundColor: UIColor(white: 0, alpha: 0.9)
        ])
        versionNode.attributedText = NSAttributedString(string: "Version 7.0.4", attributes: [
            .font: UIFont.systemFont(ofSize: 17),
            .foregroundColor: UIColor(white: 0, alpha: 0.9)
        ])
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        logoButton.style.preferredSize = CGSize(width: 64, height: 64)
        
        let topSpacer = ASLayoutSpec()
        topSpacer.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 48)
        
        let logoBottomSpacer = ASLayoutSpec()
        logoBottomSpacer.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 32)
        
        let bottomSpacer = ASLayoutSpec()
        bottomSpacer.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 32)
        
        let nameBottomSpacer = ASLayoutSpec()
        nameBottomSpacer.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 8)
        
        let stack = ASStackLayoutSpec.vertical()
        stack.alignItems = .center
        stack.children = [topSpacer, logoButton, logoBottomSpacer, nameNode, nameBottomSpacer, versionNode, bottomSpacer]
        
        return stack
    }
}
