//
//  PhotoBrowserPresentationController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/17.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

class PhotoBrowserPresentationController: UIPresentationController {
    
    var maskView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        guard let container = self.containerView else { return }
        
        container.addSubview(maskView)
        maskView.frame = container.bounds
        maskView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        maskView.alpha = 0.0
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.maskView.alpha = 1.0
        }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.maskView.alpha = 0.0
        }, completion: nil)
    }
}
