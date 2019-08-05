//
//  SettingDiscoverEntranceCellNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/2.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit
import UIKit

class SettingDiscoverEntranceCellNode: ASCellNode {
    
    private let iconNode = ASImageNode()
    
    private let titleNode = ASTextNode()
    
    private var switchNode: ASDisplayNode!
    
    private var lineNode = ASDisplayNode()
    
    private lazy var switchButton: UISwitch = {
        let button = UISwitch()
        return button
    }()
    
    private let discover: DiscoverModel
    
    private let isLastCell: Bool
    
    init(discover: DiscoverModel, isLastCell: Bool) {
        
        self.discover = discover
        self.isLastCell = isLastCell
        
        super.init()
        
        automaticallyManagesSubnodes = true
        
        switchNode = ASDisplayNode(viewBlock: { [weak self] () -> UIView in
            return self?.switchButton ?? UISwitch()
        })
        
        iconNode.image = discover.image
        titleNode.attributedText = discover.attributedStringForTitle()
        lineNode.backgroundColor = Colors.DEFAULT_SEPARTOR_LINE_COLOR
    }
    
    override func didLoad() {
        super.didLoad()
        
        backgroundColor = .white
        selectionStyle = .none
        
        switchNode.isUserInteractionEnabled = true
        switchButton.isOn = discover.enabled
        switchButton.addTarget(self, action: #selector(switchButtonValueChanged(_:)), for: .valueChanged)
    }
    
    @objc private func switchButtonValueChanged(_ sender: UISwitch) {
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        iconNode.style.spacingBefore = 16
        iconNode.style.spacingAfter = 16
        iconNode.style.preferredSize = CGSize(width: 24, height: 24)
        titleNode.style.flexGrow = 1.0
        
        switchNode.style.preferredSize = CGSize(width: 40, height: 32)
        switchNode.style.spacingAfter = 28
        
        let stack = ASStackLayoutSpec.horizontal()
        stack.alignItems = .center
        stack.children = [iconNode, titleNode, switchNode]
        
        let layout = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0), child: stack)
        layout.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 56)
        
        lineNode.isHidden = isLastCell
        lineNode.style.preferredSize = CGSize(width: Constants.screenWidth - 56, height: Constants.lineHeight)
        lineNode.style.layoutPosition = CGPoint(x: 56, y: 56 - Constants.lineHeight)
        
        return ASAbsoluteLayoutSpec(children: [layout, lineNode])
    }
    
}
