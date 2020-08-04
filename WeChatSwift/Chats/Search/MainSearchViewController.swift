//
//  MainSearchViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/19.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class MainSearchViewController: ASDKViewController<ASDisplayNode> {
    
    var searchBar: UISearchBar?
    
    private var dataSource: [FTSSearchResult] = []
    
    private let tableNode = ASTableNode(style: .grouped)
    
    private let searchGuideNode: MainSearchGuideNode
    
    override init() {
        
        searchGuideNode = MainSearchGuideNode()
        
        super.init(node: ASDisplayNode())
        
        //node.addSubnode(tableNode)
        //searchGuideNode.backgroundColor = .red
        node.addSubnode(searchGuideNode)
        tableNode.dataSource = self
        tableNode.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = .init(rawValue: 0)
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        searchGuideNode.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
    }
}

// MARK: - ASTableDelegate & ASTableDataSource
extension MainSearchViewController: ASTableDelegate, ASTableDataSource {
    
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
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: false)
    }
}

extension MainSearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        view.isHidden = false
    }
}

enum FTSSearchResult {
    case contacts([Contact])
    case chats([Message])
}
