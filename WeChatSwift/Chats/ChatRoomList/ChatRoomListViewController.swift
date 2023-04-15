//
//  ChatRoomListViewController.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/15.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class ChatRoomListViewController: ASDKViewController<ASDisplayNode> {
    
    private let tableNode = ASTableNode()
    
    private var dataSource: [ChatRoomListItemModel] = []
    
    override init() {
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
        
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        tableNode.backgroundColor = .clear
        tableNode.frame = node.bounds
        tableNode.view.separatorStyle = .none
        
        navigationItem.title = "群聊"
        
    }
}

// MARK: - ASTableDelegate & ASTableDataSource
extension ChatRoomListViewController: ASTableDelegate, ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let model = dataSource[indexPath.row]
        let isLastCell = indexPath.row == dataSource.count - 1
        let block: ASCellNodeBlock = {
            return WCTableCellNode(model: model, isLastCell: isLastCell)
        }
        return block
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return dataSource.count == 0 ? 0.01 : 50.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if dataSource.count == 0 {
            return nil
        }
        
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.text = "\(dataSource.count)个群聊"
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.textColor = UIColor(hexString: "#808080")
        titleLabel.frame = CGRect(x: 0, y: 15, width: tableView.bounds.width, height: 20)
        
        let footerView = UIView()
        footerView.addSubview(titleLabel)
        return footerView
    }
}
