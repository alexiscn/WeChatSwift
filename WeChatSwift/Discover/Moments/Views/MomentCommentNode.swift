//
//  MomentCommentNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/17.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class MomentCommentNode: ASDisplayNode {
    
    weak var delegate: MomentCommentNodeDelegate?
    
    private let triangleNode = ASImageNode()
    
    private let containerNode = ASDisplayNode()
    
    private var likeNode: ASTextNode?
    
    private var lineNode: MomentCommentLineNode?
    
    private var commentElements: [ASTextNode] = []
    
    private let kLinkAttributeName = "kLinkAttributeNamekLinkAttributeName"
    
    private let nameFont = UIFont.systemFont(ofSize: 15, weight: .semibold)
    private let textColor = UIColor(hexString: "#111111")
    private let textFont = UIFont.systemFont(ofSize: 15)
    
    private let moment: Moment
    
    init(moment: Moment) {
        self.moment = moment
        triangleNode.image = UIImage.as_imageNamed("AlbumTriangleB_45x6_")
        triangleNode.style.preferredSize = CGSize(width: 45, height: 6)
        containerNode.backgroundColor = UIColor(hexString: "#F3F3F5")
        super.init()
        automaticallyManagesSubnodes = true
        likeNode = likesTextNode(with: moment.likes)
        for comment in moment.comments {
            let node = commentTextNode(with: comment)
            commentElements.append(node)
        }
        if moment.likes.count > 0 && moment.comments.count > 0 {
            lineNode = MomentCommentLineNode()
        }
    }
    
    func likesTextNode(with likes: [MomentLikeUser]) -> ASTextNode? {
        
        guard likes.count > 0 else { return nil }
        
        let textAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor
        ]
        
        let body = NSMutableAttributedString()
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "AlbumLikeSmall_18x18_")
        attachment.bounds = CGRect(x: 0, y: -3, width: 18, height: 18)
        
        body.append(NSAttributedString(attachment: attachment))
        
        for (index, user) in likes.enumerated() {
            body.append(NSAttributedString(string: user.username, attributes: [
                .font: nameFont,
                .foregroundColor: Colors.DEFAULT_LINK_COLOR,
                .underlineColor: UIColor.clear,
                NSAttributedString.Key(rawValue: kLinkAttributeName): URL(string: "wechat://WC/" + user.userID) as Any
                ]))
            if index != likes.count - 1 {
                body.append(NSAttributedString(string: ",", attributes: textAttributes))
            }
        }
        let textNode = ASTextNode()
        textNode.delegate = self
        textNode.highlightStyle = .dark
        textNode.linkAttributeNames = [kLinkAttributeName]
        textNode.isUserInteractionEnabled = true
        textNode.maximumNumberOfLines = 0
        textNode.attributedText = body
        textNode.passthroughNonlinkTouches = true
        return textNode
    }
    
    func commentTextNode(with comment: MomentComment) -> ASTextNode {
        let textAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor
        ]
        let body = NSMutableAttributedString()
        body.append(NSAttributedString(string: comment.nickname, attributes: [
            .font: nameFont,
            .foregroundColor: Colors.DEFAULT_LINK_COLOR,
            NSAttributedString.Key(rawValue: kLinkAttributeName): URL(string: "wechat://WC/" + comment.userID) as Any,
            .underlineColor: UIColor.clear
            ]))
        
        if let refName = comment.refUsername, let refUId = comment.refUserId {
            body.append(NSAttributedString(string: "回复", attributes: textAttributes))
            
            body.append(NSAttributedString(string: refName, attributes: [
                .font: nameFont,
                .foregroundColor: Colors.DEFAULT_LINK_COLOR,
                NSAttributedString.Key(rawValue: kLinkAttributeName): URL(string: "wechat://WC/" + refUId) as Any,
                .underlineColor: UIColor.clear
                ]))
        }
        
        body.append(NSAttributedString(string: ": \(comment.content)", attributes: textAttributes))
        
        let textNode = ASTextNode()
        textNode.highlightStyle = .dark
        textNode.linkAttributeNames = [kLinkAttributeName]
        textNode.delegate = self
        textNode.isUserInteractionEnabled = true
        textNode.maximumNumberOfLines = 0
        textNode.attributedText = body
        textNode.passthroughNonlinkTouches = true
        return textNode
    }
    
    override func didLoad() {
        super.didLoad()
        
        likeNode?.layer.as_allowsHighlightDrawing = true
        commentElements.forEach { $0.layer.as_allowsHighlightDrawing = true }
    }
    
    func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: self.view)
        for (index, node) in commentElements.enumerated() {
            if node.frame.contains(point) {
                let comment = moment.comments[index]
                delegate?.momentComment(self, didTapComment: comment)
            }
        }
    }
    
    func addComment(_ comment: MomentComment) {
        commentElements.append(commentTextNode(with: comment))
        setNeedsLayout()
    }
    
    func deleteComment(_ comment: MomentComment) {
        
        setNeedsLayout()
    }
    
    func updateLikes() {
        likeNode = likesTextNode(with: moment.likes)
        setNeedsLayout()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        var elements: [ASLayoutElement] = []
        if let likeNode = likeNode {
            let textInsets = UIEdgeInsets(top: 4, left: 9, bottom: 4, right: 9)
            elements.append(ASInsetLayoutSpec(insets: textInsets, child: likeNode))
        }
        
        if let line = lineNode {
            line.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 1)
            elements.append(line)
        }
        
        if commentElements.count > 0 {
            let textInsets = UIEdgeInsets(top: 4, left: 9, bottom: 4, right: 9)
            let commentSpecs = commentElements.map { return ASInsetLayoutSpec(insets: textInsets, child: $0) }
            elements.append(contentsOf: commentSpecs)
        }
        
        let commentStack = ASStackLayoutSpec.vertical()
        commentStack.children = elements
        
        let backgroundSpec = ASBackgroundLayoutSpec(child: commentStack, background: containerNode)
        
        let layout = ASStackLayoutSpec.vertical()
        layout.children = [triangleNode, backgroundSpec]
        return ASInsetLayoutSpec(insets: .zero, child: layout)
    }
}

extension MomentCommentNode: ASTextNodeDelegate {
    
    func textNode(_ textNode: ASTextNode!, shouldHighlightLinkAttribute attribute: String!, value: Any!, at point: CGPoint) -> Bool {
        return true
    }
    
    func textNode(_ textNode: ASTextNode!, tappedLinkAttribute attribute: String!, value: Any!, at point: CGPoint, textRange: NSRange) {
        if let value = value as? String, let url = URL(string: value) {
            delegate?.momentComment(self, tappedLink: url)
        }
    }
    
}

protocol MomentCommentNodeDelegate: class {
    
    /// Tapp Link In Comment Area, eg: Tap username
    ///
    /// - Parameters:
    ///   - commentNode: Moment Comment Node
    ///   - url: url
    func momentComment(_ commentNode: MomentCommentNode, tappedLink url: URL?)
    
    func momentComment(_ commentNode: MomentCommentNode, didTapComment comment: MomentComment)
}
