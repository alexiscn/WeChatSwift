//
//  MeViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/3.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

class MeViewController: UIViewController {

    private var tableView: UITableView!
    
    private var dataSource: [MeTableSection] = []
    
    private lazy var rightButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage.SVGImage(named: "icons_filled_camera"), style: .done, target: self, action: #selector(handleRightBarButtonTapped(_:)))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Colors.backgroundColor
        
        setupTableView()
        setupDataSource()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tabBarController?.navigationItem.rightBarButtonItem = rightButtonItem
        tabBarController?.navigationItem.title = nil
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MeTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(MeTableViewCell.self))
        view.addSubview(tableView)
    }
    
    private func setupDataSource() {
        
        let pay = MeTableModel(type: .pay, title: "支付", icon: "icons_outlined_wechatpay")
        dataSource.append(MeTableSection(items: [pay]))
        
        let fav = MeTableModel(type: .favorites, title: "收藏", icon: "icons_outlined_colorful_favorites")
        let posts = MeTableModel(type: .posts, title: "相册", icon: "icons_outlined_album", color: Colors.indigo)
        let sticker = MeTableModel(type: .sticker, title: "表情", icon: "icons_outlined_album", color: Colors.yellow)
        dataSource.append(MeTableSection(items: [fav, posts, sticker]))
        
        let settings = MeTableModel(type: .settings, title: "设置", icon: "icons_outlined_setting", color: Colors.blue)
        dataSource.append(MeTableSection(items: [settings]))
        tableView.reloadData()
    }
}

// MARK: - Event Handlers
extension MeViewController {
    
    @objc private func handleRightBarButtonTapped(_ sender: Any) {
        
    }
    
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension MeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(MeTableViewCell.self), for: indexPath) as! MeTableViewCell
        cell.backgroundColor = Colors.white
        let model = dataSource[indexPath.section].items[indexPath.row]
        cell.update(model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
