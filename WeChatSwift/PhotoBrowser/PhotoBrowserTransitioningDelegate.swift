//
//  PhotoBrowserTransitioningDelegate.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/17.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

protocol PhotoBrowserTransitioningDelegate: UIViewControllerTransitioningDelegate {
    
    var maskAlpha: CGFloat { get set }
    
}

class PhotoBrowserTransitioning: NSObject, PhotoBrowserTransitioningDelegate {
    
    weak var browser: PhotoBrowserViewController?
    
    var maskAlpha: CGFloat {
        set {
            photoBrowserPresentedController?.maskView.alpha = newValue
        }
        get {
           return photoBrowserPresentedController?.maskView.alpha ?? 0
        }
    }
    
    var presentingAnimator: UIViewControllerAnimatedTransitioning?
    
    var dismissingAnimator: UIViewControllerAnimatedTransitioning?
    
    weak var photoBrowserPresentedController: PhotoBrowserPresentationController?
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissingAnimator
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentingAnimator
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let controller = PhotoBrowserPresentationController(presentedViewController: presented, presenting: presenting)
        photoBrowserPresentedController = controller
        return controller
    }
}


class PhotoBrowserFadeDismissingAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let duration = self.transitionDuration(using: transitionContext)
        if let view = transitionContext.view(forKey: .from) {
            UIView.animate(withDuration: duration, animations: {
                view.alpha = 0.0
            }) { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
}

class PhotoBrowserFadePresentingAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let duration = self.transitionDuration(using: transitionContext)
        if let view = transitionContext.view(forKey: .to) {
            containerView.addSubview(view)
            view.alpha = 0.0
            UIView.animate(withDuration: duration, animations: {
                view.alpha = 1.0
            }) { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
}

class PhotoBrowserZoomAnimator: NSObject {
    
    var zoomView: () -> UIView?
    
    var startFrame: (_ transContainer: UIView) -> CGRect?
    
    var endFrame: (_ transContainer: UIView) -> CGRect?
    
    init(zoomView: @escaping () -> UIView?,
         startFrame: @escaping (_ transContainer: UIView) -> CGRect?,
         endFrame: @escaping (_ transContainer: UIView) -> CGRect?) {
        self.zoomView = zoomView
        self.startFrame = startFrame
        self.endFrame = endFrame
    }
}

class PhotoBrowserZoomDismissingAnimator: PhotoBrowserZoomAnimator, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let zoomView = zoomView(),
            let startFrame = startFrame(containerView),
            let endFrame = endFrame(containerView) else {
            fadeTransition(using: transitionContext)
            return
        }
        
        if let view = transitionContext.view(forKey: .from) {
            view.isHidden = true
        }
        containerView.addSubview(zoomView)
        zoomView.frame = startFrame
        let duration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
            zoomView.frame = endFrame
        }) { _ in
            zoomView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    private func fadeTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let duration = self.transitionDuration(using: transitionContext)
        if let view = transitionContext.view(forKey: .from) {
            UIView.animate(withDuration: duration, animations: {
                view.alpha = 0
            }, completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }
}

class PhotoBrowserZoomPresentingAnimator: PhotoBrowserZoomAnimator, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let zoomView = zoomView(),
            let startFrame = startFrame(containerView),
            let endFrame = endFrame(containerView) else {
                fadeTransition(using: transitionContext)
                return
        }
        
        containerView.addSubview(zoomView)
        zoomView.frame = startFrame
        let duration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
            zoomView.frame = endFrame
        }) { _ in
            if let presentedView = transitionContext.view(forKey: .to) {
                containerView.addSubview(presentedView)
            }
            zoomView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    private func fadeTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let duration = self.transitionDuration(using: transitionContext)
        if let view = transitionContext.view(forKey: .to) {
            // presentation转场，需要把目标视图添加到视图栈
            containerView.addSubview(view)
            view.alpha = 0
            UIView.animate(withDuration: duration, animations: {
                view.alpha = 1.0
            }, completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }
}
