//
//  PayOfflinePayViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/30.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class PayOfflinePayViewController: ASViewController<ASDisplayNode> {
    
    private let scrollNode = ASScrollNode()
    
    init() {
        super.init(node: ASDisplayNode())
        node.addSubnode(scrollNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = UIColor(hexString: "#439057")
        navigationItem.title = "收付款"
        scrollNode.frame = view.bounds
        
        setupCardView()
        setupBottomButtons()
    }
    
    private func setupCardView() {
        let cardNode = PayOfflinePayQRCodeNode()
        cardNode.frame = CGRect(x: 10, y: 15, width: view.bounds.width - 20, height: 480)
        cardNode.cornerRadius = 4
        cardNode.cornerRoundingType = .defaultSlowCALayer
        cardNode.backgroundColor = .white
        scrollNode.addSubnode(cardNode)
    }
    
    private func setupBottomButtons() {
        let actions = PayOfflinePayAction.allCases
        let buttonHeight: CGFloat = 66.0
        let buttonWidth: CGFloat = Constants.screenWidth - 20
        let containerNode = ASDisplayNode()
        containerNode.cornerRadius = 2
        containerNode.cornerRoundingType = .precomposited
        for (index, action) in actions.enumerated() {
            let buttonNode = PayOfflinePayButtonNode(action: action)
            buttonNode.frame = CGRect(x: 0,
                                      y: CGFloat(index) * (buttonHeight + Constants.lineHeight),
                                      width: buttonWidth,
                                      height: buttonHeight)
            containerNode.addSubnode(buttonNode)
            if index != actions.count - 1 {
                let lineNode = ASDisplayNode()
                lineNode.backgroundColor = UIColor(white: 1, alpha: 0.15)
                lineNode.frame = CGRect(x: 0, y: CGFloat(index) * buttonHeight, width: buttonWidth, height: Constants.lineHeight)
                containerNode.addSubnode(lineNode)
            }
        }
        let height = CGFloat(actions.count) * (buttonHeight + Constants.lineHeight) - Constants.lineHeight
        containerNode.frame = CGRect(x: 10, y: 505, width: Constants.screenWidth - 20, height: height)
        scrollNode.addSubnode(containerNode)
        
        scrollNode.view.contentSize = CGSize(width: Constants.screenWidth, height: 505 + height + Constants.bottomInset)
    }
    
    override var wc_navigationBarBackgroundColor: UIColor? {
        return UIColor(hexString: "#439057")
    }
    
    override var wc_barTintColor: UIColor? {
        return UIColor.white
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var wc_titleTextAttributes: [NSAttributedString.Key : Any]? {
        return [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
}
