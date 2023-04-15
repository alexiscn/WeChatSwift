//
//  EmoticonManageViewController.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/7/25.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class EmoticonManageViewController: ASDKViewController<ASDisplayNode> {

    var isPresented: Bool = false
    
    private let tableNode = ASTableNode(style: .grouped)
    
    private var dataSource: [EmoticonManageGroup] = []
    
    private var cancelButtonItem: UIBarButtonItem?
    private var backButtonItem: UIBarButtonItem?
    
    override init() {
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
        
        navigationItem.title = LocalizedString("EmoticonManageTitle")
        
        let sortButton = UIBarButtonItem(title: LocalizedString("Emoticon_Manage_Sort"), style: .plain, target: self, action: #selector(handleSortButtonClicked))
        navigationItem.rightBarButtonItem = sortButton
        
        cancelButtonItem = UIBarButtonItem(title: LanguageManager.Common.cancel(), style: .plain, target: self, action: #selector(handleCancelButtonClicked))
        if isPresented {
            navigationItem.leftBarButtonItem = cancelButtonItem
        }
        backButtonItem = navigationItem.leftBarButtonItem
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
        navigationItem.leftBarButtonItem = cancelButtonItem
        tableNode.view.setEditing(true, animated: true)
    }
    
    @objc private func handleCancelButtonClicked() {
        if isPresented {
            dismiss(animated: true, completion: nil)
        } else {
            navigationItem.leftBarButtonItem = backButtonItem
            tableNode.view.setEditing(false, animated: true)
        }
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
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        let model = dataSource[indexPath.section].items[indexPath.row]
        switch model {
        case .emoticons(_):
            return .delete
        default:
            return .none
        }
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        let model = dataSource[indexPath.section].items[indexPath.row]
        switch model {
        case .emoticons(_):
            return true
        default:
            return false
        }
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
            return LocalizedString("PurchasedEmoticonRecordTitle")
        case .addSingleEmoticon:
            return LocalizedString("CustomEmoticonTitle")
        case .selfieEmoticon:
            return LocalizedString("CameraEmoticonTitle")
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
