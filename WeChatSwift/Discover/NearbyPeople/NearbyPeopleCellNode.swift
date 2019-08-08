//
//  NearbyPeopleCellNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/8.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class NearbyPeopleCellNode: ASCellNode {
    
    private let avatarNode = ASNetworkImageNode()
    
    private let nicknameNode = ASTextNode()
    
    private let genderNode = ASImageNode()
    
    private let distanceNode = ASTextNode()
    
    private let albumIconNode = ASImageNode()
    
    private let signatureNode = ASTextNode()
    
    private let lineNode = ASDisplayNode()
    
    init(people: NearbyPeople) {
        super.init()
        
        avatarNode.cornerRadius = 4
        avatarNode.cornerRoundingType = .precomposited
        
        nicknameNode.attributedText = people.attributedStringForNickname()
        distanceNode.attributedText = people.attributedStringForDistance()
        albumIconNode.image = UIImage(named: "AlbumFlagMark_15x15_")
        lineNode.backgroundColor = Colors.DEFAULT_SEPARTOR_LINE_COLOR
    }
    
    override func didLoad() {
        super.didLoad()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        avatarNode.style.preferredSize = CGSize(width: 46, height: 46)
        avatarNode.style.spacingBefore = 7
        
        let nameStack = ASStackLayoutSpec.horizontal()
        nameStack.spacing = 3
        nameStack.children = [nicknameNode, genderNode]
        
        let descStack = ASStackLayoutSpec.horizontal()
        descStack.spacing = 3
        descStack.children = [distanceNode, albumIconNode]
        
        let centerVerticalStack = ASStackLayoutSpec.vertical()
        centerVerticalStack.style.spacingBefore = 12
        centerVerticalStack.children = [nameStack, descStack]
        
        signatureNode.style.maxWidth = ASDimension(unit: .points, value: 86)
        signatureNode.style.spacingAfter = 15
        
        let stack = ASStackLayoutSpec.horizontal()
        stack.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 64)
        stack.alignItems = .center
        stack.children = [avatarNode, centerVerticalStack, signatureNode]
        
        lineNode.style.preferredSize = CGSize(width: constrainedSize.max.width - 7, height: Constants.lineHeight)
        lineNode.style.layoutPosition = CGPoint(x: 7, y: 64 - Constants.lineHeight)
        
        return ASAbsoluteLayoutSpec(children: [stack, lineNode])
    }
    
}

class NearbyPeople {
    
    
    var userId: String
    
    var nickname: String
    
    var country: String?
    
    var province: String?
    
    var distance: String? = nil
    
    var gender: Int
    
    init(userId: String, nickname: String, gender: Int) {
        self.userId = userId
        self.nickname = nickname
        self.gender = gender
    }
    
    func attributedStringForNickname() -> NSAttributedString {
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: Colors.black
        ]
        return NSAttributedString(string: nickname, attributes: attributes)
    }
    
    func attributedStringForDistance() -> NSAttributedString? {
        guard let distance = distance else { return nil }
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
            NSAttributedString.Key.foregroundColor: Colors.DEFAULT_TEXT_GRAY_COLOR
        ]
        return NSAttributedString(string: distance, attributes: attributes)
    }
}
