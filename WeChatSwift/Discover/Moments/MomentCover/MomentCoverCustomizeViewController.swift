//
//  MomentCoverCustomizeViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/16.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class MomentCoverCustomizeViewController: ASDKViewController<ASDisplayNode> {
    
    private let tableNode = ASTableNode(style: .grouped)
    
    private var dataSource: [MomentCoverCustomizeSection] = []
    
    override init() {
        super.init(node: ASDisplayNode())
        node.addSubnode(tableNode)
        tableNode.delegate = self
        tableNode.dataSource = self
        setupDataSource()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        tableNode.frame = node.bounds
        tableNode.backgroundColor = .clear
        tableNode.view.separatorStyle = .none
        
        navigationItem.title = "更换相册封面"
        
    }
    
    private func setupDataSource() {
        dataSource.append(MomentCoverCustomizeSection(items: [.albumPhoto, .takePhoto]))
        dataSource.append(MomentCoverCustomizeSection(items: [.chooseFromWorks]))
    }
}

// MARK: - ASTableDelegate & ASTableDataSource
extension MomentCoverCustomizeViewController: ASTableDelegate, ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return dataSource.count
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].items.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let source = dataSource[indexPath.section].items[indexPath.row]
        let isLastCell = indexPath.row == dataSource[indexPath.section].items.count - 1
        let block: ASCellNodeBlock = {
            return MomentCoverCustomizeCellNode(source: source, isLastCell: isLastCell)
        }
        return block
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: false)
        
        let source = dataSource[indexPath.section].items[indexPath.row]
        switch source {
        case .albumPhoto:
            let selectionHandler = { [weak self] (selectedAssets: [MediaAsset]) in
                print(selectedAssets.count)
                self?.dismiss(animated: true, completion: nil)
            }
            let configuration = AssetPickerConfiguration.configurationForMomentBackground()
            let albumPickerVC = AlbumPickerViewController(configuration: configuration)
            albumPickerVC.selectionHandler = selectionHandler
            let assetPickerVC = AssetPickerViewController(configuration: configuration)
            assetPickerVC.selectionHandler = selectionHandler
            let nav = UINavigationController()
            nav.setViewControllers([albumPickerVC, assetPickerVC], animated: false)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
        case .takePhoto:
            let sightCameraVC = SightCameraViewController()
            let nav = UINavigationController(rootViewController: sightCameraVC)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
        case .chooseFromWorks:
            let momentSetBackgroundVC = MomentSetBackgroundViewController()
            navigationController?.pushViewController(momentSetBackgroundVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.01: 8
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}


