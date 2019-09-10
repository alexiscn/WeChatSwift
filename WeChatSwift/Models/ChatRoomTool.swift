//
//  ChatRoomTool.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/7/10.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

enum ChatRoomTool: CaseIterable {
    case album
    case camera
    case videoCall
    case location
    case redPacket
    case transfer
    case voice
    case favorites
    case contactCard
    case files
    case coupons
    
    var imageName: String {
        switch self {
        case .album:
            return "ChatRomm_ToolPanel_Icon_Photo_64x64_"
        case .camera:
            return "ChatRomm_ToolPanel_Icon_Video_64x64_"
        case .videoCall:
            return "ChatRomm_ToolPanel_Icon_Videovoip_64x64_"
        case .location:
            return "ChatRomm_ToolPanel_Icon_Location_64x64_"
        case .redPacket:
            return "ChatRomm_ToolPanel_Icon_Luckymoney_64x64_"
        case .transfer:
            return "ChatRomm_ToolPanel_Icon_Pay_64x64_"
        case .voice:
            return "ChatRomm_ToolPanel_Icon_Voiceinput_64x64_"
        case .favorites:
            return "ChatRomm_ToolPanel_Icon_MyFav_64x64_"
        case .contactCard:
            return "ChatRomm_ToolPanel_Icon_FriendCard_64x64_"
        case .files:
            return "ChatRomm_ToolPanel_Icon_Files_64x64_"
        case .coupons:
            return "ChatRomm_ToolPanel_Icon_Wallet_64x64_"
        }
    }
    
    var title: String {
        switch self {
        case .album:
            return LocalizedString("MessageToolView_MediaBrowser")
        case .camera:
            return LocalizedString("MessageToolView_CameraController")
        case .videoCall:
            return LocalizedString("MessageToolView_VideoVoip")
        case .location:
            return LocalizedString("MessageToolView_Location")
        case .redPacket:
            return LocalizedString("WCCard_RedEnvelopes")
        case .transfer:
            return "转账"
        case .voice:
            return LocalizedString("MessageToolView_VoiceInput")
        case .favorites:
            return LocalizedString("MessageToolView_MyFavorites")
        case .contactCard:
            return LocalizedString("MessageToolView_ShareCard")
        case .files:
            return LocalizedString("MessageToolView_FileBrowser")
        case .coupons:
            return "折扣"
        }
    }
}
