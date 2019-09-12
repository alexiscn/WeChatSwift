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
        setupDataSource()
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
    
    private func setupDataSource() {
        dataSource = MockFactory.shared.nearbys()
    }
}

// MARK: - Event Handlers

extension NearbyPeopleViewController {
    
    @objc private func moreButtonClicked() {
        let actionSheet = WXActionSheet(cancelButtonTitle: LanguageManager.Common.cancel())
        // 只看女生
        let girlOnlyTitle = LocalizedString("LBS_Clear_MyLBS_Data_Button_Girl")
        actionSheet.add(WXActionSheetItem(title: girlOnlyTitle, handler: { _ in
            
        }))
        // 只看男生
        let boyOnlyTitle = LocalizedString("LBS_Clear_MyLBS_Data_Button_Boy")
        actionSheet.add(WXActionSheetItem(title: boyOnlyTitle, handler: { _ in
            
        }))
        // 查看全部
        let allTitle = LocalizedString("LBS_Clear_MyLBS_Data_Button_All")
        actionSheet.add(WXActionSheetItem(title: allTitle, handler: { _ in
            
        }))
        // 附近打招呼的人
        let sayHelloTitle = LocalizedString("LBS_SayHello_MyLBS_Data_Button_All")
        actionSheet.add(WXActionSheetItem(title: sayHelloTitle, handler: { _ in
            
        }))
        // 清除位置信息并退出
        let clearTitle = LocalizedString("LBS_Clear_MyLBS_Data_Button_Text")
        actionSheet.add(WXActionSheetItem(title: clearTitle, handler: { _ in
            
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
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: false)
        
        let people = dataSource[indexPath.row]
        let contactInfoVC = ContactInfoViewController(contact: people.toContact())
        navigationController?.pushViewController(contactInfoVC, animated: true)
    }
}
