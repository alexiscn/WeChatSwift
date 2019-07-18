//
//  EmoticonManager.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/18.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation
import SSZipArchive

class EmoticonManager {
 
    private var emoticons: [EmoticonViewModel] = []
    
    init() {
        emoticons.append(EmoticonViewModel(type: .expression, emoticons: []))
        emoticons.append(EmoticonViewModel(type: .favorites, emoticons: []))
        emoticons.append(EmoticonViewModel(type: .custom, emoticons: []))
        if let jsonPath = Bundle.main.path(forResource: "Emoticons", ofType: "json"),
            let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) {
            do {
                let list = try JSONDecoder().decode([EmoticonPackage].self, from: jsonData)
                for _ in list {
                    emoticons.append(EmoticonViewModel(type: .emotion, emoticons: []))
                }
            } catch {
                print(error)
            }
        }
    }
    
    func stickers() -> [EmoticonViewModel] {
        return emoticons
    }
    
    func setup() {
        let path = NSHomeDirectory().appending("/Documents/emoticons/")
        if !FileManager.default.fileExists(atPath: path) {
            
        }
    }
    
}
