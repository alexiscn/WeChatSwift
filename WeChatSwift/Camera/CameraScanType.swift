//
//  CameraScanType.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/13.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

enum CameraScanType {
    case qrCode
    case book
    case street
    case word
    
    var image: UIImage? {
        switch self {
        case .qrCode:
            return UIImage(named: "ScanQRCode_35x35_")
        case .book:
            return UIImage(named: "ScanBook_35x35_")
        case .street:
            return UIImage(named: "ScanStreet_35x35_")
        case .word:
            return UIImage(named: "ScanTrans_35x35_")
        }
    }
    
    var lighlightImage: UIImage? {
        switch self {
        case .qrCode:
            return UIImage(named: "ScanQRCode_HL_35x35_")
        case .book:
            return UIImage(named: "ScanBook_HL_35x35_")
        case .street:
            return UIImage(named: "ScanStreet_HL_35x35_")
        case .word:
            return UIImage(named: "ScanTrans_HL_35x35_")
        }
    }
    
    var title: String {
        switch self {
        case .qrCode:
            return "扫码"
        case .book:
            return "封面"
        case .street:
            return "街景"
        case .word:
            return "翻译"
        }
    }
    
    func attributedStringForNormalTitle() -> NSAttributedString {
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11),
            NSAttributedString.Key.foregroundColor: UIColor(hexString: "#B2B2B2")
        ]
        return NSAttributedString(string: title, attributes: attributes)
    }
    
    func attributedStringForHighlightTitle() -> NSAttributedString {
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11),
            NSAttributedString.Key.foregroundColor: Colors.Brand
        ]
        return NSAttributedString(string: title, attributes: attributes)
    }
}
