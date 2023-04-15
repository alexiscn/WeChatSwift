//
//  PurchasedEmoticonViewController.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/17.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit
import WXActionSheet

class PurchasedEmoticonViewController: ASDKViewController<ASDisplayNode> {
    
    private let tableNode = ASTableNode()
    
    override init() {
        super.init(node: ASDisplayNode())
        node.addSubnode(tableNode)
        tableNode.delegate = self
        tableNode.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        tableNode.frame = node.bounds
        tableNode.backgroundColor = .clear
        tableNode.view.separatorStyle = .none
        
        navigationItem.title = LocalizedString("PurchasedEmoticonRecordTitle")
        
        let rightButton = UIBarButtonItem(image: Constants.moreImage, style: .plain, target: self, action: #selector(handleRightButtonClicked))
        navigationItem.rightBarButtonItem = rightButton
    }
    
}

// MARK: - Event Handlers
extension PurchasedEmoticonViewController {
    
    @objc private func handleRightButtonClicked() {
        let actionSheet = WXActionSheet(cancelButtonTitle: LanguageManager.Common.cancel())
        actionSheet.add(WXActionSheetItem(title: "恢复购买记录", handler: { _ in
            
        }))
        actionSheet.show()
    }
    
}

// MARK: - ASTableDelegate & ASTableDataSource
extension PurchasedEmoticonViewController: ASTableDelegate, ASTableDataSource {
    
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
