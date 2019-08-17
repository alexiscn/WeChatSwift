//
//  PhotoBrowserDelegate.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/17.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

protocol PhotoBrowserDelegate: UICollectionViewDelegate {
    
    func photoBrowser(_ photoBrowser: PhotoBrowserViewController, pageIndexDidChanged pageIndex: Int)
    
    func photoBrowser(_ photoBrowser: PhotoBrowserViewController, transitionViewAt pageIndex: Int) -> UIView?
    
    func photoBrowser(_ photoBrowser: PhotoBrowserViewController, displayingContentViewAt pageIndex: Int) -> UIView
}

extension PhotoBrowserDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? PhotoBrowserViewCell else {
            return
        }
        
        
    }
    
}


