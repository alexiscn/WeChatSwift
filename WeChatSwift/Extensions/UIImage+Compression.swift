//
//  UIImage+Compression.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/7/26.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

enum CompressionQuality {
    case origin
    case wechat
    case custom(CGFloat)
    
    var value: CGFloat {
        switch self {
        case .origin:
            return 1
        case .wechat:
            return 0.5
        case .custom(let q):
            return q
        }
    }
}

enum CompressionScene {
    case session
    case moment
    case custom(CGFloat)
    
    var boundary: CGFloat {
        switch self {
        case .session:
            return 1080
        case .moment:
            return 1280
        case .custom(let b):
            return b
        }
    }
}

extension UIImage {
    
    func wx_compressData(scene: CompressionScene = .session, quality: CompressionQuality = .wechat) -> Data? {
        let size = wx_imageSize(limitTo: scene.boundary)
        guard let resizedImage = wx_resizeImage(to: size) else {
            return nil
        }
        return resizedImage.jpegData(compressionQuality: quality.value)
    }
    
    func wx_compress(scene: CompressionScene = .session, quality: CompressionQuality = .wechat) -> UIImage? {
        if let data = wx_compressData(scene: scene, quality: quality) {
            return UIImage(data: data)
        }
        return nil
    }
    
    private func wx_imageSize(limitTo boundary: CGFloat = 1280.0) -> CGSize {
        var width = self.size.width
        var height = self.size.height
        guard width > boundary || height > boundary else {
            return CGSize(width: width, height: height)
        }
        let ratio = max(width, height) / min(width, height)
        if ratio <= 2 {
            let x = max(width, height) / boundary
            if width > height {
                width = boundary
                height = height / x
            } else {
                height = boundary
                width = width / x
            }
        } else {
            if min(width, height) >= boundary {
                let x = min(width, height) / boundary
                if width < height {
                    width = boundary
                    height = height / x
                } else {
                    height = boundary
                    width = width / x
                }
            }
        }
        return CGSize(width: width, height: height)
    }
    
    private func wx_resizeImage(to size: CGSize) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        let newRect = CGRect(origin: .zero, size: size)
        var newImage: UIImage!
        UIGraphicsBeginImageContext(newRect.size)
        newImage = UIImage(cgImage: cgImage, scale: 1, orientation: self.imageOrientation)
        newImage.draw(in: newRect)
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
