//
//  MainSearchGuideNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/19.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class MainSearchGuideNode: ASDisplayNode {
    
    private let descNode = ASTextNode()
    
    private var elements: [ASButtonNode] = []
    
    override init() {
        super.init()
        
        automaticallyManagesSubnodes = true
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        descNode.attributedText = NSAttributedString(string: "", attributes: [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor(hexString: "#B1B1B1"),
            .paragraphStyle: paragraphStyle
            ])
        
        for guide in SearchGuide.allCases {
            let attributedText = NSAttributedString(string: guide.title, attributes: [
                .font: UIFont.systemFont(ofSize: 17),
                .foregroundColor: Colors.DEFAULT_LINK_COLOR
                ])
            
            let button = ASButtonNode()
            button.setAttributedTitle(attributedText, for: .normal)
            elements.append(button)
        }
    }
    
    override func didLoad() {
        super.didLoad()
        
        elements.forEach { $0.addTarget(self, action: #selector(handleButtonClicked(_:)), forControlEvents: .touchUpInside) }
    }
    
    @objc private func handleButtonClicked(_ sender: ASButtonNode) {
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        descNode.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 18)
        descNode.style.layoutPosition = CGPoint(x: 0, y: 37)
        
        var children: [ASLayoutElement] = [descNode]
        let padding: CGFloat = 42
        let itemWidth = (constrainedSize.max.width - padding * 2.0)/3.0
        let itemHeight: CGFloat = 21
        let top: CGFloat = 88.0
        for (index, element) in elements.enumerated() {
            let row = CGFloat(index % 3)
            let col = CGFloat(index / 3)
            element.style.preferredSize = CGSize(width: itemWidth, height: itemHeight)
            element.style.layoutPosition = CGPoint(x: padding + itemWidth * col , y: top + row * itemHeight)
            children.append(element)
            if col != 0 {
                let line = ASDisplayNode()
                line.backgroundColor = UIColor(hexString: "#DADADA")
                line.style.preferredSize = CGSize(width: Constants.lineHeight, height: itemHeight)
                line.style.layoutPosition = CGPoint(x: padding + itemWidth * col , y: top + row * itemHeight)
                children.append(line)
            }
        }
        
        return ASAbsoluteLayoutSpec(children: children)
    }
    
}

enum SearchGuide: CaseIterable {
    case moments
    case article
    case brand
    case miniProgram
    case music
    case emoticon
    
    var title: String {
        switch self {
        case .moments:
            return "朋友圈"
        case .article:
            return "文字"
        case .brand:
            return "公众号"
        case .miniProgram:
            return "小程序"
        case .music:
            return "音乐"
        case .emoticon:
            return "表情"
        }
    }
}
