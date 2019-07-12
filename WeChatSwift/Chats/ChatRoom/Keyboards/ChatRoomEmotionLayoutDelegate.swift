//
//  ChatRoomEmotionLayoutDelegate.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/11.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class ChatRoomEmotionLayoutInfo {
    
    let itemsCount: Int
    let itemSize: CGSize
    let itemSpacing: CGFloat
    let margin: CGFloat
    let rows: Int
    let columns: Int
    
    init(itemsCount: Int, itemSize: CGSize, itemSpacing: CGFloat, margin: CGFloat, columns: Int, rows: Int = 3) {
        self.itemsCount = itemsCount
        self.itemSize = itemSize
        self.itemSpacing = itemSpacing
        self.margin = margin
        self.columns = columns
        self.rows = rows
    }
    
    var numberOfPages: Int {
        return Int(ceilf(Float(itemsCount)/Float(numberOfItemsInPage)))
    }
    
    var numberOfItemsInPage: Int {
        return rows * columns - 1
    }
    
    var contentWidth: CGFloat {
        return CGFloat(numberOfPages) * Constants.screenWidth
    }
    
    var contentHeight: CGFloat {
        return (itemSize.height + itemSpacing) * CGFloat(rows) - itemSpacing
    }
}

class ChatRoomEmotionLayoutDelegate: NSObject, ASCollectionLayoutDelegate {
    
    private let info: ChatRoomEmotionLayoutInfo
    
    init(layoutInfo: ChatRoomEmotionLayoutInfo) {
        self.info = layoutInfo
    }
    
    func scrollableDirections() -> ASScrollDirection {
        return ASScrollDirectionHorizontalDirections
    }
    
    func additionalInfoForLayout(withElements elements: ASElementMap) -> Any? {
        return info
    }
    
    static func calculateLayout(with context: ASCollectionLayoutContext) -> ASCollectionLayoutState {
        
        let attrsMap: NSMapTable<ASCollectionElement, UICollectionViewLayoutAttributes> = NSMapTable<AnyObject, AnyObject>.elementToLayoutAttributes()
        
        guard let info = context.additionalInfo as? ChatRoomEmotionLayoutInfo,
            let elements = context.elements else {
            return ASCollectionLayoutState(context: context, contentSize: .zero, elementToLayoutAttributesTable: attrsMap)
        }
        
        let numberOfPerPage = info.numberOfItemsInPage
        for index in 0 ..< info.itemsCount {
            let page = index / numberOfPerPage // 当前的页数
            let offsetInPage = index - page * numberOfPerPage // 在当前页的索引
            let col: CGFloat = CGFloat(offsetInPage % info.columns) // 在当前页的列数
            let row: CGFloat = CGFloat(offsetInPage/info.columns) // 在当前页的行数
            let x = info.margin + col * (info.itemSpacing + info.itemSize.width) + CGFloat(page) * Constants.screenWidth
            let y = (info.itemSpacing + info.itemSize.height) * row
            let attribute = UICollectionViewLayoutAttributes(forCellWith: IndexPath(row: index, section: 0))
            attribute.frame = CGRect(origin: CGPoint(x: x, y: y), size: info.itemSize)
            let element = elements.elementForItem(at: IndexPath(row: index, section: 0))
            attrsMap.setObject(attribute, forKey: element)
        }
        let contentSize = CGSize(width: info.contentWidth, height: info.contentHeight)
        return ASCollectionLayoutState(context: context, contentSize: contentSize, elementToLayoutAttributesTable: attrsMap)
    }
}
