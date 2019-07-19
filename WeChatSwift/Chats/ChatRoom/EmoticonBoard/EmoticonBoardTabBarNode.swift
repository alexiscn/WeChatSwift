//
//  EmoticonBoardTabBarNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/17.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

protocol EmoticonBoardTabBarNodeDelegate {
    func emoticonBoardTabBarPressedAddButton()
    func emoticonBoardTabBarPressedSendButton()
    func emoticonBoardTabBarPressedDeleteButton()
    func emoticonBoardTabBarPressedSettingButton()
    func emoticonBoardTabBarDidSelected(at indexPath: IndexPath)
}

class EmoticonBoardTabBarNode: ASDisplayNode {
    
    var delegate: EmoticonBoardTabBarNodeDelegate?
    
    private let addButtonNode: ASButtonNode
    
    private let collectionNode: ASCollectionNode
    
    private let settingButtonNode: ASButtonNode
    
    private let sendButtonNode: ASButtonNode
    
    private var dataSource: [EmoticonViewModel] = []
    
    init(emoticons: [EmoticonViewModel]) {
        self.dataSource = emoticons
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 45, height: 44)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        collectionNode = ASCollectionNode(collectionViewLayout: layout)
        
        addButtonNode = ASButtonNode()
        settingButtonNode = ASButtonNode()
        sendButtonNode = ASButtonNode()
        
        super.init()
        backgroundColor = Colors.white
        automaticallyManagesSubnodes = true
        collectionNode.delegate = self
        collectionNode.dataSource = self
        
        addButtonNode.setImage(UIImage.SVGImage(named: "icons_filled_add"), for: .normal)
        settingButtonNode.setImage(UIImage.SVGImage(named: "icons_outlined_setting"), for: .normal)
        
        let sendText = NSAttributedString(string: "发送", attributes: [
            .font: UIFont.systemFont(ofSize: 15, weight: .semibold),
            .foregroundColor: UIColor(white: 0.0, alpha: 0.9)
            ])
        sendButtonNode.setAttributedTitle(sendText, for: .normal)
    }
    
    override func didLoad() {
        super.didLoad()
        
        addButtonNode.addTarget(self, action: #selector(handleTapAddButton(_:)), forControlEvents: .touchUpInside)
        sendButtonNode.addTarget(self, action: #selector(handleTapSendButton(_:)), forControlEvents: .touchUpInside)
        settingButtonNode.addTarget(self, action: #selector(handleTapSettingButton(_:)), forControlEvents: .touchUpInside)
        
        let addButtonLineView = UIView()
        addButtonLineView.frame = CGRect(x: 44.5, y: 6, width: 0.5, height: 32)
        addButtonLineView.backgroundColor = UIColor(hexString: "#ECECEC")
        addButtonNode.view.addSubview(addButtonLineView)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        collectionNode.style.flexShrink = 1.0
        collectionNode.style.flexGrow = 1.0
        
        addButtonNode.style.preferredSize = CGSize(width: 45, height: 44)
        settingButtonNode.style.preferredSize = CGSize(width: 45, height: 44)
        sendButtonNode.style.preferredSize = CGSize(width: 45, height: 44)
        
        let stack = ASStackLayoutSpec.horizontal()
        stack.children = [addButtonNode, collectionNode, sendButtonNode]
        
        return ASInsetLayoutSpec(insets: .zero, child: stack)
    }
}

// MARK: - Event Handler
extension EmoticonBoardTabBarNode {
    
    @objc private func handleTapAddButton(_ sender: Any) {
        delegate?.emoticonBoardTabBarPressedAddButton()
    }
    
    @objc private func handleTapSendButton(_ sender: Any) {
        delegate?.emoticonBoardTabBarPressedSendButton()
    }
    
    @objc private func handleTapDeleteButton(_ sender: Any) {
        delegate?.emoticonBoardTabBarPressedDeleteButton()
    }
    
    @objc private func handleTapSettingButton(_ sender: Any) {
        delegate?.emoticonBoardTabBarPressedSettingButton()
    }
}

// MARK: - ASCollectionDelegate & ASCollectionDataSource
extension EmoticonBoardTabBarNode: ASCollectionDelegate, ASCollectionDataSource {
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let viewModel = dataSource[indexPath.row]
        let block: ASCellNodeBlock = {
            return EmoticonBoardTabBarCellNode(viewModel: viewModel)
        }
        return block
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        delegate?.emoticonBoardTabBarDidSelected(at: indexPath)
    }
}
