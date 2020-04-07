//
//  SettingLanguageViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/16.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class SettingLanguageViewController: ASViewController<ASDisplayNode> {
    
    private let tableNode = ASTableNode(style: .plain)
    
    private var dataSource: [SettingLanguageModel] = []
    
    private var selectedLanguage: Language?
    
    init() {
        super.init(node: ASDisplayNode())
        node.addSubnode(tableNode)
        tableNode.dataSource = self
        tableNode.delegate = self
        
        dataSource = Language.allCases.map { return SettingLanguageModel(language: $0) }
        dataSource.first(where: { $0.language == LanguageManager.shared.current } )?.isSelected = true
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
        
        navigationItem.title = LocalizedString("Setting_LanguageTitle")
        
        let cancelButton = UIBarButtonItem(title: LanguageManager.Common.cancel(), style: .plain, target: self, action: #selector(cancelButtonClicked))
        navigationItem.leftBarButtonItem = cancelButton
        
        let rightButton = wc_doneBarButton(title: "完成")
        rightButton.addTarget(self, action: #selector(doneButtonClicked), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }
}

// MARK: - Event Handlers
extension SettingLanguageViewController {
    
    @objc private func cancelButtonClicked() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func doneButtonClicked() {
        
        if let selected = selectedLanguage, selected != LanguageManager.shared.current {
            LanguageManager.shared.current = selected
        }
        dismiss(animated: true) {
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.rootViewController.handleLanguageDidChanged()
        }
    }
}

// MARK: - ASTableDelegate & ASTableDataSource
extension SettingLanguageViewController: ASTableDelegate, ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let model = dataSource[indexPath.row]
        let isLastCell = indexPath.row == dataSource.count - 1
        let block: ASCellNodeBlock = {
            return SettingLanguageCellNode(model: model, isLastCell: isLastCell)
        }
        return block
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: false)
        
        let model = dataSource[indexPath.row]
        selectedLanguage = model.language
    }
}
