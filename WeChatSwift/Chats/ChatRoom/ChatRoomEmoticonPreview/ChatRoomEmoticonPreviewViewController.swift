//
//  ChatRoomEmoticonPreviewViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/26.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit
import WXActionSheet
import PINRemoteImage

class ChatRoomEmoticonPreviewViewController: ASDKViewController<ASDisplayNode> {

    private var animatedImageView: PINAnimatedImageView!
    
    private var nameLabel: UILabel!
    
    private let emoticonMsg: EmoticonMessage
    
    private let bottomNode: ChatRoomEmoticonPreviewBottomNode
    
    init(emoticon: EmoticonMessage) {
        self.emoticonMsg = emoticon
        bottomNode = ChatRoomEmoticonPreviewBottomNode(storeEmoticonItem: StoreEmoticonItem(image: nil, title: "22223", desc: nil))
        super.init(node: ASDisplayNode())
        node.addSubnode(bottomNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        node.backgroundColor = .white
        
        setupAnimatedImageView()
        setupNameLabel()
        
        let moreButtonItem = UIBarButtonItem(image: Constants.moreImage, style: .done, target: self, action: #selector(moreButtonClicked))
        navigationItem.rightBarButtonItem = moreButtonItem
        
        bottomNode.frame = CGRect(x: 0, y: view.bounds.height - 90, width: view.bounds.width, height: 90)
    }
    
    private func setupAnimatedImageView() {
        animatedImageView = PINAnimatedImageView(frame: CGRect(x: 0, y: 0, width: 180, height: 180))
        animatedImageView.pin_setImage(from: emoticonMsg.url)
        view.addSubview(animatedImageView)
        let width = Constants.screenWidth * 0.4
        animatedImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animatedImageView.widthAnchor.constraint(equalToConstant: width),
            animatedImageView.heightAnchor.constraint(equalToConstant: width),
            animatedImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            animatedImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -60)
        ])
    }
    
    private func setupNameLabel() {
        nameLabel = UILabel()
        nameLabel.textColor = UIColor(hexString: "#666666")
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.text = emoticonMsg.title
        view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: animatedImageView.bottomAnchor, constant: 16)
        ])
    }
 
    @objc private func moreButtonClicked() {
        let actionSheet = WXActionSheet(cancelButtonTitle: LanguageManager.Common.cancel())
        actionSheet.add(WXActionSheetItem(title: "投诉", handler: { _ in
            
        }))
        actionSheet.add(WXActionSheetItem(title: "跟拍", handler: { _ in
            
        }))
        actionSheet.add(WXActionSheetItem(title: "发送给朋友", handler: { _ in
            
        }))
        // 添加到表情
        actionSheet.add(WXActionSheetItem(title: LocalizedString("Emoticon_Add"), handler: { _ in
            
        }))
        actionSheet.show()
    }

}
