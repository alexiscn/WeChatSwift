//
//  PhotoBrowserLocalDataSource.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/17.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

class PhotoBrowserLocalDataSource: NSObject, PhotoBrowserDataSource {
    
    weak var browser: PhotoBrowserViewController?
    
    var numberOfItems: () -> Int
    
    var imageAtIndex: (Int) -> UIImage?
    
    init(numberOfItems: @escaping ()-> Int, imageAtIndex: @escaping (Int) -> UIImage?) {
        self.numberOfItems = numberOfItems
        self.imageAtIndex = imageAtIndex
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(PhotoBrowserViewCell.self), for: indexPath) as! PhotoBrowserViewCell
        cell.imageView.image = imageAtIndex(indexPath.item)
        cell.setNeedsLayout()
        return cell
    }
}
