//
//  MockData.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/9/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation
import UIKit

struct MockData: Codable {
    
    enum Gender: String, Codable {
        case male = "M"
        case female = "F"
    }
    
    struct User: Codable {
        
        let identifier: String
        
        let name: String
        
        let name_en: String
        
        let family: String
        
        let avatar: URL?
        
        let gender: Gender
        
        let country: String
        
        let wxid: String
    }
    
    struct Image: Codable {
        let url: URL?
        let middle_url: URL?
        let size: ImageSize
    }
    
    struct ImageSize: Codable {
        
        let width: CGFloat
        
        let height: CGFloat
        
        var value: CGSize {
            return CGSize(width: width, height: height)
        }
    }
    
    struct WebPage: Codable {
        
        var url: URL?
        
        var title: String
        
        var thumb_url: URL?
    }
    
    let users: [User]
    
    let images: [Image]
    
    let webpages: [WebPage]
    
    var messages: [String]
}



extension MockData.User {
    
    func toContact() -> Contact {
        let contact = Contact()
        contact.avatarURL = avatar
        contact.name = name
        contact.gender = gender
        contact.wxid = wxid
        
        let str = NSMutableString(string: name) as CFMutableString
        if CFStringTransform(str, nil, kCFStringTransformToLatin, false) && CFStringTransform(str, nil, kCFStringTransformStripDiacritics, false) {
            contact.letter = String(((str as NSString) as String).first!).uppercased()
        }
        
        return contact
    }
    
    func toMultiSelectContact() -> MultiSelectContact {
        let contact = MultiSelectContact()
        contact.avatarURL = avatar
        contact.name = name
        contact.gender = gender
        contact.wxid = wxid
        
        let str = NSMutableString(string: name) as CFMutableString
        if CFStringTransform(str, nil, kCFStringTransformToLatin, false) && CFStringTransform(str, nil, kCFStringTransformStripDiacritics, false) {
            contact.letter = String(((str as NSString) as String).first!).uppercased()
        }
        return contact
    }
    
}
