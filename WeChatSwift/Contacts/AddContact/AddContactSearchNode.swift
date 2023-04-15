//
//  AddContactSearchNode.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/7/30.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class AddContactSearchNode: ASCellNode {
    
    var qrCodeHandler: RelayCommand?
    
    private let iconNode = ASImageNode()
    
    private let textInputNode = ASEditableTextNode()
    
    private let myQRCodeTextNode = ASTextNode()
    
    private let myQRCodeButtonNode = ASButtonNode()
    
    override init() {
        super.init()
        
        automaticallyManagesSubnodes = true
        
        iconNode.image = UIImage.as_imageNamed("add_friend_searchicon_36x30_")
        
        textInputNode.attributedPlaceholderText = NSAttributedString(string: "微信号/手机号", attributes: [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor(hexString: "#000019", alpha: 0.2)
            ])
        textInputNode.textContainerInset = UIEdgeInsets(top: 14, left: 46, bottom: 14, right: 0)
        
        myQRCodeTextNode.attributedText = NSAttributedString(string: "我的微信号:wxid_jdhfgufdgyfg", attributes: [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: Colors.black
            ])
        
        myQRCodeButtonNode.setImage(UIImage(named: "add_friend_myQR_20x20_"), for: .normal)
        myQRCodeButtonNode.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    override func didLoad() {
        super.didLoad()
        
        textInputNode.backgroundColor = .white
        backgroundColor = .clear
        
        myQRCodeButtonNode.addTarget(self, action: #selector(myQRCodeButtonClicked), forControlEvents: .touchUpInside)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        iconNode.style.preferredSize = CGSize(width: 36, height: 30)
        iconNode.style.layoutPosition = CGPoint(x: 9, y: 8)
        textInputNode.style.flexGrow = 1.0
        textInputNode.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 47)
        
        let searchLayout = ASAbsoluteLayoutSpec(children: [textInputNode, iconNode])
        
        myQRCodeButtonNode.style.preferredSize = CGSize(width: 40, height: 40)
        
        let qrCodeStack = ASStackLayoutSpec.horizontal()
        qrCodeStack.horizontalAlignment = .middle
        qrCodeStack.verticalAlignment = .center
        qrCodeStack.children = [myQRCodeTextNode, myQRCodeButtonNode]
        
        let spacer = ASLayoutSpec()
        spacer.style.flexGrow = 1.0
        
        let layout = ASStackLayoutSpec.vertical()
        layout.children = [searchLayout, qrCodeStack, spacer]
        return ASInsetLayoutSpec(insets: .zero, child: layout)
    }
    
    @objc private func myQRCodeButtonClicked() {
        qrCodeHandler?()
    }
}
