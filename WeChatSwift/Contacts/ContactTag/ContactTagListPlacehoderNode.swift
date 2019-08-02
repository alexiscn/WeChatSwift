//
//  ContactTagListPlacehoderNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/2.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class ContactTagListPlacehoderNode: ASDisplayNode {
    
    var createButtonHandler: RelayCommand?
    
    private let titleNode = ASTextNode()
    
    private let descNode = ASTextNode()
    
    private let createButtonNode = ASButtonNode()
    
    override init() {
        super.init()
        
        automaticallyManagesSubnodes = true
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        titleNode.attributedText = NSAttributedString(string: "暂无标签", attributes: [
            .font: UIFont.systemFont(ofSize: 18, weight: .semibold),
            .foregroundColor: UIColor(hexString: "#B2B2B2"),
            .paragraphStyle: paragraphStyle
            ])
    
        descNode.attributedText = NSAttributedString(string: "通过标签你可方便查找和管理联系人", attributes: [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor(hexString: "#B2B2B2"),
            .paragraphStyle: paragraphStyle
            ])
        
        let buttonText = NSAttributedString(string: "新建标签", attributes: [
            .font: UIFont.systemFont(ofSize: 18, weight: .medium),
            .foregroundColor: UIColor.white
            ])
        
        createButtonNode.setAttributedTitle(buttonText, for: .normal)
        createButtonNode.backgroundColor = Colors.Brand
        
        
    }
    
    override func didLoad() {
        super.didLoad()
        
        createButtonNode.cornerRadius = 4
        createButtonNode.cornerRoundingType = .defaultSlowCALayer
        createButtonNode.setBackgroundImage(UIImage(color: Colors.Brand_80), for: .highlighted)
        createButtonNode.addTarget(self, action: #selector(createButtonClicked), forControlEvents: .touchUpInside)
    }
    
    @objc private func createButtonClicked() {
        createButtonHandler?()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        titleNode.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 23)
        titleNode.style.layoutPosition = CGPoint(x: 0, y: 184)
        
        descNode.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 18)
        descNode.style.layoutPosition = CGPoint(x: 0, y: 217)
        
        createButtonNode.style.preferredSize = CGSize(width: constrainedSize.max.width - 40, height: 47)
        createButtonNode.style.spacingBefore = 20
        createButtonNode.style.layoutPosition = CGPoint(x: 20, y: (constrainedSize.max.height - 47)/2.0)
        
        return ASAbsoluteLayoutSpec(children: [titleNode, descNode, createButtonNode])
    }
    
}
