//
//  PhotoBrowserDataSource.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/17.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

protocol PhotoBrowserDataSource: UICollectionViewDataSource {
    
    var browser: PhotoBrowserViewController? { get set }
    
}
