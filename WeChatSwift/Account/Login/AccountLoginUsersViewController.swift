//
//  AccountLoginUsersViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/19.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class AccountLoginUsersViewController: ASDKViewController<ASDisplayNode> {
    
    private let iconNode = ASImageNode()
    
    private let titleNode = ASTextNode()
    
    private let lineNode = ASDisplayNode()
    
    override init() {
        super.init(node: ASDisplayNode())
        
        iconNode.image = UIImage(named: "ChatListBackgroundLogo_50x50_")
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        titleNode.attributedText = NSAttributedString(string: "轻触头像以切换账号", attributes: [
            .font: UIFont.systemFont(ofSize: 27),
            .foregroundColor: UIColor.black,
            .paragraphStyle: paragraphStyle
            ])
        
        lineNode.backgroundColor = UIColor(hexString: "#C8C8C8")
        
        node.addSubnode(iconNode)
        node.addSubnode(titleNode)
        node.addSubnode(lineNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
}

class LoginUserImageNode: ASDisplayNode {
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASLayoutSpec()
    }
}
