//
//  PayOfflinePayViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/30.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class PayOfflinePayViewController: ASViewController<ASTableNode> {
    
    private var dataSource: [PayOfflinePayAction] = []
    
    init() {
        super.init(node: ASTableNode(style: .plain))
        node.delegate = self
        node.dataSource = self
        dataSource = PayOfflinePayAction.allCases
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = UIColor(hexString: "#439057")
        node.view.separatorStyle = .none
    }
}

// MARK: - ASTableDelegate & ASTableDataSource
extension PayOfflinePayViewController: ASTableDelegate, ASTableDataSource {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let action = dataSource[indexPath.row]
        let block: ASCellNodeBlock = {
            return PayOfflinePayCellNode(action: action)
        }
        return block
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: false)
    }
}


enum PayOfflinePayAction: CaseIterable {
    case reveive
    case reward
    case activityPayment
    case faceToFaceRedPacket
    case transferToCard
    
    var title: String {
        switch self {
        case .reveive:
            return "二维码收款"
        case .reward:
            return "赞赏码"
        case .activityPayment:
            return "群收款"
        case .faceToFaceRedPacket:
            return "面对面红包"
        case .transferToCard:
            return "转账到银行卡"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .reveive:
            return UIImage(named: "Receive_Icon_23x23_")
        case .reward:
            return UIImage(named: "Reward_Icon_23x23_")
        case .activityPayment:
            return UIImage(named: "Activity_PayIcon_23x23_")
        case .faceToFaceRedPacket:
            return UIImage(named: "f2fHongbao_Icon_23x23_")
        case .transferToCard:
            return UIImage(named: "WCPay_TransToBank_Icon_23x23_")
        }
    }
    
    func attributedStringForTitle() -> NSAttributedString {
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: Colors.white
        ]
        return NSAttributedString(string: title, attributes: attributes)
    }
}
