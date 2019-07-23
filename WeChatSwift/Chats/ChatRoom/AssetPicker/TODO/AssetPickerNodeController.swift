//
//  AssetPickerViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/23.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import Photos

// Have memory issue
class AssetPickerNodeController: ASViewController<ASCollectionNode> {
    
    private var dataSource: [MediaAsset] = []
    
    init() {
        
        let spacing: CGFloat = 4.0
        let numberOfItemsInRow: Int = 4
        var itemWidth = (Constants.screenWidth - CGFloat(numberOfItemsInRow + 1) * spacing)/CGFloat(numberOfItemsInRow)
        itemWidth = CGFloat(floorf(Float(itemWidth)))
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        let collectionNode = ASCollectionNode(collectionViewLayout: layout)
        collectionNode.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        super.init(node: collectionNode)
        
        collectionNode.dataSource = self
        collectionNode.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch authorizationStatus {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    if status == .authorized {
                        self.loadPhotos()
                    }
                }
            }
        case .authorized:
            loadPhotos()
        default:
            break
        }
    }
    
    private func loadPhotos() {
        var temp: [MediaAsset] = []
        
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        let result = PHAsset.fetchAssets(with: options)
        result.enumerateObjects { (asset, _, _) in
            temp.append(MediaAsset(asset: asset, selected: false))
        }
        dataSource = temp
        self.node.reloadData()
        
        if dataSource.count > 0 {
            let indexPath = IndexPath(row: dataSource.count - 1, section: 0)
            node.scrollToItem(at: indexPath, at: .bottom, animated: false)
        }
    }
}

// MARK: - ASCollectionDelegate & ASCollectionDataSource
extension AssetPickerNodeController: ASCollectionDelegate, ASCollectionDataSource {
    
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let asset = dataSource[indexPath.row]
        let block: ASCellNodeBlock = {
            return AssetPickerCellNode(asset: asset)
        }
        return block
    }
}
