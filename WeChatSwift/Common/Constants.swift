//
//  Constants.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/4.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

struct Constants {
    
    static let screenHeight = UIScreen.main.bounds.height
    
    static let screenWidth = UIScreen.main.bounds.width
    
    static var screenSize: CGSize {
        return CGSize(width: screenWidth, height: screenHeight)
    }
    
    static let iPhoneX = UIScreen.main.bounds.height >= 812
    
    static let lineHeight = 1/UIScreen.main.scale
    
    static var bottomInset: CGFloat {
        return iPhoneX ? 34.0: 0.0
    }
    
    static var topInset: CGFloat {
        return iPhoneX ? 44.0: 0.0
    }
    
    static var statusBarHeight: CGFloat {
        return iPhoneX ? 44.0: 20.0
    }
    
    static let durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.calendar = Calendar(identifier: .chinese)
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        return formatter
    }()
    
    static func formatDuration(_ duration: TimeInterval) -> String {
        if let text = durationFormatter.string(from: duration) {
            if text.count == 3 {
                return "0" + text
            }
            return text
        }
        return ""
    }
    
    static let BrandSessionName = "brandsessionholder"
    
    static let helpURL = URL(string: "https://kf.qq.com/touch/product/wechat_app.html?scene_id=kf338")

    /// 收付款的使用说明URL
    static let payHelpURL = URL(string: "https://wx.gtimg.com/action/shuaka/help.shtml")
    
    static let labAgreementURL = URL(string: "https://weixin.qq.com/cgi-bin/readtemplate?t=weixin_agreement&s=lab&lang=zh_CN&cliVersion=385877288")
    
    static let arrowImage = UIImage.SVGImage(named: "icons_outlined_arrow")
    
    static let moreImage = UIImage.SVGImage(named: "icons_filled_more")
    
    static let backImage = UIImage.SVGImage(named: "icons_outlined_back")?.withRenderingMode(.alwaysTemplate)
}
