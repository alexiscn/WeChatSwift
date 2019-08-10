//
//  NearbyPeopleViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/8.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit
import WXActionSheet
import CoreLocation

class NearbyPeopleViewController: ASViewController<ASDisplayNode> {
    
    private let tableNode = ASTableNode(style: .plain)
    
    private var dataSource: [NearbyPeople] = []
    
    private var errorPlaceholder: NearbyPeopleErrorPlaceholder?
    
    init() {
        super.init(node: ASDisplayNode())
        node.addSubnode(tableNode)
        tableNode.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableNode.delegate = self
        tableNode.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        tableNode.frame = view.bounds
        tableNode.backgroundColor = .clear
        tableNode.view.separatorStyle = .none
        
        navigationItem.title = "附近的人"
        let moreButtonItem = UIBarButtonItem(image: Constants.moreImage, style: .done, target: self, action: #selector(moreButtonClicked))
        navigationItem.rightBarButtonItem = moreButtonItem
    }
    
    private func checkLocation() {
        let status = CLLocationManager.authorizationStatus()
        if status == .denied {
            
        }
    }
}

// MARK: - Event Handlers

extension NearbyPeopleViewController {
    
    @objc private func moreButtonClicked() {
        let actionSheet = WXActionSheet(cancelButtonTitle: "取消")
        actionSheet.add(WXActionSheetItem(title: "只看女生", handler: { _ in
            
        }))
        actionSheet.add(WXActionSheetItem(title: "只看男生", handler: { _ in
            
        }))
        actionSheet.add(WXActionSheetItem(title: "查看全部", handler: { _ in
            
        }))
        actionSheet.add(WXActionSheetItem(title: "附近打招呼的人", handler: { _ in
            
        }))
        actionSheet.add(WXActionSheetItem(title: "清除位置信息并退出", handler: { _ in
            
        }))
        actionSheet.show()
    }
    
}

// MARK: - ASTableDelegate & ASTableDataSource
extension NearbyPeopleViewController: ASTableDelegate, ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let people = dataSource[indexPath.row]
        let block: ASCellNodeBlock = {
            return NearbyPeopleCellNode(people: people)
        }
        return block
    }
}
