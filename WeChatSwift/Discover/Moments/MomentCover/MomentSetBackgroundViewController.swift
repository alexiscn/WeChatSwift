//
//  MomentSetBackgroundViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/16.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class MomentSetBackgroundViewController: ASViewController<ASDisplayNode> {
    
    private let tableNode = ASTableNode()
    
    private var dataSource: [MomentBackgroundGroup] = []
    
    init() {
        super.init(node: ASDisplayNode())
        node.addSubnode(tableNode)
        tableNode.dataSource = self
        tableNode.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = UIColor(hexString: "#303030")
        tableNode.backgroundColor = .clear
        
        navigationItem.title = "更换相册封面"
    }
}

// MARK: - ASTableDelegate & ASTableDataSource
extension MomentSetBackgroundViewController: ASTableDelegate, ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let group = dataSource[indexPath.row]
        let block: ASCellNodeBlock = {
            return MomentSetBackgroundCellNode(group: group)
        }
        return block
    }
    
}
