//
//  MediaAsset.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/23.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation
import Photos

class MediaAsset {
    
    var asset: PHAsset
    
    var selected: Bool = false
    
    var keepOrigin: Bool = false
    
    var index: Int = -1
    
    init(asset: PHAsset) {
        self.asset = asset
    }
}
