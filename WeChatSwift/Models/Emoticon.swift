//
//  Emoticon.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/16.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation

struct EmoticonPackage: Codable {
    
    var packageID: String
    
    var emoticons: [String]
    
}

struct Emoticon {
    
    var packageID: String
    
    var name: String
    
    var imageName: String {
        return ""
    }
    
    var thumbImageName: String {
        return ""
    }
    
}
