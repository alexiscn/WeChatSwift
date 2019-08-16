//
//  MomentBackground.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/16.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

struct MomentBackgroundModel: Codable {
    
    var artist: MomentBackgroundArtist
    
    var photos: [MomentBackgroundGroup]
    
}

struct MomentBackgroundArtist: Codable {
    
    enum CodingKeys: String, CodingKey {
        case name
        case desc
        case thumbAvatarURL = "avatar_thumb"
        case avatarURL = "avatar"
    }
    
    var name: String
    
    var desc: String
    
    var thumbAvatarURL: URL?
    
    var avatarURL: URL?
    
}

struct MomentBackgroundGroup: Codable {
    
    var name: String
    
    var items: [MomentBackground]
    
    func attributedStringForName() -> NSAttributedString {
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor(hexString: "#909090")
        ]
        return NSAttributedString(string: name, attributes: attributes)
    }
}

struct MomentBackground: Codable {
    
    var previewURL: URL?
    
    var url: URL?
}
