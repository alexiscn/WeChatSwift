//
//  ChatRoomDataSource.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/7/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation
import AsyncDisplayKit

final class ChatRoomDataSource {
    
    private let dateFormatter = ChatRoomDateFormatter()
    
    private var messages: [Message] = []
    
    private var currentPage = 0
    
    private let sessionID: String
    
    private let lock = DispatchSemaphore(value: 1)
    
    weak var tableNode: ASTableNode?
    
    init(sessionID: String) {
        self.sessionID = sessionID
        
        let user = MockFactory.shared.user(with: sessionID)!
        messages = MockFactory.shared.messages(with: user)
        formatTime()
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
        formatTime()
        
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
    
    func formatTime() {
        guard var time = messages.first?.time else {
            return
        }
        messages.first?._formattedTime = dateFormatter.formatTimestamp(TimeInterval(time))
        for message in messages {
            if message.time - time > 300 {
                time = message.time
                message._formattedTime = dateFormatter.formatTimestamp(TimeInterval(time))
            } else {
                message._formattedTime = nil
            }
        }
    }
    
}

