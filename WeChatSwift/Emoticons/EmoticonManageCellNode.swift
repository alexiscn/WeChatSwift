//
//  EmoticonManageCellNode.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/8/17.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class EmoticonManageCellNode: ASCellNode {
    
    private let iconNode = ASNetworkImageNode()
    
    private let titleNode = ASTextNode()
    
    private let actionButton = ASButtonNode()
    
    private let lineNode = ASDisplayNode()
    
    private let isLastCell: Bool
    
    init(emotions: [String], isLastCell: Bool) {
        self.isLastCell = isLastCell
        super.init()
        automaticallyManagesSubnodes = true
        
        titleNode.attributedText = NSAttributedString(string: "AAAAA", attributes: [
            .font: UIFont.systemFont(ofSize: 17),
            .foregroundColor: Colors.black
            ])
        
        let backgroundImage = UIImage.as_resizableRoundedImage(withCornerRadius: 4, cornerColor: nil, fill: Colors.DEFAULT_BACKGROUND_COLOR)
        actionButton.setBackgroundImage(backgroundImage, for: .normal)
    }
    
    override func didLoad() {
        super.didLoad()
        
        backgroundColor = .white
        actionButton.addTarget(self, action: #selector(handleRemoveButtonClicked), forControlEvents: .touchUpInside)
    }
    
    @objc private func handleRemoveButtonClicked() {
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        iconNode.style.preferredSize = CGSize(width: 40.0, height: 40.0)
        titleNode.style.flexGrow = 1.0
        actionButton.style.preferredSize = CGSize(width: 60.0, height: 30.0)
        actionButton.style.spacingAfter = 15
        
        let stack = ASStackLayoutSpec.horizontal()
        stack.alignItems = .center
        stack.children = [iconNode, titleNode, actionButton]
        stack.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 50.0)
        
        lineNode.style.preferredSize = CGSize(width: constrainedSize.max.width - 15, height: Constants.lineHeight)
        lineNode.style.layoutPosition = CGPoint(x: 15.0, y: 50.0 - Constants.lineHeight)
        lineNode.isHidden = isLastCell
        
        return ASAbsoluteLayoutSpec(children: [stack, lineNode])
    }
}
