//
//  SightCameraViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/16.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class SightCameraViewController: ASDKViewController<ASDisplayNode> {
    
    private let camera = SightCamera(sessionPreset: .high, frameRate: 60)
    
    private var previewView: SightCameraPreviewView!
    
    override init() {
        super.init(node: ASDisplayNode())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modalPresentationCapturesStatusBarAppearance = true
        
        view.backgroundColor = .black
        let bgView = SightCameraGradientView(frame: view.bounds)
        view.addSubview(bgView)
        
        previewView = SightCameraPreviewView(frame: view.bounds)
        view.addSubview(previewView)
        previewView.session = camera.captureSession
        
        let shotView = SightCameraShotVideoView(frame: view.bounds)
        shotView.delegate = self
        view.addSubview(shotView)
    
        camera.configureSession()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        camera.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        camera.stopRunning()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var wx_navigationBarBackgroundColor: UIColor? {
        return .clear
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
    
    func cameraShotVideoViewDidTapSwitchButton() {
        camera.switchCamera()
    }
    
    func cameraShotVideoViewDidTakePhoto() {
        camera.takePhoto { image in
            if let img = image {
                print(img)
            }
        }
    }
}
