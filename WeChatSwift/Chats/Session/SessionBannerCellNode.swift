//
//  SessionBannerCellNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/19.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class SessionBannerCellNode: ASCellNode {
    
    private let iconNode = ASImageNode()
    
    private let titleNode = ASTextNode()
    
    init(banner: SessionBannerModel) {
        super.init()
        
        automaticallyManagesSubnodes = true
        
        iconNode.image = UIImage.SVGImage(named: "icons_filled_error")
        iconNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(Colors.Red)
        
        titleNode.attributedText = NSAttributedString(string: banner.title, attributes: [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor(white: 0, alpha: 0.6)
            ])
    }
    
    override func didLoad() {
        super.didLoad()
        
        backgroundColor = UIColor(hexString: "#FEEDED")
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        iconNode.style.preferredSize = CGSize(width: 24, height: 24)
        iconNode.style.layoutPosition = CGPoint(x: 28, y: 12)
        
        titleNode.style.preferredSize = CGSize(width: constrainedSize.max.width - 100, height: 17)
        titleNode.style.layoutPosition = CGPoint(x: 76, y: (48.0 - 17.0)/2)
        
        let layout = ASAbsoluteLayoutSpec(children: [iconNode, titleNode])
        layout.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 48)
        return layout
    }
    
}


struct SessionBannerModel {
    var title: String
    var backgroundColor: UIColor
}
