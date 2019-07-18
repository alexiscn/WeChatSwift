//
//  Emoticon.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/16.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation
import UIKit

protocol Emoticon {
    var image: UIImage? { get }
}

struct EmoticonPackage: Codable {
    
    var packageID: String
    
    var emoticons: [String]
    
    func toEmoticonViewModel() -> EmoticonViewModel {
        let items = emoticons.map { return WCEmotion(packageID: packageID, name: $0) }
        return EmoticonViewModel(type: .emotion, tabImage: nil, emoticons: items)
    }
}

struct WCEmotion: Emoticon {
    
    var packageID: String
    
    var name: String
    
    var image: UIImage? {
        let folder = NSHomeDirectory().appending("/Documents/emoticons/Emoticons/")
        let filename = folder.appending("\(name).pic.thumb")
//        if name == "ba7eb52f6b1b5ebc42ed7e3f2a7cac14" {
//            let img = UIImage(named: filename)
//            print(img)
//        }
        return UIImage.as_imageNamed(filename)
    }
}

struct EmoticonViewModel {
    
    var type: EmoticonType
    
    var tabImage: UIImage?
    
    var layout: EmoticonGridInfo
    
    private var pagesDataSource: [[Emoticon]] = []
    
    init(type: EmoticonType, tabImage: UIImage?, emoticons: [Emoticon]) {
        self.type = type
        self.tabImage = tabImage
        var layout = type.layoutInfo
        let columns = Int((Constants.screenWidth - 2 * layout.marginLeft + layout.spacingX)/(layout.spacingX + layout.itemSize.width))
        let margin = (Constants.screenWidth + layout.spacingX - CGFloat(columns) * (layout.itemSize.width + layout.spacingX))/2
        layout.marginLeft = margin
        layout.columns = columns
        if type != .expression {
            let width = Constants.screenWidth - CGFloat(columns) * layout.itemSize.width
            let space = width / CGFloat(columns - 1 + 2)
            layout.marginLeft = space
            layout.spacingX = space
        }
        
        //print("当前的Type:\(type)，列数：\(columns)，左边距:\(layout.marginLeft)，间距:\(layout.spacingX)")

        let count = emoticons.count
        let rows = layout.rows
        let numberOfItemsInPage = type == .expression ? (rows * columns - 1): rows * columns
        var temp: [Emoticon] = []
        for index in 0 ..< count {
            if index != 0 && index % numberOfItemsInPage == 0 {
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
            return EmoticonGridInfo(itemSize: size, rows: 3, marginTop: 30, spacingX: 12.0, spacingY: 12, marginLeft: 20)
        case .favorites:
            let size = CGSize(width: 56, height: 56)
            return EmoticonGridInfo(itemSize: size, rows: 2, marginTop: 18, spacingX: 18.0, spacingY: 15, marginLeft: 20)
        default:
            let size = CGSize(width: 56, height: 56)
            return EmoticonGridInfo(itemSize: size, rows: 2, marginTop: 10, spacingX: 18.0, spacingY: 23, marginLeft: 20)
        }
    }
}

struct EmoticonGridInfo {
    
    var itemSize: CGSize
    
    var rows: Int
    
    var marginTop: CGFloat
    
    var spacingX: CGFloat
    
    var spacingY: CGFloat
    
    var marginLeft: CGFloat
    
    var columns: Int = 0
    
    init(itemSize: CGSize, rows: Int, marginTop: CGFloat, spacingX: CGFloat, spacingY: CGFloat, marginLeft: CGFloat) {
        self.itemSize = itemSize
        self.rows = rows
        self.marginTop = marginTop
        self.spacingX = spacingX
        self.spacingY = spacingY
        self.marginLeft = marginLeft
    }
}
