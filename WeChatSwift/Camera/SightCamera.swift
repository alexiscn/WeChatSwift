//
//  SightCamera.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/22.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AVFoundation

public class SightCamera: NSObject {
 
    private var captureSession: AVCaptureSession?
    private var inputCamera: AVCaptureDevice?
    private var videoInput: AVCaptureDeviceInput?
    private var audioInput: AVCaptureDeviceInput?
    private var imageOutput: AVCapturePhotoOutput?
    private var videoOutput: AVCaptureVideoDataOutput?
    private var audioOutput: AVCaptureAudioDataOutput?
    private var fileOutput: AVCaptureMovieFileOutput?
    
    public var isRunning: Bool {
        return false
    }
    
    public init(session: AVCaptureSession) {
        
    }
    
    public init(sessionPreset: AVCaptureSession.Preset, frameRate: Int, cameraPosition: Int) {
    
    }
}

// MARK: - Public Methods
public extension SightCamera {
    
    func startRunning() {
        
    }
    
    func stopRunning() {
        
    }
    
    func switchCamera() {
        
    }
    
    func focus(at point: CGPoint) {
        
    }
    
    func capturePreviewImage() {
        
    }
    
    func takePhoto() {
        
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate & AVCaptureAudioDataOutputSampleBufferDelegate
extension SightCamera: AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate {
    
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
    }
}
