//
//  DiscoverViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/3.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class DiscoverViewController: ASViewController<ASTableNode> {
    
    private var sections: [DiscoverSection] = []
    
    private lazy var momentsVC: MomentsViewController = {
        return MomentsViewController()
    }()
    
    init() {
        super.init(node: ASTableNode(style: .grouped))
        setupDataSource()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        
        node.delegate = self
        node.dataSource = self
        node.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        node.view.separatorColor = Colors.DEFAULT_SEPARTOR_LINE_COLOR
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tabBarController?.navigationItem.rightBarButtonItem = nil
        tabBarController?.navigationItem.title = "发现"
    }
    
    private func setupDataSource() {
        var moment = DiscoverModel(type: .moment, title: "朋友圈", icon: "icons_outlined_colorful_moment")
        moment.unreadCount = 2
        sections.append(DiscoverSection(models: [moment]))
        
        sections.append(DiscoverSection(models: [
            DiscoverModel(type: .scan, title: "扫一扫", icon: "icons_outlined_scan", color: Colors.indigo),
            DiscoverModel(type: .shake, title: "摇一摇", icon: "icons_outlined_shake", color: Colors.indigo)]
        ))
        
        sections.append(DiscoverSection(models: [
            DiscoverModel(type: .news, title: "看一看", icon: "icons_outlined_news", color: Colors.yellow),
            DiscoverModel(type: .news, title: "搜一搜", icon: "icons_filled_search-logo", color: Colors.red)
            ]))
        
        sections.append(DiscoverSection(models: [DiscoverModel(type: .nearby, title: "附近的人", icon: "icons_outlined_nearby", color: Colors.indigo)]))
        sections.append(DiscoverSection(models: [
            DiscoverModel(type: .shop, title: "购物", icon: "icons_outlined_shop", color: Colors.orange),
            DiscoverModel(type: .game, title: "游戏", icon: "icons_outlined_colorful_game")]))
        sections.append(DiscoverSection(models: [DiscoverModel(type: .miniProgram, title: "小程序", icon: "icons_outlined_miniprogram", color: Colors.purple)]))
    }
}

extension DiscoverViewController: ASTableDelegate, ASTableDataSource {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return sections.count
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return sections[section].models.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let model = sections[indexPath.section].models[indexPath.row]
        let block: ASCellNodeBlock = {
            return DiscoverCellNode(model: model)
        }
        return block
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: false)
        let model = sections[indexPath.section].models[indexPath.row]
        switch model.type {
        case .moment:
            navigationController?.pushViewController(momentsVC, animated: true)
        default:
            break
        }
    }
}
