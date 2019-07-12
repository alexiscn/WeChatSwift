//
//  ChatRoomToolPanelNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit
import UIKit

class ChatRoomToolPanelNode: ASDisplayNode, ASCollectionDataSource, ASCollectionDelegate {
 
    private let collectionNode: ASCollectionNode
    
    var pageControl: UIPageControl = {
        let page = UIPageControl()
        return page
    }()
    
    private let dataSource: [ChatRoomTool]
    
    init(tools: [ChatRoomTool]) {
        self.dataSource = tools
        
        let itemWidth = (Constants.screenWidth - 20.0)/4
        let itemHeight: CGFloat = (216 - 20)/2.0
        
        let layoutInfo = GridPageLayoutInfo(itemsCount: tools.count, itemSize: CGSize(width: itemWidth, height: itemHeight))
        layoutInfo.minimumLineSpacing = 3
        layoutInfo.minimumInteritemSpacing = 3
        let layoutDelegate = GridPageLayoutDelegate(layoutInfo: layoutInfo)
        
        collectionNode = ASCollectionNode(layoutDelegate: layoutDelegate, layoutFacilitator: nil)
        
        super.init()
        
        addSubnode(collectionNode)
        collectionNode.dataSource = self
        collectionNode.delegate = self
    }
    
    override func didLoad() {
        super.didLoad()
        
        collectionNode.backgroundColor = UIColor(hexString: "#F5F5F7")
        collectionNode.view.isPagingEnabled = true
        collectionNode.view.showsHorizontalScrollIndicator = false
        collectionNode.view.showsVerticalScrollIndicator = false
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: .zero, child: collectionNode)
    }
    
    // MARK: - ASCollectionDataSource
    
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    // MARK: - ASCollectionDelegate
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let tool = dataSource[indexPath.row]
        let block: ASCellNodeBlock = {
            return ChatRoomToolCellNode(tool: tool)
        }
        return block
    }
}

class ChatRoomToolCellNode: ASCellNode {
    
    private let backgroundNode: ASImageNode
    
    private let iconNode: ASImageNode
    
    private let textNode: ASTextNode
    
    init(tool: ChatRoomTool) {
        backgroundNode = ASImageNode()
        backgroundNode.image = UIImage.as_imageNamed("ChatRomm_ToolPanel_Icon_Buttons_64x64_")
        backgroundNode.style.preferredSize = CGSize(width: 64, height: 64)
        
        iconNode = ASImageNode()
        iconNode.style.preferredSize = CGSize(width: 64, height: 64)
        iconNode.image = UIImage.as_imageNamed(tool.imageName)
        iconNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor(white: 75.0/255, alpha: 1.0))
        
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
        stack.spacing = 5.0
        stack.children = [backgroundSpec, textNode]
        
        let spacingX = (constrainedSize.max.width - 64)/2.0
        let spacingY = (constrainedSize.max.height - 64)/2.0
        let insets = UIEdgeInsets(top: spacingY, left: spacingX, bottom: spacingY, right: spacingX)
        
        return ASInsetLayoutSpec(insets: insets, child: stack)
    }
}
