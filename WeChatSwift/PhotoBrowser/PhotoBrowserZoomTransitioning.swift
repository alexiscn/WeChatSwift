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
    typealias ViewClosure = (_ browser: PhotoBrowserViewController, _ pageIndex: Int, _ transContainer: UIView) -> UIView?
    
    let originFrame: FrameClosure
    
    init(originFrame: @escaping FrameClosure) {
        self.originFrame = originFrame
        super.init()
        setupPresenting()
        setupDismissing()
    }
    
    convenience init(originView: @escaping ViewClosure) {
        let frameClosure: FrameClosure = { (browser, index, view) -> CGRect? in
            if let oriView = originView(browser, index, view) {
                if let res = oriView as? PhotoBrowserZoomTransitioningOriginResource {
                    return PhotoBrowserZoomTransitioning.resRect(oriRes: res, to: view)
                }
                return oriView.convert(oriView.bounds, to: view)
            }
            return nil
        }
        self.init(originFrame: frameClosure)
    }
    
    func setupPresenting() {
        presentingAnimator = PhotoBrowserZoomPresentingAnimator(zoomView: { [weak self] () -> UIView? in
            let view = self?.browser?.transitionZoomView
            view?.contentMode = .scaleAspectFill
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
    
    public static func resRect(oriRes: PhotoBrowserZoomTransitioningOriginResource,
                               to view: UIView) -> CGRect {
        let oriView = oriRes.originResourceView
        var rect = oriView.convert(oriView.bounds, to: view)
        // 维持宽高比例
        let ratio = oriRes.originResourceAspectRatio
        if ratio > 0 {
            rect.size.height = rect.width / ratio
        }
        return rect
    }
    
}
