//
//  WXScrollActionSheetItemView.swift
//  WXActionSheet
//
//  Created by xushuifeng on 2020/7/23.
//

import UIKit

public protocol WXScrollActionSheetItemViewDelegate: class {
    
    func scrollActionSheetItemView(_ itemView: WXScrollActionSheetItemView,
                                   didTappedWithItem item: WXScrollActionSheetItem)
    
}

public class WXScrollActionSheetItemView: UIView {
    
    public weak var delegate: WXScrollActionSheetItemViewDelegate?
    
    public var item: WXScrollActionSheetItem?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        addGestureRecognizer(tap)
    }
    
    @objc func onTap() {
        guard let item = item else {
            return
        }
        delegate?.scrollActionSheetItemView(self, didTappedWithItem: item)
    }
    
    func reloadData() {
        
    }
}
