//
//  SettingLabHeaderNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class SettingLabHeaderNode: ASDisplayNode {
    
    private let leftBackgroundNode = ASImageNode()
    
    private let rightBackgroundNode = ASImageNode()
    
    private let labsIconNode = ASImageNode()
    
    private let titleNode = ASTextNode()
    
    private let descNode = ASTextNode()
    
    override init() {
        super.init()
        
        automaticallyManagesSubnodes = true
        
        titleNode.attributedText = NSAttributedString(string: "欢迎使用微信插件", attributes: [
            .font: UIFont.systemFont(ofSize: 25),
            .foregroundColor: UIColor.white
            ])
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        descNode.attributedText = NSAttributedString(string: "这里有微信的新功能，你可以打开来使用", attributes: [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor.white,
            .paragraphStyle: paragraphStyle
            ])
        
        leftBackgroundNode.image = UIImage(named: "me_lab_small_63x60_")
        rightBackgroundNode.image = UIImage(named: "me_lab_large_147x164_")
        labsIconNode.image = UIImage(named: "me_wechatlab_bulb_43x43_")
    }
    
    override func didLoad() {
        super.didLoad()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        leftBackgroundNode.style.preferredSize = CGSize(width: 63, height: 60)
        leftBackgroundNode.style.layoutPosition = CGPoint(x: 0, y: 131)
        
        rightBackgroundNode.style.preferredSize = CGSize(width: 147, height: 164)
        rightBackgroundNode.style.layoutPosition = CGPoint(x: constrainedSize.max.width - 147, y: 76)
        
        labsIconNode.style.preferredSize = CGSize(width: 43, height: 43)
        
        let stack = ASStackLayoutSpec.horizontal()
        stack.verticalAlignment = .bottom
        stack.horizontalAlignment = .middle
        stack.children = [labsIconNode, titleNode]
        
        stack.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 50)
        stack.style.layoutPosition = CGPoint(x: 0, y: 100)
        
        descNode.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 20)
        descNode.style.layoutPosition = CGPoint(x: 0, y: 167)
        
        return ASAbsoluteLayoutSpec(children: [leftBackgroundNode, rightBackgroundNode, stack, descNode])
    }
    
}
