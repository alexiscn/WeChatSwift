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
    
    private var topSessions: [Session] = []
    
    private var dataSource: [Session] = []
    
    private lazy var mainSearchViewController: MainSearchViewController = {
        return MainSearchViewController()
    }()
    
    private var searchViewController: UISearchController?
    
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
        
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        //node.view.isUserInteractionEnabled = true
        //tableNode.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableNode.view.separatorStyle = .none
        tableNode.frame = view.bounds
        tableNode.backgroundColor = .clear
        tableNode.view.allowsMultipleSelectionDuringEditing = false
        loadSessions()
        tableNode.reloadData()
        
        let rightButtonItem = UIBarButtonItem(image: UIImage.SVGImage(named: "icons_outlined_addoutline"), style: .done, target: self, action: #selector(handleRightBarButtonTapped(_:)))
        navigationItem.rightBarButtonItem = rightButtonItem
        navigationItem.title = "微信"
        
        setupSearchController()
    }
    
    private func loadSessions() {
        dataSource = MockFactory.shared.sessions()
        let first = dataSource.removeFirst()
        first.stickTop = true
        topSessions.append(first)
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
    
    private func setupSearchController() {
        
        searchViewController = UISearchController(searchResultsController: mainSearchViewController)
        searchViewController?.delegate = self
        searchViewController?.view.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        searchViewController?.searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchViewController?.searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .defaultPrompt)
        searchViewController?.searchBar.placeholder = "搜索"
        searchViewController?.searchBar.barTintColor = Colors.DEFAULT_BACKGROUND_COLOR
        
        searchViewController?.searchBar.tintColor = Colors.DEFAULT_LINK_COLOR
        searchViewController?.searchResultsUpdater = mainSearchViewController
        tableNode.view.tableHeaderView = searchViewController?.searchBar
        tableNode.view.backgroundView = UIView()
        searchViewController?.dimsBackgroundDuringPresentation = false
        
        mainSearchViewController.searchBar = searchViewController?.searchBar
        mainSearchViewController.searchBar?.alignmentCenter()
        
        definesPresentationContext = true
        searchViewController?.definesPresentationContext = true
        
        tableNode.view.contentInsetAdjustmentBehavior = .automatic
        extendedLayoutIncludesOpaqueBars = false
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
        case .scan:
            let cameraScanVC = CameraScanViewController()
            navigationController?.pushViewController(cameraScanVC, animated: true)
        case .money:
            let payVC = PayOfflinePayViewController()
            navigationController?.pushViewController(payVC, animated: true)
        case .groupChats:
            let multiSelectContactsVC = MultiSelectContactsViewController()
            multiSelectContactsVC.selectionHandler = { selectedContacts in
                
            }
            let nav = WCNavigationController(rootViewController: multiSelectContactsVC)
            present(nav, animated: true, completion: nil)
        }
        hideMoreMenu(animated: false)
    }
}

// MARK: - ASTableDelegate & ASTableDataSource
extension SessionViewController: ASTableDelegate, ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 2
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return topSessions.count
        }
        return dataSource.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let session = indexPath.section == 0 ? topSessions[indexPath.row] : dataSource[indexPath.row]
        let block: ASCellNodeBlock = {
            return SessionCellNode(session: session)
        }
        return block
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: false)
        
        let session = indexPath.section == 0 ? topSessions[indexPath.row] : dataSource[indexPath.row]
        if session.sessionID == Constants.BrandSessionName {
            let brandTimelineVC = BrandTimelineViewController()
            navigationController?.pushViewController(brandTimelineVC, animated: true)
        } else {
            let chatVC = ChatRoomViewController(sessionID: session.sessionID)
            navigationController?.pushViewController(chatVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        var actions: [UITableViewRowAction] = []
        let deleteAction = UITableViewRowAction(style: .default, title: "删除") { (_, _) in
            
        }
        actions.append(deleteAction)
        
        let session = indexPath.section == 0 ? topSessions[indexPath.row] : dataSource[indexPath.row]
        if session.unreadCount > 0 {
            let readAction = UITableViewRowAction(style: .normal, title: "标记为已读") { (_, _) in
                
            }
            actions.append(readAction)
        } else {
            let unReadAction = UITableViewRowAction(style: .normal, title: "标记为未读") { (_, _) in
                
            }
            actions.append(unReadAction)
        }
        return actions
    }
}

// MARK: - UISearchControllerDelegate

extension SessionViewController: UISearchControllerDelegate {
    
    func willPresentSearchController(_ searchController: UISearchController) {
        tabBarController?.tabBar.isHidden = true
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        tabBarController?.tabBar.isHidden = false
        searchController.searchBar.alignmentCenter()
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        
    }
    
    func presentSearchController(_ searchController: UISearchController) {
        searchViewController?.searchResultsController?.view.isHidden = false
        searchController.searchBar.resetAlignment()
    }
}
