//
//  PhotoBrowserLocalDataSource.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/17.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

class PhotoBrowserLocalDataSource: NSObject, PhotoBrowserDataSource {
    
    weak var browser: PhotoBrowserViewController?
    
    var numberOfItems: Int
    
    var images: [UIImage?]
    
    init(numberOfItems: Int, images: [UIImage?]) {
        self.numberOfItems = numberOfItems
        self.images = images
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(PhotoBrowserViewCell.self), for: indexPath) as! PhotoBrowserViewCell
        cell.imageView.image = images[indexPath.item]
        cell.setNeedsLayout()
        return cell
    }
}
