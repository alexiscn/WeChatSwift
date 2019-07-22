//
//  EmoticonBoardTabBarNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/17.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

protocol EmoticonBoardTabBarNodeDelegate: class {
    func emoticonBoardTabBarPressedAddButton()
    func emoticonBoardTabBarPressedSendButton()
    func emoticonBoardTabBarPressedDeleteButton()
    func emoticonBoardTabBarPressedSettingButton()
    func emoticonBoardTabBarDidSelected(at indexPath: IndexPath)
}

fileprivate enum EmoticonBoardTabBarRightButtonType {
    case settings
    case send
}

class EmoticonBoardTabBarNode: ASDisplayNode {
    
    weak var delegate: EmoticonBoardTabBarNodeDelegate?
    
    private let addButtonNode: ASButtonNode
    
    private let collectionNode: ASCollectionNode
    
    private let settingButtonNode: ASButtonNode
    
    private let sendButtonNode: ASButtonNode
    
    private var dataSource: [EmoticonViewModel] = []
    
    private var rightButtonType: EmoticonBoardTabBarRightButtonType = .send
    
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
        settingButtonNode.setBackgroundImage(UIImage.as_imageNamed("EmotionsSendBtnGrey_70x37_"), for: .normal)
        settingButtonNode.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        
        let sendText = NSAttributedString(string: "发送", attributes: [
            .font: UIFont.systemFont(ofSize: 15, weight: .semibold),
            .foregroundColor: UIColor(white: 0.0, alpha: 0.9)
            ])
        sendButtonNode.setAttributedTitle(sendText, for: .normal)
        sendButtonNode.setBackgroundImage(UIImage.as_imageNamed("EmotionsSendBtnGrey_70x37_"), for: .normal)
        sendButtonNode.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
    }
    
    func emoticonGridDidScrollTo(_ indexPath: IndexPath) {
        let destIndex = IndexPath(row: indexPath.section, section: 0)
        collectionNode.selectItem(at: destIndex, animated: false, scrollPosition: .left)
        
        if indexPath.section == 0 {
            if rightButtonType != .send {
                rightButtonType = .send
                transitionLayout(withAnimation: true, shouldMeasureAsync: false, measurementCompletion: nil)
            }
        } else {
            if rightButtonType != .settings {
                rightButtonType = .settings
                transitionLayout(withAnimation: true, shouldMeasureAsync: false, measurementCompletion: nil)
            }
        }
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
    
    override func animateLayoutTransition(_ context: ASContextTransitioning) {
        UIView.animate(withDuration: 0.25) {
            switch self.rightButtonType {
            case .send:
                self.settingButtonNode.frame.origin.x += 60
                self.sendButtonNode.frame.origin.x -= 60
            case .settings:
                self.settingButtonNode.frame.origin.x -= 60
                self.sendButtonNode.frame.origin.x += 60
            }
        }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        collectionNode.style.flexShrink = 1.0
        collectionNode.style.flexGrow = 1.0
        
        addButtonNode.style.preferredSize = CGSize(width: 45, height: 44)
        settingButtonNode.style.preferredSize = CGSize(width: 60, height: 44)
        sendButtonNode.style.preferredSize = CGSize(width: 60, height: 44)
        
        let stack = ASStackLayoutSpec.horizontal()
        if rightButtonType == .settings {
            stack.children = [addButtonNode, collectionNode, settingButtonNode]
        } else {
            stack.children = [addButtonNode, collectionNode, sendButtonNode]
        }
        
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
