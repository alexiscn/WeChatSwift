//
//  EmoticonManageViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/25.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class EmoticonManageViewController: ASViewController<ASDisplayNode> {

    var isPresented: Bool = false
    
    private let tableNode = ASTableNode(style: .grouped)
    
    private var dataSource: [EmoticonManageGroup] = []
    
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
        tableNode.view.separatorStyle = .none
        tableNode.backgroundColor = .clear
        
        navigationItem.title = "我的表情"
        
        let sortButton = UIBarButtonItem(title: "排序", style: .plain, target: self, action: #selector(handleSortButtonClicked))
        navigationItem.rightBarButtonItem = sortButton
    }

    private func setupDataSource() {
        dataSource.append(EmoticonManageGroup(items: [.addSingleEmoticon, .selfieEmoticon]))
        dataSource.append(EmoticonManageGroup(items: [.emoticons([""])]))
        dataSource.append(EmoticonManageGroup(items: [.addHistory]))
    }
}

// MARK: - Event Handlers

extension EmoticonManageViewController {
    
    @objc private func handleSortButtonClicked() {
        tableNode.view.setEditing(true, animated: true)
    }
    
    @objc private func handleCancelButtonClicked() {
        tableNode.view.endEditing(true)
    }
    
    @objc private func handleDoneButtonClicked() {
        
    }
    
}

// MARK: - ASTableDelegate & ASTableDataSource
extension EmoticonManageViewController: ASTableDelegate, ASTableDataSource {
    
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
            switch model {
            case .emoticons(let emoticons):
                return EmoticonManageCellNode(emotions: emoticons, isLastCell: isLastCell)
            default:
                return EmoticonManageActionCellNode(model: model, isLastCell: isLastCell)
            }
        }
        return block
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}

enum EmoticonManageItem {
    case addHistory
    case emoticons([String])
    case addSingleEmoticon
    case selfieEmoticon
    
    var title: String? {
        switch self {
        case .addHistory:
            return "整套表情添加记录"
        case .addSingleEmoticon:
            return "添加的单个表情"
        case .selfieEmoticon:
            return "我的自拍表情"
        default:
            return nil
        }
    }
    
    var image: UIImage? {
        switch self {
        case .addSingleEmoticon:
            return UIImage.SVGImage(named: "icons_outlined_like")
        case .selfieEmoticon:
            return UIImage.SVGImage(named: "icons_outlined_takephoto_nor")
        default:
            return nil
        }
    }
}

struct EmoticonManageGroup {
    var items: [EmoticonManageItem]
}
