//
//  SettingFilesViewController.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/8/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class SettingFilesViewController: ASViewController<ASTableNode> {
    
    private var dataSource: [SettingFileSection] = []
    
    init() {
        super.init(node: ASTableNode(style: .grouped))
        node.dataSource = self
        node.delegate = self
        setupDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        node.view.separatorStyle = .none
        
        navigationItem.title = "照片、视频和文件"
    }
    
    private func setupDataSource() {
        dataSource.append(SettingFileSection(title: "", items: [.automaticallyDownload(true)]))
        dataSource.append(SettingFileSection(title: "", items: [.photoSaveToPhone(true), .videoSaveToPhone(true)]))
        dataSource.append(SettingFileSection(title: "", items: [.automaticallyPlayWWAN(true)]))
    }
}

extension SettingFilesViewController: ASTableDelegate, ASTableDataSource {
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
}

struct SettingFileSection {
    var title: String
    var items: [SettingFileModel]
}

enum SettingFileModel: WCTableCellModel {
    case automaticallyDownload(Bool)
    case photoSaveToPhone(Bool)
    case videoSaveToPhone(Bool)
    case automaticallyPlayWWAN(Bool)
    
    var wc_title: String {
        switch self {
        case .automaticallyDownload(_):
            return "自动下载"
        case .photoSaveToPhone(_):
            return "照片"
        case .videoSaveToPhone(_):
            return "视频"
        case .automaticallyPlayWWAN(_):
            return "移动网络下视频自动播放"
        }
    }
    
    var wc_showSwitch: Bool {
        return true
    }
    
    var wc_switchValue: Bool {
        switch self {
        case .automaticallyDownload(let isOn):
            return isOn
        case .photoSaveToPhone(let isOn):
            return isOn
        case .videoSaveToPhone(let isOn):
            return isOn
        case .automaticallyPlayWWAN(let isOn):
            return isOn
        }
    }
}
