//
//  EmoticonBoardCameraEntryNode.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/7/19.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class EmoticonBoardCameraEntryNode: ASDisplayNode {
    
    private let imageNode = ASImageNode()
    
    private let titleNode = ASTextNode()
    
    private let subTitleNode = ASTextNode()
    
    override init() {
        super.init()
        
        automaticallyManagesSubnodes = true
        
        imageNode.image = UIImage(named: "CameraEmoticonCreateButton_56x56_")
        
        titleNode.attributedText = NSAttributedString(string: "拍自己的表情", attributes: [
            .font: UIFont.systemFont(ofSize: 17),
            .foregroundColor: UIColor(white: 0, alpha: 0.9)
            ])
        subTitleNode.attributedText = NSAttributedString(string: "表情将会上传保存，在其他设备也可以查看", attributes: [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor(white: 0, alpha: 0.9)
            ])
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        imageNode.style.preferredSize = CGSize(width: 56, height: 56)
        
        let spacer1 = ASLayoutSpec()
        spacer1.style.preferredSize = CGSize(width: 20, height: 20)
        
        let spacer2 = ASLayoutSpec()
        spacer2.style.preferredSize = CGSize(width: 20, height: 8)
        
        let stack = ASStackLayoutSpec.vertical()
        stack.alignItems = .center
        stack.children = [imageNode, spacer1, titleNode, spacer2, subTitleNode]
        
        return ASCenterLayoutSpec(centeringOptions: .Y, sizingOptions: .minimumY, child: stack)
    }
    
}
