//
//  GridPageLayoutDelegate.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/12.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

public class GridPageLayoutInfo {
    
    public let itemsCount: Int
    
    public let itemSize: CGSize

    public private(set) var numberOfRows: Int
    
    public private(set) var numberOfColumns: Int
    
    public private(set) var insets: UIEdgeInsets = .zero
    
    public var minimumLineSpacing: CGFloat = 0.0
    
    public var minimumInteritemSpacing: CGFloat = 0.0
    
    var itemWidthWithSpacing: CGFloat {
        return itemSize.width + minimumInteritemSpacing
    }
    
    var itemHeightWithSpacing: CGFloat {
        return itemSize.height + minimumLineSpacing
    }
    
    var numberOfItemsInPage: Int {
        return numberOfRows * numberOfColumns
    }
    
    var numberOfPages: Int {
        return Int(ceilf(Float(itemsCount)/Float(numberOfItemsInPage)))
    }
    
    public init(itemsCount: Int, itemSize: CGSize) {
        self.itemsCount = itemsCount
        self.itemSize = itemSize
        self.numberOfRows = 1
        self.numberOfColumns = 1
    }
    
    func update(viewportSize: CGSize) {
        let width = viewportSize.width
        let height = viewportSize.height
        numberOfColumns = Int(width / itemWidthWithSpacing)
        numberOfRows = Int(height / itemHeightWithSpacing)
        let marginH = (width - CGFloat(numberOfColumns) * itemWidthWithSpacing + minimumInteritemSpacing)/2.0
        let marginV = (height - CGFloat(numberOfRows) * itemHeightWithSpacing + minimumLineSpacing)/2.0
        insets = UIEdgeInsets(top: marginV, left: marginH, bottom: marginV, right: marginH)
    }
}

public class GridPageLayoutDelegate: NSObject, ASCollectionLayoutDelegate {
    
    private let info: GridPageLayoutInfo
    
    public init(layoutInfo: GridPageLayoutInfo) {
        self.info = layoutInfo
        super.init()
    }
    
    public func scrollableDirections() -> ASScrollDirection {
        return ASScrollDirectionHorizontalDirections
    }
    
    public func additionalInfoForLayout(withElements elements: ASElementMap) -> Any? {
        return info
    }
    
    public static func calculateLayout(with context: ASCollectionLayoutContext) -> ASCollectionLayoutState {
        let attrsMap: NSMapTable<ASCollectionElement, UICollectionViewLayoutAttributes> = NSMapTable<AnyObject, AnyObject>.elementToLayoutAttributes()
        guard let info = context.additionalInfo as? GridPageLayoutInfo else {
            return ASCollectionLayoutState(context: context, contentSize: .zero, elementToLayoutAttributesTable: attrsMap)
        }
        info.update(viewportSize: context.viewportSize)
        let pageWidth = context.viewportSize.width
        let columns = info.numberOfColumns
        for index in 0 ..< info.itemsCount {
            let page = index / info.numberOfItemsInPage
            let offset = index - page * info.numberOfItemsInPage
            let col = CGFloat(offset % columns)
            let row = CGFloat(offset / columns)
            let x = info.insets.left + col * info.itemWidthWithSpacing + CGFloat(page) * Constants.screenWidth
            let y = info.insets.top + row * info.itemHeightWithSpacing
            let attribute = UICollectionViewLayoutAttributes(forCellWith: IndexPath(row: index, section: 0))
            attribute.frame = CGRect(origin: CGPoint(x: x, y: y), size: info.itemSize)
            let element = context.elements?.elementForItem(at: IndexPath(row: index, section: 0))
            attrsMap.setObject(attribute, forKey: element)
        }
        let contentSize = CGSize(width: pageWidth * CGFloat(info.numberOfPages), height: context.viewportSize.height)
        return ASCollectionLayoutState(context: context, contentSize: contentSize, elementToLayoutAttributesTable: attrsMap)
    }
}
