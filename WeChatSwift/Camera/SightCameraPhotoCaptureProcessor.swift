//
//  SightCameraPhotoCaptureProcessor.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/23.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit
import AVFoundation

class SightCameraPhotoCaptureProcessor: NSObject, AVCapturePhotoCaptureDelegate {
    
    var cameraPosition: AVCaptureDevice.Position = .unspecified
    
    private(set) var image: UIImage?
    
    private let completionHandler: RelayCommand
    
    init(completionHandler: @escaping RelayCommand) {
        self.completionHandler = completionHandler
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        defer {
            completionHandler()
        }
        
        guard let data = photo.fileDataRepresentation() else {
            return
        }
        
        if cameraPosition == .front, let provider = CGDataProvider(data: data as CFData), let cgImage = CGImage(jpegDataProviderSource: provider, decode: nil, shouldInterpolate: true, intent: .defaultIntent) {
            image = UIImage(cgImage: cgImage, scale: 1.0, orientation: .leftMirrored)
        } else {
            image = UIImage(data: data)
        }
    }
    
}
