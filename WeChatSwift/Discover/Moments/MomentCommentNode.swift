//
//  MomentCommentNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/17.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class MomentCommentNode: ASDisplayNode {
    
    private let triangleNode = ASImageNode()
    
    private let containerNode = ASDisplayNode()
    
    private var likeElements: [ASButtonNode] = []
    
    private var commentElements: [ASTextNode] = []
    
    init(likes: [MomentLikeUser], comments: [MomentComment]) {
        
        triangleNode.image = UIImage.as_imageNamed("AlbumTriangleB_45x6_")
        triangleNode.style.preferredSize = CGSize(width: 45, height: 6)
        containerNode.backgroundColor = UIColor(hexString: "#F3F3F5")
        
        //        for likeUser in likes {
        //
        //        }
        
        let commentTextColor = UIColor(hexString: "#111111")
        let commentFont = UIFont.systemFont(ofSize: 15)
        let nameFont = UIFont.systemFont(ofSize: 15, weight: .semibold)
        for comment in comments {
            let body = NSMutableAttributedString()
            body.append(NSAttributedString(string: comment.nickname, attributes: [
                .font: nameFont,
                .foregroundColor: Colors.DEFAULT_LINK_COLOR,
                .link: URL(string: "wechat://WC/" + comment.userID) as Any,
                .underlineColor: UIColor.clear
                ]))
            
            if let refName = comment.refUsername, let refUId = comment.refUserId {
                body.append(NSAttributedString(string: "回复", attributes: [
                    .font: commentFont,
                    .foregroundColor: commentTextColor
                    ]))
                
                body.append(NSAttributedString(string: refName, attributes: [
                    .font: nameFont,
                    .foregroundColor: Colors.DEFAULT_LINK_COLOR,
                    .link: URL(string: "wechat://WC/" + refUId) as Any,
                    .underlineColor: UIColor.clear
                    ]))
            }
            
            body.append(NSAttributedString(string: ": \(comment.content)", attributes: [
                .font: commentFont,
                .foregroundColor: commentTextColor
                ]))
            
            let textNode = ASTextNode()
            textNode.maximumNumberOfLines = 0
            textNode.attributedText = body
            commentElements.append(textNode)
        }
        
        super.init()
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        
        commentElements.forEach { $0.delegate = self }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let commentStack = ASStackLayoutSpec.vertical()
        commentStack.children = commentElements.map { return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 3, left: 9, bottom: 3, right: 9), child: $0) }
        
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
        if let value = value {
            print(value)
        }
    }
    
}

private class MomentLineNode: ASDisplayNode {
    
    override func didLoad() {
        super.didLoad()
        
        let backLayer = CAShapeLayer()
        backLayer.frame = CGRect(x: 0, y: (1.0 - Constants.lineHeight)/2.0, width: bounds.width, height: Constants.lineHeight)
        backLayer.backgroundColor = UIColor(hexString: "#DDDEDF").cgColor
        layer.addSublayer(backLayer)
        
        let frontLayer = CAShapeLayer()
        frontLayer.backgroundColor = UIColor(hexString: "#F6F7F7").cgColor
        frontLayer.frame = CGRect(x: 0, y: (1.0 - Constants.lineHeight)/2.0, width: bounds.width, height: Constants.lineHeight)
        layer.addSublayer(frontLayer)
    }
}
