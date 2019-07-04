//
//  SessionViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/3.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

class SessionViewController: UIViewController {
    
    private var dataSource: [Session] = []
    
    private var tableView: UITableView!
    
    private lazy var rightButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage.SVGImage(named: "icons_outlined_addoutline"), style: .done, target: self, action: #selector(handleRightBarButtonTapped(_:)))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = Colors.backgroundColor
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tabBarController?.navigationItem.rightBarButtonItem = rightButtonItem
        tabBarController?.navigationItem.title = "微信"
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds)
        tableView.backgroundColor = .clear
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 56, bottom: 0, right: 0)
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SessionViewCell.self, forCellReuseIdentifier: NSStringFromClass(SessionViewCell.self))
        view.addSubview(tableView)
    }
    
    private func setupDataSource() {
        
    }
    
    private func showMoreMenu() {
        
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
        view.addSubview(menuView)
    }
    
    private func hideMoreMenu() {
        
    }
}

// MARK: - Event Handlers
extension SessionViewController {
    
    @objc private func handleRightBarButtonTapped(_ sender: Any) {
        showMoreMenu()
    }
    
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension SessionViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}
