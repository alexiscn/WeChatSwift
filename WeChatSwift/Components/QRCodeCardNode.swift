//
//  QRCodeCardNode.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/7/30.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import CoreImage

class QRCodeCardNode: ASDisplayNode {
    
    private let avatarNode = ASImageNode()
    
    private let nameNode = ASTextNode()
    
    private let genderNode = ASImageNode()
    
    private let locationNode = ASTextNode()
    
    private let qrCodeNode = ASImageNode()
    
    private let bottomTextNode = ASTextNode()
    
    private let filter = CIFilter(name: "CIQRCodeGenerator")
    
    private let contact: ContactModel
    
    init(contact: ContactModel) {
        self.contact = contact
        super.init()
        
        automaticallyManagesSubnodes = true
        
        avatarNode.image = contact.image
        avatarNode.cornerRadius = 6
        avatarNode.cornerRoundingType = .precomposited
        
        genderNode.image = UIImage(named: "Contact_Male_18x18_")
        
        let nameAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .semibold),
            NSAttributedString.Key.foregroundColor: Colors.black
        ]
        nameNode.attributedText = NSAttributedString(string: contact.name, attributes: nameAttributes)
        
        let descAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
            NSAttributedString.Key.foregroundColor: UIColor(hexString: "#717171")
        ]
        locationNode.attributedText = NSAttributedString(string: "北京 朝阳", attributes: descAttributes)
        
        let bottomTextParagraph = NSMutableParagraphStyle()
        bottomTextParagraph.alignment = .center
        let bottomTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11),
            NSAttributedString.Key.foregroundColor: Colors.DEFAULT_TEXT_GRAY_COLOR,
            NSAttributedString.Key.paragraphStyle: bottomTextParagraph
        ]
        bottomTextNode.attributedText = NSAttributedString(string: LocalizedString("FF_QRCode_MyQRCodeIntro"), attributes: bottomTextAttributes)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didLoad() {
        super.didLoad()
        
        createQRImage(with: contact.name)
    }
    
    func createQRImage(with text: String) {
        guard let filter = filter, let data = text.data(using: .utf8) else {
            return
        }
        filter.setValue(data, forKey: "inputMessage")
        guard let ciImage = filter.outputImage else {
            return
        }
        genderNode.image = UIImage(ciImage: ciImage, scale: UIScreen.main.scale, orientation: .up)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        avatarNode.style.preferredSize = CGSize(width: 64, height: 64)
        
        let nameStack = ASStackLayoutSpec.horizontal()
        nameStack.children = [nameNode, genderNode]
        
        let nameVerticalStack = ASStackLayoutSpec.vertical()
        nameVerticalStack.children = [nameVerticalStack, locationNode]
        
        let topStack = ASStackLayoutSpec.horizontal()
        topStack.children = [avatarNode, nameVerticalStack]
        
        let qrCodeInsets = UIEdgeInsets(top: 21, left: 21, bottom: 21, right: 21)
        let qrCodeLayout = ASInsetLayoutSpec(insets: qrCodeInsets, child: qrCodeNode)
        
        let layout = ASStackLayoutSpec.vertical()
        layout.children = [topStack, qrCodeLayout, bottomTextNode]
        
        return ASInsetLayoutSpec(insets: .zero, child: layout)
    }
}
