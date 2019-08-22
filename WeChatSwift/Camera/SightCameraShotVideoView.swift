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
    
    private let closeButton: UIButton
    
    override init(frame: CGRect) {
        
        closeButton = UIButton(type: .custom)
        closeButton.setImage(UIImage(named: "icon_sight_close_40x40_"), for: .normal)
        
        super.init(frame: frame)
        
        addSubview(closeButton)
        
        closeButton.addTarget(self, action: #selector(handleCloseButtonClicked), for: .touchUpInside)
        
        closeButton.frame = CGRect(x: 55, y: bounds.height - 194, width: 90, height: 194)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handleCloseButtonClicked() {
        delegate?.cameraShotVideoViewDidTapCloseButton()
    }
}

protocol SightCameraShotVideoViewDelegate: class {
    
    func cameraShotVideoViewDidTapCloseButton()
    
}
