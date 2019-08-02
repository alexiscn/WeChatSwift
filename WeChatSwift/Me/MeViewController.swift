//
//  MeViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/3.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class MeViewController: ASViewController<ASDisplayNode> {

    private let tableNode: ASTableNode = ASTableNode(style: .grouped)
    
    private var dataSource: [MeTableSection] = []
    
    private var headerNode: MeHeaderNode!
    
    private lazy var rightButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage.SVGImage(named: "icons_filled_camera"), style: .done, target: self, action: #selector(handleRightBarButtonTapped(_:)))
        return button
    }()
    
    init() {
        super.init(node: ASDisplayNode())
        node.addSubnode(tableNode)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        tableNode.frame = node.bounds
        tableNode.dataSource = self
        tableNode.delegate = self
        tableNode.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        headerNode = MeHeaderNode()
        
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 111)
        headerView.addSubnode(headerNode)
        headerNode.frame = headerView.bounds
        tableNode.view.tableHeaderView = headerView
        
        setupDataSource()
        tableNode.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tabBarController?.navigationItem.rightBarButtonItem = rightButtonItem
        tabBarController?.navigationItem.title = nil
    }
    
    private func setupDataSource() {
        
        let pay = MeTableModel(type: .pay, title: "支付", icon: "icons_outlined_wechatpay")
        dataSource.append(MeTableSection(items: [pay]))
        
        let fav = MeTableModel(type: .favorites, title: "收藏", icon: "icons_outlined_colorful_favorites")
        let posts = MeTableModel(type: .posts, title: "相册", icon: "icons_outlined_album", color: Colors.indigo)
        let sticker = MeTableModel(type: .sticker, title: "表情", icon: "icons_outlined_sticker", color: Colors.yellow)
        dataSource.append(MeTableSection(items: [fav, posts, sticker]))
        
        let settings = MeTableModel(type: .settings, title: "设置", icon: "icons_outlined_setting", color: Colors.blue)
        dataSource.append(MeTableSection(items: [settings]))
    }
}

// MARK: - Event Handlers
extension MeViewController {
    
    @objc private func handleRightBarButtonTapped(_ sender: Any) {
        
    }
    
}

// MARK: - ASTableDelegate & ASTableDataSource
extension MeViewController: ASTableDelegate, ASTableDataSource {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return dataSource.count
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].items.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let model = dataSource[indexPath.section].items[indexPath.row]
        let block: ASCellNodeBlock = {
            return MeCellNode(model: model)
        }
        return block
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: false)
        
        let model = dataSource[indexPath.section].items[indexPath.row]
        switch model.type {
        case .settings:
            let settingsVC = SettingsViewController()
            navigationController?.pushViewController(settingsVC, animated: true)
        case .sticker:
            let emoticonStoreViewController = EmoticonStoreViewController()
            navigationController?.pushViewController(emoticonStoreViewController, animated: true)
        case .pay:
            let paymentMainVC = PaymentMainViewController()
            navigationController?.pushViewController(paymentMainVC, animated: true)
        default:
            break
        }
    }
}
