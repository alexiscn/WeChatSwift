//
//  Emoticon.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/16.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation
import UIKit

struct EmoticonPackage: Codable {
    
    var packageID: String
    
    var emoticons: [String]
    
}

struct Emotion {
    
    var packageID: String
    
    var name: String
    
    var imageName: String {
        return ""
    }
    
    var thumbImageName: String {
        return ""
    }
    
}

protocol Emoticon {
    
}

struct EmoticonModel {
    var type: EmoticonType
    var pages: Int
    private var sections: [[Emoticon]]
    
    init(type: EmoticonType, emoticons: [Emoticon]) {
        self.type = type
        self.sections = []
        
//        let count = emoticons.count
//        let rows = type.rows
//        let columns = 6
//        
//        var temp: [Emoticon] = []
//        var offset: Int = 0
//        for index in 0 ..< count {
//            if offset == rows * columns {
//                
//            }
//        }
        
//        let itemSize = CGSize(width: 36.0, height: 36.0)
//        let itemSpacing: CGFloat = 6
//        var margin: CGFloat = 12.0
//        let columns = Int((Constants.screenWidth - 2.0 * margin + itemSpacing) / (itemSpacing + itemSize.width))
//        margin = (Constants.screenWidth - CGFloat(columns) * (itemSize.height + itemSpacing))/2
        
        self.pages = 1
    }
    
    func numberOfItems(at page: Int) -> [Emoticon] {
        return sections[page]
    }
}

enum EmoticonType {
    case expression
    case favorites
    case custom
    case emotion
    
    var itemSize: CGSize {
        switch self {
        case .expression:
            return CGSize(width: 36, height: 36)
        case .emotion:
            return CGSize(width: 56, height: 56)
        default:
            return CGSize(width: 60, height: 60)
        }
    }
    
    var rows: Int {
        switch self {
        case .expression:
            return 3
        default:
            return 2
        }
    }
}
