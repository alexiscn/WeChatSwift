//
//  StorageUsageSummaryNode.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/16.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class StorageUsageSummaryNode: ASDisplayNode {
    
    private let percentNode: StorageUsageSummaryPercentNode
    
    private let titleNode = ASTextNode()
    
    private let fileSizeNode = ASTextNode()
    
    private let descNode = ASTextNode()
    
    init(summary: StorageUsageSummary) {
        
        percentNode = StorageUsageSummaryPercentNode(summary: summary)
        
        super.init()
        
        automaticallyManagesSubnodes = true
        
        titleNode.attributedText = NSAttributedString(string: summary.title, attributes: [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: Colors.black
            ])
        
        fileSizeNode.attributedText = NSAttributedString(string: "158M", attributes: [
            .font: UIFont.systemFont(ofSize: 40, weight: .medium),
            .foregroundColor: Colors.black
            ])
        
        descNode.attributedText = NSAttributedString(string: summary.desc, attributes: [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor(hexString: "#7F7F7F")
            ])
    }
    
    override func didLoad() {
        super.didLoad()
        backgroundColor = .white
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        percentNode.style.preferredSize = CGSize(width: constrainedSize.max.width - 48, height: 44.0)
        percentNode.style.layoutPosition = CGPoint(x: 24, y: 24)
        
        titleNode.style.preferredSize = CGSize(width: constrainedSize.max.width - 48, height: 17)
        titleNode.style.layoutPosition = CGPoint(x: 24, y: 100)
        
        fileSizeNode.style.preferredSize = CGSize(width: constrainedSize.max.width - 48, height: 48)
        fileSizeNode.style.layoutPosition = CGPoint(x: 24, y: 125)
        
        descNode.style.preferredSize = CGSize(width: constrainedSize.max.width - 48, height: 17)
        descNode.style.layoutPosition = CGPoint(x: 24, y: 181)
        
        return ASAbsoluteLayoutSpec(children: [percentNode, titleNode, fileSizeNode, descNode])
    }
    
}

class StorageUsageSummaryPercentNode: ASDisplayNode {
    
    private let weChatUsageNode = ASDisplayNode()
    
    private let phoneUsageNode = ASDisplayNode()
    
    private let remainUsageNode = ASDisplayNode()
    
    private let weChatDescNode: StorageUsageSummaryPercentDescNode
    
    private let phoneDescNode: StorageUsageSummaryPercentDescNode
    
    private let remainDescNode: StorageUsageSummaryPercentDescNode
    
    private let summary: StorageUsageSummary
    
    init(summary: StorageUsageSummary) {
        
        self.summary = summary
        
        weChatDescNode = StorageUsageSummaryPercentDescNode(summary: .wechat)
        phoneDescNode = StorageUsageSummaryPercentDescNode(summary: .phone)
        remainDescNode = StorageUsageSummaryPercentDescNode(summary: .remain)
        
        weChatUsageNode.backgroundColor = StorageUsageSummaryType.wechat.color
        phoneUsageNode.backgroundColor = StorageUsageSummaryType.phone.color
        remainUsageNode.backgroundColor = StorageUsageSummaryType.remain.color
        
        super.init()
        
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let width = constrainedSize.max.width
        
        weChatUsageNode.style.preferredSize = CGSize(width: width * summary.wechatPercent, height: 16)
        weChatUsageNode.style.layoutPosition = CGPoint(x: 0, y: 0)
        
        phoneUsageNode.style.preferredSize = CGSize(width: width * summary.phonePercent, height: 16)
        phoneUsageNode.style.layoutPosition = CGPoint(x: width * summary.wechatPercent, y: 0)
        
        remainUsageNode.style.preferredSize = CGSize(width: width * summary.remainPercent, height: 16)
        remainUsageNode.style.layoutPosition = CGPoint(x: width * (1 - summary.remainPercent), y: 0)
        
        let stack = ASStackLayoutSpec.horizontal()
        stack.style.preferredSize = CGSize(width: width, height: 17)
        stack.style.layoutPosition = CGPoint(x: 0, y: 27)
        stack.justifyContent = .spaceBetween
        stack.children = [weChatDescNode, phoneDescNode, remainDescNode]
        
        return ASAbsoluteLayoutSpec(children: [weChatUsageNode, phoneUsageNode, remainUsageNode, stack])
    }
    
}

class StorageUsageSummaryPercentDescNode: ASDisplayNode {

    let colorNode = ASDisplayNode()
    
    let titleNode = ASTextNode()
    
    init(summary: StorageUsageSummaryType) {
        super.init()
        
        automaticallyManagesSubnodes = true
        colorNode.backgroundColor = summary.color
        titleNode.attributedText = NSAttributedString(string: summary.title, attributes: [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor(hexString: "#7F7F7F")
        ])
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        colorNode.style.preferredSize = CGSize(width: 8, height: 8)
        
        let stack = ASStackLayoutSpec.horizontal()
        stack.spacing = 4
        stack.alignItems = .center
        stack.children = [colorNode, titleNode]
        return stack
    }
    
}

