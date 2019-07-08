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
    var size: CGSize = .zero
}

struct MomentLikeUser {
    var userID: String
}

class MomentComment {
    var userID: String = ""
    var comment: String = ""
}
