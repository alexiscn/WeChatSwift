//
//  MakeRedEnvelopeViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/29.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit
import WXActionSheet

class MakeRedEnvelopeViewController: ASViewController<ASDisplayNode> {
    
    private let tableNode = ASTableNode()
    
    private let errorTextNode: ASTextNode
    private let errorNode: ASDisplayNode

    private let moneyTextNode: ASTextNode
    
    private let redEnvelopeButton: ASButtonNode
    
    init() {
        
        errorTextNode = ASTextNode()
        errorTextNode.attributedText = NSAttributedString(string: "单个红包金额不可超过200元", attributes: [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor(hexString: "#EA5F39")
        ])
        
        errorNode = ASDisplayNode()
        errorNode.frame = CGRect(x: 0, y: -35.0, width: Constants.screenWidth, height: 35)
        errorNode.addSubnode(errorTextNode)
        errorTextNode.frame = errorNode.bounds
        
        moneyTextNode = ASTextNode()
        moneyTextNode.attributedText = NSAttributedString(string: "￥0.00", attributes: [
            .font: Fonts.font(.superScriptMedium, fontSize: 50)!,
            .foregroundColor: UIColor(hexString: "#303030")
        ])
        
        redEnvelopeButton = ASButtonNode()
        
        super.init(node: ASDisplayNode())
        
        node.addSubnode(tableNode)
        node.addSubnode(errorNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        
        tableNode.frame = node.bounds
        tableNode.backgroundColor = .clear
        
        navigationItem.title = "发红包"
        
        let cancelButton = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(handleCancelButtonClicked))
        navigationItem.leftBarButtonItem = cancelButton
        
        let moreItem = UIBarButtonItem(image: Constants.moreImage, style: .plain, target: self, action: #selector(handleMoreButtonClicked))
        navigationItem.rightBarButtonItem = moreItem
    }
    
    private func showError() {
        
    }
    
    private func hideError() {
        
    }
}

// MARK: - Event Handlers
extension MakeRedEnvelopeViewController {
    
    @objc private func handleCancelButtonClicked() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleMoreButtonClicked() {
        let actionSheet = WXActionSheet(cancelButtonTitle: "取消")
        actionSheet.add(WXActionSheetItem(title: "红包记录", handler: { _ in
            
        }))
        actionSheet.add(WXActionSheetItem(title: "帮助中心", handler: { _ in
            
        }))
        actionSheet.show()
    }
}

// MARK: - ASTableDelegate & ASTableDataSource
extension MakeRedEnvelopeViewController: ASTableDelegate, ASTableDataSource {
    
}
