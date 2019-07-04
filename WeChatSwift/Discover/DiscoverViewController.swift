//
//  DiscoverViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/3.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {
    
    private var tableView: UITableView!
    
    private var sections: [DiscoverSection] = []
    
    private lazy var momentsVC: MomentsViewController = {
       return MomentsViewController()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.backgroundColor
        
        setupTableView()
        setupDataSource()
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DiscoverViewCell.self, forCellReuseIdentifier: NSStringFromClass(DiscoverViewCell.self))
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 56, bottom: 0, right: 0)
        view.addSubview(tableView)
    }
    
    private func setupDataSource() {
        sections.append(DiscoverSection(models: [
            DiscoverModel(type: .moment, title: "朋友圈", icon: "icons_outlined_colorful_moment")
            ]))
        
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

extension DiscoverViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(DiscoverViewCell.self), for: indexPath) as! DiscoverViewCell
        let model = sections[indexPath.section].models[indexPath.row]
        cell.update(model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let model = sections[indexPath.section].models[indexPath.row]
        switch model.type {
        case .moment:
            navigationController?.pushViewController(momentsVC, animated: true)
        default:
            break
        }
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
}
