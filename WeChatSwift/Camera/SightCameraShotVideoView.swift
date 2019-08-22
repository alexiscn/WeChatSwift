//
//  SightCameraShotVideoView.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/22.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

class SightCameraShotVideoView: UIView {
    
    weak var delegate: SightCameraShotVideoViewDelegate?
    
    private let switchCameraButton: UIButton
    
    private let bottomBarView: UIView
    private let closeButton: UIButton
    private let recordView: SightCameraRecordView
    private let captureButtn: UIButton
    
    override init(frame: CGRect) {
        
        switchCameraButton = UIButton(type: .custom)
        switchCameraButton.setImage(UIImage(named: "sight_camera_switch_40x40_"), for: .normal)
        
        bottomBarView = UIView()
    
        closeButton = UIButton(type: .custom)
        closeButton.setImage(UIImage(named: "icon_sight_close_40x40_"), for: .normal)
        captureButtn = UIButton(type: .custom)
        recordView = SightCameraRecordView(frame: CGRect(x: 0, y: 0, width: 74, height: 76))
        
        super.init(frame: frame)
        
        addSubview(switchCameraButton)
        addSubview(bottomBarView)
        bottomBarView.addSubview(closeButton)
        bottomBarView.addSubview(recordView)
        bottomBarView.addSubview(captureButtn)
        
        bottomBarView.frame = CGRect(x: 0, y: bounds.height - 194, width: bounds.width, height: 194)
        
        switchCameraButton.addTarget(self, action: #selector(handleSwitchCameraButtonClicked), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(handleCloseButtonClicked), for: .touchUpInside)
        
        
        captureButtn.addTarget(self, action: #selector(onCaptureButtonDragInside(_:)), for: .touchDragInside)
        captureButtn.addTarget(self, action: #selector(onCaptureButtonDragOutside(_:)), for: .touchDragOutside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switchCameraButton.frame = CGRect(x: bounds.width - 55.0, y: Constants.topInset, width: 55.0, height: 55.0)
        closeButton.frame = CGRect(x: 0.1 * bounds.width, y: 0, width: 90, height: 194)
        captureButtn.frame = CGRect(x: (bounds.width - 90.0)/2, y: 0, width: 90, height: 194.0)
        recordView.frame.origin = CGPoint(x: (bounds.width - 74)/2, y: (194.0 - 76.0)/2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handleCloseButtonClicked() {
        delegate?.cameraShotVideoViewDidTapCloseButton()
    }
    
    @objc private func handleSwitchCameraButtonClicked() {
        
    }
    
    @objc private func onCaptureButtonDragInside(_ sender: UIButton) {
        
    }
    
    @objc private func onCaptureButtonDragOutside(_ sender: UIButton) {
        
    }
    
    @objc private func onCaptureButtonPressed(_ sender: UIButton) {
        
    }
    
    
}

protocol SightCameraShotVideoViewDelegate: class {
    
    func cameraShotVideoViewDidTapCloseButton()
    
}
