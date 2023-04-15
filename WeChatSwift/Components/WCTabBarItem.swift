//
//  WCTabBarItem.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/7/17.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

class WCTabBarItem: UITabBarItem {
    
    var contentView: WCTabBarContentView?
    
    override var title: String? { didSet { contentView?.title = title } }
    
    override var image: UIImage? { didSet { contentView?.image = image } }
    
    override var selectedImage: UIImage? { didSet { contentView?.selectedImage = selectedImage } }
    
    override var badgeValue: String? {
        get { return contentView?.badgeValue }
        set { contentView?.badgeValue = newValue }
    }
    
    override var badgeColor: UIColor? {
        get { return contentView?.badgeColor }
        set { contentView?.badgeColor = newValue }
    }
    
    override var tag: Int {
        didSet { contentView?.tag = tag }
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

class WCTabBarContentView: UIView {
    
    var title: String?
    
    var image: UIImage?
    
    var selectedImage: UIImage?
    
    var badgeValue: String? {
        didSet {
            
        }
    }
    
    var badgeColor: UIColor? {
        didSet {
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class WCTabBarItemBadgeView: UIView {
    
    var badgeColor: UIColor? = UIColor(red: 1.0, green: 59.0/255, blue: 48.0/255, alpha: 1.0) {
        didSet {
            imageView.backgroundColor = badgeColor
        }
    }
    
    var badge: Badge = .none {
        didSet {
            switch badge {
            case .text(let value):
                badgeLabel.text = value
            default:
                break
            }
            setNeedsLayout()
        }
    }
    
    let imageView: UIImageView
    
    let badgeLabel: UILabel
    
    override init(frame: CGRect) {
        
        imageView = UIImageView(frame: .zero)
        
        badgeLabel = UILabel(frame: .zero)
        badgeLabel.backgroundColor = .clear
        badgeLabel.textColor = .white
        badgeLabel.font = UIFont.systemFont(ofSize: 13)
        badgeLabel.textAlignment = .center
        
        super.init(frame: frame)
        
        addSubview(imageView)
        addSubview(badgeLabel)
        
        imageView.backgroundColor = badgeColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switch badge {
        case .none:
            imageView.isHidden = true
            badgeLabel.isHidden = true
        case .text(_):
            imageView.isHidden = false
            badgeLabel.isHidden = false
            badgeLabel.sizeToFit()
            badgeLabel.center = imageView.center
            imageView.frame = bounds
        case .dot:
            imageView.isHidden = false
            badgeLabel.isHidden = true
            imageView.frame = CGRect(x: (bounds.size.width - 8.0) / 2.0, y: (bounds.size.height - 8.0) / 2.0, width: 8.0, height: 8.0)
            badgeLabel.sizeToFit()
            badgeLabel.center = imageView.center
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        switch badge {
        case .none:
            return CGSize(width: 18.0, height: 18.0)
        default:
            let textSize = badgeLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
            return CGSize(width: max(18.0, textSize.width + 10.0), height: 18.0)
        }
    }
}

enum Badge {
    case none
    case text(String)
    case dot
}
