//
//  BrandTimelineCellNode.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/8/11.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class BrandTimelineCellNode: ASCellNode {
    
    private let timeline: BrandTimelineModel
    private let isLastCell: Bool
    
    private let titleNode = ASTextNode()
    
    private let thumbNode = ASNetworkImageNode()
    
    init(timeline: BrandTimelineModel, isLastCell: Bool) {
        self.timeline = timeline
        self.isLastCell = isLastCell
        super.init()
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASLayoutSpec()
    }
    
}


struct BrandTimelineGroup {
    
    var items: [BrandTimelineModel]
    
    func attributedStringForName() -> NSAttributedString {
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17),
            NSAttributedString.Key.foregroundColor: Colors.DEFAULT_LINK_COLOR
        ]
        return NSAttributedString(string: "", attributes: attributes)
    }
    
    func attributedStringForTime() -> NSAttributedString {
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor: UIColor(white: 0, alpha: 0.2)
        ]
        return NSAttributedString(string: "1 Day Ago", attributes: attributes)
    }
}

struct BrandTimelineModel {
    
    
    func attributedStringForTitle() -> NSAttributedString {
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17),
            NSAttributedString.Key.foregroundColor: Colors.black
        ]
        return NSAttributedString(string: "", attributes: attributes)
    }
    
}
