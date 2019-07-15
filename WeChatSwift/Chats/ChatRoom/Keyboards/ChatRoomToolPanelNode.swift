//
//  ChatRoomToolPanelNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit
import UIKit

protocol ChatRoomToolPanelNodeDelegate {
    func toolPanelDidPressedTool(_ tool: ChatRoomTool)
}

class ChatRoomToolPanelNode: ASDisplayNode, ASCollectionDataSource, ASCollectionDelegate {
 
    var delegate: ChatRoomToolPanelNodeDelegate?
    
    private let collectionNode: ASCollectionNode
    
    private let pageContainerNode: ASDisplayNode
    
    var pageControl: UIPageControl = {
        let page = UIPageControl()
        page.pageIndicatorTintColor = UIColor(hexString: "#E1E2E6")
        page.currentPageIndicatorTintColor = UIColor(hexString: "#8E8E8E")
        return page
    }()
    
    private let dataSource: [ChatRoomTool]
    
    init(tools: [ChatRoomTool]) {
        self.dataSource = tools
        
        let itemWidth = (Constants.screenWidth - 20.0)/4
        let itemHeight: CGFloat = (236 - 36 - 6)/2.0
        
        let layoutInfo = GridPageLayoutInfo(itemsCount: tools.count, itemSize: CGSize(width: itemWidth, height: itemHeight))
        layoutInfo.update(viewportSize: CGSize(width: Constants.screenWidth, height: 200))
        layoutInfo.minimumLineSpacing = 0
        layoutInfo.minimumInteritemSpacing = 0
        let layoutDelegate = GridPageLayoutDelegate(layoutInfo: layoutInfo)
        
        collectionNode = ASCollectionNode(layoutDelegate: layoutDelegate, layoutFacilitator: nil)
        
        pageContainerNode = ASDisplayNode()
        
        super.init()
        
        addSubnode(collectionNode)
        addSubnode(pageContainerNode)
        collectionNode.dataSource = self
        collectionNode.delegate = self
        
        pageControl.numberOfPages = layoutInfo.numberOfPages
    }
    
    override func didLoad() {
        super.didLoad()
        
        collectionNode.backgroundColor = .clear
        collectionNode.view.isPagingEnabled = true
        collectionNode.view.showsHorizontalScrollIndicator = false
        collectionNode.view.showsVerticalScrollIndicator = false
        collectionNode.style.preferredSize = CGSize(width: bounds.width, height: bounds.height - 36)
        
        pageContainerNode.view.addSubview(pageControl)
        
        pageControl.frame = CGRect(x: 0, y: 0, width: Constants.screenWidth, height: 36)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        pageContainerNode.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 36)
        let stack = ASStackLayoutSpec.vertical()
        stack.children = [collectionNode, pageContainerNode]
        return ASInsetLayoutSpec(insets: .zero, child: stack)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = bounds.width
        var page =  Int(floorf(Float((scrollView.contentOffset.x - pageWidth/2)/pageWidth)) + 1)
        page = min(pageControl.numberOfPages, page)
        pageControl.currentPage = page
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
            let node = ChatRoomToolCellNode(tool: tool)
            node.tapHandler = { [weak self] in
                self?.delegate?.toolPanelDidPressedTool(tool)
            }
            return node
        }
        return block
    }
}

class ChatRoomToolCellNode: ASCellNode {
    
    var tapHandler: RelayCommand?
    
    private let buttonNode: ASButtonNode
    
    private let textNode: ASTextNode
    
    init(tool: ChatRoomTool) {
        buttonNode = ASButtonNode()
        buttonNode.isUserInteractionEnabled = true
        buttonNode.setBackgroundImage(UIImage.as_imageNamed("ChatRomm_ToolPanel_Icon_Buttons_64x64_"), for: .normal)
        buttonNode.setBackgroundImage(UIImage.as_imageNamed("ChatRomm_ToolPanel_Icon_Buttons_HL_64x64_"), for: .highlighted)
        buttonNode.setImage(UIImage.as_imageNamed(tool.imageName), for: .normal)
        buttonNode.style.preferredSize = CGSize(width: 64, height: 64)
        buttonNode.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor(white: 75.0/255, alpha: 1.0))
        
        textNode = ASTextNode()
        textNode.style.alignSelf = .center
        textNode.attributedText = NSAttributedString(string: tool.title, attributes: [
            .foregroundColor: Colors.DEFAULT_TEXT_GRAY_COLOR,
            .font: UIFont.systemFont(ofSize: 12)
        ])
        
        super.init()
        
        addSubnode(buttonNode)
        addSubnode(textNode)
    }
    
    override func didLoad() {
        super.didLoad()
        
        buttonNode.addTarget(self, action: #selector(buttonClicked), forControlEvents: .touchUpInside)
    }
    
    @objc private func buttonClicked() {
        tapHandler?()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let stack = ASStackLayoutSpec.vertical()
        stack.spacing = 6.0
        stack.alignItems = .center
        stack.children = [buttonNode, textNode]
        
        let spacingX = (constrainedSize.max.width - 84)/2.0
        let spacingY = (constrainedSize.max.height - 84)/2.0
        let insets = UIEdgeInsets(top: spacingY, left: spacingX, bottom: spacingY, right: spacingX)
        
        return ASInsetLayoutSpec(insets: insets, child: stack)
    }
}
