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

struct WCEmotion {
    
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

struct EmoticonViewModel {
    
    var type: EmoticonType
    
    var layout: EmoticonGridInfo
    
    private var pagesDataSource: [[Emoticon]] = []
    
    init(type: EmoticonType, emoticons: [Emoticon]) {
        self.type = type
        
        var layout = type.layoutInfo
        let columns = Int((Constants.screenWidth + layout.spacingX)/(layout.spacingX + layout.itemSize.height))
        let margin = (Constants.screenWidth - CGFloat(columns) * (layout.itemSize.height + layout.spacingX))/2
        layout.marginLeft = margin
        let count = emoticons.count
        let rows = layout.rows
        
        print("当前的Type:\(type)，列数：\(columns)，左边距:\(margin)")

        let numberOfItemsInPage = type == .emotion ? (rows * columns - 1): rows * columns
        var temp: [Emoticon] = []
        for index in 0 ..< count {
            if index == numberOfItemsInPage {
                pagesDataSource.append(temp)
                temp.removeAll()
            }
            temp.append(emoticons[index])
        }
        if temp.count > 0 {
            pagesDataSource.append(temp)
            temp.removeAll()
        }
        
        self.layout = layout
    }
    
    func numberOfPages() -> Int {
        return pagesDataSource.count
    }
    
    func numberOfItems(at page: Int) -> [Emoticon] {
        return pagesDataSource[page]
    }
}

enum EmoticonType {
    case expression
    case favorites
    case custom
    case emotion
    
    var layoutInfo: EmoticonGridInfo {
        switch self {
        case .expression:
            let size = CGSize(width: 30, height: 30)
            return EmoticonGridInfo(itemSize: size, rows: 3, marginTop: 30, spacingX: 12.0, spacingY: 12)
        case .favorites:
            let size = CGSize(width: 56, height: 56)
            return EmoticonGridInfo(itemSize: size, rows: 2, marginTop: 18, spacingX: 18.0, spacingY: 15)
        default:
            let size = CGSize(width: 56, height: 56)
            return EmoticonGridInfo(itemSize: size, rows: 2, marginTop: 10, spacingX: 18.0, spacingY: 23)
        }
    }
}

struct EmoticonGridInfo {
    
    var itemSize: CGSize
    
    var rows: Int
    
    var marginTop: CGFloat
    
    var spacingX: CGFloat
    
    var spacingY: CGFloat
    
    var marginLeft: CGFloat = 0.0
    
    init(itemSize: CGSize, rows: Int, marginTop: CGFloat, spacingX: CGFloat, spacingY: CGFloat) {
        self.itemSize = itemSize
        self.rows = rows
        self.marginTop = marginTop
        self.spacingX = spacingX
        self.spacingY = spacingY
    }
}

struct EmoticonTab {
    var thumbImage: UIImage?
}
