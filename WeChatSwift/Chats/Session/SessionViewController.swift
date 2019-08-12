//
//  SessionViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/3.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class SessionViewController: ASViewController<ASDisplayNode> {
    
    private let tableNode = ASTableNode(style: .plain)
    
    private var menuFloatView: SessionMoreFrameFloatView?
    
    init() {
        super.init(node: ASDisplayNode())
        
        node.addSubnode(tableNode)
        tableNode.dataSource = self
        tableNode.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var dataSource: [Session] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        node.view.isUserInteractionEnabled = true
        tableNode.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableNode.view.separatorStyle = .none
        tableNode.frame = view.bounds
        tableNode.backgroundColor = .clear
        dataSource = MockFactory.shared.sessions()
        tableNode.reloadData()
        
        let rightButtonItem = UIBarButtonItem(image: UIImage.SVGImage(named: "icons_outlined_addoutline"), style: .done, target: self, action: #selector(handleRightBarButtonTapped(_:)))
        navigationItem.rightBarButtonItem = rightButtonItem
        navigationItem.title = "微信"
    }
    
    private func showMoreMenu() {
        if menuFloatView == nil {
            let y = Constants.statusBarHeight + 44
            let frame = CGRect(x: 0, y: y, width: view.bounds.width, height: view.bounds.height - y)
            menuFloatView = SessionMoreFrameFloatView(frame: frame)
            menuFloatView?.delegate = self
        }
        menuFloatView?.show(in: self.view)
    }
    
    private func hideMoreMenu(animated: Bool = true) {
        menuFloatView?.hide(animated: animated)
    }
}

// MARK: - Event Handlers
extension SessionViewController {
    
    @objc private func handleRightBarButtonTapped(_ sender: Any) {
        if self.menuFloatView?.superview != nil {
            hideMoreMenu()
        } else {
            showMoreMenu()
        }
    }
    
}

// MARK: - SessionMoreMenuViewDelegate
extension SessionViewController: SessionMoreMenuViewDelegate {
    
    func moreMenuView(_ menu: SessionMoreMenuView, didTap item: SessionMoreItem) {
        switch item.type {
        case .addFriends:
            let addFriendVC = AddContactViewController()
            navigationController?.pushViewController(addFriendVC, animated: true)
        case .money:
            let payVC = PayOfflinePayViewController()
            navigationController?.pushViewController(payVC, animated: true)
        case .groupChats:
            let multiSelectContactsVC = MultiSelectContactsViewController(string: "11")
            let nav = WCNavigationController(rootViewController: multiSelectContactsVC)
            present(nav, animated: true, completion: nil)
        default:
            break
        }
        hideMoreMenu(animated: false)
    }
}

// MARK: - ASTableDelegate & ASTableDataSource
extension SessionViewController: ASTableDelegate, ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let session = dataSource[indexPath.row]
        let block: ASCellNodeBlock = {
            return SessionCellNode(session: session)
        }
        return block
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: false)
        
        let session = dataSource[indexPath.row]
        if session.sessionID == Constants.BrandSessionName {
            let brandTimelineVC = BrandTimelineViewController()
            navigationController?.pushViewController(brandTimelineVC, animated: true)
        } else {
            let chatVC = ChatRoomViewController(sessionID: session.sessionID)
            navigationController?.pushViewController(chatVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let readAction = UITableViewRowAction(style: .normal, title: "标记为已读") { (_, _) in
            
        }
        let deleteAction = UITableViewRowAction(style: .destructive, title: "删除") { (_, _) in
            
        }
        return [deleteAction, readAction]
    }
}
