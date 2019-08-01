//
//  WCNavigationController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/23.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

class WCNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let backgroundImage = UIImage.imageFromColor(Colors.backgroundColor)
//        
//        navigationBar.shadowImage = UIImage()
//        navigationBar.isTranslucent = false
//        
//        navigationBar.setBackgroundImage(backgroundImage, for: .default)
//        navigationBar.backIndicatorImage = UIImage.SVGImage(named: "icons_outlined_back")
//        navigationBar.backIndicatorTransitionMaskImage = UIImage.SVGImage(named: "icons_outlined_back")
    }
}

extension UINavigationController {
    
//    @_dynamicReplacement(for: viewDidLoad())
//    func wc_viewDidLoad() {
//    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard WCNavigationBar.enabled else { return }
        sendNavigationBarToBack()
        
        guard let bar = topViewController?.wc_navigationBar else { return }
        isNavigationBarHidden = false
        navigationBar.isHidden = bar.isHidden
        bar.adjustLayout()
        topViewController?.adjustSafeAreaInsets()
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard WCNavigationBar.enabled else { return }
        
        topViewController?.wc_navigationBar.adjustLayout()
    }
    
    func sendNavigationBarToBack() {
        navigationBar.tintColor = .clear
        if navigationBar.shadowImage == nil {
            let image = UIImage()
            navigationBar.setBackgroundImage(image, for: .default)
            navigationBar.shadowImage = image
            navigationBar.backIndicatorImage = image
            navigationBar.backIndicatorTransitionMaskImage = image
        }
        view.sendSubviewToBack(navigationBar)
    }
}
