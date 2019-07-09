//
//  ChatRoomToolPanelNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit
import UIKit

class ChatRoomToolPanelNode: ASDisplayNode {
 
    var pageNode: ASPagerNode = ASPagerNode()
    
    var pageControl: UIPageControl = {
        let page = UIPageControl()
        return page
    }()
    
    var dataSource: [ChatRoomTool] = ChatRoomTool.tools()
    
    override init() {
        super.init()
    }
}

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
    
    var imageName: String? {
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
    
    var title: String? {
        switch self {
        case .album:
            return "照片"
        case .camera:
            return "拍摄"
        case .videoCall:
            return "视频通话"
        case .location:
            return "位置"
        case .redPacket:
            return "红包"
        case .transfer:
            return "转账"
        case .voice:
            return "语音输入"
        case .favorites:
            return "收藏"
        case .contactCard:
            return "个人名片"
        case .files:
            return "文件"
        case .coupons:
            return "折扣"
        }
    }
    
    static func tools() -> [ChatRoomTool] {
        return ChatRoomTool.allCases
    }
}
