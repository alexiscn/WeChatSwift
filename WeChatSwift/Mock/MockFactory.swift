//
//  MockFactory.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/4.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation
import UIKit
import SSZipArchive

class MockFactory {
    
    struct MockUser {
        var identifier: String
        var name: String
        var avatar: String
        
        func toContact() -> Contact {
            let contact = Contact()
            contact.avatar = UIImage.as_imageNamed(avatar)
            contact.name = name
            return contact
        }
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
        messages.append("我很为布兰高兴，你要是在场也会为他骄傲的")
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
        messages.append("baidu.com")
        messages.append("google.com")
        messages.append("qq.com")
        messages.append("打开这个网站试试 t.tt")
        messages.append("微博weibo.com微博")
        
        let temp = messages
        messages.removeAll()
        messages = temp.map { return $0 + "[微笑]好的" }
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
        var userSessions: [Session] = users.map { user in
            let session = Session(sessionID: user.identifier, name: user.name)
            session.content = randomMessage()
            session.avatar = user.avatar
            if user.identifier == "20001" {
                session.unreadCount = 5
            }
            if user.identifier == "20002" {
                session.unreadCount = 2
                session.showUnreadAsRedDot = true
                session.muted = true
            }
            return session
        }
        
        let brandSession = Session(sessionID: Constants.BrandSessionName, name: "订阅号消息")
        brandSession.content = "七麦研究院：从“消灭病毒”到“我的小家”"
        brandSession.avatar = "ReadVerified_icon_45x45_"
        userSessions.insert(brandSession, at: 1)
        return userSessions
    }
    
    func messages(with user: MockUser, count: Int = 30) -> [Message] {
        var messages: [Message] = []
        let myID = AppContext.current.userID
        let stickerPackages = AppContext.current.emoticonMgr.allStickers
        let stickerDescPackages = AppContext.current.emoticonMgr.allStickerPackageDesc
        let now = Int(Date().timeIntervalSince1970)
        let past = 1560493108
        for index in 0 ..< count {
            
            let randomTime = Int(arc4random_uniform(UInt32(now - past))) + past
            
            let msg = Message()
            msg.chatID = user.identifier
            msg.senderID = index % 2 == 0 ? user.identifier: myID
            msg.time = randomTime
            if index % 3 == 0 {
                msg.content = .image(ImageMessage(image: UIImage(named: "Bran.jpg"), size: .zero))
            } else if index % 4 == 0 {
                msg.content = .voice(VoiceMessage(duration: 4))
            } else if index % 5 == 0 {
                let package = random(of: stickerPackages)
                let sticker = random(of: package.emoticons)
                let title = stickerDescPackages.first(where: { $0.packageID == package.packageID })?.stickers.first(where: { $0.key == sticker })?.value.title
                msg.content = .emoticon(EmoticonMessage(md5: sticker, packageID: package.packageID, title: title))
            } else {
                msg.content = .text(randomMessage())
            }
            messages.append(msg)
        }
        messages.sort(by: { $0.time < $1.time })
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
            } else if index % 7 == 0 {
                var images: [MomentMedia] = []
                for _ in 0 ..< 9 {
                    let remoteImage = random(of: remoteImages)
                    let image = MomentMedia(url: URL(string: remoteImage.urlString), size: remoteImage.size)
                    images.append(image)
                }
                let body = MomentMultiImage(images: images)
                moment.body = MomentBody.multi(body)
            }
            moments.append(moment)
        }
        return moments
    }
    
    func discoverEntrance() -> [DiscoverSection] {
        var sections: [DiscoverSection] = []
        var moment = DiscoverModel(type: .moment, title: "朋友圈", icon: "icons_outlined_colorful_moment")
        moment.unreadCount = 2
        sections.append(DiscoverSection(models: [moment]))
        
        sections.append(DiscoverSection(models: [
            DiscoverModel(type: .scan, title: "扫一扫", icon: "icons_outlined_scan", color: Colors.Indigo),
            DiscoverModel(type: .shake, title: "摇一摇", icon: "icons_outlined_shake", color: Colors.Indigo)]
        ))
        
        sections.append(DiscoverSection(models: [
            DiscoverModel(type: .news, title: "看一看", icon: "icons_outlined_news", color: Colors.Yellow),
            DiscoverModel(type: .news, title: "搜一搜", icon: "icons_filled_search-logo", color: Colors.Red)
            ]))
        
        sections.append(DiscoverSection(models: [DiscoverModel(type: .nearby, title: "附近的人", icon: "icons_outlined_nearby", color: Colors.Indigo)]))
        sections.append(DiscoverSection(models: [
            DiscoverModel(type: .shop, title: "购物", icon: "icons_outlined_shop", color: Colors.Orange),
            DiscoverModel(type: .game, title: "游戏", icon: "icons_outlined_colorful_game")]))
        sections.append(DiscoverSection(models: [DiscoverModel(type: .miniProgram, title: "小程序", icon: "icons_outlined_miniprogram", color: Colors.Purple)]))
        return sections
    }
}
