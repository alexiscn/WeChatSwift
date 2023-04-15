//
//  PhotoBrowserViewController.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/17.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

class PhotoBrowserViewController: UIViewController {
    
    var pageIndex: Int = 0 {
        didSet {
            if pageIndex != oldValue {
                delegate.photoBrowser(self, pageIndexDidChanged: pageIndex)
            }
        }
    }
    
    lazy var flowLayout: PhotoBrowserCollectionFlowLayout = {
        let layout = PhotoBrowserCollectionFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.decelerationRate = .fast
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.alwaysBounceVertical = false
        return collectionView
    }()
    
    let delegate: PhotoBrowserDelegate
    
    let dataSource: PhotoBrowserDataSource
    
    let transDelegate: PhotoBrowserTransitioningDelegate
    
    init(dataSource: PhotoBrowserDataSource,
         transDelegate: PhotoBrowserZoomTransitioning,
         delegate: PhotoBrowserDelegate) {
        self.dataSource = dataSource
        self.delegate = delegate
        self.transDelegate = transDelegate
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = transDelegate
        
        dataSource.browser = self
        transDelegate.browser = self
        delegate.browser = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(pageIndex: Int, in viewController: UIViewController) {
        self.pageIndex = pageIndex
        viewController.present(self, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        extendedLayoutIncludesOpaqueBars = true
        
        view.addSubview(collectionView)
        collectionView.contentInsetAdjustmentBehavior = .never
        
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
        collectionView.register(PhotoBrowserViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(PhotoBrowserViewCell.self))
        
        let index = pageIndex
        setLayout()
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        scrollTo(index: index, at: .left, animated: false)
        collectionView.layoutIfNeeded()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate.photoBrowser(self, viewWillAppear: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate.photoBrowser(self, viewWillDisappear: animated)
    }
    
    func setLayout() {
        flowLayout.minimumLineSpacing = 0
        flowLayout.itemSize = view.bounds.size
        collectionView.frame = view.bounds
        collectionView.contentInset = .zero
    }
    
    func scrollTo(index: Int, at position: UICollectionView.ScrollPosition, animated: Bool) {
        let safeIndex = min(max(0, index), itemsCount - 1)
        let indexPath = IndexPath(item: safeIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: position, animated: animated)
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    var itemsCount: Int {
        return dataSource.collectionView(collectionView, numberOfItemsInSection: 0)
    }
    
    var transitionZoomView: UIView? {
        return delegate.photoBrowser(self, transitionViewAt: pageIndex)
    }
    
    var displayingContentView: UIView? {
        return delegate.photoBrowser(self, displayingContentViewAt: pageIndex)
    }
}
