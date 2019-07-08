//
//  UserProfileService.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/4.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation

class UserProfileService {
    
    func getUser(with uid: String) -> MockFactory.MockUser? {
        return MockFactory.shared.users.first(where: { $0.identifier == uid })
    }
    
}
