//
//  ChatRoomDataSource.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation

final class ChatRoomDataSource {
    
    private var messages: [Message] = []
    
    private var currentPage = 0
    
    private let sessionID: String
    
    init(sessionID: String) {
        self.sessionID = sessionID
        
        let user = MockFactory.shared.users.first(where: { $0.identifier == sessionID })!
        messages = MockFactory.shared.messages(with: user)
    }
    
    func numberOfRows() -> Int {
        return messages.count
    }
    
    func itemAtIndexPath(_ indexPath: IndexPath) -> Message {
        return messages[indexPath.row]
    }
    
}
