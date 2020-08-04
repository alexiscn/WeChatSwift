//
//  WXScrollActionSheet.swift
//  WXActionSheet
//
//  Created by xushuifeng on 2020/6/19.
//

import UIKit

@objc public protocol WXScrollActionSheetDelegate: class {
    
    @objc optional func scrollActionSheet(_ scrollActionSheet: WXScrollActionSheet, didSelectItem item: WXScrollActionSheetItem)
    
    @objc optional func scrollActionSheetDidClickCancelButton(_ scrollActionSheet: WXScrollActionSheet)
    
    @objc optional func scrollActionSheetDidAppear(_ scrollActionSheet: WXScrollActionSheet)
    
    @objc optional func scrollActionSheetWillDisappear(_ scrollActionSheet: WXScrollActionSheet)
    
}

/// Scrollable ActionSheet.
public class WXScrollActionSheet: UIView {
    
    public weak var delegate: WXScrollActionSheetDelegate?
    
    public private(set) var titleLabel: UILabel!
    
    public private(set) var subTitleLabel: UILabel!
    
    private var containerView: UIView!
    
    private var bottomPaddingView: UIView!
    
    private var cancelButton: UIButton!
    
    /// A String value indicating the title for the cancel button.
    public var cancelTitle: String? = NSLocalizedString("Cancel", comment: "")
    
    /// A Boolean value indicating whether dismiss self when click item. The default value is `true`.
    public var dismissOnClickItem: Bool = true
    
    /// The background view. normally it is transparent.
    public private(set) var backgroundTappingView: UIView!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {

        containerView = UIView()
        
        titleLabel = UILabel()
        
        bottomPaddingView = UIView()
        
        containerView.addSubview(bottomPaddingView)
    }
    
    public func show() {
        
    }
    
    public func dismiss(animated: Bool = true) {
        
    }
    
    public func reloadData() {
        
    }
}

// MARK: - WXScrollActionSheetItemViewDelegate
extension WXScrollActionSheet: WXScrollActionSheetItemViewDelegate {
    
    public func scrollActionSheetItemView(_ itemView: WXScrollActionSheetItemView, didTappedWithItem item: WXScrollActionSheetItem) {
        if dismissOnClickItem {
            dismiss()
        }
        delegate?.scrollActionSheet?(self, didSelectItem: item)
    }
}

