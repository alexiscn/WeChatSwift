//
//  EmoticonGridCellNode.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/7/17.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class EmoticonGridCellNode: ASCellNode {
    
    var didTapEmoticon: ((_ emoticon: Emoticon) -> Void)?
    
    var didTapDeleteButton: (() -> Void)?
    
    private var nodes: [EmoticonGridItemNode] = []
    
    private let viewModel: EmoticonViewModel
    
    private var cameraEntryNode: EmoticonBoardCameraEntryNode?
    
    init(viewModel: EmoticonViewModel, emoticons: [Emoticon]) {
        self.viewModel = viewModel
        
        super.init()
        
        let columns = viewModel.layout.columns
        let insetX = viewModel.layout.marginLeft
        let insetY = viewModel.layout.marginTop
        let itemSize = viewModel.layout.itemSize
        let spacingX = viewModel.layout.spacingX
        let spacingY = viewModel.layout.spacingY
        let numberOfPerPage = viewModel.layout.numberOfItemsInPage
        
        for index in 0 ..< emoticons.count {
            let page = index / numberOfPerPage // 当前的页数
            let offsetInPage = index - page * numberOfPerPage // 在当前页的索引
            let col = CGFloat(offsetInPage % columns) // 在当前页的列数
            let row = CGFloat(offsetInPage/columns) // 在当前页的行数
            let x = insetX + col * (spacingX + itemSize.width) + CGFloat(page) * Constants.screenWidth
            let y = insetY +  row * (spacingY + itemSize.height)
            let emoticon = emoticons[index]
            let node = EmoticonGridItemNode(emoticon: emoticon, itemSize: itemSize)
            node.style.preferredSize = itemSize
            node.style.layoutPosition = CGPoint(x: x, y: y)
            addSubnode(node)
            nodes.append(node)
        }
        
        if viewModel.type == .cameraEmoticon {
            let node = EmoticonBoardCameraEntryNode()
            addSubnode(node)
            self.cameraEntryNode = node
        }
    }
    
    override func didLoad() {
        super.didLoad()
        
        addDeleteButtonIfNeeded()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func addDeleteButtonIfNeeded() {
        guard viewModel.type == .expression else { return }
        
        let layout = viewModel.layout
        let x = layout.marginLeft + CGFloat(layout.columns - 1) * (layout.spacingX + layout.itemSize.width)
        let y = layout.marginTop + CGFloat(layout.rows - 1) * (layout.spacingY + layout.itemSize.height)
        let deleteButton = UIButton(type: .custom)
        deleteButton.addTarget(self, action: #selector(deleteEmoticonButtonClicked), for: .touchUpInside)
        deleteButton.setImage(UIImage(named: "DeleteEmoticonBtn_32x32_"), for: .normal)
        deleteButton.frame = CGRect(origin: CGPoint(x: x, y: y), size: layout.itemSize)
        deleteButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        self.view.addSubview(deleteButton)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        if let cameraNode = cameraEntryNode {
            return ASInsetLayoutSpec(insets: .zero, child: cameraNode)
        }
        return ASAbsoluteLayoutSpec(children: nodes)
    }
}

// MARK: - Event Handlers
extension EmoticonGridCellNode {
    
    @objc private func deleteEmoticonButtonClicked() {
        didTapDeleteButton?()
    }
    
    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: self.view)
        if let node = nodes.first(where: { $0.frame.contains(point) }) {
            didTapEmoticon?(node.emoticon)
        }
    }
}
