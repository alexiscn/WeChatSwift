//
//  SettingAutoDownloadViewController.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/8/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class SettingAutoDownloadViewController: ASViewController<ASDisplayNode> {
    
    private let tableNode = ASTableNode(style: .grouped)
    
    private var dataSource: [SettingAutoDownloadSection] = []
    
    init() {
        super.init(node: ASDisplayNode())
        node.addSubnode(tableNode)
        tableNode.dataSource = self
        tableNode.delegate = self
        setupDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        tableNode.frame = node.bounds
        tableNode.backgroundColor = .clear
        tableNode.view.separatorStyle = .none
        
        navigationItem.title = "照片、视频和文件"
    }
    
    private func setupDataSource() {
        dataSource.append(SettingAutoDownloadSection(title: "在其他设备查看的照片、视频和文件在手机上自动下载", items: [.automaticallyDownload(true)]))
        dataSource.append(SettingAutoDownloadSection(title: "拍摄或编辑后的内容保存到系统相册", items: [.photoSaveToPhone(true), .videoSaveToPhone(true)]))
        dataSource.append(SettingAutoDownloadSection(title: "开启后，朋友圈视频在移动网络下自动播放", items: [.automaticallyPlayWWAN(true)]))
    }
}

extension SettingAutoDownloadViewController: ASTableDelegate, ASTableDataSource {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return dataSource.count
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].items.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let model = dataSource[indexPath.section].items[indexPath.row]
        let isLastCell = indexPath.row == dataSource[indexPath.section].items.count - 1
        let block: ASCellNodeBlock = {
            return WCTableCellNode(model: model, isLastCell: isLastCell)
        }
        return block
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 38
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let headerLabel = UILabel()
        headerLabel.text = dataSource[section].title
        headerLabel.textColor = UIColor(hexString: "#808080")
        headerLabel.font = UIFont.systemFont(ofSize: 14)
        headerLabel.frame = CGRect(x: 16, y: 16, width: view.bounds.width - 16, height: 17)
        headerView.addSubview(headerLabel)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}
