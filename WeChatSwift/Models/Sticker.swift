//
//  Sticker.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/7/19.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation

struct StickerDesc: Codable {

    enum CodingKeys: String, CodingKey {
        case title = "default"
        case simplefiledChinese = "zh_cn"
        case tranditionalChinese = "zh_tw"
    }
    
    var title: String?
    
    var simplefiledChinese: String?
    
    var tranditionalChinese: String?
    
}


struct StickerDescPackage: Codable {
    var packageID: String
    var stickers: [String: StickerDesc]
}
