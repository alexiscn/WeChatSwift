//
//  SessionBadgeNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/17.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class SessionBadgeNode: ASDisplayNode {
    
    private let textNode = ASTextNode()
    
    private var showDot = false
    
    private var badgeCountNode: ASImageNode = {
        let background = ASImageNode()
        background.image = UIImage.SVGImage(named: "ui-resources_badge_count")
        return background
    }()
    
    private var badgeDotNode: ASImageNode = {
        let dot = ASImageNode()
        dot.image = UIImage.SVGImage(named: "ui-resources_badge_dot")
        return dot
    }()
    
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
        //backgroundColor = .green
    }
    
    func update(count: Int, showDot: Bool) {
        self.showDot = showDot
        textNode.attributedText = NSAttributedString(string: String(count), attributes: [
            .font: UIFont.systemFont(ofSize: 10),
            .foregroundColor: UIColor.white
            ])
        setNeedsLayout()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        if showDot {
            badgeDotNode.style.preferredSize = CGSize(width: 20, height: 20)
            return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 0), child: badgeDotNode)
        } else {
            let center = ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: .minimumXY, child: textNode)
            let background = ASBackgroundLayoutSpec(child: center, background: badgeCountNode)
            return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0), child: background)
        }
    }
    
}
