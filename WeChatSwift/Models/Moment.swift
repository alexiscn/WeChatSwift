//
//  Moment.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/7/4.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation
import UIKit

class Moment: Equatable {
    
    var identifier: String = ""
    
    var userID: String = ""
    
    var time: Int = 0
    
    var content: String? = nil
    
    var body: MomentBody = .none
    
    var likes: [MomentLikeUser] = []
    
    var comments: [MomentComment] = []
    
    var liked: Bool = false
    
    static func == (lhs: Moment, rhs: Moment) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}


enum MomentBody {
    case none
    case link(MomentWebpage)
    case media(MomentMedia)
    case video(MomentVideo)
    case multi(MomentMultiImage)
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

class MomentVideo {
    
    var url: URL?
    
    var thumb: UIImage?
    
    var size: CGSize
    
    var length: TimeInterval
    
    init(url: URL?, thumb: UIImage?, size: CGSize, length: TimeInterval) {
        self.url = url
        self.thumb = thumb
        self.size = size
        self.length = length
    }
}

struct MomentLikeUser {
    var userID: String
    var username: String
    
    func attributedStringForName() -> NSAttributedString {
        return NSAttributedString(string: username, attributes: [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: Colors.DEFAULT_LINK_COLOR
            ])
    }
}

class MomentComment {
    /// 评论ID
    var commentId: String = ""
    
    /// 评论发布者的昵称
    var nickname: String = ""
    
    /// 评论发布者的UID
    var userID: String = ""
    
    /// 评论发布时间
    var createTime: Int64 = 0
    
    /// 评论内容
    var content: String = ""
    
    /// 评论中@XX 发表的评论ID
    var refCommentId: String? = nil
    
    var refUsername: String? = nil
    
    var refUserId: String? = nil
    
    /// 是否为本地添加
    var isLocalAdded: Bool = false
    
    /// 评论类型（未知）
    var type: Int = 0
    
    /// 是否能删除
    var canBeDeleted: Bool = false
    
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
    
    func attributedStringForTitle() -> NSAttributedString? {
        guard let title = title else { return nil }
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: Colors.DEFAULT_TEXT_COLOR,
            .font: UIFont.systemFont(ofSize: 14.5)
        ]
        return NSAttributedString(string: title, attributes: attributes)
    }
}

struct MomentMultiImage {
    var images: [MomentMedia]
}

extension Moment {
    
    func attributedStringForUsername(with name: String) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: Colors.DEFAULT_LINK_COLOR,
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]
        return NSAttributedString(string: name, attributes: attributes)
    }
    
    func timeAttributedText() -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(white: 0, alpha: 0.3),
            .font: UIFont.systemFont(ofSize: 14)
        ]
        return NSAttributedString(string: "5小时前", attributes: attributes)
    }
    
    func contentAttributedText() -> NSAttributedString? {
        guard let content = content else { return nil }
        
        let textFont = UIFont.systemFont(ofSize: 17)
        let lineHeight = textFont.lineHeight
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.lineSpacing = 3
        paragraphStyle.maximumLineHeight = lineHeight
        paragraphStyle.minimumLineHeight = lineHeight
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: Colors.DEFAULT_TEXT_COLOR,
            .font: UIFont.systemFont(ofSize: 17),
            .paragraphStyle: paragraphStyle
        ]
        let attributedText = NSAttributedString(string: content, attributes: attributes)
        return ExpressionParser.shared?.attributedText(with: attributedText)
    }
    
}

struct MomentNewMessage {
    
    var userAvatar: UIImage?
    
    var unread: Int
}
