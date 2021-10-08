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
    
    private var backgroundView: UIView!
    
    private var containerView: UIView!
    
    private var cancelButton: UIButton!
    
    public var titleView: UIView?
    
    public var title: String? = nil
    
    /// A String value indicating the title for the cancel button.
    public var cancelTitle: String? = NSLocalizedString("Cancel", comment: "")
    
    public var topItems: [WXScrollActionSheetItem] = []
    
    public var bottomItems: [WXScrollActionSheetItem] = []
    
    /// A Boolean value indicating whether dismiss self when click item. The default value is `true`.
    public var dismissOnClickItem: Bool = true
    
    fileprivate var safeInsets: UIEdgeInsets {
        return UIApplication.shared.keyWindow?.safeAreaInsets ?? .zero
    }
    
    public init(title: String = "", topItems: [WXScrollActionSheetItem] = [], bottomItems: [WXScrollActionSheetItem] = []) {
        self.title = title
        self.topItems = topItems
        self.bottomItems = bottomItems
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {

        backgroundView = UIView()
        backgroundView.alpha = 0.0
        addSubview(backgroundView)
        
        containerView = UIView()
        addSubview(containerView)
        
        titleLabel = UILabel()
        containerView.addSubview(titleLabel)
    }
    
    private func buildUI() {
        var offsetY: CGFloat = 0.0
        titleLabel.font = UIFont.systemFont(ofSize: 10)
        titleLabel.frame = CGRect(x: 10, y: 16.0, width: bounds.width - 20, height: 14.0)
        titleLabel.textColor = UIColor(white: 0, alpha: 0.5)
        titleLabel.text = title
        titleLabel.textAlignment = .center
        containerView.addSubview(titleLabel)

        let topScrollViewFrame = CGRect(x: 0, y: 54, width: bounds.width, height: 108)
        let topScrollView = WXActionSheetScrollView(items: topItems, frame: topScrollViewFrame)
        //topScrollView.itemDelegate = delegate
        containerView.addSubview(topScrollView)

        offsetY = 54.0 + 108.0

        if bottomItems.count > 0 {

            let separtorLine = UIView()
            separtorLine.frame = CGRect(x: 12.0, y: offsetY, width: bounds.width - 24.0, height: LineHeight)
            separtorLine.backgroundColor = UIColor(white: 0, alpha: 0.1)
            containerView.addSubview(separtorLine)

            offsetY += 15

            let bottomScrollViewFrame = CGRect(x: 0, y: offsetY, width: bounds.width, height: 108.0)
            let bottomScrollView = WXActionSheetScrollView(items: bottomItems, frame: bottomScrollViewFrame)
            //bottomScrollView.itemDelegate = delegate
            containerView.addSubview(bottomScrollView)
            offsetY += 108.0
        }

        offsetY += 15.0

        let cancelButton = UIButton(type: .custom)
        cancelButton.backgroundColor = .white
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(UIColor(white: 0, alpha: 0.9), for: .normal)
        containerView.addSubview(cancelButton)
        cancelButton.frame = CGRect(x: 0, y: offsetY, width: bounds.width, height: 56.0 + safeInsets.bottom)
        cancelButton.addTarget(self, action: #selector(handleCancelButtonClicked), for: .touchUpInside)

        offsetY += (56.0 + safeInsets.bottom)
        
        let bottomInset = safeInsets.bottom
        cancelButton.titleEdgeInsets = UIEdgeInsets(top: -bottomInset/2, left: 0, bottom: bottomInset/2, right: 0)

        containerView.frame = CGRect(x: 0, y: bounds.height, width: bounds.width, height: offsetY)

        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurView.frame = containerView.bounds
        containerView.addSubview(blurView)
        containerView.sendSubviewToBack(blurView)
    }
    
    public func show() {
        let windows = UIApplication.shared.windows.filter { NSStringFromClass($0.classForCoder) != "UIRemoteKeyboardWindow" }
        guard let win = windows.last else { return }
        buildUI()
        UIView.animate(withDuration: 0.1, animations: {
            win.addSubview(self)
        }) { _ in
            UIView.animate(withDuration: 0.3) {
                self.backgroundView.alpha = 1.0
                let y = self.bounds.height - self.containerView.frame.height
                self.containerView.frame.origin = CGPoint(x: 0, y: y)
            }
        }
    }
    
    public func dismiss(animated: Bool = true) {
        UIView.animate(withDuration: 0.25, animations: {
            self.backgroundView.alpha = 0.0
            let y = UIScreen.main.bounds.height
            self.containerView.frame.origin = CGPoint(x: 0, y: y)
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    public func reloadData() {
        
    }
    
    @objc private func handleCancelButtonClicked() {
        dismiss()
    }
}

// MARK: - UIGestureRecognizerDelegate
extension WXScrollActionSheet: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view == self.containerView {
            return false
        }
        return true
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

