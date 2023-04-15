//
//  CameraScanViewController.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/13.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit
import AVFoundation

class CameraScanViewController: ASDKViewController<ASDisplayNode> {
    
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    private let supportedCodeTypes: [AVMetadataObject.ObjectType] = [.qr]
    
    //private
    
    private let bottomButtons: CameraScanBottomNode
    
    override init() {
        
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
                self.setuoOverlays()
            }
        }
        
    }
    
    private func setuoOverlays() {
        
        let overlay = UIView()
        overlay.frame = CGRect(origin: .zero, size: Constants.screenSize)
        view.addSubview(overlay)
        
        let centerWidth = Constants.screenWidth * 0.65
        let centerHeight = centerWidth
        
        let leftSpacing = (Constants.screenWidth - 2 * Constants.lineHeight - centerWidth)/2.0
        let topSpacing = (Constants.screenHeight - 2 * Constants.lineHeight - centerHeight)/2.0
        
        // left 1, top: 2, right: 3, bottom: 4
        for index in 1 ... 4 {
            let backgroundView = UIView()
            let width = (index == 1 || index == 3) ? leftSpacing : Constants.screenWidth
            let height = (index == 2 || index == 4) ? topSpacing : (Constants.screenHeight - 2 * topSpacing)
            let x: CGFloat = index != 3 ? 0.0 : (Constants.screenWidth - leftSpacing)
            
            let y: CGFloat
            if index == 1 || index == 3 {
                y = topSpacing
            } else if index == 2 {
                y = 0.0
            } else {
                y = Constants.screenHeight - topSpacing
            }
            
            backgroundView.frame = CGRect(x: x, y: y, width: width, height: height)
            backgroundView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            overlay.addSubview(backgroundView)
        }
        
        // left 1, top: 2, right: 3, bottom: 4
        for index in 1 ... 4 {
            let lineView = UIView()
            let width = (index == 1 || index == 3) ? Constants.lineHeight: centerWidth
            let height = (index == 2 || index == 4) ? Constants.lineHeight: centerHeight
            let x: CGFloat
            let y: CGFloat
            if index == 1 {
                x = leftSpacing
                y = topSpacing + Constants.lineHeight
            } else if index == 2 {
                x = leftSpacing + Constants.lineHeight
                y = topSpacing
            } else if index == 3 {
                x = Constants.screenWidth - leftSpacing - Constants.lineHeight
                y = topSpacing + Constants.lineHeight
            } else {
                x = leftSpacing + Constants.lineHeight
                y = Constants.screenHeight - topSpacing - Constants.lineHeight
            }
            
            lineView.frame = CGRect(x: x, y: y, width: width, height: height)
            lineView.backgroundColor = UIColor(white: 1, alpha: 0.7)
            overlay.addSubview(lineView)
        }
        
        // top 1, right 2, left 3, bottom: 4
        for index in 1 ... 4 {
            let imageView = UIImageView()
            let x = (index == 1 || index == 3) ? leftSpacing : (Constants.screenWidth - leftSpacing - 25)
            let y = (index == 1 || index == 2) ? topSpacing: (Constants.screenHeight - topSpacing - 25)
            imageView.frame = CGRect(x: x, y: y, width: 25, height: 25)
            imageView.image = UIImage(named: "ScanQR\(index)_25x25_")
            overlay.addSubview(imageView)
        }
        
        let scanLine = UIImageView()
        scanLine.frame = CGRect(x: 15, y: topSpacing, width: Constants.screenWidth - 30.0, height: 12)
        scanLine.image = UIImage(named: "ff_QRCodeScanLine_320x12_")
        overlay.addSubview(scanLine)
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = NSValue(cgPoint: CGPoint(x: Constants.screenWidth/2.0, y: topSpacing))
        animation.toValue = NSValue(cgPoint: CGPoint(x: Constants.screenWidth/2.0, y: Constants.screenHeight - topSpacing))
        animation.duration = 2.0
        animation.autoreverses = false
        animation.isRemovedOnCompletion = true
        animation.fillMode = .forwards
        animation.repeatCount = .greatestFiniteMagnitude
        scanLine.layer.add(animation, forKey: "position")
        
        setupTipsView()
    }
    
    private func setupTipsView() {
        
        let centerWidth = Constants.screenWidth * 0.65
        let centerHeight = centerWidth
        
        let top = (Constants.screenHeight - 2 * Constants.lineHeight - centerHeight)/2.0
        
        let tipsLabel = UILabel()
        tipsLabel.frame = CGRect(x: 16, y: Constants.screenHeight - top + 16.0 , width: Constants.screenWidth - 32.0, height: 16)
        tipsLabel.textAlignment = .center
        tipsLabel.text = "将二维码/条码放入框内，即可自动扫描"
        tipsLabel.textColor = UIColor(hexString: "#AFAFAF")
        tipsLabel.font = UIFont.systemFont(ofSize: 13)
        view.addSubview(tipsLabel)
        
        let myQRCodeButton = UIButton(type: .system)
        myQRCodeButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        myQRCodeButton.setTitle("我的二维码", for: .normal)
        myQRCodeButton.setTitleColor(Colors.Brand, for: .normal)
        myQRCodeButton.frame = CGRect(x: (Constants.screenWidth - 102.0)/2.0, y: Constants.screenHeight - top + 36.0 , width: 102, height: 22)
        
        view.addSubview(myQRCodeButton)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var wx_navigationBarBackgroundColor: UIColor? {
        return .clear
    }
    
    override var wx_barTintColor: UIColor? {
        return .white
    }
    
    override var wx_titleTextAttributes: [NSAttributedString.Key : Any]? {
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
        
        let configuration = AssetPickerConfiguration.configurationForScan()
        let albumPickerVC = AlbumPickerViewController(configuration: configuration)
        albumPickerVC.selectionHandler = selectionHandler
        let assetPickerVC = AssetPickerViewController(configuration: configuration)
        assetPickerVC.selectionHandler = selectionHandler
        let nav = UINavigationController()
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

