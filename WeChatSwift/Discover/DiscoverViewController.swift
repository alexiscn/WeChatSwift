//
//  DiscoverViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/3.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class DiscoverViewController: ASViewController<ASTableNode> {
    
    private var dataSource: [DiscoverSection] = []
    
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
        node.view.separatorStyle = .none
        
        navigationItem.title = "发现"
    }
    
    private func setupDataSource() {
        dataSource = MockFactory.shared.discoverEntrance()
    }
}

extension DiscoverViewController: ASTableDelegate, ASTableDataSource {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return dataSource.count
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].models.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let model = dataSource[indexPath.section].models[indexPath.row]
        let isLastCell = indexPath.row == dataSource[indexPath.section].models.count - 1
        let block: ASCellNodeBlock = {
            return WCTableCellNode(model: model, isLastCell: isLastCell)
        }
        return block
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.01 : 8.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: false)
        let model = dataSource[indexPath.section].models[indexPath.row]
        switch model.type {
        case .moment:
            navigationController?.pushViewController(momentsVC, animated: true)
        case .shake:
            let shakeVC = ShakeViewController()
            navigationController?.pushViewController(shakeVC, animated: true)
        case .nearby:
            let nearbyPeopleVC = NearbyPeopleViewController()
            navigationController?.pushViewController(nearbyPeopleVC, animated: true)
        default:
            break
        }
    }
}
