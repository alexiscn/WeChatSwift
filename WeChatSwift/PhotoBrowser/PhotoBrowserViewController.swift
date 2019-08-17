//
//  PhotoBrowserViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/17.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

class PhotoBrowserViewController: UIViewController {
    
    var pageIndex: Int = 0 {
        didSet {
            if pageIndex != oldValue {
                
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
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.alwaysBounceVertical = false
        return collectionView
    }()
    
    let delegate: PhotoBrowserDelegate
    
    let dataSource: PhotoBrowserDataSource
    
    init(dataSource: PhotoBrowserDataSource, delegate: PhotoBrowserDelegate) {
        self.dataSource = dataSource
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .custom
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(pageIndex: Int, in viewController: UIViewController) {
        viewController.present(self, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        extendedLayoutIncludesOpaqueBars = true
        
        view.addSubview(collectionView)
        collectionView.contentInsetAdjustmentBehavior = .never
        
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
        
        setLayout()
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        
        collectionView.layoutIfNeeded()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setLayout()
    }
    
    func setLayout() {
        flowLayout.itemSize = view.bounds.size
        collectionView.frame = view.bounds
        
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    var transitionZoomView: UIView? {
        return delegate.photoBrowser(self, transitionViewAt: pageIndex)
    }
    
    var displayingContentView: UIView? {
        return delegate.photoBrowser(self, displayingContentViewAt: pageIndex)
    }
}

class PhotoBrowserPresentationController: UIPresentationController {
    
    var maskView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        guard let container = self.containerView else {
            return
        }
        
        container.addSubview(maskView)
        maskView.frame = container.bounds
        maskView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        maskView.alpha = 0.0
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.maskView.alpha = 1.0
        }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.maskView.alpha = 0.0
        }, completion: nil)
    }
}
