//
//  StorageUsageScanner.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/8/19.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation

typealias StorageUsageScannerCompletion = (StorageUsageSummary, StorageUsageDetail) -> Void

class StorageUsageScanner {
    
    private let queue = DispatchQueue(label: "me.shuifeng.WeChatSwift.storage.scan")
    
    func startScan(completion: @escaping StorageUsageScannerCompletion) {
        queue.async {
            
            //let summary = StorageUsageSummary(systemTotalSize: <#T##Int#>, systemFreeSize: <#T##Int#>, wechatSize: <#T##Int#>)
//            if let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first,
//                let documentAttributes = try? FileManager.default.attributesOfFileSystem(forPath: documentPath) {
//                if let systemSize = documentAttributes[FileAttributeKey.systemSize] as? Int,
//                    let systemFreeSize = documentAttributes[FileAttributeKey.systemFreeSize] as? Int {
//                    print(systemSize)
//                    print(systemFreeSize)
//                }
//            }
//            
//            if let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first {
//                print(cachePath)
//            }
//            
//            let fileURL = URL(fileURLWithPath: "/")
//            do {
//                let values = try fileURL.resourceValues(forKeys: [.volumeAvailableCapacityKey, .volumeMaximumFileSizeKey, .volumeTotalCapacityKey])
//                print(values.volumeAvailableCapacity)
//                print(values.volumeMaximumFileSize)
//                print(values.volumeTotalCapacity)
//            } catch {
//                print(error)
//            }
        }
    }
    
}
