//
//  SettingFontSizeViewController.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/8/4.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class SettingFontSizeViewController: ASViewController<ASDisplayNode> {
    
    private let tableNode: ASTableNode
    
    private var dataSource: [Message] = []
    
    init() {
        
        tableNode = ASTableNode(style: .plain)
        
        super.init(node: ASDisplayNode())
        
        node.addSubnode(tableNode)
        tableNode.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableNode.delegate = self
        tableNode.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        tableNode.backgroundColor = .clear
        tableNode.view.separatorStyle = .none
        
        navigationItem.title = LocalizedString("Setting_FontSize_Title")
        let cancelButton = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(handleCancelButtonTapped(_:)))
        cancelButton.tintColor = .black
        navigationItem.leftBarButtonItem = cancelButton
        
        setupDataSource()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableNode.frame = view.bounds
    }
    
    private func setupDataSource() {
        var messages: [Message] = []
        let myID = AppContext.current.userID
        let weChatID = "111"
        messages.append(buildMessage(with: "预览字体大小", from: myID, sessionID: weChatID))
        messages.append(buildMessage(with: "拖动下面的滑块，可设置字体大小", from: weChatID, sessionID: weChatID))
        messages.append(buildMessage(with: "设置后，会改变聊天、菜单和朋友圈中的字体大小。如果在使用过程中存在问题或意见，可反馈给微信团队。", from: weChatID, sessionID: weChatID))
        dataSource = messages
    }
    
    func buildMessage(with text: String, from: String, sessionID: String) -> Message {
        let msg = Message()
        msg.chatID = sessionID
        msg.senderID = from
        msg.content = .text(text)
        return msg
    }
}

// MARK: - Event Handlers

extension SettingFontSizeViewController {
    
    @objc private func handleCancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - ASTableDelegate & ASTableDataSource
extension SettingFontSizeViewController: ASTableDelegate, ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let message = dataSource[indexPath.row]
        let block: ASCellNodeBlock = {
            switch message.content {
            case .text(let text):
                let contentNode = TextContentNode(message: message, text: text)
                return MessageCellNode(message: message, contentNode: contentNode)
            default:
                return ASCellNode()
            }
        }
        return block
    }
}
