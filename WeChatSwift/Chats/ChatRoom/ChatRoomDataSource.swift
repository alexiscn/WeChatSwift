//
//  ChatRoomDataSource.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation
import AsyncDisplayKit

final class ChatRoomDataSource {
    
    private var messages: [Message] = []
    
    private var currentPage = 0
    
    private let sessionID: String
    
    private let lock = DispatchSemaphore(value: 1)
    
    weak var tableNode: ASTableNode?
    
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
    
    func append(_ message: Message, scrollToLastMessage: Bool = true) {
        let _ = lock.wait(timeout: .distantFuture)
        messages.append(message)
        
        tableNode?.insertRows(at: [IndexPath(row: messages.count - 1, section: 0)], with: .none)
        
        if scrollToLastMessage {
            let last = messages.count - 1
            if last > 0 {
                let indexPath = IndexPath(row: last, section: 0)
                tableNode?.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
        
        lock.signal()
    }
    
}
