//
//  WCTableCellModel.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/8/10.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit


/// Style of WCTableCell
///
/// - `default`: Normal Cell Style
/// - centerButton: Center Text Button
/// - destructiveButton: Center Text Destructive Button
enum WCTableCellStyle {
    case `default`
    case centerButton
    case destructiveButton
}

protocol WCTableCellModel {
    
    /// Icon Image, default nil
    var wc_image: UIImage? { get }
    
    var wc_imageLayoutSize: CGSize { get }
    
    var wc_imageCornerRadius: CGFloat { get }
    
    var wc_title: String { get }
    
    var wc_badgeCount: Int { get }
    
    var wc_accessoryNode: ASDisplayNode? { get }
    
    var wc_showArrow: Bool { get }
    
    var wc_showSwitch: Bool { get }
    
    var wc_switchValue: Bool { get }
    
    var wc_cellStyle: WCTableCellStyle { get }
}

extension WCTableCellModel {
    
    var wc_image: UIImage? { return nil }
    
    var wc_badgeCount: Int { return 0 }
    
    var wc_imageLayoutSize: CGSize { return CGSize(width: 24.0, height: 24.0) }
    
    var wc_imageCornerRadius: CGFloat { return 0.0 }
    
    var wc_accessoryNode: ASDisplayNode? { return nil }
    
    var wc_showArrow: Bool { return true }
    
    var wc_showSwitch: Bool { return false }
    
    var wc_switchValue: Bool { return false }
    
    var wc_cellStyle: WCTableCellStyle { return .default }
    
    func wc_attributedStringForTitle() -> NSAttributedString {
        
        switch self.wc_cellStyle {
        case .destructiveButton:
            return NSAttributedString(string: wc_title, attributes: [
                .font: UIFont.systemFont(ofSize: 17),
                .foregroundColor: Colors.Red,
                ])
        default:
            return NSAttributedString(string: wc_title, attributes: [
                .font: UIFont.systemFont(ofSize: 17),
                .foregroundColor: UIColor(white: 0, alpha: 0.9)
                ])
        }
    }
}
