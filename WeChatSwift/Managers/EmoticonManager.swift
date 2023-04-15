//
//  EmoticonManager.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/7/18.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation
import SSZipArchive

class EmoticonManager {
 
    public private(set) var emoticons: [EmoticonViewModel] = []
    
    public private(set) var allStickers: [EmoticonPackage] = []
    
    public private(set) var allStickerPackageDesc: [StickerDescPackage] = []
    
    init() {
        
    }
    
    func setup() {
        let expressionTabImage = UIImage.SVGImage(named: "icons_outlined_sticker")
        emoticons.append(EmoticonViewModel(type: .expression, tabImage: expressionTabImage, emoticons: Expression.all))
        
        let favImage = UIImage.SVGImage(named: "icons_outlined_like")
        
        var favorites: [FavoriteEmoticon] = []
        favorites.append(FavoriteEmoticon(type: .add))
        favorites.append(FavoriteEmoticon(type: .jsb))
        favorites.append(FavoriteEmoticon(type: .dice))
        emoticons.append(EmoticonViewModel(type: .favorites, tabImage: favImage, emoticons: favorites))
        
        let takeImage = UIImage.SVGImage(named: "icons_outlined_takephoto_nor")
        emoticons.append(EmoticonViewModel(type: .cameraEmoticon, tabImage: takeImage, emoticons: []))
        
        let path = NSHomeDirectory().appending("/Documents/emoticons/")
        //try? FileManager.default.removeItem(atPath: path)
        if !FileManager.default.fileExists(atPath: path) {
            try? FileManager.default.createDirectory(at: URL(fileURLWithPath: path), withIntermediateDirectories: true, attributes: nil)
            if let zipPath = Bundle.main.path(forResource: "Emoticons", ofType: "zip") {
                SSZipArchive.unzipFile(atPath: zipPath, toDestination: path)
            }
        }
        
        if let jsonPath = Bundle.main.path(forResource: "Emoticons", ofType: "json"),
            let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) {
            do {
                let list = try JSONDecoder().decode([EmoticonPackage].self, from: jsonData)
                allStickers = list
                list.forEach { package in
                    if let desc = package.toDescPackage() {
                        allStickerPackageDesc.append(desc)
                    }
                }
                list.forEach { emoticons.append($0.toEmoticonViewModel()) }
            } catch {
                print(error)
            }
        }
    }
}
