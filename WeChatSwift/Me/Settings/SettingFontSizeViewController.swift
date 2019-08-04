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
        navigationItem.title = "设置字体大小"
        
        
    }
    
    private func setupDataSource() {
//        let message = Message()
//        message.content = .text("预览字体大小")
//
//        message.content = .text("拖动下面的滑块，可设置字体大小")
//
//        message.content = .text("设置后，会改变聊天、菜单和朋友圈中的字体大小。如果在使用过程中存在问题或意见，可反馈给微信团队。")
    }
}

extension SettingFontSizeViewController: ASTableDelegate, ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let block: ASCellNodeBlock = {
            return ASCellNode()
        }
        return block
    }
}
