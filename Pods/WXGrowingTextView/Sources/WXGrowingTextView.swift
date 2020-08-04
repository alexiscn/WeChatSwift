//
//  WXGrowingTextView.h
//  WXGrowingTextView
//
//  Created by xu.shuifeng on 2020/6/9.
//  Copyright © 2020 alexiscn. All rights reserved.
//

import UIKit

/// A scrollable, multiline, auto growing text view.
open class WXGrowingTextView: UIView {
    
    /// The receiver’s delegate.
    public weak var delegate: WXGrowingTextViewDelegate?
    
    /// The internal text view inside `WXGrowingTextView`.
    public var internalTextView: WXTextViewInternal { return textView }
    
    /// The private internal text view.
    private lazy var textView: WXTextViewInternal = {
        let textView = WXTextViewInternal()
        return textView
    }()
    
    /// The min height of the text view. By default is 0, which will calculated by text view.
    open var minHeight: CGFloat = 0 {
        didSet {
            minNumberOfLines = 0
        }
    }
    
    /// The max height of the text view.
    open var maxHeight: CGFloat? = nil {
        didSet {
            maxNumberOfLines = 0
        }
    }
    
    /// A Boolean value indicating whether the receiver is allow the animate the growing change.
    open var isGrowingAnimationEnabled = true
    
    /// The duration of height growing animation. 0.1 by default.
    open var growingAnimationDuration: TimeInterval = 0.1
    
    /// The max number of lines. The default value is 5.
    open var maxNumberOfLines: Int = 5 {
        didSet {
            updateMaxNumberOfLines()
        }
    }
    
    /// The min number of lines. The default value is 1.
    open var minNumberOfLines: Int = 1 {
        didSet {
            updateMinNumberOfLines()
        }
    }
    
    /// The content inset.
    open var contentInset: UIEdgeInsets = .zero {
        didSet {
            let lineFragmentPadding = textView.textContainer.lineFragmentPadding
            var rect = self.frame
            rect.origin.x = contentInset.left - lineFragmentPadding
            rect.origin.y = contentInset.top - contentInset.bottom
            rect.size.width = rect.size.width - contentInset.left - contentInset.right - 2 * lineFragmentPadding
            rect.size.height = rect.size.height - contentInset.top - contentInset.bottom
            textView.frame = rect
            updateMaxNumberOfLines()
            updateMinNumberOfLines()
        }
    }
    
    open var textContainerInset: UIEdgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0) {
        didSet {
            textView.textContainerInset = textContainerInset
            textView.setNeedsDisplay()
        }
    }
    
    /// The background of the text view.
    public override var backgroundColor: UIColor? {
        didSet {
            textView.backgroundColor = backgroundColor
        }
    }
    
    /// The current selection range of the receiver.
    open var selectedRange: NSRange {
        get { return textView.selectedRange }
        set { textView.selectedRange = newValue }
    }
    
    /// Scrolls the receiver until the text in the specified range is visible.
    open func scrollRangeToVisible(_ range: NSRange) {
        textView.scrollRangeToVisible(range)
    }
    
    open var attributedText: NSAttributedString? {
        get { return textView.attributedText }
        set {
            textView.attributedText = newValue
            textViewDidChange(textView)
        }
    }
    
    open var isScrollEnabled: Bool {
        get { return textView.isScrollEnabled }
        set { textView.isScrollEnabled = newValue }
    }
    
    /// A Boolean value that indicates whether the text-entry objects has any text.
    public var hasText: Bool { return textView.hasText }
    
    public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame)
        commonInit(textContainer: textContainer)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit(textContainer: NSTextContainer? = nil) {
        
        var rect = self.frame
        rect.origin.x = 0
        rect.origin.y = 0
        textView = WXTextViewInternal(frame: rect, textContainer: textContainer)
        textView.delegate = self
        textView.isScrollEnabled = false
        textView.showsHorizontalScrollIndicator = false
        textView.font = font
        textView.contentInset = .zero
        textView.textContainerInset = textContainerInset
        textView.text = "-"
        textView.contentMode = .redraw
        addSubview(textView)
        
        minHeight = textView.frame.size.height
        minNumberOfLines = 1
        maxNumberOfLines = 5
        textView.text = ""
        contentInset = .zero
        
        maxNumberOfLines = 5
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        var rect = bounds
        rect.origin.y = 0
        rect.origin.x = contentInset.left
        rect.size.width = rect.width - contentInset.left - contentInset.right
        textView.frame = rect
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = size
        if text?.count == 0 {
            size.height = minHeight
        }
        return size
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        textView.becomeFirstResponder()
    }
    
    public override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        return textView.becomeFirstResponder()
    }
    
    public override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        return textView.resignFirstResponder()
    }
    
    public override var isFirstResponder: Bool {
        return textView.isFirstResponder
    }
}

// MARK: - Public Properties
extension WXGrowingTextView {
    
    /// The text displayed by the text view.
    open var text: String? {
        get { return textView.text }
        set {
            textView.text = newValue
            textViewDidChange(textView)
        }
    }
    
    /// The font of the text.
    open var font: UIFont? {
        get { return textView.font }
        set { textView.font = newValue }
    }
    
    /// The color of the text.
    open var textColor: UIColor? {
        get { return textView.textColor }
        set { textView.textColor = newValue }
    }
    
    /// A Boolean value indicating whether the receiver is editable.
    open var isEditable: Bool {
        get { return textView.isEditable }
        set { textView.isEditable = newValue }
    }
    
    /// The types of data converted to tappable URLs in the text view.
    ///
    /// You can use this property to specify the types of data (phone numbers, http links, and so on) that should be automatically converted to URLs in the text view.
    /// When tapped, the text view opens the application responsible for handling the URL type and passes it the URL. Note that data detection does not occur if the text view's isEditable property is set to true.
    open var dataDetectorTypes: UIDataDetectorTypes {
        get { return textView.dataDetectorTypes }
        set { textView.dataDetectorTypes = newValue }
    }
    
    /// The technique to use for aligning the text.
    open var textAlignment: NSTextAlignment {
        get { return textView.textAlignment }
        set { textView.textAlignment = newValue }
    }
    
    /// The keyboard style associated with the text object.
    open var keyboardType: UIKeyboardType {
        get { return textView.keyboardType }
        set { textView.keyboardType = newValue }
    }
    
    /// The visible title of the Return key.
    open var returnKeyType: UIReturnKeyType {
        get { return textView.returnKeyType }
        set { textView.returnKeyType = newValue }
    }
    
    /// The text of the placeholder
    open var placeholder: String? {
        get { return textView.placeholder }
        set { textView.placeholder = newValue }
    }
    
    /// The color of the placeholder
    open var placeholderColor: UIColor {
        get { return textView.placeholderColor }
        set { textView.placeholderColor = newValue }
    }
    
    /// The text font of the placeholder.  The default value is UIFont.systemFont(ofSize: 15) .
    open var placeholderFont: UIFont {
        get { return textView.placeholderFont }
        set { textView.placeholderFont = newValue }
    }
}

// MARK: - UITextViewDelegate
extension WXGrowingTextView: UITextViewDelegate {
    
    public func textViewDidChangeSelection(_ textView: UITextView) {
     
        delegate?.growingTextViewDidChangeSelection?(self)
    }
    
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return delegate?.growingTextViewShouldBeginEditing?(self) ?? true
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        
        delegate?.growingTextViewDidBeginEditing?(self)
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if !hasText && text == "" {
            return false
        }
        
        if let shouldChange = delegate?.growingTextView?(self, shouldChangeTextIn: range, replacementText: text) {
            return shouldChange
        }
        
        if text == "\n" {
            if let shouldReturn = delegate?.growingTextViewShouldReturn?(self) {
                return shouldReturn
            } else {
                textView.resignFirstResponder()
                return false
            }
        }
        
        return true
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        refreshHeight()
        delegate?.growingTextViewDidChange?(self)
    }
}

// MARK: - Private works
extension WXGrowingTextView {
    
    private func refreshHeight() {
        var newHeight = measureHeight()
        if newHeight < minHeight || !textView.hasText {
            newHeight = minHeight // not smalles than minHeight
        } else if let maxHeight = self.maxHeight, newHeight > maxHeight {
            newHeight = maxHeight // not taller than maxHeight
        }
        
        // If need change height
        if textView.frame.height != newHeight {
            
            if let maxH = maxHeight, newHeight >= maxH {
                if !textView.isScrollEnabled {
                    textView.isScrollEnabled = true
                    textView.flashScrollIndicators()
                }
            } else {
                textView.isScrollEnabled = false
            }
            
            if isGrowingAnimationEnabled {
                UIView.animate(withDuration: growingAnimationDuration, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
                    self.resizeTextView(to: newHeight)
                }) { [weak self] _ in
                    if let self = self {
                        self.delegate?.growingTextView?(self, didChangeHeight: newHeight)
                    }
                }
            } else {
                resizeTextView(to: newHeight)
                delegate?.growingTextView?(self, didChangeHeight: newHeight)
            }
        }
        let wasDisplayingPlaceholder = textView.displayPlaceholder
        textView.displayPlaceholder = textView.text.count == 0
        if wasDisplayingPlaceholder != textView.displayPlaceholder {
            textView.setNeedsDisplay()
        }
    }
    
    private func measureHeight() -> CGFloat {
        if self.responds(to: #selector(snapshotView(afterScreenUpdates:))) {
            let size = textView.sizeThatFits(textView.frame.size)
            return ceil(size.height)
        } else {
            return textView.contentSize.height
        }
    }
    
    private func resizeTextView(to newHeight: CGFloat) {
        delegate?.growingTextView?(self, willChangeHeight: newHeight)
        
        var rect = self.frame
        rect.size.height = newHeight
        self.frame = rect
        
        rect.origin.x = contentInset.left
        rect.origin.y = contentInset.top - contentInset.bottom
        
        if rect != textView.frame {
            textView.frame = rect
        }
    }
    
    private func updateMaxNumberOfLines() {
        
        // The number is invalided.
        if maxNumberOfLines < 0 {
            return
        }
        // The user specified a maxHeight themselves.
        if let maxH = maxHeight, maxH > 0 && maxNumberOfLines == 0 {
            return
        }
        maxHeight = heightForNumberOfLines(maxNumberOfLines)
    }
    
    private func updateMinNumberOfLines() {
        // The number is invalided.
        if minNumberOfLines < 0 {
            return
        }
        // The user specified a minHeight themselves.
        if minNumberOfLines <= 0 && minHeight > 0 {
            return
        }
        minHeight = heightForNumberOfLines(minNumberOfLines)
    }
    
    private func heightForNumberOfLines(_ numberOfLines: Int)  -> CGFloat {
        
        let savedText = textView.text
        textView.delegate = nil
        textView.isHidden = true
        
//        var tempText = "-"
//        if numberOfLines > 0 {
//            for _ in 1 ..< numberOfLines {
//                tempText.append("\n|W|")
//            }
//        }
//        textView.text = tempText
        textView.text = String(repeating: "|W|\n", count: numberOfLines).appending("|W|")
        let height = measureHeight()
        
        textView.text = savedText
        textView.delegate = self
        textView.isHidden = false
        
        sizeToFit()
        
        return height
    }

}
