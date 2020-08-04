//
//  MyFavoritesViewController.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/8/11.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class MyFavoritesViewController: ASDKViewController<ASDisplayNode> {
    
    private let tableNode = ASTableNode(style: .plain)
    
    private var dataSource: [FavoriteItem] = []
    
    override init() {
        super.init(node: ASDisplayNode())
        node.addSubnode(tableNode)
        tableNode.dataSource = self
        tableNode.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        tableNode.frame = node.bounds
        tableNode.backgroundColor = .clear
        tableNode.view.separatorStyle = .none
        
        navigationItem.title = "收藏"
        let rightButtonItem = UIBarButtonItem(image: UIImage.SVGImage(named: "icons_outlined_addoutline"), style: .done, target: self, action: #selector(handleRightBarButtonTapped(_:)))
        navigationItem.rightBarButtonItem = rightButtonItem
    }
}

// MARK: - Event Handlers
extension MyFavoritesViewController {
    
    @objc private func handleRightBarButtonTapped(_ sender: Any) {
        
    }
    
}

// MARK: - ASTableDelegate & ASTableDataSource
extension MyFavoritesViewController: ASTableDataSource, ASTableDelegate {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let model = dataSource[indexPath.row]
        let block: ASCellNodeBlock = {
            return MyFavoritesCellNode(favItem: model)
        }
        return block
    }
}

struct FavoriteItem {
    
    var type: FavoriteType
    
    var fromUserID: String?
    
    var toUserID: String?
    
    var time: Int
    
    func attributedStringForTime() -> NSAttributedString {
        let timeString = "Today"
        return NSAttributedString(string: timeString, attributes: [
            .font: UIFont.systemFont(ofSize: 11),
            .foregroundColor: Colors.DEFAULT_TEXT_GRAY_COLOR
        ])
    }
    
    func attributedStringForAuthor() -> NSAttributedString? {
        guard let fromUserID = fromUserID else {
            return nil
        }
        return NSAttributedString(string: fromUserID, attributes: [
            .font: UIFont.systemFont(ofSize: 11),
            .foregroundColor: Colors.DEFAULT_TEXT_GRAY_COLOR
        ])
    }
}

enum FavoriteType {
    case text
    case location
    case url
    case weApp
    case tv
    case product
    
}
