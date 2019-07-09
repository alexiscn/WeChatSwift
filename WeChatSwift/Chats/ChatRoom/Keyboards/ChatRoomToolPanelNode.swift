//
//  ChatRoomToolPanelNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit
import UIKit

class ChatRoomToolPanelNode: ASDisplayNode, ASPagerDelegate, ASPagerDataSource {
 
    var pagerNode: ASPagerNode = ASPagerNode()
    
    var pageControl: UIPageControl = {
        let page = UIPageControl()
        return page
    }()
    
    private let dataSource: [ChatRoomTool]
    
    init(tools: [ChatRoomTool]) {
        self.dataSource = tools
        
        super.init()
        
        addSubnode(pagerNode)
        pagerNode.setDelegate(self)
        pagerNode.setDataSource(self)
    }
    
    override func didLoad() {
        super.didLoad()
    }
    
    func numberOfPages(in pagerNode: ASPagerNode) -> Int {
        return dataSource.count / 6
    }
    
    func pagerNode(_ pagerNode: ASPagerNode, nodeBlockAt index: Int) -> ASCellNodeBlock {
        let tool = dataSource[index]
        let block: ASCellNodeBlock = {
            return ChatRoomToolNode(tool: tool)
        }
        return block
    }
}

class ChatRoomToolNode: ASCellNode {
    
    private let backgroundNode: ASImageNode
    
    private let iconNode: ASImageNode
    
    private let textNode: ASTextNode
    
    init(tool: ChatRoomTool) {
        backgroundNode = ASImageNode()
        backgroundNode.image = UIImage.as_imageNamed("ChatRomm_ToolPanel_Icon_Buttons_64x64_")
        backgroundNode.style.preferredSize = CGSize(width: 64, height: 64)
        
        iconNode = ASImageNode()
        iconNode.image = UIImage.as_imageNamed(tool.imageName)
        
        textNode = ASTextNode()
        textNode.style.alignSelf = .center
        textNode.attributedText = NSAttributedString(string: tool.title, attributes: [
            .foregroundColor: Colors.DEFAULT_TEXT_GRAY_COLOR,
            .font: UIFont.systemFont(ofSize: 13)
        ])
        
        super.init()
        
        addSubnode(backgroundNode)
        addSubnode(iconNode)
        addSubnode(textNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let imageSpec = ASInsetLayoutSpec(insets: .zero, child: iconNode)
        let backgroundSpec = ASBackgroundLayoutSpec(child: imageSpec, background: backgroundNode)
        
        let stack = ASStackLayoutSpec.vertical()
        stack.children = [backgroundSpec, textNode]
        return stack
    }
}
