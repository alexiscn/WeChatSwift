//
//  MakeRedEnvelopeViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/29.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit
import WXActionSheet

class MakeRedEnvelopeViewController: ASDKViewController<ASDisplayNode> {
    
    private let tableNode = ASTableNode()
    
    private let errorTextNode: ASTextNode
    private let errorNode: ASDisplayNode
    
    private let enterMoneyNode: MakeRedEnvelopeEnterMoneyNode
    private let enterDescNode: MakeRedEnvelopeEnterDescNode

    private let moneyTextNode: ASTextNode
    
    private let redEnvelopeButton: ASButtonNode
    
    override init() {
        
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
        moneyTextNode.frame = CGRect(x: 0, y: 220, width: Constants.screenWidth, height: 56)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
            
        moneyTextNode.attributedText = NSAttributedString(string: "￥0.00", attributes: [
            .font: Fonts.font(.superScriptMedium, fontSize: 50)!,
            .foregroundColor: UIColor(hexString: "#303030"),
            .paragraphStyle: paragraphStyle
        ])
        
        enterMoneyNode = MakeRedEnvelopeEnterMoneyNode()
        enterMoneyNode.frame = CGRect(x: 24.0, y: 20.0, width: Constants.screenWidth - 48, height: 56.0)
        
        enterDescNode = MakeRedEnvelopeEnterDescNode()
        enterDescNode.frame = CGRect(x: 24.0, y: 92.0, width: Constants.screenWidth - 48.0, height: 64.0)
        
        redEnvelopeButton = ASButtonNode()
        redEnvelopeButton.isUserInteractionEnabled = true
        redEnvelopeButton.frame = CGRect(x: (Constants.screenWidth - 184.0)/2.0, y: 295.0, width: 184.0, height: 48.0)
        redEnvelopeButton.setAttributedTitle(NSAttributedString(string: "塞钱进红包", attributes: [
            .font: UIFont.systemFont(ofSize: 18),
            .foregroundColor: UIColor.white
        ]), for: .normal)
        
        let normalBackground = UIImage.as_resizableRoundedImage(withCornerRadius: 5, cornerColor: nil, fill: UIColor(hexString: "#EA5F39"))
        let highlightBackground = UIImage.as_resizableRoundedImage(withCornerRadius: 5, cornerColor: nil, fill: UIColor(hexString: "#D6522E"))
        let disableBackground = UIImage.as_resizableRoundedImage(withCornerRadius: 5, cornerColor: nil, fill: UIColor(hexString: "#E9C0B6"))
        redEnvelopeButton.setBackgroundImage(normalBackground, for: .normal)
        redEnvelopeButton.setBackgroundImage(highlightBackground, for: .highlighted)
        redEnvelopeButton.setBackgroundImage(disableBackground, for: .disabled)
        
        super.init(node: ASDisplayNode())
        
        node.addSubnode(tableNode)
        node.addSubnode(errorNode)
        
        tableNode.addSubnode(enterMoneyNode)
        tableNode.addSubnode(enterDescNode)
        tableNode.addSubnode(moneyTextNode)
        tableNode.addSubnode(redEnvelopeButton)
        
        tableNode.delegate = self
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
        
        navigationItem.title = "发红包"
        
        let cancelButton = UIBarButtonItem(title: LanguageManager.Common.cancel(), style: .plain, target: self, action: #selector(handleCancelButtonClicked))
        navigationItem.leftBarButtonItem = cancelButton
        
        let moreItem = UIBarButtonItem(image: Constants.moreImage, style: .plain, target: self, action: #selector(handleMoreButtonClicked))
        navigationItem.rightBarButtonItem = moreItem
    }
    
    private func showError() {
        
    }
    
    private func hideError() {
        
    }
    
    private func dismissKeyboard() {
        enterDescNode.resignFirstResponder()
        enterMoneyNode.resignFirstResponder()
    }
}

// MARK: - Event Handlers
extension MakeRedEnvelopeViewController {
    
    @objc private func handleCancelButtonClicked() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleMoreButtonClicked() {
        dismissKeyboard()
        
        let actionSheet = WXActionSheet(cancelButtonTitle: LanguageManager.Common.cancel())
        actionSheet.add(WXActionSheetItem(title: "红包记录", handler: { _ in
            
        }))
        actionSheet.add(WXActionSheetItem(title: "帮助中心", handler: { _ in
            
        }))
        actionSheet.show()
    }
}

// MARK: - ASTableDelegate & ASTableDataSource
extension MakeRedEnvelopeViewController: ASTableDelegate, ASTableDataSource {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        dismissKeyboard()
    }
    
}
