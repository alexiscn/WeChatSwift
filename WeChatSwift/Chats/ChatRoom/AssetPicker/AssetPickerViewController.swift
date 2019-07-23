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

class AssetPickerViewController: ASViewController<ASCollectionNode> {
    
    private var dataSource: PHFetchResult<PHAsset>?
    
    init() {
        
        let spacing: CGFloat = 4.0
        let numberOfItemsInRow: Int = 4
        let itemWidth = (Constants.screenWidth - CGFloat(numberOfItemsInRow + 1) * spacing)/CGFloat(numberOfItemsInRow)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        let collectionNode = ASCollectionNode(collectionViewLayout: layout)
        super.init(node: collectionNode)
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
                if status == .authorized {
                    self.loadPhotos()
                }
            }
        case .authorized:
            loadPhotos()
        default:
            break
        }
    }
    
    private func loadPhotos() {
        
    }
}

// MARK: - ASCollectionDelegate & ASCollectionDataSource
extension AssetPickerViewController: ASCollectionDelegate, ASCollectionDataSource {
    
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let block: ASCellNodeBlock = {
            return ASCellNode()
        }
        return block
    }
}
