//
//  PhotoBrowserPHAssetDataSource.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/8/17.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit
import Photos
import FLAnimatedImage

class PhotoBrowserPHAssetDataSource: NSObject, PhotoBrowserDataSource {
    
    weak var browser: PhotoBrowserViewController?
    
    let numberOfItems: Int
    
    let assets: [PHAsset]
    
    init(numberOfItems: Int, assets: [PHAsset]) {
        self.numberOfItems = numberOfItems
        self.assets = assets
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(PhotoBrowserViewCell.self), for: indexPath) as! PhotoBrowserViewCell
        let asset = assets[indexPath.row]
        if asset.isGIF {
            PHImageManager.default().requestImageData(for: asset, options: nil) { (data, _, _, _) in
                DispatchQueue.main.async {
                    if let data = data {
                        cell.imageView.animatedImage = FLAnimatedImage(animatedGIFData: data)
                        cell.setNeedsLayout()
                    }
                }
            }
        } else {
            let size = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
            let options = PHImageRequestOptions()
            options.deliveryMode = .highQualityFormat
            options.isNetworkAccessAllowed = true
            PHCachingImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: options) { (image, _) in
                DispatchQueue.main.async {
                    cell.imageView.image = image
                    cell.setNeedsLayout()
                }
            }
        }
        
        let thumbSize = asset.pixelSizeFitToScreen
        let scale = UIScreen.main.scale
        cell.localAsset = asset
        cell.imageView.image = asset.thumbImage(with: CGSize(width: thumbSize.width/scale, height: thumbSize.height/scale))
        cell.playButton.isHidden = asset.mediaType != .video
        cell.setNeedsLayout()
        return cell
    }
}
