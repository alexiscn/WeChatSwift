//
//  PayOfflinePayAction.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

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
