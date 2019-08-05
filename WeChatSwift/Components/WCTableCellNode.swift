//
//  WCTableCellNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/5.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

/// WeChat Common Table Cell Node
/// -------------------------
/// [Icon?]--[Title]------[>]
/// -------------------------
class WCTableCellNode: ASCellNode {
    
    private let iconNode = ASImageNode()
    private let titleNode = ASTextNode()
    private let arrowNode = ASImageNode()
    private let lineNode = ASDisplayNode()
    private let badgeNode = BadgeNode()
    
    private let model: WCTableCellModel
    private let isLastCell: Bool
    
    init(model: WCTableCellModel, isLastCell: Bool) {
        self.model = model
        self.isLastCell = isLastCell
        super.init()
        automaticallyManagesSubnodes = true
        iconNode.image = model.wc_image
        titleNode.attributedText = model.wc_attributedStringForTitle()
        lineNode.backgroundColor = Colors.DEFAULT_SEPARTOR_LINE_COLOR
        arrowNode.image = UIImage.SVGImage(named: "icons_outlined_arrow")
        badgeNode.update(count: model.wc_badgeCount, showDot: false)
    }
    
    override func didLoad() {
        super.didLoad()
        
        backgroundColor = .white
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let stack = ASStackLayoutSpec.horizontal()
        stack.alignItems = .center
        var elements: [ASLayoutElement] = []
        
        // Append Image
        if model.wc_image != nil {
            iconNode.style.spacingBefore = 16
            iconNode.style.spacingAfter = 16
            iconNode.style.preferredSize = model.wc_imageLayoutSize
            elements.append(iconNode)
        }
        
        // Append Title
        elements.append(titleNode)
    
        // Append Badge
        if model.wc_badgeCount > 0 {
            badgeNode.style.preferredSize = CGSize(width: 30, height: 30)
            elements.append(badgeNode)
        }
        
        // Append Spacer
        let spacer = ASLayoutSpec()
        spacer.style.flexGrow = 1.0
        spacer.style.flexShrink = 1.0
        elements.append(spacer)
        
        // Append Arrow
        arrowNode.style.preferredSize = CGSize(width: 12, height: 24)
        arrowNode.style.spacingAfter = 16
        elements.append(arrowNode)
        
        stack.children = elements
        
        let layout = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0), child: stack)
        layout.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 56)
        
        lineNode.isHidden = isLastCell
        lineNode.style.preferredSize = CGSize(width: Constants.screenWidth - 56, height: Constants.lineHeight)
        lineNode.style.layoutPosition = CGPoint(x: 56, y: 56 - Constants.lineHeight)
        
        return ASAbsoluteLayoutSpec(children: [layout, lineNode])
    }
}

protocol WCTableCellModel {
    
    var wc_title: String { get }
    
    var wc_image: UIImage? { get }
    
    var wc_imageLayoutSize: CGSize { get }
    
    var wc_badgeCount: Int { get }
}

extension WCTableCellModel {
    
    var wc_badgeCount: Int { return 0 }
    
    var wc_imageLayoutSize: CGSize { return CGSize(width: 24.0, height: 24.0) }
    
    func wc_attributedStringForTitle() -> NSAttributedString {
        return NSAttributedString(string: wc_title, attributes: [
            .font: UIFont.systemFont(ofSize: 17),
            .foregroundColor: UIColor(white: 0, alpha: 0.9)
            ])
    }
}
