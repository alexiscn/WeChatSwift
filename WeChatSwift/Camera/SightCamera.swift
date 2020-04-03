//
//  SightCamera.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/22.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit
import AVFoundation

public typealias SightCameraTakePhotoCompletion = (UIImage?) -> Void

public class SightCamera: NSObject {
 
    private let sessionQueue = DispatchQueue(label: "me.shuifeng.WeChatSwift.SightCamera")
    let captureSession: AVCaptureSession
    private var inputCamera: AVCaptureDevice? { return videoInput?.device }
    
    private var pipelineRunningTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0)
    
    private var videoInput: AVCaptureDeviceInput?
    private var videoOutput: AVCaptureVideoDataOutput = AVCaptureVideoDataOutput()
    private var videoConnection: AVCaptureConnection?
    private var videoOutputFormatDescription: CMFormatDescription?
    private var videoDimensions: CMVideoDimensions = CMVideoDimensions(width: 0, height: 0)
    
    private var photoOutput: AVCapturePhotoOutput = AVCapturePhotoOutput()
    
    private var audioInput: AVCaptureDeviceInput?
    private var audioOutput: AVCaptureAudioDataOutput = AVCaptureAudioDataOutput()
    private var audioConnection: AVCaptureConnection?
    
    private var fileOutput: AVCaptureMovieFileOutput = AVCaptureMovieFileOutput()
    private var photoCaptureProcessor: SightCameraPhotoCaptureProcessor?
    private var cameraPosition: AVCaptureDevice.Position = .unspecified
    
    public var isRunning: Bool {
        return false
    }
    
    public init(sessionPreset: AVCaptureSession.Preset, frameRate: Int, cameraPosition: AVCaptureDevice.Position = AVCaptureDevice.Position.back) {
        captureSession = AVCaptureSession()
    
        captureSession.beginConfiguration()
        if captureSession.canSetSessionPreset(sessionPreset) {
            captureSession.sessionPreset = sessionPreset
        }
        
        captureSession.commitConfiguration()
    }
    
    func configureSession() {
        captureSession.beginConfiguration()
        if videoInput == nil {
            if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .unspecified),
                let deviceInput = try? AVCaptureDeviceInput(device: device) {
                if captureSession.canAddInput(deviceInput) {
                    captureSession.addInput(deviceInput)
                    videoInput = deviceInput
                }
            }
            
            if captureSession.canAddOutput(videoOutput) {
                captureSession.addOutput(videoOutput)
            }
            videoConnection = videoOutput.connection(with: .video)
            
            photoOutput.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            if captureSession.canAddOutput(photoOutput) {
                captureSession.addOutput(photoOutput)
            }
            
            fileOutput.maxRecordedDuration = CMTime(seconds: 15.0, preferredTimescale: 30)
            if captureSession.canAddOutput(fileOutput) {
                captureSession.addOutput(fileOutput)
            }
        }
        if audioInput == nil {
            if let audioDevice = AVCaptureDevice.default(for: .audio),
                let audioDeviceInput = try? AVCaptureDeviceInput(device: audioDevice) {
                if captureSession.canAddInput(audioDeviceInput) {
                    captureSession.addInput(audioDeviceInput)
                }
            }
            
            if captureSession.canAddOutput(audioOutput) {
                captureSession.addOutput(audioOutput)
            }
            audioConnection = audioOutput.connection(with: .audio)
        }
        captureSession.commitConfiguration()
    }
}

// MARK: - Public Methods
public extension SightCamera {
    
    func startRunning() {
        if !captureSession.isRunning {
            captureSession.startRunning()
        }
    }
    
    func stopRunning() {
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
    
    func switchCamera() {
        guard let videoDeviceInput = videoInput else { return }
        
        let currentVideoDevice = videoDeviceInput.device
        let position: AVCaptureDevice.Position
        switch currentVideoDevice.position {
        case .front:
            position = .back
        default:
            position = .front
        }
        
        captureSession.beginConfiguration()
        captureSession.removeInput(videoDeviceInput)
        do {
            if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position) {
                let deviceInput = try AVCaptureDeviceInput(device: device)
                if captureSession.canAddInput(deviceInput) {
                    captureSession.addInput(deviceInput)
                    videoInput = deviceInput
                    cameraPosition = position
                } else {
                    captureSession.addInput(videoDeviceInput)
                    cameraPosition = currentVideoDevice.position
                }
            }
        } catch {
            print(error)
            captureSession.addInput(videoDeviceInput)
            cameraPosition = currentVideoDevice.position
        }
        captureSession.commitConfiguration()
    }
    
    func zoom(factor: CGFloat) {
        guard let camera = inputCamera else { return }
        let maxZoomFactor = min(camera.maxAvailableVideoZoomFactor, 3.0)
        let zoomFactor = max(min(factor, maxZoomFactor), 1.0)
        do {
            try camera.lockForConfiguration()
            camera.videoZoomFactor = zoomFactor
            camera.unlockForConfiguration()
        } catch {
            print(error)
        }
    }
    
    func resetZoomFactor() {
        zoom(factor: 1.0)
    }
    
    func focus(at point: CGPoint, focusMode: AVCaptureDevice.FocusMode = .autoFocus, exposureMode: AVCaptureDevice.ExposureMode = .continuousAutoExposure) {
        guard let camera = inputCamera else { return }
        
        do {
            try camera.lockForConfiguration()
            if camera.isFocusPointOfInterestSupported && camera.isFocusModeSupported(focusMode) {
                camera.focusPointOfInterest = point
                camera.focusMode = focusMode
            }
            
            if camera.isFocusPointOfInterestSupported && camera.isExposureModeSupported(exposureMode) {
                camera.focusPointOfInterest = point
                camera.exposureMode = exposureMode
            }
            camera.unlockForConfiguration()
        } catch {
            print(error)
        }
    }
    
    func capturePreviewImage() {
        
    }
    
    func takePhoto(completion: @escaping SightCameraTakePhotoCompletion) {
        let photoSettings = AVCapturePhotoSettings()
        let previewPixelType = photoSettings.availablePreviewPhotoPixelFormatTypes.first!
        let previewPhotoFormat: [String: Any] = [
            kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
            kCVPixelBufferWidthKey as String: Constants.screenWidth,
            kCVPixelBufferHeightKey as String: Constants.screenHeight
        ]
        photoSettings.previewPhotoFormat = previewPhotoFormat
        photoSettings.isAutoStillImageStabilizationEnabled = true
        
        let processor = SightCameraPhotoCaptureProcessor { [weak self] in
            completion(self?.photoCaptureProcessor?.image)
        }
        processor.cameraPosition = cameraPosition
        self.photoCaptureProcessor = processor
        photoOutput.capturePhoto(with: photoSettings, delegate: processor)
    }
    
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate & AVCaptureAudioDataOutputSampleBufferDelegate
extension SightCamera: AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate {
    
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let formatDescription = CMSampleBufferGetFormatDescription(sampleBuffer) else { return }
        
        if connection == audioConnection {
            
        } else if connection == videoConnection {
            if videoOutputFormatDescription == nil {
                videoPipelineWillStartRunning()
                videoDimensions = CMVideoFormatDescriptionGetDimensions(formatDescription)
                videoOutputFormatDescription = formatDescription
            } else {
                renderVideoSampleBuffer(sampleBuffer)
            }
        }
    }
}

// MARK: - Private Work
extension SightCamera {
    
    private func videoPipelineWillStartRunning() {
        pipelineRunningTask = UIApplication.shared.beginBackgroundTask (expirationHandler: {
            print("video capture pipeline background task expired")
        })
    }
    
    private func videoPipelineDidFinishRunning() {
        pipelineRunningTask = .invalid
    }
    
    private func renderVideoSampleBuffer(_ sampleBuffer: CMSampleBuffer) {
        
    }
}
