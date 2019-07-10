//
//  MomentCellNode.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/7/10.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class MomentCellNode: ASCellNode {
    
    private let moment: Moment
    
    private let avatarNode: ASImageNode
    
    private let nameNode: ASButtonNode
    
    private var textNode: ASTextNode?
    
    private var contentNode: MomentContentNode?
    
    private let timeNode: ASTextNode
    
    private var sourceNode: ASButtonNode?
    
    private let moreNode: ASButtonNode
    
    private var commentNode: ASDisplayNode?
    
    private let bottomSeparator: ASDisplayNode
    
    init(moment: Moment) {
        self.moment = moment
        
        avatarNode = ASImageNode()
        avatarNode.contentMode = .scaleAspectFill
        avatarNode.style.preferredSize = CGSize(width: 40, height: 40)
        avatarNode.cornerRoundingType = .clipping
        avatarNode.cornerRadius = 5
        avatarNode.backgroundColor = Colors.backgroundColor
        
        nameNode = ASButtonNode()
        nameNode.contentHorizontalAlignment = .left
        
        textNode = ASTextNode()
        
        switch moment.body {
        case .media(_):
            contentNode = ImageContentNode(moment: moment)
        default:
            break
        }
        
        timeNode = ASTextNode()
        
        moreNode = ASButtonNode()
        moreNode.setImage(UIImage.as_imageNamed("AlbumOperateMore_32x20_"), for: .normal)
        moreNode.setImage(UIImage.as_imageNamed("AlbumOperateMoreHL_32x20_"), for: .highlighted)
        moreNode.style.preferredSize = CGSize(width: 32, height: 20)
        
        bottomSeparator = ASDisplayNode()
        bottomSeparator.backgroundColor = Colors.DEFAULT_BORDER_COLOR
        bottomSeparator.style.preferredLayoutSize = ASLayoutSize(width: ASDimensionMake("100%"), height: ASDimensionMake(LINE_HEIGHT))
        
        super.init()
        
        automaticallyManagesSubnodes = true
        
        let user = MockFactory.shared.users.first(where: { $0.identifier == moment.userID })
        let avatar = user?.avatar ?? "DefaultHead_48x48_"
        avatarNode.image = UIImage.as_imageNamed(avatar)
        
        let name = user?.name ?? ""
        nameNode.setAttributedTitle(moment.attributedStringForUsername(with: name), for: .normal)
        timeNode.attributedText = moment.timeAttributedText()
        textNode?.attributedText = moment.contentAttributedText()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        avatarNode.style.spacingBefore = 12
        nameNode.style.flexShrink = 1.0
        bottomSeparator.style.flexGrow = 1.0
        textNode?.style.flexGrow = 1.0
        
        let rightStack = ASStackLayoutSpec.vertical()
        rightStack.spacing = 6
        rightStack.style.flexShrink = 1.0
        rightStack.style.flexGrow = 1.0
        rightStack.style.spacingAfter = 12
        rightStack.style.spacingBefore = 12
        rightStack.children = [nameNode]
        
        if let textNode = textNode {
            rightStack.children?.append(textNode)
        }
        
        if let node  = contentNode {
            node.style.flexGrow = 0.5
            rightStack.children?.append(node)
        }
        
        let footerStack = ASStackLayoutSpec.horizontal()
        let footerSpacer = ASLayoutSpec()
        footerSpacer.style.flexGrow = 1.0
        var footerElements: [ASLayoutElement] = []
        footerElements.append(timeNode)
        if let node = sourceNode {
            footerElements.append(node)
        }
        footerElements.append(footerSpacer)
        footerElements.append(moreNode)
        footerStack.children = footerElements
        rightStack.children?.append(footerStack)
        
        let layoutSpec = ASStackLayoutSpec.horizontal()
        layoutSpec.justifyContent = .start
        layoutSpec.alignItems = .start
        layoutSpec.children = [avatarNode, rightStack]
        
        let topSpacer = ASLayoutSpec()
        topSpacer.style.preferredLayoutSize = ASLayoutSize(width: ASDimensionMake("100%"), height: ASDimensionMake(1))
        
        let verticalSpec = ASStackLayoutSpec.vertical()
        verticalSpec.spacing = 10
        verticalSpec.children = [topSpacer, layoutSpec, bottomSeparator]
        
        return ASInsetLayoutSpec(insets: .zero, child: verticalSpec)
    }
}

// MARK: - MomentContentNode
extension MomentCellNode {
    
    class MomentContentNode: ASDisplayNode {
        let moment: Moment
        init(moment: Moment) {
            self.moment = moment
            super.init()
        }
    }
    
}

// MARK: - WebpageContentNode
extension MomentCellNode {
    
    class WebpageContentNode: MomentContentNode {
    
        private let imageNode: ASNetworkImageNode = ASNetworkImageNode()
        
        private let textNode: ASTextNode = ASTextNode()
        
        override init(moment: Moment) {
            super.init(moment: moment)
            
            addSubnode(imageNode)
            addSubnode(textNode)
            
            imageNode.style.preferredSize = CGSize(width: 45, height: 45)
            
            backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
            
        }
        
        override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
            
            textNode.style.flexGrow = 1.0
            textNode.style.flexShrink = 1.0
            
            let stack = ASStackLayoutSpec.horizontal()
            stack.alignItems = .center
            stack.spacing = 4.0
            stack.children = [imageNode, textNode]
            
            return ASInsetLayoutSpec(insets: .zero, child: stack)
        }
        
    }
}

// MARK: - ImageContentNode
extension MomentCellNode {
    
    class ImageContentNode: MomentContentNode {
        
        private let imageNode: ASNetworkImageNode = ASNetworkImageNode()
        
        private var ratio: CGFloat = 1.0
        
        override init(moment: Moment) {
            super.init(moment: moment)
            
            switch moment.body {
            case .media(let media):
                imageNode.url = media.url
                ratio = media.size.height / media.size.width
            default:
                break
            }
            
            imageNode.contentMode = .scaleToFill
            imageNode.clipsToBounds = true
            imageNode.shouldCacheImage = false
            addSubnode(imageNode)
        }
        
        override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
            let width = constrainedSize.max.width * 0.75
            
            let ratiopSpec = ASRatioLayoutSpec(ratio: ratio, child: imageNode)
            ratiopSpec.style.maxSize = CGSize(width: width, height: width)
            
            let layout = ASStackLayoutSpec.horizontal()
            layout.style.flexGrow = 1.0
            layout.children = [ratiopSpec]
            return layout
        }
    }
}

// MARK: - MultiImageContentNode
extension MomentCellNode {
    
    class MultiImageContentNode: MomentContentNode {
        override init(moment: Moment) {
            super.init(moment: moment)
        }
        
        override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
            return ASLayoutSpec()
        }
    }
}
