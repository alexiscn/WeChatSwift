//
//  AlbumPickerTableViewCell.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/23.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit
import Photos

class AlbumPickerTableViewCell: UITableViewCell {
    
    private let headImageView: UIImageView
    
    private let nameLabel: UILabel
    
    private let numberLabel: UILabel
    
    private var album: AlbumPickerModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        headImageView = UIImageView()
        headImageView.contentMode = .scaleAspectFill
        headImageView.clipsToBounds = true
        
        nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        nameLabel.textColor = .black
        
        numberLabel = UILabel()
        numberLabel.font = UIFont.systemFont(ofSize: 17)
        numberLabel.textColor = UIColor(white: 0.5, alpha: 1)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(headImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(numberLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let maxSize = CGSize(width: .greatestFiniteMagnitude, height: bounds.height)
        headImageView.frame = CGRect(x: 0, y: 0, width: bounds.height, height: bounds.height)
        
        if let name = album?.name {
            let size = (name as NSString).boundingRect(with: maxSize, options: .usesFontLeading, attributes: [.font: UIFont.systemFont(ofSize: 17, weight: .semibold)], context: nil).size
            nameLabel.frame = CGRect(x: 65, y: 0, width: size.width, height: bounds.height)
        }
        
        if let count = album?.count {
            let text = "(\(count))"
            let size = (text as NSString).boundingRect(with: maxSize, options: .usesFontLeading, attributes: [.font: UIFont.systemFont(ofSize: 17)], context: nil).size
            
            numberLabel.frame = CGRect(x: nameLabel.frame.maxX + 8, y: 0, width: size.width, height: bounds.height)
        }
    }
 
    func update(_ album: AlbumPickerModel) {
        self.album = album
        nameLabel.text = album.name
        numberLabel.text = "(\(album.count))"
        
        if let asset = album.coverAsset {
            let size = bounds.size
            let options = PHImageRequestOptions()
            options.isNetworkAccessAllowed = true
            PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: nil) { [weak self] (image, _) in
                DispatchQueue.main.async {
                    self?.headImageView.image = image
                }
            }
        } else {
            // Display Default Album Cover
        }
        
    }
}
