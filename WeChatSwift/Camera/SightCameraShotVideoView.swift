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
    
    // Top Views
    private let topBarView: UIView
    private let switchCameraButton: UIButton
    
    // Center Views
    private let touchDownView: SightCameraTouchDownView
    
    // Bottom Views
    private let bottomBarView: UIView
    private let closeButton: UIButton
    private let recordView: SightCameraRecordView
    private let captureButton: UIButton
    
    override init(frame: CGRect) {
        
        topBarView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 44 + Constants.topInset))
        switchCameraButton = UIButton(type: .custom)
        switchCameraButton.setImage(UIImage(named: "sight_camera_switch_40x40_"), for: .normal)
        
        touchDownView = SightCameraTouchDownView(frame: CGRect(x: 0, y: 44 + Constants.topInset, width: frame.width, height: frame.height - 44 - Constants.topInset - 194.0))
        
        bottomBarView = UIView(frame: CGRect(x: 0, y: frame.height - 194, width: frame.width, height: 194))
        closeButton = UIButton(type: .custom)
        closeButton.setImage(UIImage(named: "icon_sight_close_40x40_"), for: .normal)
        captureButton = UIButton(type: .custom)
        recordView = SightCameraRecordView(frame: CGRect(x: 0, y: 0, width: 74, height: 76))
        
        super.init(frame: frame)
        
        addSubview(touchDownView)
        
        addSubview(topBarView)
        topBarView.addSubview(switchCameraButton)
        
        addSubview(bottomBarView)
        bottomBarView.addSubview(closeButton)
        bottomBarView.addSubview(recordView)
        bottomBarView.addSubview(captureButton)
        
        switchCameraButton.addTarget(self, action: #selector(handleSwitchCameraButtonClicked), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(handleCloseButtonClicked), for: .touchUpInside)
        
        captureButton.addTarget(self, action: #selector(onCaptureButtonDragInside(_:)), for: .touchDragInside)
        captureButton.addTarget(self, action: #selector(onCaptureButtonDragOutside(_:)), for: .touchDragOutside)
        
        // Used To Pan to Zoom out(in) Preview
        let captureButtonPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanPreviewGesture(_:)))
        captureButton.addGestureRecognizer(captureButtonPanGesture)
        
        let touchDownDoubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTouchDownViewDoubleTapGesture(_:)))
        touchDownDoubleTapGesture.numberOfTapsRequired = 2
        touchDownView.addGestureRecognizer(touchDownDoubleTapGesture)
        
        let touchDownPinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handleTouchDownViewPinchGesture(_:)))
        touchDownView.addGestureRecognizer(touchDownPinchGesture)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switchCameraButton.frame = CGRect(x: bounds.width - 55.0, y: Constants.topInset, width: 55.0, height: 55.0)
        closeButton.frame = CGRect(x: 0.1 * bounds.width, y: 0, width: 90, height: 194)
        captureButton.frame = CGRect(x: (bounds.width - 90.0)/2, y: 0, width: 90, height: 194.0)
        recordView.frame.origin = CGPoint(x: (bounds.width - 74)/2, y: (194.0 - 76.0)/2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handleCloseButtonClicked() {
        delegate?.cameraShotVideoViewDidTapCloseButton()
    }
    
    @objc private func handleSwitchCameraButtonClicked() {
        delegate?.cameraShotVideoViewDidTapSwitchButton()
    }
    
    @objc private func onCaptureButtonDragInside(_ sender: UIButton) {
        
    }
    
    @objc private func onCaptureButtonDragOutside(_ sender: UIButton) {
        
    }
    
    @objc private func onCaptureButtonPressed(_ sender: UIButton) {
        
    }
    
    @objc private func handlePanPreviewGesture(_ gesture: UIPanGestureRecognizer) {
        
    }
    
    @objc private func handleTouchDownViewPinchGesture(_ gesture: UIPinchGestureRecognizer) {
        //TODO: - Zoom
        //gesture.scale
    }
    
    @objc private func handleTouchDownViewDoubleTapGesture(_ gesture: UITapGestureRecognizer) {
        //TODO: - Switch Camera
    }
    
    @objc private func handleTouchDownViewPanGesture(_ gesture: UIPanGestureRecognizer) {
        
    }
}

protocol SightCameraShotVideoViewDelegate: class {
    
    func cameraShotVideoViewDidTapCloseButton()
    
    func cameraShotVideoViewDidTapSwitchButton()
}
