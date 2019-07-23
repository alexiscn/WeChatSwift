//
//  AssetPickerCellNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/23.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit
import Photos

class AssetPickerCellNode: ASCellNode {
    
    private let imageNode = ASImageNode()
    
    private let selectionButtonNode = ASButtonNode()
    
    private let numberNode = ASTextNode()
    
    private let placeholderNode = ASImageNode()
    
    private let mediaAsset: MediaAsset
    
    init(asset: MediaAsset) {
        self.mediaAsset = asset
        super.init()
        automaticallyManagesSubnodes = true
        placeholderNode.image = UIImage.as_imageNamed("FriendsSendsPicturesSelectIcon_27x27_")
    }
    
    override func didLoad() {
        super.didLoad()
        let size = CGSize(width: 150, height: 150)
        PHCachingImageManager.default().requestImage(for: mediaAsset.asset, targetSize: size, contentMode: .aspectFill, options: nil) { [weak self] (image, _) in
            self?.imageNode.image = image
        }
        selectionButtonNode.addTarget(self, action: #selector(selectionButtonTapped(_:)), forControlEvents: .touchUpInside)
    }
    
    @objc private func selectionButtonTapped(_ sender: Any) {
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        placeholderNode.style.preferredSize = CGSize(width: 27, height: 27)
        placeholderNode.style.layoutPosition = CGPoint(x: constrainedSize.max.width - 27, y: 0)
        
        selectionButtonNode.style.preferredSize = CGSize(width: constrainedSize.max.width * 0.5, height: constrainedSize.max.height * 0.5)
        selectionButtonNode.style.layoutPosition = CGPoint(x: constrainedSize.max.width * 0.5, y: 0)
        
        imageNode.style.preferredSize = constrainedSize.max
        imageNode.style.layoutPosition = .zero
        
        let absolute = ASAbsoluteLayoutSpec(children: [imageNode, selectionButtonNode, placeholderNode])
        return absolute //ASInsetLayoutSpec(insets: .zero, child: absolute)
    }
    
}
