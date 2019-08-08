//
//  ShakeSettingCellNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/8.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class ShakeSettingCellNode: ASCellNode {
    
    private var titleNode = ASTextNode()
    
    private var arrowNode = ASImageNode()
    
    private var lineNode = ASDisplayNode()
    
    private var switchNode: ASDisplayNode?
    
    private lazy var switchButton: UISwitch = {
        let button = UISwitch()
        button.onTintColor = Colors.Brand
        return button
    }()
    
    private let settingItem: ShakeSettingItem
    private let isLastCell: Bool
    
    init(settingItem: ShakeSettingItem, isLastCell: Bool) {
        self.settingItem = settingItem
        self.isLastCell = isLastCell
        super.init()
        
        titleNode.attributedText = settingItem.attributedStringForTitle()
        lineNode.backgroundColor = Colors.DEFAULT_SEPARTOR_LINE_COLOR
        arrowNode.image = Constants.arrowImage
        automaticallyManagesSubnodes = true

        switch settingItem {
        case .enablePlaySound(let isOn):
            switchNode = ASDisplayNode(viewBlock: { [weak self] () -> UIView in
                let button = self?.switchButton ?? UISwitch()
                button.isOn = isOn
                return button
            })
        default:
            break
        }
    }
    
    override func didLoad() {
        super.didLoad()
        
        backgroundColor = .white
        
        if settingItem.showSwithButton {
            switchButton.addTarget(self, action: #selector(switchButtonValueChanged(_:)), for: .valueChanged)
        }
    }
    
    @objc private func switchButtonValueChanged(_ sender: UISwitch) {
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        titleNode.style.spacingBefore = 20
        titleNode.style.flexGrow = 1.0
        
        arrowNode.style.preferredSize = CGSize(width: 12, height: 24)
        arrowNode.style.spacingAfter = 16
        arrowNode.isHidden = !settingItem.showArrowImage
        
        var elements: [ASLayoutElement] = [titleNode, arrowNode]
        if let switchNode = switchNode {
            switchNode.style.preferredSize = CGSize(width: 51, height: 31)
            switchNode.style.spacingAfter = 16
            elements.append(switchNode)
        }
        let stack = ASStackLayoutSpec.horizontal()
        stack.alignItems = .center
        stack.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 44)
        stack.children = elements
        
        lineNode.style.preferredSize = CGSize(width: constrainedSize.max.width - 20, height: Constants.lineHeight)
        lineNode.style.layoutPosition = CGPoint(x: 20, y: 44.0 - Constants.lineHeight)
        
        return ASAbsoluteLayoutSpec(children: [stack, lineNode])
    }
}


