//
//  PhotoBrowserNetworkDataSource.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/17.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit
import FLAnimatedImage

class PhotoBrowserNetworkDataSource: NSObject, PhotoBrowserDataSource {
    
    weak var browser: PhotoBrowserViewController?
    
    private let numberOfItems: Int
    
    private let placeholders: [UIImage?]
    
    private let remoteURLs: [URL?]
    
    init(numberOfItems: Int, placeholders: [UIImage?], remoteURLs: [URL?]) {
        self.numberOfItems = numberOfItems
        self.placeholders = placeholders
        self.remoteURLs = remoteURLs
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(PhotoBrowserViewCell.self), for: indexPath) as! PhotoBrowserViewCell
        cell.imageView.image = placeholders[indexPath.item]
        cell.imageView.pin_setImage(from: remoteURLs[indexPath.item])
        cell.setNeedsLayout()
        return cell
    }
}
