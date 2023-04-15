//
//  ScrollActionSheetItem.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/27.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

class ScrollActionSheetItem {
    enum Action {
        case sendToFriend
        case sendToMoment
        case favorite
        case openInSafari
        case searchInPage
        case floating
        case report
        case copyLink
        case refresh
        case adjustFont
    }
    
    var action: Action
    
    var title: String
    
    var iconImage: UIImage?
    
    var disabled: Bool = false
    
    var userInfo: [String: Any]? = nil
    
    init(action: Action, title: String, iconImage: UIImage?) {
        self.action = action
        self.title = title
        self.iconImage = iconImage
    }
}


