//
//  Emoticon.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/7/16.
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
    
    func toDescPackage() -> StickerDescPackage? {
        var package: StickerDescPackage? = nil
        if let descPath = Bundle.main.path(forResource: packageID, ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: descPath)) {
            do {
                package = try JSONDecoder().decode(StickerDescPackage.self, from: data)
            } catch {
                print(error)
            }
            
        }
        return package
    }
    
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
        let tabImage = UIImage(named: "\(packageID).png")
        return EmoticonViewModel(type: .sticker, tabImage: tabImage, emoticons: items)
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
        if type == .cameraEmoticon && pagesDataSource.count == 0 {
            return 1
        }
        return pagesDataSource.count
    }
    
    func numberOfItems(at page: Int) -> [Emoticon] {
        if pagesDataSource.count == 0 {
            return []
        }
        return pagesDataSource[page]
    }
}


/// 表情类型
///
/// - expression: emoji 表情
/// - favorites: 自定义表情
/// - cameraEmoticon: 相机表情
/// - sticker: 商城表情
enum EmoticonType {
    case expression
    case favorites
    case cameraEmoticon
    case sticker
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


struct FavoriteEmoticon: Emoticon {
    
    var thumbImage: UIImage? {
        switch type {
        case .add:
            return UIImage(named: "EmoticonAddButton_56x56_")
        case .dice:
            return UIImage(named: "dice_emoticon_md5")
        case .jsb:
            return UIImage(named: "jsb_emoticon_md5")
        }
    }
    
    var title: String? = nil
    
    var type: FavoriteEmoticonType
    
    init(type: FavoriteEmoticonType) {
        self.type = type
    }
}

enum FavoriteEmoticonType {
    case add
    case dice
    case jsb
}

struct EmoticonBanner: Codable {
    
    let width: CGFloat
    
    let height: CGFloat
    
    let productId: String?
    
    let setType: EmoticonBannerType
    
    let title: String?
    
    let desc: String?
    
    let iconUrl: URL?
}

enum EmoticonBannerType: Int, Codable {
    case personalSticker = 1
    case stickerList = 3
}


struct StoreEmoticonItem {
    
    var image: UIImage?
    
    var title: String?
    
    var desc: String?
    
    func attributedStringForTitle() -> NSAttributedString? {
        guard let title = title else { return nil }
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor(hexString: "#111111")
        ]
        return NSAttributedString(string: title, attributes: attributes)
    }
    
    func attributedStringForDesc() -> NSAttributedString? {
        guard let desc = desc else { return nil }
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13),
            NSAttributedString.Key.foregroundColor: Colors.DEFAULT_TEXT_GRAY_COLOR
        ]
        return NSAttributedString(string: desc, attributes: attributes)
    }
}
