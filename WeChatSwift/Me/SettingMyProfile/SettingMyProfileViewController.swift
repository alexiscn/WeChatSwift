//
//  SettingMyProfileViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/28.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class SettingMyProfileViewController: ASDKViewController<ASDisplayNode> {
    
    private let tableNode = ASTableNode(style: .grouped)
    
    override init() {
        super.init(node: ASDisplayNode())
        node.addSubnode(tableNode)
        tableNode.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableNode.dataSource = self
        tableNode.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        tableNode.frame = node.bounds
        tableNode.backgroundColor = .clear
        
        navigationItem.title = "个人信息"
    }
    
}

extension SettingMyProfileViewController: ASTableDelegate, ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 0
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let block: ASCellNodeBlock = {
            return ASCellNode()
        }
        return block
    }
}
