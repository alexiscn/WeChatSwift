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
    
    private var menuView: SessionMoreMenuView?
    private var menuViewFrame: CGRect = .zero
    
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
    
    private lazy var rightButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage.SVGImage(named: "icons_outlined_addoutline"), style: .done, target: self, action: #selector(handleRightBarButtonTapped(_:)))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = Colors.backgroundColor
        tableNode.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableNode.view.separatorStyle = .none
        tableNode.frame = view.bounds
        dataSource = MockFactory.shared.sessions()
        tableNode.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tabBarController?.navigationItem.rightBarButtonItem = rightButtonItem
        tabBarController?.navigationItem.title = "微信"
        node.view.isUserInteractionEnabled = true
    }
    
    private func showMoreMenu() {
        
        if menuView == nil {
            let groupChatMenu = SessionMoreItem(title: "发起群聊", icon: "icons_filled_chats") {
                
            }
            let addFriendMenu = SessionMoreItem(title: "添加朋友", icon: "icons_filled_add-friends") {
                
            }
            let scanMenu = SessionMoreItem(title: "扫一扫", icon: "icons_filled_scan") {
                
            }
            let payMenu = SessionMoreItem(title: "收付款", icon: "icons_filled_pay") {
                
            }
            let menuWidth: CGFloat = 0.45 * view.bounds.width
            let menuHeight: CGFloat = 60.0
            let paddingTop: CGFloat = 0
            let paddingRight: CGFloat = 8.0
            let menus = [groupChatMenu, addFriendMenu, scanMenu, payMenu]
            let menuFrame = CGRect(x: view.bounds.width - menuWidth - paddingRight,
                                   y: paddingTop,
                                   width: menuWidth,
                                   height: CGFloat(menus.count) * menuHeight)
            let menuView = SessionMoreMenuView(frame: menuFrame, menus: menus)
            menuView.transform = .identity
            menuView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.menuView = menuView
            self.menuViewFrame = menuFrame
        }
        
        guard let menu = menuView else {
            return
        }
        menu.frame = menuViewFrame
        view.addSubview(menu)
    }
    
    private func hideMoreMenu() {
        UIView.animate(withDuration: 0.25, animations: {
            let scale: CGFloat = 0.7
            self.menuView?.transform = CGAffineTransform(scaleX: scale, y: scale)
            self.menuView?.frame.origin.x = self.menuViewFrame.origin.x + self.menuViewFrame.width * scale/2 - 12 // To keep arrow stick
            self.menuView?.frame.origin.y = self.menuViewFrame.origin.y
            self.menuView?.alpha = 0.0
        }) { _ in
            self.menuView?.alpha = 1.0
            self.menuView?.transform = .identity
            self.menuView?.removeFromSuperview()
        }
    }
}

// MARK: - Event Handlers
extension SessionViewController {
    
    @objc private func handleRightBarButtonTapped(_ sender: Any) {
        if self.menuView?.superview != nil {
            hideMoreMenu()
        } else {
            showMoreMenu()
        }
    }
    
}

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
        let chatVC = ChatRoomViewController(sessionID: session.sessionID)
        navigationController?.pushViewController(chatVC, animated: true)
    }
}
