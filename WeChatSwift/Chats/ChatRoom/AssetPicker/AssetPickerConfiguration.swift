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
    
    func configurationForMomentBackground() -> AssetPickerConfiguration {
        let configuration = AssetPickerConfiguration()
        configuration.doneButtonTitle = "完成"
        return configuration
    }
}

enum AssetCompressionType {
    case `default`
}
