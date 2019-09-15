//
//  ChatRoomEmoticonPreviewViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/26.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit
import FLAnimatedImage
import WXActionSheet

class ChatRoomEmoticonPreviewViewController: ASViewController<ASDisplayNode> {

    private var animatedImageView: FLAnimatedImageView!
    
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
        animatedImageView = FLAnimatedImageView(frame: CGRect(x: 0, y: 0, width: 180, height: 180))
        animatedImageView.pin_setImage(from: emoticonMsg.url)
        view.addSubview(animatedImageView)
        let width = Constants.screenWidth * 0.4
        animatedImageView.snp.makeConstraints { make in
            make.height.width.equalTo(width)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-60)
        }
    }
    
    private func setupNameLabel() {
        nameLabel = UILabel()
        nameLabel.textColor = UIColor(hexString: "#666666")
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.text = emoticonMsg.title
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(animatedImageView.snp.bottom).offset(16)
        }
    }
 
    @objc private func moreButtonClicked() {
        let actionSheet = WXActionSheet(cancelButtonTitle: LanguageManager.Common.cancel())
        actionSheet.add(WXActionSheetItem(title: "投诉", handler: { _ in
            
        }))
        actionSheet.add(WXActionSheetItem(title: "跟拍", handler: { _ in
            
        }))
        actionSheet.add(WXActionSheetItem(title: "发送给朋友", handler: { _ in
            
        }))
        actionSheet.add(WXActionSheetItem(title: "添加到表情", handler: { _ in
            
        }))
        actionSheet.show()
    }

}
