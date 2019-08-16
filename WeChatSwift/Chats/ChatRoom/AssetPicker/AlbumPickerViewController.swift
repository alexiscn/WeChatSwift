//
//  AlbumPickerViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/23.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit
import Photos

class AlbumPickerViewController: UIViewController {

    private var tableView: UITableView!
    
    private var dataSource: [AlbumPickerModel] = []
    
    var selectionHandler: ((_ assets: [MediaAsset]) -> Void)?
    
    private let configuration: AssetPickerConfiguration
    
    init(configuration: AssetPickerConfiguration) {
        self.configuration = configuration
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        setupTableView()
        loadAlbums()
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.register(AlbumPickerTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(AlbumPickerTableViewCell.self))
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "照片"
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelButtonClicked))
    }
    
    @objc private func cancelButtonClicked() {
        dismiss(animated: true, completion: nil)
    }

    private func loadAlbums() {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        let result = PHAsset.fetchAssets(with: options)
        var cameraAssets: [PHAsset] = []
        result.enumerateObjects { (asset, _, _) in
            cameraAssets.append(asset)
        }
        let cameraCollection = PHAssetCollection.transientAssetCollection(with: cameraAssets, title: "相机胶卷")
        let cameraRollAlbum = AlbumPickerModel(assetCollection: cameraCollection, coverAsset: cameraAssets.last, name: "相机胶卷", count: cameraAssets.count)
    
        dataSource.append(cameraRollAlbum)
        dataSource.append(contentsOf: loadAlbum(type: .smartAlbum))
        dataSource.append(contentsOf: loadAlbum(type: .album))
        
    }
    
    private func loadAlbum(type: PHAssetCollectionType) -> [AlbumPickerModel] {
        var result: [AlbumPickerModel] = []
        let collections = PHAssetCollection.fetchAssetCollections(with: type, subtype: .any, options: nil)
        collections.enumerateObjects { (collection, _, _) in
            
            let options = PHFetchOptions()
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            let assets = PHAsset.fetchAssets(in: collection, options: options)
            let count = assets.count
            
            if count > 0 {
                let name = collection.localizedTitle
                let cover = assets.lastObject
                result.append(AlbumPickerModel(assetCollection: collection, coverAsset: cover, name: name, count: count))
            }
        }
        return result
    }
}

extension AlbumPickerViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let album = dataSource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(AlbumPickerTableViewCell.self), for: indexPath) as! AlbumPickerTableViewCell
        cell.update(album)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let album = dataSource[indexPath.row]
        let assetPickerVC = AssetPickerViewController(configuration: configuration, assetCollection: album.assetCollection)
        assetPickerVC.selectionHandler = selectionHandler
        navigationController?.pushViewController(assetPickerVC, animated: true)
    }
}


struct AlbumPickerModel {
    
    var assetCollection: PHAssetCollection
    
    var coverAsset: PHAsset?
    
    var name: String?
    
    var count: Int
}
