//
//  MockFactory.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/4.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation
import UIKit

class MockFactory {
    
    struct MockUser {
        var identifier: String
        var name: String
        var avatar: String
    }
    
    struct RemoteImage {
        var urlString: String
        var size: CGSize
    }
    
    struct WebPage {
        var urlString: String
        var title: String
        var thumbImage: UIImage?
        //var thumbURL: String
    }
    
    static let shared = MockFactory()
    
    var users: [MockUser] = []
    
    var messages: [String] = []
    
    var remoteImages: [RemoteImage] = []
    
    var webPages: [WebPage] = []
    
    private init() {
        setupUsers()
        setupMessages()
        setupRemoteImages()
        setupWebPages()
        
        DispatchQueue.global().async {
            Expression.load()
        }
    }
    
    private func setupUsers() {
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
    }
    
    private func setupMessages() {
        messages.append("握紧缰绳，别让马儿乱动。还有，千万别扭头，不然父亲会知道。")
        messages.append("混账东西")
        messages.append("你做得很好")
        messages.append("这逃兵死得挺勇敢")
        messages.append("孩子们呢？")
        messages.append("艾莉亚已经爱得发狂，珊莎也很喜欢，瑞肯则还不太确定")
        messages.append("他害怕吗？")
        messages.append("毕竟他才三岁。")
        messages.append("他得学着面对自己的恐惧，他不可能永远都是三岁，更何况凛冬将至。")
        messages.append("今天那个人死得很干脆，这一点我承认")
        messages.append("我很为布兰高兴，你要是在场，也会为他骄傲的")
        messages.append("我向来都很为他骄傲")
        messages.append("这已经是今年第四个逃兵了")
        messages.append("是野人的关系吗？")
        messages.append("还会有谁呢？")
        messages.append("恐怕情况只会越来越糟，也许我真的别无选择，非得召集封臣，率军北进，与这个绝境长城以外的国王一决生死")
        messages.append("绝境长城以外？")
        messages.append("长城之外还有更可怕的东西")
        messages.append("老奶妈的故事你听太多啦。异鬼和森林之子一样，早已经消失了八千多年。鲁温师傅会告诉你他们根本就没存在过，没有活人见过他们")
        messages.append("今天早上之前，不也没人见过冰原狼？")
        messages.append("我怎么也说不过徒利家的人")
        messages.append("今天我们接获了悲伤的消息，大人，我不想在你清理宝剑之前打扰你")
        messages.append("这消息确实么？")
        messages.append("我想这也算是最后的一点慈悲")
    }
    
    private func setupRemoteImages() {
        remoteImages.append(RemoteImage(urlString: "https://ws3.sinaimg.cn/large/005BYqpgly1g4uu4e0p80j30k00cijst.jpg",
                                        size: CGSize(width: 755.0, height: 450.0)))
        remoteImages.append(RemoteImage(urlString: "https://ws3.sinaimg.cn/large/005BYqpgly1g4uu6b6ir4j30kz0cidq8.jpg",
                                        size: CGSize(width: 720.0, height: 450.0)))
        remoteImages.append(RemoteImage(urlString: "https://ws3.sinaimg.cn/large/005BYqpgly1g4uw1spjs2j30b90godio.jpg",
                                        size: CGSize(width: 405.0, height: 600.0)))
    }
    
    private func setupWebPages() {
        webPages.append(WebPage(urlString: "https://mp.weixin.qq.com/s/WZruGVpOpen2f4NNiSu7cw", title: "Flutter 1.7 版正式发布", thumbImage: UIImage(named: "flutter.jpeg")))
        
        
    }
    
    private func setupEmoticon() {
        let path = NSHomeDirectory().appending("/Documents/emoticons/")
        if !FileManager.default.fileExists(atPath: path) {
            
        }
    }
    
    func random<T>(of list: [T]) -> T {
        let count = list.count
        let index = Int(arc4random_uniform(UInt32(count)))
        return list[index]
    }
    
    func randomUser() -> MockUser {
        let count = users.count
        let index = Int(arc4random_uniform(UInt32(count)))
        return users[index]
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
    
    func messages(with user: MockUser, count: Int = 20) -> [Message] {
        var messages: [Message] = []
        let myID = AppContext.current.userID
        for index in 0 ..< count {
            let msg = Message()
            msg.chatID = user.identifier
            msg.senderID = index % 2 == 0 ? user.identifier: myID
            
            if index % 3 == 0 {
                msg.content = .image(ImageMessage(image: UIImage(named: "Bran.jpg"), size: .zero))
            } else if index % 4 == 0 {
                msg.content = .audio(AudioMessage(duration: 4))
            } else {
                msg.content = .text(randomMessage())
            }
            messages.append(msg)
        }
        return messages
    }
    
    func moments() -> [Moment] {
        var moments: [Moment] = []
        for index in 0 ..< 20 {
            let user = random(of: users)
            let moment = Moment()
            moment.userID = user.identifier
            moment.content = randomMessage()
            if index % 4 == 0 {
                let remoteImage = random(of: remoteImages)
                let body = MomentMedia(url: URL(string: remoteImage.urlString), size: remoteImage.size)
                moment.body = MomentBody.media(body)
            } else if index % 6 == 0 {
                let link = random(of: webPages)
                let webPage = MomentWebpage(url: URL(string: link.urlString),
                                            title: link.title,
                                            thumbImage: link.thumbImage,
                                            thumbImageURL: nil)
                moment.body = .link(webPage)
            }
            moments.append(moment)
        }
        return moments
    }
}
