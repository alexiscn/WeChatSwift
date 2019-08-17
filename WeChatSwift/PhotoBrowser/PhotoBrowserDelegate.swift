//
//  PhotoBrowserDelegate.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/17.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

protocol PhotoBrowserDelegate: UICollectionViewDelegate {
    
    var browser: PhotoBrowserViewController? { set get }
    
    func photoBrowser(_ photoBrowser: PhotoBrowserViewController, pageIndexDidChanged pageIndex: Int)
    
    func photoBrowser(_ photoBrowser: PhotoBrowserViewController, transitionViewAt pageIndex: Int) -> UIView?
    
    func photoBrowser(_ photoBrowser: PhotoBrowserViewController, displayingContentViewAt pageIndex: Int) -> UIView?
}

class PhotoBrowserDefaultDelegate: NSObject, PhotoBrowserDelegate {
    
    weak var browser: PhotoBrowserViewController?
    
    func photoBrowser(_ photoBrowser: PhotoBrowserViewController, pageIndexDidChanged pageIndex: Int) {
        
    }
    
    func photoBrowser(_ photoBrowser: PhotoBrowserViewController, transitionViewAt pageIndex: Int) -> UIView? {
        let indexPath = IndexPath(item: pageIndex, section: 0)
        let cell = browser?.collectionView.cellForItem(at: indexPath) as? PhotoBrowserViewCell
        return UIImageView(image: cell?.imageView.image)
    }
    
    func photoBrowser(_ photoBrowser: PhotoBrowserViewController, displayingContentViewAt pageIndex: Int) -> UIView? {
        let indexPath = IndexPath(item: pageIndex, section: 0)
        let cell = browser?.collectionView.cellForItem(at: indexPath) as? PhotoBrowserViewCell
        return cell?.imageView
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? PhotoBrowserViewCell else {
            return
        }
        cell.imageView.contentMode = .scaleAspectFill
        
        cell.tapHandler = { [weak self] in
            self?.dismiss()
        }
        cell.panGestureChangedHandler = { [weak self] scale in
            let alpha = scale * scale
            self?.browser?.transDelegate.maskAlpha = alpha
            self?.coverStatusBar(alpha > 0.95)
        }
        cell.panGestureReleasedHandler = { [weak self] swipeDown in
            if swipeDown {
                self?.dismiss()
            } else {
                self?.browser?.transDelegate.maskAlpha = 1.0
                self?.coverStatusBar(true)
            }
        }
    }
    
    private func dismiss() {
        browser?.dismiss(animated: true, completion: nil)
    }
    
    private func coverStatusBar(_ shouldCover: Bool) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = (scrollView.contentOffset.x + scrollView.bounds.width / 2) / scrollView.bounds.width
        browser?.pageIndex = max(0, Int(value))
    }
}
