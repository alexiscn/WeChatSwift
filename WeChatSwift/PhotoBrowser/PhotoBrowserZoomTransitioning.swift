//
//  PhotoBrowserZoomTransitioning.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/17.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

class PhotoBrowserZoomTransitioning: PhotoBrowserTransitioning {
    
    typealias FrameClosure = (_ browser: PhotoBrowserViewController, _ pageIndex: Int, _ transContainer: UIView) -> CGRect?
    
    let originFrame: FrameClosure
    
    init(originFrame: @escaping FrameClosure) {
        self.originFrame = originFrame
        super.init()
        setupPresenting()
        setupDismissing()
    }
    
    func setupPresenting() {
        presentingAnimator = PhotoBrowserZoomPresentingAnimator(zoomView: { [weak self] () -> UIView? in
            let view = self?.browser?.transitionZoomView
            view?.clipsToBounds = true
            return view
        }, startFrame: { [weak self] (view) -> CGRect? in
            if let browser = self?.browser {
                return self?.originFrame(browser, browser.pageIndex, view)
            }
            return nil
        }, endFrame: { [weak self] (view) -> CGRect? in
            if let contentView = self?.browser?.displayingContentView {
                return contentView.convert(contentView.bounds, to: view)
            }
            return nil
        })
    }
    
    func setupDismissing() {
        dismissingAnimator = PhotoBrowserZoomDismissingAnimator(zoomView: { [weak self] () -> UIView? in
            let view = self?.browser?.transitionZoomView
            view?.clipsToBounds = true
            return view
        }, startFrame: { [weak self] (view) -> CGRect? in
            if let contentView = self?.browser?.displayingContentView {
                return contentView.convert(contentView.bounds, to: view)
            }
            return nil
        }, endFrame: { [weak self] (view) -> CGRect? in
            if let browser = self?.browser {
                return self?.originFrame(browser, browser.pageIndex, view)
            }
            return nil
        })
    }
    
}
