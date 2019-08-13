//
//  CameraScanViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/13.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit
import AVFoundation

class CameraScanViewController: ASViewController<ASDisplayNode> {
    
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    private let supportedCodeTypes: [AVMetadataObject.ObjectType] = [.qr]
    
    //private
    
    private let bottomButtons: CameraScanBottomNode
    
    init() {
        
        bottomButtons = CameraScanBottomNode(scanTypes: [.qrCode, .book, .street, .word])
        
        super.init(node: ASDisplayNode())
        
        node.addSubnode(bottomButtons)
    }
    
    deinit {
        print("CameraScanViewController deinit")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSession()
        
        view.backgroundColor = .black
        
        navigationItem.title = "二维码/条码"
        
        let galleryButton = UIBarButtonItem(title: "相册", style: .plain, target: self, action: #selector(galleryButtonClicked))
        galleryButton.tintColor = .white
        navigationItem.rightBarButtonItem = galleryButton
        
        let bottomHeight = 83.0 + Constants.bottomInset
        
        bottomButtons.frame = CGRect(x: 0, y: view.bounds.height - bottomHeight, width: view.bounds.width, height: bottomHeight)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.bringSubviewToFront(bottomButtons.view)
    }
    
    private func setupSession() {
        
        DispatchQueue.global().async {
            let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: .video, position: .back)
            guard let captureDevice = session.devices.first else {
                return
            }
            
            let captureSession = AVCaptureSession()
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                captureSession.addInput(input)
                
                let output = AVCaptureMetadataOutput()
                captureSession.addOutput(output)
                output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                output.metadataObjectTypes = self.supportedCodeTypes
                
            } catch {
                print(error)
                return
            }
            captureSession.startRunning()
            DispatchQueue.main.async {
                self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                self.videoPreviewLayer?.videoGravity = .resizeAspectFill
                self.videoPreviewLayer?.frame = self.view.bounds
                if let previewLayer = self.videoPreviewLayer {
                    self.view.layer.addSublayer(previewLayer)
                }
            }
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var wc_navigationBarBackgroundColor: UIColor? {
        return .clear
    }
    
    override var wc_barTintColor: UIColor? {
        return .white
    }
    
    override var wc_titleTextAttributes: [NSAttributedString.Key : Any]? {
        return [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
}

// MARK: - Event Handlers
extension CameraScanViewController {
    
    @objc private func galleryButtonClicked() {
        let selectionHandler = { [weak self] (selectedAssets: [MediaAsset]) in
            print(selectedAssets.count)
            self?.dismiss(animated: true, completion: nil)
        }
        
        let albumPickerVC = AlbumPickerViewController()
        albumPickerVC.selectionHandler = selectionHandler
        let assetPickerVC = AssetPickerViewController()
        assetPickerVC.selectionHandler = selectionHandler
        let nav = WCNavigationController()
        nav.setViewControllers([albumPickerVC, assetPickerVC], animated: false)
        present(nav, animated: true, completion: nil)
    }
    
}

extension CameraScanViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard metadataObjects.count > 0 else {
            return
        }
        
        //
    }
    
}

