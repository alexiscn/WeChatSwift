//
//  AssetPickerCollectionViewCell.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/23.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit
import Photos

class AssetPickerCollectionViewCell: UICollectionViewCell {
    
    private let imageView: UIImageView
    
    private let selectionButton: UIButton
    
    private let selectionImageView: UIImageView
    
    override init(frame: CGRect) {
        
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        selectionButton = UIButton(type: .custom)
        
        selectionImageView = UIImageView()
        selectionImageView.image = UIImage.as_imageNamed("FriendsSendsPicturesSelectIcon_27x27_")
        
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        contentView.addSubview(selectionButton)
        contentView.addSubview(selectionImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
        selectionButton.frame = CGRect(x: bounds.width/2, y: 0, width: bounds.width/2, height: bounds.height/2)
        selectionImageView.frame = CGRect(x: bounds.width - 27, y: 0, width: 27, height: 27)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(mediaAsset: MediaAsset) {
        
        selectionImageView.isHidden = mediaAsset.selected
        
        let size = CGSize(width: 150, height: 150)
        PHCachingImageManager.default().requestImage(for: mediaAsset.asset,
                                                     targetSize: size,
                                                     contentMode: .aspectFill,
                                                     options: nil) { [weak self] (image, _) in
            DispatchQueue.main.async {
                self?.imageView.image = image
            }
        }
    }
}
