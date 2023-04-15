//
//  PublishMomentViewController.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/7/29.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

enum PublishMomentSource {
    case text
    case media([MediaAsset])
}

class PublishMomentViewController: ASDKViewController<ASDisplayNode> {

    private let tableNode = ASTableNode(style: .plain)
    
    private var dataSource: [PublishMomentAction] = []
    
    private let source: PublishMomentSource
    
    private var headerView: UIView?
    
    private var growingTextView: GrowingTextView?
    
    init(source: PublishMomentSource) {
        self.source = source
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
        tableNode.backgroundColor = .white
        
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 186)
        tableNode.view.tableHeaderView = headerView
        
        let textView = GrowingTextView(frame: CGRect(x: 18, y: 20, width: view.bounds.width - 36, height: 70))
        textView.tintColor = Colors.Brand
        textView.placeholder = "这一刻的想法..."
        textView.font = UIFont.systemFont(ofSize: 17)
        headerView.addSubview(textView)
        self.growingTextView = textView
        
        switch source {
        case .text:
            navigationItem.title = "发表文字"
        case .media(let assets):
            print(assets.count)
        }
        
        let cancelButton = UIBarButtonItem(title: LanguageManager.Common.cancel(), style: .plain, target: self, action: #selector(handleCancelButtonClicked))
        navigationItem.leftBarButtonItem = cancelButton
        
        let publishButton = wc_doneBarButton(title: "发表")
        publishButton.isEnabled = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: publishButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        switch source {
        case .text:
            growingTextView?.becomeFirstResponder()
        case .media(_):
            break
        }
    }
    
    private func setupDataSource() {
        dataSource = [.location, .remind, .permission]
    }
}

// MARK: - Event Handlers
extension PublishMomentViewController {
    
    @objc private func handleCancelButtonClicked() {
        growingTextView?.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handlePublishButtonClicked() {
        growingTextView?.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - ASTableDelegate & ASTableDataSource
extension PublishMomentViewController: ASTableDelegate, ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let action = dataSource[indexPath.row]
        let block: ASCellNodeBlock = {
            return PublishMomentCellNode(action: action)
        }
        return block
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: false)
        
        let action = dataSource[indexPath.row]
        switch action {
        case .location:
            print("TODO")
        case .remind:
            print("TODO")
        case .permission:
            let momentGroupTagVC = MomentGroupTagViewController()
            let nav = UINavigationController(rootViewController: momentGroupTagVC)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
        default:
            break
        }
    }
}

// MARK: - GrowingTextViewDelegate
extension PublishMomentViewController: GrowingTextViewDelegate {
    
}
