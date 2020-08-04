//
//  AddContactViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/4.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class AddContactViewController: ASDKViewController<ASDisplayNode> {
    
    private let tableNode = ASTableNode(style: .grouped)
    
    private var dataSource: [AddContactSource] = []
    
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
        
        navigationItem.title = LocalizedString("FF_Entry_AddFriend") //"添加朋友"
        
        let tableHeader = UIView()
        tableHeader.frame = CGRect(x: 0, y: 0, width: Constants.screenWidth, height: 108)
        
        let searchNode = AddContactSearchNode()
        searchNode.qrCodeHandler = {
            
        }
        searchNode.frame = tableHeader.bounds
        tableHeader.addSubnode(searchNode)
        
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        tableNode.frame = view.bounds
        tableNode.backgroundColor = .clear
        tableNode.view.separatorStyle = .none
        tableNode.view.tableHeaderView = tableHeader
        
        setupDataSource()
    }
    
    private func setupDataSource() {
        dataSource = [.radar, .faceToFaceGroup, .scan, .phoneContacts, .officialAccounts, .enterpriseContacts]
    }
    
}

extension AddContactViewController: ASTableDelegate, ASTableDataSource {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let model = dataSource[indexPath.row]
        let block: ASCellNodeBlock = {
            return AddContactCellNode(model: model)
        }
        return block
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: false)
        
        let model = dataSource[indexPath.row]
        switch model {
        case .radar:
            let radarSearchVC = RadarSearchViewController()
            navigationController?.pushViewController(radarSearchVC, animated: true)
        default:
            break
        }
    }
}
