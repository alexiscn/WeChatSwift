//
//  MomentCellNode.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/7/10.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class MomentCellNode: ASCellNode {
    
    weak var delegate: MomentCellNodeDelegate?
    
    private let moment: Moment
    
    private let avatarNode: ASImageNode
    
    private let nameNode: ASButtonNode
    
    private var textNode: ASTextNode?
    
    private var contentNode: MomentContentNode?
    
    private let timeNode: ASTextNode
    
    private var sourceNode: ASButtonNode?
    
    private let moreNode: ASButtonNode
    
    private var commentNode: MomentCommentNode?
    
    private let bottomSeparator: ASImageNode
    
    init(moment: Moment) {
        self.moment = moment
        
        avatarNode = ASImageNode()
        avatarNode.contentMode = .scaleAspectFill
        avatarNode.style.preferredSize = CGSize(width: 40, height: 40)
        avatarNode.cornerRoundingType = .precomposited
        avatarNode.cornerRadius = 5
        
        nameNode = ASButtonNode()
        nameNode.contentHorizontalAlignment = .left
        
        textNode = ASTextNode()
        
        switch moment.body {
        case .media(let image):
            contentNode = ImageContentNode(image: image)
        case .link(let webPage):
            contentNode = WebpageContentNode(webPage: webPage)
        case .multi(let multiImage):
            contentNode = MultiImageContentNode(multiImage: multiImage)
        default:
            break
        }
        
        timeNode = ASTextNode()
        
        moreNode = ASButtonNode()
        moreNode.setImage(UIImage.as_imageNamed("AlbumOperateMore_32x20_"), for: .normal)
        moreNode.setImage(UIImage.as_imageNamed("AlbumOperateMoreHL_32x20_"), for: .highlighted)
        moreNode.style.preferredSize = CGSize(width: 32, height: 20)
        
        if moment.comments.count > 0 {
            commentNode = MomentCommentNode(likes: [], comments: moment.comments)
        }
        
        bottomSeparator = ASImageNode()
        bottomSeparator.image = UIImage.as_imageNamed("PhotographerSeparator_320x2_")
        bottomSeparator.style.preferredLayoutSize = ASLayoutSize(width: ASDimensionMake("100%"), height: ASDimensionMake(1))
        
        super.init()
        
        automaticallyManagesSubnodes = true
        backgroundColor = .white
        
        let user = MockFactory.shared.users.first(where: { $0.identifier == moment.userID })
        let avatar = user?.avatar ?? "DefaultHead_48x48_"
        avatarNode.image = UIImage.as_imageNamed(avatar)
        
        let name = user?.name ?? ""
        nameNode.setAttributedTitle(moment.attributedStringForUsername(with: name), for: .normal)
        timeNode.attributedText = moment.timeAttributedText()
        textNode?.attributedText = moment.contentAttributedText()
    }
    
    override func didLoad() {
        super.didLoad()
        
        moreNode.addTarget(self, action: #selector(handleMoreButtonClicked(_:)), forControlEvents: .touchUpInside)
    }
    
    @objc private func handleMoreButtonClicked(_ sender: ASButtonNode) {
        delegate?.momentCellNode(self, didPressedMoreButton: sender, moment: moment)
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
        
        if let commentNode = commentNode {
            rightStack.children?.append(commentNode)
        }
        
        let layoutSpec = ASStackLayoutSpec.horizontal()
        layoutSpec.justifyContent = .start
        layoutSpec.alignItems = .start
        layoutSpec.children = [avatarNode, rightStack]
        
        let topSpacer = ASLayoutSpec()
        topSpacer.style.preferredLayoutSize = ASLayoutSize(width: ASDimensionMake("100%"), height: ASDimensionMake(1))
        
        let bottomSpacer = ASLayoutSpec()
        bottomSpacer.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 6)
        
        let verticalSpec = ASStackLayoutSpec.vertical()
        verticalSpec.spacing = 10
        verticalSpec.children = [topSpacer, layoutSpec, bottomSpacer, bottomSeparator]
        
        return ASInsetLayoutSpec(insets: .zero, child: verticalSpec)
    }
}

protocol MomentCellNodeDelegate: class {
    
    func momentCellNode(_ cellNode: MomentCellNode, didPressedMoreButton moreButton: ASButtonNode, moment: Moment)
    
}
