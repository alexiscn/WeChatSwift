//
//  MeTableModel.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/7/4.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

struct MeTableSection {
    var items: [MeTableModel]
}

struct MeTableModel {
    
    enum MeType {
        case pay
        case favorites
        case posts
        case cards
        case sticker
        case settings
        case debug
    }
    
    var type: MeType
    var image: UIImage?
    var title: String
    var unread: Bool = false
    var unreadCount: Int = 0
    
    init(type: MeType, title: String, icon: String, color: UIColor? = nil) {
        self.type = type
        self.title = title
        self.image = UIImage.SVGImage(named: icon, fillColor: color)
        self.unread = false
        self.unreadCount = 0
    }
}

extension MeTableModel: WCTableCellModel {
    
    var wc_image: UIImage? { return image }
    
    var wc_title: String { return title }
}
