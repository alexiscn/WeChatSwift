//
//  AssetPickerConfiguration.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/16.
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
    
    var doneButtonTitle: String = LanguageManager.Common.done()
    
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
        configuration.canSendGif = true
        configuration.canSendVideo = true
        configuration.canSendMultiImage = true
        configuration.canSendOriginImage = true
        configuration.showBottomBar = true
        configuration.doneButtonTitle = LanguageManager.Common.done()
        return configuration
    }
    
    static func configurationForScan() -> AssetPickerConfiguration {
        let configuration = AssetPickerConfiguration()
        configuration.canSendGif = false
        configuration.canSendVideo = false
        configuration.canSendMultiImage = false
        configuration.canSendOriginImage = false
        configuration.showBottomBar = false
        configuration.doneButtonTitle = LanguageManager.Common.done()
        return configuration
    }
    
    static func configurationForChatRoom() -> AssetPickerConfiguration {
        let configuration = AssetPickerConfiguration()
        configuration.canSendGif = true
        configuration.canSendMultiImage = true
        configuration.canSendOriginImage = true
        configuration.canSendVideo = true
        configuration.doneButtonTitle = LanguageManager.Common.done()
        return configuration
    }
    
    static func configurationForChatBackground() -> AssetPickerConfiguration {
        let configuration = AssetPickerConfiguration()
        configuration.canSendGif = false
        configuration.canSendMultiImage = false
        configuration.canSendOriginImage = false
        configuration.canSendVideo = false
        configuration.showBottomBar = false
        return configuration
    }
}

enum AssetCompressionType {
    case `default`
    case session
    case moment
}
