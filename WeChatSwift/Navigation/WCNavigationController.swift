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
        
        let backgroundImage = UIImage.imageFromColor(Colors.DEFAULT_BACKGROUND_COLOR)
        
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        
        navigationBar.setBackgroundImage(backgroundImage, for: .default)
        navigationBar.backIndicatorImage = UIImage.SVGImage(named: "icons_outlined_back")
        navigationBar.backIndicatorTransitionMaskImage = UIImage.SVGImage(named: "icons_outlined_back")
    }
}

extension UIViewController {
    
    func titleLabel(_ title: String) -> UILabel {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        titleLabel.textColor = UIColor(hexString: "#181818")
        titleLabel.text = title
        return titleLabel
    }
    
    func setNavigationBarTitle(_ title: String) {
        navigationItem.titleView = titleLabel(title)
    }
    
}
