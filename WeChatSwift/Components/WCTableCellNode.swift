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
    
    var valueChangedHandler: ((Bool) -> Void)?
    
    private let iconNode = ASImageNode()
    private let titleNode = ASTextNode()
    private let arrowNode = ASImageNode()
    private let lineNode = ASDisplayNode()
    private let badgeNode = BadgeNode()
    private var switchNode: ASDisplayNode?
    
    private lazy var switchButton: UISwitch = {
        let button = UISwitch()
        button.onTintColor = Colors.Brand
        return button
    }()
    
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
        
        if model.wc_showSwitch {
            isUserInteractionEnabled = true
            let isOn = model.wc_switchValue
            switchNode = ASDisplayNode(viewBlock: { [weak self] () -> UIView in
                let button = self?.switchButton ?? UISwitch()
                button.isOn = isOn
                return button
            })
        }
        if model.wc_imageCornerRadius > 0 {
            iconNode.cornerRadius = model.wc_imageCornerRadius
            iconNode.cornerRoundingType = .precomposited
        }
    }
    
    override func didLoad() {
        super.didLoad()
        
        backgroundColor = .white
        
        if model.wc_showSwitch {
            switchButton.addTarget(self, action: #selector(switchButtonValueChanged(_:)), for: .valueChanged)
        }
    }
    
    @objc private func switchButtonValueChanged(_ sender: UISwitch) {
        valueChangedHandler?(sender.isOn)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        var elements: [ASLayoutElement] = []
        var leading: CGFloat = 0.0
        
        // Append Image
        if model.wc_image != nil {
            iconNode.style.spacingBefore = 16
            iconNode.style.preferredSize = model.wc_imageLayoutSize
            elements.append(iconNode)
            
            leading += 16.0 + model.wc_imageLayoutSize.width
        }
        
        // Append Title
        titleNode.style.spacingBefore = 16.0
        elements.append(titleNode)
        leading += 16.0
    
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
        
        if let accessory = model.wc_accessoryNode {
            elements.append(accessory)
        }
        
        if let switchNode = self.switchNode {
            // Append Switch
            switchNode.style.preferredSize = CGSize(width: 51, height: 31)
            switchNode.style.spacingAfter = 16
            elements.append(switchNode)
        } else {
            // Append Arrow
            arrowNode.style.preferredSize = CGSize(width: 12, height: 24)
            arrowNode.style.spacingBefore = 16
            arrowNode.style.spacingAfter = 16
            arrowNode.isHidden = !model.wc_showArrow
            elements.append(arrowNode)
        }
        
        let stack = ASStackLayoutSpec.horizontal()
        stack.alignItems = .center
        stack.children = elements
        stack.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 56)
        
        lineNode.isHidden = isLastCell
        lineNode.style.preferredSize = CGSize(width: Constants.screenWidth - leading, height: Constants.lineHeight)
        lineNode.style.layoutPosition = CGPoint(x: leading, y: 56 - Constants.lineHeight)
    
        return ASAbsoluteLayoutSpec(children: [stack, lineNode])
    }
}
