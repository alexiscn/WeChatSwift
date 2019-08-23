//
//  SightCamera.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/22.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AVFoundation

public class SightCamera: NSObject {
 
    private let sessionQueue = DispatchQueue(label: "me.shuifeng.WeChatSwift.SightCamera")
    private let captureSession: AVCaptureSession
    private var inputCamera: AVCaptureDevice? { return videoInput?.device }
    private var videoInput: AVCaptureDeviceInput?
    private var audioInput: AVCaptureDeviceInput?
    private var photoOutput: AVCapturePhotoOutput = AVCapturePhotoOutput()
    private var videoOutput: AVCaptureVideoDataOutput = AVCaptureVideoDataOutput()
    private var audioOutput: AVCaptureAudioDataOutput?
    private var fileOutput: AVCaptureMovieFileOutput = AVCaptureMovieFileOutput()
    
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
            
            photoOutput.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            if captureSession.canAddOutput(photoOutput) {
                captureSession.addOutput(photoOutput)
            }
            
            fileOutput.maxRecordedDuration = CMTime(seconds: 15.0, preferredTimescale: 30)
            if captureSession.canAddOutput(fileOutput) {
                captureSession.addOutput(fileOutput)
            }
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
                } else {
                    captureSession.addInput(videoDeviceInput)
                }
            }
        } catch {
            print(error)
            captureSession.addInput(videoDeviceInput)
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
    
    func takePhoto() {
        let photoSettings = AVCapturePhotoSettings()
        let size = Constants.screenSize
        //photoSettings.previewPhotoFormat
        //photoOutput.capturePhoto(with: <#T##AVCapturePhotoSettings#>, delegate: <#T##AVCapturePhotoCaptureDelegate#>)
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate & AVCaptureAudioDataOutputSampleBufferDelegate
extension SightCamera: AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate {
    
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
    }
}
