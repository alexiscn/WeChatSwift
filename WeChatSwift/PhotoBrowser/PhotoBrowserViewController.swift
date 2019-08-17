//
//  PhotoBrowserViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/17.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

class PhotoBrowserViewController: UIViewController {
    
    lazy var flowLayout: PhotoBrowserCollectionFlowLayout = {
        let layout = PhotoBrowserCollectionFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.alwaysBounceVertical = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        extendedLayoutIncludesOpaqueBars = true
        
        view.addSubview(collectionView)
        collectionView.contentInsetAdjustmentBehavior = .never
        
        
    }
    
    func setupLayout() {
        flowLayout.itemSize = view.bounds.size
        collectionView.frame = view.bounds
        
    }
    
}
