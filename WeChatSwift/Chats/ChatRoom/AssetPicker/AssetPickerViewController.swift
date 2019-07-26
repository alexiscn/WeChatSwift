//
//  AssetPickerViewController2.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/23.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit
import Photos

class AssetPickerViewController: UIViewController {

    var dismissHandler: RelayCommand?
    
    var selectionHandler: ((_ assets: [MediaAsset]) -> Void)?
    
    var enableOrigin: Bool = true
    
    private var collectionView: UICollectionView!
    
    private var dataSource: [MediaAsset] = []
    
    private var bottomBar: AssetPickerBottomBar!
    
    private(set) var selectedIndexPathList: [IndexPath] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        configureNavigationBar()
        setupCollectionView()
        setupBottomBar()
        requestAuthorizationAndLoadPhotos()
    }
    
    private func requestAuthorizationAndLoadPhotos() {
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
    
    private func setupCollectionView() {
        let spacing: CGFloat = 4.0
        let numberOfItemsInRow: Int = 4
        var itemWidth = (Constants.screenWidth - CGFloat(numberOfItemsInRow + 1) * spacing)/CGFloat(numberOfItemsInRow)
        itemWidth = CGFloat(floorf(Float(itemWidth)))
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = true
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(AssetPickerCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(AssetPickerCollectionViewCell.self))
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        view.addSubview(collectionView)
    }
    
    private func setupBottomBar() {
        let frame = CGRect(x: 0, y: 0, width: Constants.screenWidth, height: 45 + Constants.bottomInset)
        bottomBar = AssetPickerBottomBar(frame: frame)
        bottomBar.previewHandler = {
            
        }
        bottomBar.sendHandler = { [weak self] in
            self?.sendAssets()
        }
        view.addSubview(bottomBar)
    }
    
    private func sendAssets() {
        let selectedAssets = selectedIndexPathList.map { return dataSource[$0.row] }
        selectionHandler?(selectedAssets)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        bottomBar.frame.origin.y = view.bounds.height - bottomBar.bounds.height
    }
    
    private func loadPhotos() {
        var temp: [MediaAsset] = []
        
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        let result = PHAsset.fetchAssets(with: options)
        result.enumerateObjects { (asset, _, _) in
            temp.append(MediaAsset(asset: asset))
        }
        dataSource = temp
        collectionView.reloadData()
        
        if dataSource.count > 0 {
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: self.dataSource.count - 1, section: 0)
                self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: false)
            }
            
        }
    }

    private func configureNavigationBar() {
        navigationItem.title = "相机胶卷"
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelButtonClicked))
    }
    
    private func updateSelection(at indexPath: IndexPath) {
    
        let mediaAsset = dataSource[indexPath.row]
        if mediaAsset.selected {
            selectedIndexPathList.append(indexPath)
        } else {
            mediaAsset.index = -1
            if let index = selectedIndexPathList.firstIndex(where: { $0 == indexPath }) {
                selectedIndexPathList.remove(at: index)
            }
        }
        for (index, item) in selectedIndexPathList.enumerated() {
            let asset = dataSource[item.row]
            asset.index = index + 1
        }
        collectionView.reloadItems(at: selectedIndexPathList)
        bottomBar.updateButtonEnabled(selectedIndexPathList.count > 0)
    }
}

// Event Handlers
extension AssetPickerViewController {
    
    @objc private func cancelButtonClicked() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension AssetPickerViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let asset = dataSource[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(AssetPickerCollectionViewCell.self), for: indexPath) as! AssetPickerCollectionViewCell
        cell.update(mediaAsset: asset)
        cell.selectionHandler = { [weak self] in
            self?.updateSelection(at: indexPath)
        }
        cell.parent = self
        return cell
    }
}


