//
//  AssetPickerCollectionViewCell.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/7/23.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit
import Photos

class AssetPickerCollectionViewCell: UICollectionViewCell {
    
    weak var parent: AssetPickerViewController?
    
    var selectionHandler: RelayCommand?
    
    private let imageView: UIImageView
    
    private let selectionButton: UIButton
    
    private let selectionImageView: UIImageView
    
    private let selectionNumberLabel: UILabel
    
    private var mediaAsset: MediaAsset?
    
    private var videoLogoView: UIImageView?
    
    private var tagBackgroundView: UIImageView?
    
    private var lengthLabel: UILabel?
    
    var imageViewForZoomTransition: UIImageView {
        return imageView
    }
    
    override init(frame: CGRect) {
        
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        selectionButton = UIButton(type: .custom)
        
        selectionImageView = UIImageView()
        selectionImageView.image = UIImage.as_imageNamed("FriendsSendsPicturesSelectIcon_27x27_")
        
        selectionNumberLabel = UILabel()
        selectionNumberLabel.isHidden = true
        selectionNumberLabel.layer.cornerRadius = 11.5
        selectionNumberLabel.layer.masksToBounds = true
        selectionNumberLabel.clipsToBounds = true
        selectionNumberLabel.frame = CGRect(x: 2, y: 2, width: 23, height: 23)
        selectionNumberLabel.backgroundColor = UIColor(hexString: "#1AAD19")
        
        selectionNumberLabel.textAlignment = .center
        selectionNumberLabel.textColor = .white
        
        selectionNumberLabel.font = UIFont.systemFont(ofSize: 14)
        
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        contentView.addSubview(selectionButton)
        contentView.addSubview(selectionImageView)
        
        selectionImageView.addSubview(selectionNumberLabel)
        
        selectionButton.addTarget(self, action: #selector(selectionButtonTapped), for: .touchUpInside)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        removeVideoLogoView()
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
    
    @objc private func selectionButtonTapped() {
        guard let mediaAsset = mediaAsset, let parent = parent else { return }
        if !mediaAsset.selected && parent.selectedIndexPathList.count >= 9 {
            return
        }
        
        mediaAsset.selected.toggle()
        if mediaAsset.selected {
            let index = parent.selectedIndexPathList.count + 1
            selectionNumberLabel.text = String(index)
            selectionNumberLabel.isHidden = false
        } else {
            selectionNumberLabel.isHidden = true
        }
        selectionHandler?()
    }
    
    func update(mediaAsset: MediaAsset, configuration: AssetPickerConfiguration) {
        self.mediaAsset = mediaAsset
        
        selectionButton.isHidden = !configuration.canSendMultiImage
        selectionImageView.isHidden = !configuration.canSendMultiImage
        
        removeVideoLogoView()
        if mediaAsset.asset.mediaType == .video {
            addVideoLogoView()
        } else {
            if mediaAsset.asset.isGIF {
                addGifLogoView()
            }
        }
        
        selectionNumberLabel.text = String(mediaAsset.index)
        selectionNumberLabel.isHidden = !mediaAsset.selected
        
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
    
    private func addVideoLogoView() {
        let videoLogoView = UIImageView(frame: CGRect(x: 10, y: 7, width: 18, height: 11))
        videoLogoView.image = UIImage(named: "fileicon_video_wall_18x11_")
        let tagBackgroundView = UIImageView(frame: CGRect(x: 0, y: bounds.height - 28, width: bounds.width, height: 28))
        tagBackgroundView.image = UIImage(named: "Albumtimeline_video_shadow_4x28_")
        
        let lengthLabel = UILabel()
        lengthLabel.font = UIFont.systemFont(ofSize: 12)
        lengthLabel.textColor = UIColor.white
        lengthLabel.text = Constants.formatDuration(mediaAsset?.asset.duration ?? 0)
        lengthLabel.frame = CGRect(x: 39, y: 5, width: 34, height: 15)
        
        tagBackgroundView.addSubview(videoLogoView)
        tagBackgroundView.addSubview(lengthLabel)
        contentView.addSubview(tagBackgroundView)
        self.tagBackgroundView = tagBackgroundView
    }
    
    private func removeVideoLogoView() {
        if videoLogoView != nil {
            videoLogoView?.removeFromSuperview()
            videoLogoView = nil
        }
        if tagBackgroundView != nil {
            tagBackgroundView?.removeFromSuperview()
            tagBackgroundView = nil
        }
        if lengthLabel != nil {
            lengthLabel?.removeFromSuperview()
            lengthLabel = nil
        }
    }
    
    private func addGifLogoView() {
        
        let tagBackgroundView = UIImageView(frame: CGRect(x: 0, y: bounds.height - 28, width: bounds.width, height: 28))
        tagBackgroundView.image = UIImage(named: "Albumtimeline_video_shadow_4x28_")
        
        let gifLabel = UILabel()
        gifLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        gifLabel.textColor = .white
        gifLabel.text = "GIF"
        gifLabel.frame = CGRect(x: 10, y: 0, width: 20, height: 28)
        tagBackgroundView.addSubview(gifLabel)
        contentView.addSubview(tagBackgroundView)
        self.tagBackgroundView = tagBackgroundView
    }
}
