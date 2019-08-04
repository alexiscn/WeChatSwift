//
//  ScrollActionSheet.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/8/3.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit


class ScrollActionSheet: ASDisplayNode {
    
    private let titleNode = ASTextNode()
    
    private let cancelButton = ASButtonNode()
    
    private let containerNode = ASDisplayNode()
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        
        
        return ASLayoutSpec()
    }
    
}

struct ScrollActionSheetItem {
    enum Action {
        case floating
        case report
        case copyLink
        case refresh
        case adjustFont
    }
    
}
