//
//  PaymentMainViewController.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/2.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class PaymentMainViewController: ASDKViewController<ASDisplayNode> {
 
    private let scrollNode = ASScrollNode()
    
    private let buttonBackground = ASDisplayNode()
    
    private let balanceButton = ASButtonNode()
    
    private let cardButton = ASButtonNode()
    
    private var officialMallNode: MallFunctionActivityContainerNode!
    
    private var thirdPartyMallNode: MallFunctionActivityContainerNode!
    
    private let mallCellHeight: CGFloat = 117.0
    
    override init() {
        super.init(node: ASDisplayNode())
        
        node.addSubnode(scrollNode)
        
        scrollNode.addSubnode(buttonBackground)
        scrollNode.addSubnode(cardButton)
        scrollNode.addSubnode(balanceButton)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        navigationItem.title = "支付"
        let moreButtonItem = UIBarButtonItem(image: Constants.moreImage, style: .done, target: self, action: #selector(moreButtonClicked))
        navigationItem.rightBarButtonItem = moreButtonItem
        
        buttonBackground.backgroundColor = UIColor(hexString: "#3CB371")
        buttonBackground.cornerRadius = 10
        buttonBackground.cornerRoundingType = .defaultSlowCALayer
        
        setupCardButton()
        setupBalanceNode()
        
        setupOfficialActivities()
        setupThirdPartyActivities()
        
        cardButton.addTarget(self, action: #selector(cardButtonClicked), forControlEvents: .touchUpInside)
        balanceButton.addTarget(self, action: #selector(balanceButtonClicked), forControlEvents: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollNode.frame = view.bounds
        
        let buttonWidth = (view.bounds.width - 16)/2.0
        let buttonHeight: CGFloat = 156.0
        let buttonPadding: CGFloat = 8.0
        
        buttonBackground.frame = CGRect(x: buttonPadding, y: buttonPadding, width: view.bounds.width - 16, height: buttonHeight)
        cardButton.frame = CGRect(x: buttonPadding, y: buttonPadding, width: buttonWidth, height: buttonHeight)
        balanceButton.frame = CGRect(x: buttonPadding + buttonWidth, y: buttonPadding, width: buttonWidth, height: buttonHeight)
    }
    
    private func setupCardButton() {
        
        let buttonWidth = (view.bounds.width - 16)/2.0
        
        let iconNode = ASImageNode()
        iconNode.frame = CGRect(x: (buttonWidth - 40)/2, y: 42, width: 40, height: 40)
        iconNode.image = UIImage.SVGImage(named: "icons_outlined_pay")
        iconNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(.white)
        cardButton.addSubnode(iconNode)
        
        let titleNode = ASTextNode()
        titleNode.frame = CGRect(x: 0, y: 97, width: buttonWidth, height: 22)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        titleNode.attributedText = NSAttributedString(string: "收付款", attributes: [
            .font: UIFont.systemFont(ofSize: 17.6),
            .foregroundColor: UIColor.white,
            .paragraphStyle: paragraphStyle
            ])
        cardButton.addSubnode(titleNode)
    }
    
    private func setupBalanceNode() {
        
        let buttonWidth = (view.bounds.width - 16)/2.0
        
        let iconNode = ASImageNode()
        iconNode.frame = CGRect(x: (buttonWidth - 40)/2, y: 42, width: 40, height: 40)
        iconNode.image = UIImage.SVGImage(named: "icons_outlined_wallet")
        iconNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(.white)
        balanceButton.addSubnode(iconNode)
        
        let titleNode = ASTextNode()
        titleNode.frame = CGRect(x: 0, y: 97, width: buttonWidth, height: 22)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        titleNode.attributedText = NSAttributedString(string: "钱包", attributes: [
            .font: UIFont.systemFont(ofSize: 17.6),
            .foregroundColor: UIColor.white,
            .paragraphStyle: paragraphStyle
            ])
        balanceButton.addSubnode(titleNode)
        
        let balanceValueNode = ASTextNode()
        balanceValueNode.attributedText = NSAttributedString(string: "￥100.00", attributes: [
            .font: UIFont.systemFont(ofSize: 14.4),
            .foregroundColor: UIColor(white: 1, alpha: 0.5)
            ])
        balanceButton.addSubnode(balanceValueNode)
    }
    
    private func setupOfficialActivities() {
        let activities = [
            MallFunctionActivity(identifier: 10001, title: "信用卡还款", image: UIImage(named: "mall_credit_card_repayment")),
            MallFunctionActivity(identifier: 10002, title: "手机充值", image: UIImage(named: "mall_phone_recharge")),
            MallFunctionActivity(identifier: 10003, title: "理财通", image: UIImage(named: "mall_tencent_money")),
            MallFunctionActivity(identifier: 10004, title: "生活缴费", image: UIImage(named: "mall_life_service")),
            MallFunctionActivity(identifier: 10005, title: "Q币充值", image: UIImage(named: "mall_qcoin")),
            MallFunctionActivity(identifier: 10006, title: "城市服务", image: UIImage(named: "mall_city_service")),
            MallFunctionActivity(identifier: 10007, title: "腾讯公益", image: UIImage(named: "mall_tencent_public_benefit"))
        ]
        
        let rows = (activities.count % 3) == 0 ? activities.count / 3: activities.count / 3 + 1
        
        for (index, activity) in activities.enumerated() {
            if index % 3 == 2 {
                activity.showRightLine = false
            }
            let row = index / 3
            if row == rows - 1 {
                activity.showBottomLine = false
            }
        }
    
        officialMallNode = MallFunctionActivityContainerNode(title: "腾讯服务", activities: activities)
        officialMallNode.frame = CGRect(x: 8, y: 174, width: view.bounds.width - 16, height: 53.0 + CGFloat(rows) * mallCellHeight)
        scrollNode.addSubnode(officialMallNode)
    }
    
    private func setupThirdPartyActivities() {
        let activities = [
            MallFunctionActivity(identifier: 20001, title: "火车票机票", image: UIImage(named: "mall_train_airplane_tickets")),
            MallFunctionActivity(identifier: 20002, title: "滴滴出行", image: UIImage(named: "mall_didi_service")),
            MallFunctionActivity(identifier: 20003, title: "京东购物", image: UIImage(named: "mall_jd")),
            MallFunctionActivity(identifier: 20004, title: "美团外卖", image: UIImage(named: "mall_meituan")),
            MallFunctionActivity(identifier: 20005, title: "电影演出赛事", image: UIImage(named: "mall_maoyan")),
            MallFunctionActivity(identifier: 20006, title: "吃喝玩乐", image: UIImage(named: "mall_dianping")),
            MallFunctionActivity(identifier: 20007, title: "酒店", image: UIImage(named: "mall_hotel")),
            MallFunctionActivity(identifier: 20008, title: "拼多多", image: UIImage(named: "mall_pdd")),
            MallFunctionActivity(identifier: 20009, title: "蘑菇街女装", image: UIImage(named: "mall_mogu")),
            MallFunctionActivity(identifier: 20010, title: "唯品会特卖", image: UIImage(named: "mall_vip")),
            MallFunctionActivity(identifier: 20011, title: "转转二手", image: UIImage(named: "mall_zhuanzhuan")),
            MallFunctionActivity(identifier: 20012, title: "贝壳找房", image: UIImage(named: "mall_beike"))
        ]
        
        let rows = (activities.count % 3) == 0 ? activities.count / 3: activities.count / 3 + 1
        
        for (index, activity) in activities.enumerated() {
            if index % 3 == 2 {
                activity.showRightLine = false
            }
            let row = index / 3
            if row == rows - 1 {
                activity.showBottomLine = false
            }
        }
        
        let offsetY = officialMallNode.view.frame.maxY + 10
        
        thirdPartyMallNode = MallFunctionActivityContainerNode(title: "第三方服务", activities: activities)
        thirdPartyMallNode.frame = CGRect(x: 8, y: offsetY, width: view.bounds.width - 16, height: 53.0 + CGFloat(rows) * mallCellHeight)
        scrollNode.addSubnode(thirdPartyMallNode)
        
        scrollNode.view.contentSize = CGSize(width: view.bounds.width, height: thirdPartyMallNode.frame.maxY + 10)
    }
    
}

// MARK: - Event Handlers
extension PaymentMainViewController {
    
    @objc private func moreButtonClicked() {
        
    }
    
    @objc private func cardButtonClicked() {
        
    }
    
    @objc private func balanceButtonClicked() {
        
    }
    
}
