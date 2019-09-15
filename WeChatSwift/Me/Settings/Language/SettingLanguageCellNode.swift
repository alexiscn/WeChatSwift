//
//  SettingLanguageCellNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/16.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class SettingLanguageCellNode: ASCellNode {
    
    private let textNode = ASTextNode()
    
    private let lineNode = ASDisplayNode()
    
    private let markNode = ASImageNode()
    
    private let isLastCell: Bool
    
    private let model: SettingLanguageModel
    
    init(model: SettingLanguageModel, isLastCell: Bool) {
        self.model = model
        self.isLastCell = isLastCell
        super.init()
        
        automaticallyManagesSubnodes = true
        
        textNode.attributedText = NSAttributedString(string: model.language.title, attributes: [
            .font: UIFont.systemFont(ofSize: 17),
            .foregroundColor: Colors.black
            ])
        
        lineNode.backgroundColor = Colors.DEFAULT_SEPARTOR_LINE_COLOR
        
        markNode.image = UIImage.SVGImage(named: "icons_filled_done")
        markNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor(hexString: "#007AFF"))
    }
    
    override func didLoad() {
        super.didLoad()
        
        backgroundColor = Colors.white
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        textNode.style.flexGrow = 1.0
        textNode.style.spacingBefore = 20.0
        
        markNode.style.preferredSize = CGSize(width: 14, height: 11)
        
        let stack = ASStackLayoutSpec.horizontal()
        stack.alignItems = .center
        stack.children = model.isSelected ? [textNode, markNode] : [textNode]
        stack.style.preferredSize = CGSize(width: constrainedSize.max.width - 20, height: 56)
        
        lineNode.style.preferredSize = CGSize(width: constrainedSize.max.width - 20, height: Constants.lineHeight)
        lineNode.style.layoutPosition = CGPoint(x: 20, y: 56.0 - Constants.lineHeight)
        lineNode.isHidden = isLastCell
        
        return ASAbsoluteLayoutSpec(children: [stack, lineNode])
    }
    
}
