//
//  ChatRoomBackgroundEntranceViewController.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/8/4.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class ChatRoomBackgroundEntranceViewController: ASDKViewController<ASDisplayNode> {
    
    private var isFromGeneralSettings = false
    
    private let tableNode = ASTableNode(style: .grouped)
    
    private var dataSource: [ChatRoomBackgroundActionGroup] = []
    
    init(isFromGeneralSettings: Bool = false) {
        self.isFromGeneralSettings = isFromGeneralSettings
        super.init(node: ASDisplayNode())
        node.addSubnode(tableNode)
        tableNode.autoresizingMask = [.flexibleWidth, .flexibleWidth]
        tableNode.dataSource = self
        tableNode.delegate = self
     
        dataSource.append(ChatRoomBackgroundActionGroup(items: [.pick]))
        dataSource.append(ChatRoomBackgroundActionGroup(items: [.pickFromAlbum, .takeFromCamera]))
        if isFromGeneralSettings {
            dataSource.append(ChatRoomBackgroundActionGroup(items: [.applyToAllChats]))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        tableNode.frame = view.bounds
        tableNode.backgroundColor = .clear
        tableNode.view.separatorStyle = .none
        navigationItem.title = "聊天背景"
    }
}

// MARK: - ASTableDelegate & ASTableDataSource
extension ChatRoomBackgroundEntranceViewController: ASTableDelegate, ASTableDataSource {
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
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: false)
        
        let action = dataSource[indexPath.section].items[indexPath.row]
        switch action {
        case .pick:
            let backgroundSettingVC = ChatRoomBackgroundSettingViewController()
            let nav = UINavigationController(rootViewController: backgroundSettingVC)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
        case .pickFromAlbum:
            let selectionHandler = { [weak self] (selectedAssets: [MediaAsset]) in
                print(selectedAssets.count)
                self?.dismiss(animated: true, completion: nil)
            }
            let configuration = AssetPickerConfiguration.configurationForChatBackground()
            let albumPickerVC = AlbumPickerViewController(configuration: configuration)
            albumPickerVC.selectionHandler = selectionHandler
            let assetPickerVC = AssetPickerViewController(configuration: configuration)
            assetPickerVC.selectionHandler = selectionHandler
            let nav = UINavigationController()
            nav.setViewControllers([albumPickerVC, assetPickerVC], animated: false)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
        case .takeFromCamera:
            let sightCameraVC = SightCameraViewController()
            sightCameraVC.modalPresentationCapturesStatusBarAppearance = true
            sightCameraVC.modalTransitionStyle = .coverVertical
            sightCameraVC.modalPresentationStyle = .fullScreen
            present(sightCameraVC, animated: true, completion: nil)
        default:
            break
        }
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
}

struct ChatRoomBackgroundActionGroup {
    var items: [ChatRoomBackgroundAction]
}

enum ChatRoomBackgroundAction: WCTableCellModel {
    case pick
    case pickFromAlbum
    case takeFromCamera
    case applyToAllChats
    
    var title: String {
        switch self {
        case .pick:
            return LocalizedString("ChatBackground_SelectBackground")
        case .pickFromAlbum:
            return LocalizedString("ChatBackground_SelectFromAlbum")
        case .takeFromCamera:
            return LocalizedString("ChatBackground_TakePhoto")
        case .applyToAllChats:
            return LocalizedString("ChatBackground_ApplyToAllChat")
        }
    }
    
    func attributedStringForTitle() -> NSAttributedString {
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17),
            NSAttributedString.Key.foregroundColor: UIColor(white: 0, alpha: 0.9)
        ]
        return NSAttributedString(string: title, attributes: attributes)
    }
    
    var wc_title: String {
        return title
    }
    
    var wc_cellStyle: WCTableCellStyle {
        if self == .applyToAllChats {
            return .centerButton
        }
        return .default
    }
}
