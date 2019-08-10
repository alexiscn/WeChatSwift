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
    
    static let helpURL = URL(string: "https://kf.qq.com/touch/product/wechat_app.html?scene_id=kf338")

    /// 收付款的使用说明URL
    static let payHelpURL = URL(string: "https://wx.gtimg.com/action/shuaka/help.shtml")
    
    static let labAgreementURL = URL(string: "https://weixin.qq.com/cgi-bin/readtemplate?t=weixin_agreement&s=lab&lang=zh_CN&cliVersion=385877288")
    
    static let arrowImage = UIImage.SVGImage(named: "icons_outlined_arrow")
    
    static let moreImage = UIImage.SVGImage(named: "icons_filled_more")
}
