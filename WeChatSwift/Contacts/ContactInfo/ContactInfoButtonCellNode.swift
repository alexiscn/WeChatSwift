//
//  ContactInfoButtonCellNode.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/7/30.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class ContactInfoButtonCellNode: ASCellNode {
    
    private let buttonNode = ASButtonNode()
    
    private let lineNode = ASDisplayNode()
    
    private let isLastCell: Bool
    
    init(info: ContactInfo, isLastCell: Bool) {
        self.isLastCell = isLastCell
        super.init()
        automaticallyManagesSubnodes = true
        
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .semibold),
            NSAttributedString.Key.foregroundColor: Colors.DEFAULT_LINK_COLOR
        ]
        let attrbutedText = NSAttributedString(string: info.title, attributes: attributes)
        buttonNode.setAttributedTitle(attrbutedText, for: .normal)
        buttonNode.setImage(info.image, for: .normal)
        buttonNode.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(Colors.DEFAULT_LINK_COLOR)
        buttonNode.imageNode.style.preferredSize = CGSize(width: 20, height: 20)
        lineNode.backgroundColor = Colors.DEFAULT_SEPARTOR_LINE_COLOR
    }
    
    override func didLoad() {
        super.didLoad()
        backgroundColor = Colors.white
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        buttonNode.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 56)
            
        lineNode.isHidden = isLastCell
        lineNode.style.preferredSize = CGSize(width: constrainedSize.max.width, height: Constants.lineHeight)
        lineNode.style.layoutPosition = CGPoint(x: 0, y: 56.0 - Constants.lineHeight)
        return ASAbsoluteLayoutSpec(children: [buttonNode, lineNode])
    }
}
