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
    
    private let avatarNode: ASNetworkImageNode
    
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
        
        avatarNode = ASNetworkImageNode()
        avatarNode.contentMode = .scaleAspectFill
        avatarNode.style.preferredSize = CGSize(width: 40, height: 40)
        avatarNode.cornerRoundingType = .precomposited
        avatarNode.cornerRadius = 5
        
        let highlightBackgroundImage = UIImage.as_resizableRoundedImage(withCornerRadius: 0, cornerColor: nil, fill: UIColor(hexString: "#C6C8C6"))
        nameNode = ASButtonNode()
        nameNode.isUserInteractionEnabled = true
        nameNode.setBackgroundImage(highlightBackgroundImage, for: .highlighted)
        nameNode.contentHorizontalAlignment = .left
        
        textNode = ASTextNode()
        
        switch moment.body {
        case .media(let image):
            contentNode = MomentImageContentNode(image: image)
        case .link(let webPage):
            contentNode = MomentWebpageContentNode(webPage: webPage)
        case .multi(let multiImage):
            contentNode = MomentMultiImageContentNode(multiImage: multiImage)
        default:
            break
        }
        
        timeNode = ASTextNode()
        
        moreNode = ASButtonNode()
        moreNode.setImage(UIImage.as_imageNamed("AlbumOperateMore_32x20_"), for: .normal)
        moreNode.setImage(UIImage.as_imageNamed("AlbumOperateMoreHL_32x20_"), for: .highlighted)
        moreNode.contentEdgeInsets = UIEdgeInsets(top: 4, left: 6, bottom: 4, right: 6)
        moreNode.style.preferredSize = CGSize(width: 44, height: 28)
        
        if moment.likes.count > 0 || moment.comments.count > 0 {
            commentNode = MomentCommentNode(moment: moment)
            commentNode?.isUserInteractionEnabled = true
        }
        
        bottomSeparator = ASImageNode()
        bottomSeparator.image = UIImage.as_imageNamed("PhotographerSeparator_320x2_")
        bottomSeparator.style.preferredLayoutSize = ASLayoutSize(width: ASDimensionMake("100%"), height: ASDimensionMake(1))
        
        super.init()
        
        automaticallyManagesSubnodes = true
        backgroundColor = .white
        isUserInteractionEnabled = true
        
        contentNode?.isUserInteractionEnabled = true
        contentNode?.cellNode = self
        
        commentNode?.delegate = self
        
        let user = MockFactory.shared.user(with: moment.userID)
        avatarNode.defaultImage = UIImage.as_imageNamed("DefaultHead_48x48_")
        avatarNode.url = user?.avatar
        
        let name = user?.name ?? ""
        nameNode.setAttributedTitle(moment.attributedStringForUsername(with: name), for: .normal)
        timeNode.attributedText = moment.timeAttributedText()
        textNode?.attributedText = moment.contentAttributedText()
    }
    
    override func didLoad() {
        super.didLoad()
        
        nameNode.addTarget(self, action: #selector(handleNameButtonClicked), forControlEvents: .touchUpInside)
        moreNode.addTarget(self, action: #selector(handleMoreButtonClicked(_:)), forControlEvents: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    func addLike() {
        if commentNode == nil {
            commentNode = MomentCommentNode(moment: moment)
            commentNode?.delegate = self
            setNeedsLayout()
        } else {
            commentNode?.updateLikes()
        }
    }
    
    func deleteLike() {
        commentNode?.updateLikes()
    }
    
    func addComment(_ comment: MomentComment) {
        if commentNode == nil {
            commentNode = MomentCommentNode(moment: moment)
            commentNode?.delegate = self
            setNeedsLayout()
        } else {
            commentNode?.addComment(comment)
        }
    }
    
    func deleteComment(_ comment: MomentComment) {
        commentNode?.deleteComment(comment)
    }
    
    @objc private func handleNameButtonClicked() {
        delegate?.momentCellNode(self, didPressedUser: moment.userID)
    }
    
    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: self.view)
        if avatarNode.frame.contains(point) {
            delegate?.momentCellNode(self, didPressedUser: moment.userID)
        }
        // Passthrough tap gesture to content node
        if let contentNode = contentNode, contentNode.frame.contains(point) {
            contentNode.handleTapGesture(gesture)
        }
        // Passthrough tap gesture to comment node
        if let commentNode = commentNode, commentNode.frame.contains(point) {
            commentNode.handleTapGesture(gesture)
        }
    }
    
    @objc private func handleMoreButtonClicked(_ sender: ASButtonNode) {
        delegate?.momentCellNode(self, didPressedMoreButton: sender, moment: moment)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        avatarNode.style.spacingBefore = 12
        bottomSeparator.style.flexGrow = 1.0
        textNode?.style.flexGrow = 1.0
        
        let nameStack = ASStackLayoutSpec.horizontal()
        nameStack.children = [nameNode]
        
        let rightStack = ASStackLayoutSpec.vertical()
        rightStack.spacing = 5
        rightStack.style.flexShrink = 1.0
        rightStack.style.flexGrow = 1.0
        rightStack.style.spacingAfter = 12
        rightStack.style.spacingBefore = 12
        rightStack.children = [nameStack]
        
        if let textNode = textNode {
            rightStack.children?.append(textNode)
        }
        
        if let node  = contentNode {
            node.style.flexGrow = 0.5
            rightStack.children?.append(node)
        }
        
        let footerStack = ASStackLayoutSpec.horizontal()
        footerStack.alignItems = .center
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
        topSpacer.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 11)
        
        let bottomSpacer = ASLayoutSpec()
        bottomSpacer.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 16)
        
        let verticalSpec = ASStackLayoutSpec.vertical()
        verticalSpec.children = [topSpacer, layoutSpec, bottomSpacer, bottomSeparator]
        
        return ASInsetLayoutSpec(insets: .zero, child: verticalSpec)
    }
}

// MARK: - MomentCommentNodeDelegate
extension MomentCellNode: MomentCommentNodeDelegate {
    
    func momentComment(_ commentNode: MomentCommentNode, tappedLink url: URL?) {
        guard let url = url else { return }
        
        if url.absoluteString.starts(with: "wechat://WC/") {
            let uid = url.absoluteString.replacingOccurrences(of: "wechat://WC/", with: "")
            delegate?.momentCellNode(self, didPressedUser: uid)
        }
    }
    
    func momentComment(_ commentNode: MomentCommentNode, didTapComment comment: MomentComment) {
        
    }
}

protocol MomentCellNodeDelegate: class {
    
    func momentCellNode(_ cellNode: MomentCellNode, didPressedMoreButton moreButton: ASButtonNode, moment: Moment)
    
    func momentCellNode(_ cellNode: MomentCellNode, didPressedUser userID: String)
    
    func momentCellNode(_ cellNode: MomentCellNode, didTapImage image: MomentMedia, thumbImage: UIImage?, tappedView: UIView?)
    
    func momentCellNode(_ cellNode: MomentCellNode, didTapImage index: Int, mulitImage: MomentMultiImage, thumbs: [UIImage?], tappedView: UIView?)
    
    func momentCellNode(_ cellNode: MomentCellNode, didTapWebPage webpage: MomentWebpage)
}
