//
//  MockFactory.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/4.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation

struct MockFactory {
    
    struct MockUser {
        var identifier: String
        var name: String
        var avatar: String
    }
    
    static let shared = MockFactory()
    
    var users: [MockUser] = []
    
    var messages: [String] = []
    
    private init() {
    
        // 兰尼斯特
        users.append(MockUser(identifier: "10001", name: "提利昂·兰尼斯特", avatar: "Tyrion.jpg"))
        users.append(MockUser(identifier: "10002", name: "詹姆·兰尼斯特", avatar: "Jaime.jpg"))
        users.append(MockUser(identifier: "10003", name: "瑟曦", avatar: "Cersei.jpg"))
        
        // 坦格利安
        users.append(MockUser(identifier: "20001", name: "丹妮莉丝", avatar: "Daenerys.jpg"))
        users.append(MockUser(identifier: "20002", name: "琼恩·雪诺", avatar: "JonSnow.jpg"))

        // 史塔克
        users.append(MockUser(identifier: "30001", name: "珊莎", avatar: "Sansa.jpg"))
        users.append(MockUser(identifier: "30002", name: "艾莉亚", avatar: "Arya.jpg"))
        users.append(MockUser(identifier: "30003", name: "布兰", avatar: "Bran.jpg"))

        //users.append(MockUser(identifier: "", name: "", avatar: ""))
        
        messages.append("握紧缰绳，别让马儿乱动。还有，千万别扭头，不然父亲会知道。")
        messages.append("混账东西")
        messages.append("你做得很好")
        messages.append("这逃兵死得挺勇敢")
    }
    
    func random<T>() -> T? {
        return nil
    }
    
    func randomMessage() -> String {
        let count = messages.count
        let index = Int(arc4random_uniform(UInt32(count)))
        return messages[index]
    }
    
    func sessions() -> [Session] {
        return users.map { user in
            let session = Session(sessionID: user.identifier, name: user.name)
            session.content = randomMessage()
            session.avatar = user.avatar
            return session
        }
    }
}
