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

    static let shared = MockFactory()
    
    private let data: MockData
    
    private init() {
        let url = Bundle.main.url(forResource: "MockData", withExtension: "json")!
        let mockData = try! Data(contentsOf: url)
        self.data = try! JSONDecoder().decode(MockData.self, from: mockData)
    }
    
    func random<T>(of list: [T]) -> T {
        let count = list.count
        let index = Int(arc4random_uniform(UInt32(count)))
        return list[index]
    }
    
    func randomMessage() -> String {
        return random(of: data.messages)
    }
    
    func user(with identifier: String) -> MockData.User? {
        return data.users.first(where: { $0.identifier == identifier })
    }
    
    func sessions() -> [Session] {
        var userSessions: [Session] = data.users.map { user in
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
        brandSession.avatarImage = UIImage(named: "ReadVerified_icon_45x45_")
        userSessions.insert(brandSession, at: 1)
        return userSessions
    }

    func messages(with user: MockData.User, count: Int = 30) -> [Message] {
        var messages: [Message] = []
        let myID = AppContext.current.userID
        let now = Int(Date().timeIntervalSince1970)
        let past = 1560493108
        for index in 0 ..< count {
            let randomTime = Int(arc4random_uniform(UInt32(now - past))) + past
            let msg = Message()
            msg.chatID = user.identifier
            msg.senderID = index % 2 == 0 ? user.identifier: myID
            msg.time = randomTime
            let r = Int.random(in: 0 ..< 5)
            switch r {
            case 0:
                msg.content = randomTextMessage()
            case 1:
                msg.content = randomImageMessage()
            case 2:
                msg.content = randomVoiceMessage()
            case 3:
                msg.content = randomEmoticonMessage()
            case 4:
                msg.content = randomVideoMessage()
            default:
                msg.content = randomTextMessage()
            }
            messages.append(msg)
        }
        messages.sort(by: { $0.time < $1.time })
        return messages
    }

    private func randomImageMessage() -> MessageContent {
        let image = random(of: data.images)
        let msg = ImageMessage(url: image.url, size: image.size.value)
        return .image(msg)
    }

    private func randomVideoMessage() -> MessageContent {
        let image = random(of: data.images)
        let msg = VideoMessage(url: image.url, thumb: nil, size: image.size.value, fileSize: 0, duration: 6)
        return .video(msg)
    }

    private func randomVoiceMessage() -> MessageContent {
        let msg = VoiceMessage(duration: 4)
        return .voice(msg)
    }

    private func randomEmoticonMessage() -> MessageContent {
        let stickerPackages = AppContext.current.emoticonMgr.allStickers
        let stickerDescPackages = AppContext.current.emoticonMgr.allStickerPackageDesc
        let package = random(of: stickerPackages)
        let sticker = random(of: package.emoticons)
        let title = stickerDescPackages.first(where: { $0.packageID == package.packageID })?.stickers.first(where: { $0.key == sticker })?.value.title
        let msg = EmoticonMessage(md5: sticker, packageID: package.packageID, title: title)
        return .emoticon(msg)
    }

    private func randomTextMessage() -> MessageContent {
        let message = randomMessage()
        return .text(message)
    }

    func moments() -> [Moment] {
        var moments: [Moment] = []
        for _ in 0 ..< 20 {
            let user = random(of: data.users)
            let moment = Moment()
            moment.identifier = UUID().uuidString
            moment.userID = user.identifier
            moment.content = randomMessage()

            let r = Int.random(in: 0 ... 4)
            if r == 0 {
                moment.body = randomMomentImage()
                moment.comments = [randomMomentComment(of: user)]
                moment.likes = [randomMomentLike(of: user)]
            } else if r == 1 {
                moment.body = randomMomentMultiImage()
            } else if r == 2 {
                moment.body = randomMomentWebpages()
            } else {

            }

            moments.append(moment)
        }
        return moments
    }

    func randomMomentImage() -> MomentBody {
        let remoteImage = random(of: data.images)
        let body = MomentMedia(url: remoteImage.url, size: remoteImage.size.value)
        return MomentBody.media(body)
    }

    func randomMomentMultiImage() -> MomentBody {
        var images: [MomentMedia] = []
        for _ in 0 ..< 9 {
            let remoteImage = random(of: data.images)
            let image = MomentMedia(url: remoteImage.url, size: remoteImage.size.value)
            images.append(image)
        }
        let multiImages = MomentMultiImage(images: images)
        return MomentBody.multi(multiImages)
    }

    func randomMomentWebpages() -> MomentBody {
        let link = random(of: data.webpages)
        let webPage = MomentWebpage(url: link.url,
                                    title: link.title,
                                    thumbImageURL: link.thumb_url)
        return MomentBody.link(webPage)
    }

    func randomMomentComment(of user: MockData.User) -> MomentComment {
        let comment = MomentComment()
        comment.nickname = user.name
        comment.content = "还不错哦还不错哦还不错哦还不错哦还不错哦还不错哦"
        comment.userID = user.identifier
        return comment
    }

    func randomMomentLike(of user: MockData.User) -> MomentLikeUser {
        let like = MomentLikeUser(userID: user.identifier, username: user.name)
        return like
    }

    private func randomMomentVideo() -> MomentBody {
        //TODO
        return MomentBody.none
    }
    
    func contacts() -> [Contact] {
        return data.users.map { $0.toContact() }
    }
    
    func multiSelectContacts() -> [MultiSelectContact] {
        return data.users.map { $0.toMultiSelectContact() } 
    }
    
    func nearbys() -> [NearbyPeople] {
        return data.users.map { NearbyPeople(userId: $0.identifier, nickname: $0.name, avatar: $0.avatar, gender: $0.gender) }
    }
}


