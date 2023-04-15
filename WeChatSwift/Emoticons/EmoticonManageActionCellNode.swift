//
//  EmoticonManageActionCellNode.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/17.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class EmoticonManageActionCellNode: ASCellNode {
    
    private let iconNode = ASImageNode()
    
    private let titleNode = ASTextNode()
    
    private let arrowNode = ASImageNode()
    
    private let lineNode = ASDisplayNode()
    
    private let model: EmoticonManageItem
    
    private let isLastCell: Bool
    
    init(model: EmoticonManageItem, isLastCell: Bool) {
        self.model = model
        self.isLastCell = isLastCell
        super.init()
        
        automaticallyManagesSubnodes = true
        
        iconNode.image = model.image
        if let title = model.title {
            titleNode.attributedText = NSAttributedString(string: title, attributes: [
                .font: UIFont.systemFont(ofSize: 17),
                .foregroundColor: Colors.black
                ])
        }
        
        arrowNode.image = Constants.arrowImage
        lineNode.backgroundColor = Colors.DEFAULT_SEPARTOR_LINE_COLOR
    }
    
    override func didLoad() {
        super.didLoad()
        
        backgroundColor = .white
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        iconNode.style.preferredSize = CGSize(width: 24.0, height: 24.0)
        titleNode.style.flexGrow = 1.0
        arrowNode.style.preferredSize = CGSize(width: 12, height: 24)
        
        let stack = ASStackLayoutSpec.horizontal()
        stack.alignItems = .center
        stack.spacing = 5
        stack.children = model.image == nil ? [titleNode, arrowNode] : [iconNode, titleNode, arrowNode]
        stack.style.preferredSize = CGSize(width: constrainedSize.max.width - 30.0, height: 44)
        stack.style.layoutPosition = CGPoint(x: 15, y: 0)
        
        lineNode.style.preferredSize = CGSize(width: constrainedSize.max.width - 15, height: Constants.lineHeight)
        lineNode.style.layoutPosition = CGPoint(x: 15, y: 44.0 - Constants.lineHeight)
        lineNode.isHidden = isLastCell
        
        return ASAbsoluteLayoutSpec(children: [stack, lineNode])
    }
}
