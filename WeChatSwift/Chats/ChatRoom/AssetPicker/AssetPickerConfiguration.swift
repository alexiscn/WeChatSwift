//
//  AssetPickerConfiguration.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/16.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation

class AssetPickerConfiguration {
    
    var canSendGif = false
    
    var canSendMultiImage = false
    
    var canSendOriginImage = false
    
    var canSendVideo = false
    
    var compressionType: AssetCompressionType = .default
    
    var maximumImageCount: Int = 9
    
    var doneButtonTitle: String = "完成"
    
    var showBottomBar: Bool = true
    
    static func configurationForMomentBackground() -> AssetPickerConfiguration {
        let configuration = AssetPickerConfiguration()
        configuration.canSendGif = false
        configuration.canSendVideo = false
        configuration.canSendMultiImage = false
        configuration.canSendOriginImage = false
        configuration.showBottomBar = false
        return configuration
    }
    
    static func configurationForPublishMoment() -> AssetPickerConfiguration {
        let configuration = AssetPickerConfiguration()
        configuration.doneButtonTitle = "完成"
        return configuration
    }
    
    static func configurationForScan() -> AssetPickerConfiguration {
        let configuration = AssetPickerConfiguration()
        configuration.doneButtonTitle = "完成"
        return configuration
    }
    
    static func configurationForChatRoom() -> AssetPickerConfiguration {
        let configuration = AssetPickerConfiguration()
        configuration.canSendGif = true
        configuration.canSendMultiImage = true
        configuration.canSendOriginImage = true
        configuration.canSendVideo = true
        configuration.doneButtonTitle = "完成"
        return configuration
    }
}

enum AssetCompressionType {
    case `default`
}
