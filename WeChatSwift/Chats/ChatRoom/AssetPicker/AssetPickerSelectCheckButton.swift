//
//  AssetPickerSelectCheckButton.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/21.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

class AssetPickerSelectCheckButton: UIButton {
    
    private let selectionNumberLabel: UILabel
    
    private let selectionImageView: UIImageView
    
    override init(frame: CGRect) {
        
        selectionImageView = UIImageView()
        selectionImageView.image = UIImage.as_imageNamed("FriendsSendsPicturesSelectIcon_27x27_")
        
        selectionNumberLabel = UILabel()
        selectionNumberLabel.isHidden = true
        selectionNumberLabel.layer.cornerRadius = 11.5
        selectionNumberLabel.layer.masksToBounds = true
        selectionNumberLabel.clipsToBounds = true
        selectionNumberLabel.frame = CGRect(x: 2, y: 2, width: 23, height: 23)
        selectionNumberLabel.backgroundColor = UIColor(hexString: "#1AAD19")
        
        super.init(frame: frame)
        
        addSubview(selectionImageView)
        addSubview(selectionNumberLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func startPopupAnimation() {
        selectionNumberLabel.layer.removeAllAnimations()
        let animation = CAKeyframeAnimation(keyPath: "transform")
        animation.duration = 0.6
        animation.keyTimes = [0, 0.8, 0.9, 1.0]
        animation.values = [1, 1.1, 0.9, 1.0]
        selectionNumberLabel.layer.add(animation, forKey: "popup")
    }
    
}
