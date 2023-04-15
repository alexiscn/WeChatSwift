//
//  NearbyPeopleErrorPlaceholder.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/8.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class NearbyPeopleErrorPlaceholder: ASDisplayNode {
    
    private let imageNode = ASImageNode()
    
    private let textNode = ASTextNode()
    
    override init() {
        super.init()
        
        imageNode.image = UIImage(named: "setting_locationServicesDisable_120x120_")
        
        let text = "无法获取你的位置信息。\n请到手机系统的[设置]->[隐私]->[定位服务]中打开定位服务，并允许微信使用定位服务。"
        textNode.maximumNumberOfLines = 0
        textNode.attributedText = NSAttributedString(string: text, attributes: [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor(hexString: "#555555")
            ])
    }
    
    override func didLoad() {
        super.didLoad()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        imageNode.style.preferredSize = CGSize(width: 120, height: 120)
        imageNode.style.layoutPosition = CGPoint(x: (constrainedSize.max.width - 120)/2, y: 36)
        
        textNode.style.preferredSize = CGSize(width: 230, height: 121)
        textNode.style.layoutPosition = CGPoint(x: (constrainedSize.max.width - 230)/2, y: 162)
        
        return ASAbsoluteLayoutSpec(children: [imageNode, textNode])
    }
    
}
