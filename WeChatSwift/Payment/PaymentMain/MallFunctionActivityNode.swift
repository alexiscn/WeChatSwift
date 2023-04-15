//
//  MallFunctionActivityNode.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/2.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class MallFunctionActivityNode: ASDisplayNode {
    
    private let imageNode = ASNetworkImageNode()
    
    private let titleNode = ASTextNode()
    
    private let bottomLine = ASDisplayNode()
    
    private let rightLine = ASDisplayNode()
    
    private let activity: MallFunctionActivity
    
    init(activity: MallFunctionActivity) {
        self.activity = activity
        super.init()
        
        automaticallyManagesSubnodes = true
        
        imageNode.image = activity.image
        titleNode.attributedText = activity.attributedStringForTitle()
        
        bottomLine.backgroundColor = UIColor(hexString: "#E5E5E5")
        rightLine.backgroundColor = UIColor(hexString: "#E5E5E5")
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        imageNode.style.preferredSize = CGSize(width: 30, height: 30)
        imageNode.style.layoutPosition = CGPoint(x: (constrainedSize.max.width - 30.0)/2, y: (constrainedSize.max.height - 30.0)/2 - 10)
        
        titleNode.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 18)
        titleNode.style.layoutPosition = CGPoint(x: 0, y: imageNode.style.layoutPosition.y + 40)
        
        
        var elements: [ASLayoutElement] = [imageNode, titleNode]
        if activity.showBottomLine {
            bottomLine.style.preferredSize = CGSize(width: constrainedSize.max.width, height: Constants.lineHeight)
            bottomLine.style.layoutPosition = CGPoint(x: 0, y: constrainedSize.max.height - Constants.lineHeight)
            elements.append(bottomLine)
        }
        if activity.showRightLine {
            rightLine.style.preferredSize = CGSize(width: Constants.lineHeight, height: constrainedSize.max.height)
            rightLine.style.layoutPosition = CGPoint(x: constrainedSize.max.width - Constants.lineHeight, y: 0)
            elements.append(rightLine)
        }
        
        return ASAbsoluteLayoutSpec(children: elements)
    }
    
}

class MallFunctionActivity {
    
    var identifier: Int

    var title: String?
    
    var image: UIImage?
    
    var showBottomLine = true
    
    var showRightLine = true
    
    init(identifier: Int, title: String?, image: UIImage?) {
        self.identifier = identifier
        self.title = title
        self.image = image
    }
    
    func attributedStringForTitle() -> NSAttributedString? {
        guard let title = title else { return nil }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        return NSAttributedString(string: title, attributes: attributes)
    }
}
