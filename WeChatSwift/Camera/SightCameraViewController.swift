//
//  SightCameraViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/16.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class SightCameraViewController: ASViewController<ASDisplayNode> {
    
    private let sessionQueue = DispatchQueue(label: "me.shuifeng.WeChatSwift.SightCamera")
    private let metadataOutput = AVCaptureMetadataOutput()
    private let session = AVCaptureSession()
    private var videoDeviceInput: AVCaptureDeviceInput?
    private var capturePhotoOutput: AVCapturePhotoOutput?
    
    private var previewView: SightCameraPreviewView!
    
    init() {
        super.init(node: ASDisplayNode())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        let bgView = SightCameraGradientView(frame: view.bounds)
        view.addSubview(bgView)
        
        previewView = SightCameraPreviewView(frame: view.bounds)
        view.addSubview(previewView)
        previewView.session = session
        
        let shotView = SightCameraShotVideoView(frame: view.bounds)
        shotView.delegate = self
        view.addSubview(shotView)
        
        sessionQueue.async {
            self.configureSession()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sessionQueue.async {
            if !self.session.isRunning {
                self.session.startRunning()
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        session.stopRunning()
    }
    
    private func configureSession() {
        session.beginConfiguration()
        session.sessionPreset = .high
        
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .unspecified),
            let deviceInput = try? AVCaptureDeviceInput(device: device) {
            if session.canAddInput(deviceInput) {
                session.addInput(deviceInput)
                self.videoDeviceInput = deviceInput
            }
        }
        
        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)
        }
        
        capturePhotoOutput = AVCapturePhotoOutput()
        capturePhotoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
        if let capturePhotoOutput = capturePhotoOutput, session.canAddOutput(capturePhotoOutput) {
            session.addOutput(capturePhotoOutput)
        }
        
    
        session.commitConfiguration()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

// MARK: - Event Handlers
extension SightCameraViewController {
    
}

// MARK: - AVCaptureFileOutputRecordingDelegate

extension SightCameraViewController: AVCaptureFileOutputRecordingDelegate {
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
    }
    
    
}

// MARK: - SightCameraShotVideoViewDelegate
extension SightCameraViewController: SightCameraShotVideoViewDelegate {
    
    func cameraShotVideoViewDidTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
    
    
}
