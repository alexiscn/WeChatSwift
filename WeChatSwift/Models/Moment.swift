//
//  Moment.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/4.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation
import UIKit

class Moment {
    
    var userID: String = ""
    
    var time: Int = 0
    
    var content: String? = nil
    
    var body: MomentBody = .none
    
    var likes: [MomentLikeUser] = []
    
    var comments: [MomentComment] = []
}


enum MomentBody {
    case none
    case link(URL)
    case media(MomentMedia)
}

class MomentMedia {
    
    var url: URL? = nil
    
    var image: UIImage? = nil
    
    var size: CGSize = CGSize(width: 1.0, height: 1.0)
    
    init(url: URL?, size: CGSize = CGSize(width: 1.0, height: 1.0)) {
        self.url = url
        self.size = size
    }
    
    init(image: UIImage?, size: CGSize = CGSize(width: 1.0, height: 1.0)) {
        self.image = image
        self.size = size
    }
}

struct MomentLikeUser {
    var userID: String
}

class MomentComment {
    var userID: String = ""
    var comment: String = ""
}

struct MomentWebpage {
    var url: URL?
    var title: String?
    var thumbImage: UIImage? = nil
    var thumbImageURL: URL? = nil
    
    init(url: URL?, title: String?, thumbImage: UIImage? = nil, thumbImageURL: URL? = nil) {
        self.url = url
        self.title = title
        self.thumbImage = thumbImage
        self.thumbImageURL = thumbImageURL
    }
}

extension Moment {
    
    func attributedStringForUsername(with name: String) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: Colors.DEFAULT_LINK_COLOR,
            .font: UIFont.systemFont(ofSize: 15, weight: .semibold)
        ]
        return NSAttributedString(string: name, attributes: attributes)
    }
    
    func timeAttributedText() -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: Colors.DEFAULT_TEXT_DISABLED_COLOR,
            .font: UIFont.systemFont(ofSize: 13)
        ]
        return NSAttributedString(string: "5小时前", attributes: attributes)
    }
    
    func contentAttributedText() -> NSAttributedString? {
        guard let content = content else { return nil }
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: Colors.DEFAULT_TEXT_COLOR,
            .font: UIFont.systemFont(ofSize: 15)
        ]
        return NSAttributedString(string: content, attributes: attributes)
    }
    
}
