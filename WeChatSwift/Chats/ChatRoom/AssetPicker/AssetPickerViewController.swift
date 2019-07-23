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
    
    private var collectionView: UICollectionView!
    
    private var dataSource: [MediaAsset] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        configureNavigationBar()
        setupCollectionView()
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
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(AssetPickerCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(AssetPickerCollectionViewCell.self))
        view.addSubview(collectionView)
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
    
    @objc private func cancelButtonClicked() {
        dismiss(animated: true, completion: nil)
    }

}

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
        return cell
    }
}


