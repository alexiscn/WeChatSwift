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
    
    var thumbImage: UIImage? { get }
    
    var title: String? { get set }
}

struct EmoticonPackage: Codable {
    
    var packageID: String
    
    var emoticons: [String]
    
    func toEmoticonViewModel() -> EmoticonViewModel {
        
        var package: StickerDescPackage? = nil
        if let descPath = Bundle.main.path(forResource: packageID, ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: descPath)) {
            do {
                package = try JSONDecoder().decode(StickerDescPackage.self, from: data)
            } catch {
                print(error)
            }
            
        }
        
        let items = emoticons.map { return WCEmotion(packageID: packageID, name: $0, package: package) }
        return EmoticonViewModel(type: .emotion, tabImage: nil, emoticons: items)
    }
}

struct WCEmotion: Emoticon {
    
    var packageID: String
    
    var name: String
    
    var thumbImage: UIImage? {
        let folder = NSHomeDirectory().appending("/Documents/emoticons/thumbs/")
        let filename = folder.appending("\(name).pic.thumb")
        if let data = try? Data(contentsOf: URL(fileURLWithPath: filename)) {
            return UIImage(data: data)
        }
        return UIImage.as_imageNamed(filename)
    }
    
    var title: String? = nil
    
    init(packageID: String, name: String, package: StickerDescPackage?) {
        self.packageID = packageID
        self.name = name
        
        self.title = package?.stickers.first(where: { $0.key == name })?.value.title
    }
}

struct EmoticonViewModel {
    
    var type: EmoticonType
    
    var tabImage: UIImage?
    
    var layout: EmoticonGridLayoutInfo
    
    private var pagesDataSource: [[Emoticon]] = []
    
    init(type: EmoticonType, tabImage: UIImage?, emoticons: [Emoticon]) {
        self.type = type
        self.tabImage = tabImage
        self.layout = EmoticonGridLayoutInfo(emoticonType: type)
        var temp: [Emoticon] = []
        for index in 0 ..< emoticons.count {
            if index != 0 && index % layout.numberOfItemsInPage == 0 {
                pagesDataSource.append(temp)
                temp.removeAll()
            }
            temp.append(emoticons[index])
        }
        if temp.count > 0 {
            pagesDataSource.append(temp)
            temp.removeAll()
        }
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
}

class EmoticonGridLayoutInfo {
    
    var emoticonType: EmoticonType
    
    var itemSize: CGSize = .zero
    
    var rows: Int = 2
    
    var marginTop: CGFloat = 1
    
    var spacingX: CGFloat = 1
    
    var spacingY: CGFloat = 1
    
    var marginLeft: CGFloat = 20
    
    var columns: Int = 0
    
    var numberOfItemsInPage: Int {
        if emoticonType == .expression {
            return rows * columns - 1
        }
        return rows * columns
    }
    
    init(emoticonType: EmoticonType) {
        self.emoticonType = emoticonType
        
        switch emoticonType {
        case .expression:
            itemSize = CGSize(width: 30, height: 30)
            rows = 3
            spacingX = 12
            spacingY = 12
            marginTop = 30
        case .favorites:
            itemSize = CGSize(width: 56, height: 56)
            rows = 2
            spacingX = 18
            spacingY = 15
            marginTop = 18
        default:
            itemSize = CGSize(width: 56, height: 56)
            rows = 2
            spacingX = 18
            spacingY = 23
            marginTop = 10
        }
        
        let columns = Int((Constants.screenWidth - 2 * marginLeft + spacingX)/(spacingX + itemSize.width))
        let margin = (Constants.screenWidth + spacingX - CGFloat(columns) * (itemSize.width + spacingX))/2
        self.columns = columns
        
        if emoticonType != .expression {
            let width = Constants.screenWidth - CGFloat(columns) * itemSize.width
            let space = width / CGFloat(columns - 1 + 2)
            self.marginLeft = space
            self.spacingX = space
        } else {
            self.marginLeft = margin
        }
    }
    

}
