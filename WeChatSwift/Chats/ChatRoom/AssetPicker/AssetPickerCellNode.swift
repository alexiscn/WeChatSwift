//
//  AssetPickerCellNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/23.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class AssetPickerCellNode: ASCellNode {
    
    private let imageNode = ASImageNode()
    
    private let selectionButton = ASButtonNode()
    
    private let asset: PHAsset
    
    init(asset: PHAsset) {
        self.asset = asset
        super.init()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASLayoutSpec()
    }
    
}
