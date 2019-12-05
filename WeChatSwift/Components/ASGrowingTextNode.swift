//
//  ASGrowingTextNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/12/5.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit

@objc public protocol ASGrowingTextNodeDelegate: class {
    
    @objc optional func growingTextViewShouldBeginEditing(_ growingTextView: ASGrowingTextNodeView) -> Bool
    
    @objc optional func growingTextViewShouldEndEditing(_ growingTextView: ASGrowingTextNodeView) -> Bool

    @objc optional func growingTextViewDidBeginEditing(_ growingTextView: ASGrowingTextNodeView)
    
    @objc optional func growingTextViewDidEndEditing(_ growingTextView: ASGrowingTextNodeView)

    @objc optional func growingTextView(_ growingTextView: ASGrowingTextNodeView,
                                        shouldChangeTextInRange range: NSRange,
                                        replacementText text: String) -> Bool
    
    @objc optional func growingTextViewDidChange(_ growingTextView: ASGrowingTextNodeView)
    
    @objc optional func growingTextViewDidChangeSelection(_ growingTextView: ASGrowingTextNodeView)

    @objc optional func growingTextView(_ growingTextView: ASGrowingTextNodeView,
                                        willChangeHeight height: CGFloat,
                                        difference: CGFloat)
    
    @objc optional func growingTextView(_ growingTextView: ASGrowingTextNodeView,
                                        didChangeHeight height: CGFloat,
                                        difference: CGFloat)

    @objc optional func growingTextViewShouldReturn(_ growingTextView: ASGrowingTextNodeView) -> Bool
}

public class ASGrowingTextNode: ASDisplayNode {
    
}

public class ASGrowingTextNodeView: UIView {
    
    public weak var delegate: ASGrowingTextNodeDelegate?
    
    public var internalTextView: UITextView {
        return textView
    }
    
    public var maxNumberOfLines: Int? {
        willSet {
            if let newValue = newValue {
                assert(newValue >= 0, "MaxNumberOfLines of growingTextView must be no less than 0.")
            }
        }
        didSet {
            updateMaxHeight()
        }
    }
    public var minNumberOfLines: Int? {
        willSet {
            if let newValue = newValue {
                assert(newValue >= 0, "MinNumberOfLines of growingTextView must be no less than 0.")
            }
        }
        didSet {
            updateMinHeight()
        }
    }
    
    public var maxHeight: CGFloat? {
        willSet {
            if let newValue = newValue {
                assert(newValue >= 0, "MaxHeight of growingTextView must be no less than 0.")
            }
        }
    }
    
    public var minHeight: CGFloat = 0 {
        willSet {
            assert(newValue >= 0, "MinHeight of growingTextView must be no less than 0.")
        }
    }
    /// A Boolean value that determines whether growing animations are enabled.
    ///
    /// The default value of this property is true.
    public var isGrowingAnimationEnabled = true
    
    /// The time duration of text view's growing animation.
    ///
    /// The default value of this property is 0.1.
    public var animationDuration: TimeInterval = 0.1
    
    /// The inset of the text view.
    ///
    /// The default value of this property is (top: 8, left: 5, bottom: 8, right: 5).
    public var contentInset = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5) {
        didSet {
            updateTextViewFrame()
            updateMaxHeight()
            updateMinHeight()
        }
    }
    
    /// A Boolean value that determines whether scrolling is enabled.
    ///
    /// If the value of this property is true, scrolling is enabled, and if it is false, scrolling is disabled. The default is false.
    public var isScrollEnabled = false {
        didSet {
            textView.isScrollEnabled = isScrollEnabled
        }
    }
    
    /// A Boolean value that determines whether to display a placeholder when the text is empty.
    ///
    /// The default value of this property is true.
    public var isPlaceholderEnabled = true {
        didSet {
            textView.shouldDisplayPlaceholder = textView.text.isEmpty && isPlaceholderEnabled
        }
    }
    
    /// An attributed string that displays when there is no other text in the text view.
    public var placeholder: NSAttributedString? {
        get { return textView.placeholder }
        set { textView.placeholder = newValue }
    }
    
    /// A Boolean value that determines whether to display the caret.
    ///
    /// The default value of this property is false.
    public var isCaretHidden = false {
        didSet { textView.isCaretHidden = isCaretHidden }
    }

    // MARK: - UITextView properties
    /// The text displayed by the text view.
    public var text: String? {
        get { return textView.text }
        set {
            textView.text = newValue
            updateHeight()
        }
    }
    
    /// The font of the text.
    public var font: UIFont? {
        get { return textView.font }
        set {
            textView.font = newValue
            updateMaxHeight()
            updateMinHeight()
        }
    }
    
    /// The color of the text.
    ///
    /// This property applies to the entire text string. The default text color is black.
    public var textColor: UIColor? {
        set { textView.textColor = newValue }
        get { return textView.textColor }
    }
    
    /// The technique to use for aligning the text.
    ///
    /// This property applies to the entire text string. The default value of this property is NSTextAlignment.left.
    public var textAlignment: NSTextAlignment {
        set { textView.textAlignment = newValue }
        get { return textView.textAlignment }
    }
    
    /// A Boolean value indicating whether the receiver is editable.
    ///
    /// The default value of this property is true.
    public var isEditable: Bool {
        set { textView.isEditable = newValue }
        get { return textView.isEditable }
    }
    
    /// The current selection range of the receiver.
    public var selectedRange: NSRange? {
        get { return textView.selectedRange }
        set {
            if let newValue = newValue {
                textView.selectedRange = newValue
            }
        }
    }
    
    /// The types of data converted to clickable URLs in the text view.
    ///
    /// You can use this property to specify the types of data (phone numbers, http links, and so on) that should be automatically converted to clickable URLs in the text view. When clicked, the text view opens the application responsible for handling the URL type and passes it the URL.
    public var dataDetectorTypes: UIDataDetectorTypes {
        set { textView.dataDetectorTypes = newValue }
        get { return textView.dataDetectorTypes }
    }
    
    /// The visible title of the Return key.
    ///
    /// Setting this property to a different key type changes the visible title of the Return key and typically results in the keyboard being dismissed when it is pressed. The default value for this property is UIReturnKeyType.default.
    public var returnKeyType: UIReturnKeyType {
        set { textView.returnKeyType = newValue }
        get { return textView.returnKeyType }
    }
    
    /// The keyboard style of the text view.
    ///
    /// Text view can be targeted for specific types of input, such as plain text, email, numeric entry, and so on. The keyboard style identifies what keys are available on the keyboard and which ones appear by default. The default value for this property is UIKeyboardType.default.
    public var keyboardType: UIKeyboardType {
        set { textView.keyboardType = newValue }
        get { return textView.keyboardType }
    }
    
    /// A Boolean value indicating whether the Return key is automatically enabled when the user is entering text.
    ///
    /// The default value for this property is false. If you set it to true, the keyboard disables the Return key when the text entry area contains no text. As soon as the user enters some text, the Return key is automatically enabled.
    public var enablesReturnKeyAutomatically: Bool {
        set { textView.enablesReturnKeyAutomatically = newValue }
        get { return textView.enablesReturnKeyAutomatically }
    }
    
    /// A Boolean value indicating whether the text view currently contains any text.
    public var hasText: Bool { return textView.hasText }

    // MARK: - Private properties
    fileprivate var textView: ASGrowingInternalTextView = {
        let textView = ASGrowingInternalTextView(frame: .zero)
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 1 // 1 pixel for caret
        textView.showsHorizontalScrollIndicator = false
        textView.contentInset = .zero
        textView.contentMode = .redraw
        return textView
    }()

    // MARK: - Initialization
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public func scrollRangeToVisible(_ range: NSRange) {
        textView.scrollRangeToVisible(range)
    }

    public func calculateHeight() -> CGFloat {
        return ceil(textView.sizeThatFits(textView.frame.size).height + contentInset.top + contentInset.bottom)
    }

    public func updateHeight() {
        let updatedHeightInfo = updatedHeight()
        let newHeight = updatedHeightInfo.newHeight
        let difference = updatedHeightInfo.difference

        if difference != 0 {
            if newHeight == maxHeight {
                if !textView.isScrollEnabled {
                    textView.isScrollEnabled = true
                    textView.flashScrollIndicators()
                }
            } else {
                textView.isScrollEnabled = isScrollEnabled
            }

            if isGrowingAnimationEnabled {
                UIView.animate(withDuration: animationDuration, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
                    self.updateGrowingTextView(newHeight: newHeight, difference: difference)
                    }, completion: { (_) in
                        self.delegate?.growingTextView?(self, didChangeHeight: newHeight, difference: difference)
                })
            } else {
                updateGrowingTextView(newHeight: newHeight, difference: difference)
                self.delegate?.growingTextView?(self, didChangeHeight: newHeight, difference: difference)
            }
        }

        updateScrollPosition(animated: false)
        textView.shouldDisplayPlaceholder = textView.text.isEmpty && isPlaceholderEnabled
    }
}

// MARK: - Overriding

extension ASGrowingTextNodeView {
    
    public override var backgroundColor: UIColor? {
        didSet { textView.backgroundColor = backgroundColor }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        updateTextViewFrame()
        updateMaxHeight()
        updateMinHeight()
        updateHeight()
    }

    public override func sizeThatFits(_ size: CGSize) -> CGSize {
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

// MARK: - Helper
extension ASGrowingTextNodeView {
    fileprivate func commonInit() {
        textView.frame = CGRect(origin: .zero, size: frame.size)
        textView.delegate = self
        minNumberOfLines = 1
        addSubview(textView)
    }

    fileprivate func updateTextViewFrame() {
        let lineFragmentPadding = textView.textContainer.lineFragmentPadding
        var textViewFrame = frame
        textViewFrame.origin.x = contentInset.left - lineFragmentPadding
        textViewFrame.origin.y = contentInset.top
        textViewFrame.size.width -= contentInset.left + contentInset.right - lineFragmentPadding * 2
        textViewFrame.size.height -= contentInset.top + contentInset.bottom
        textView.frame = textViewFrame
        textView.sizeThatFits(textView.frame.size)
    }

    fileprivate func updateGrowingTextView(newHeight: CGFloat, difference: CGFloat) {
        delegate?.growingTextView?(self, willChangeHeight: newHeight, difference: difference)
        frame.size.height = newHeight
        updateTextViewFrame()
    }

    fileprivate func updatedHeight() -> (newHeight: CGFloat, difference: CGFloat) {
        var newHeight = calculateHeight()
        if newHeight < minHeight || !hasText {
            newHeight = minHeight
        }
        if let maxHeight = maxHeight, newHeight > maxHeight {
            newHeight = maxHeight
        }
        let difference = newHeight - frame.height

        return (newHeight, difference)
    }

    fileprivate func heightForNumberOfLines(_ numberOfLines: Int) -> CGFloat {
        var text = "-"
        if numberOfLines > 0 {
            for _ in 1..<numberOfLines {
                text += "\n|W|"
            }
        }
        let textViewCopy: ASGrowingInternalTextView = textView.copy() as! ASGrowingInternalTextView
        textViewCopy.text = text
        let height = ceil(textViewCopy.sizeThatFits(textViewCopy.frame.size).height + contentInset.top + contentInset.bottom)
        return height
    }

    fileprivate func updateMaxHeight() {
        guard let maxNumberOfLines = maxNumberOfLines else {
            return
        }
        maxHeight = heightForNumberOfLines(maxNumberOfLines)
    }

    fileprivate func updateMinHeight() {
        guard let minNumberOfLines = minNumberOfLines else {
            return
        }
        minHeight = heightForNumberOfLines(minNumberOfLines)
    }

    fileprivate func updateScrollPosition(animated: Bool) {
        guard let selectedTextRange = textView.selectedTextRange else {
            return
        }
        let caretRect = textView.caretRect(for: selectedTextRange.end)
        let caretY = max(caretRect.origin.y + caretRect.height - textView.frame.height, 0)

        // Continuous multiple "\r\n" get an infinity caret rect, set it as the content offset will result in crash.
        guard caretY != CGFloat.infinity && caretY != CGFloat.greatestFiniteMagnitude else {
            print("Invalid caretY: \(caretY)")
            return
        }

        if animated {
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationBeginsFromCurrentState(true)
            textView.setContentOffset(CGPoint(x: 0, y: caretY), animated: false)
            UIView.commitAnimations()
        } else {
            textView.setContentOffset(CGPoint(x: 0, y: caretY), animated: false)
        }
    }
}

// MARK: - TextView delegate
extension ASGrowingTextNodeView: UITextViewDelegate {
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return delegate?.growingTextViewShouldBeginEditing?(self) ?? true
    }

    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return delegate?.growingTextViewShouldEndEditing?(self) ?? true
    }

    public func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.growingTextViewDidBeginEditing?(self)
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.growingTextViewDidEndEditing?(self)
    }

    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if !hasText && text == "" {
            return false
        }
        if let value = delegate?.growingTextView?(self, shouldChangeTextInRange: range, replacementText: text) {
            return value
        }

        if text == "\n" {
            if let value = delegate?.growingTextViewShouldReturn?(self) {
                return value
            } else {
                textView.resignFirstResponder()
                return false
            }
        }
        return true
    }

    public func textViewDidChange(_ textView: UITextView) {
        updateHeight()
        delegate?.growingTextViewDidChange?(self)
    }

    public func textViewDidChangeSelection(_ textView: UITextView) {
        let willUpdateHeight = updatedHeight().difference != 0
        if !willUpdateHeight {
            updateScrollPosition(animated: true)
        }
        delegate?.growingTextViewDidChangeSelection?(self)
    }
}

// MARK: - ASGrowingInternalTextView
class ASGrowingInternalTextView: UITextView, NSCopying {
    var placeholder: NSAttributedString? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var shouldDisplayPlaceholder = true {
        didSet {
            if shouldDisplayPlaceholder != oldValue {
                setNeedsDisplay()
            }
        }
    }
    
    var isCaretHidden = false
    
    fileprivate var isScrollEnabledTemp = false

    override var text: String! {
        willSet {
            // If one of GrowingTextView's superviews is a scrollView, and self.scrollEnabled is false, setting the text programatically will cause UIKit to search upwards until it finds a scrollView with scrollEnabled true, then scroll it erratically. Setting scrollEnabled temporarily to true prevents this.
            isScrollEnabledTemp = isScrollEnabled
            isScrollEnabled = true
        }
        didSet {
            isScrollEnabled = isScrollEnabledTemp
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let placeholder = placeholder, shouldDisplayPlaceholder else {
            return
        }
        let placeholderSize = sizeForAttributedString(placeholder)
        let xPosition: CGFloat = textContainer.lineFragmentPadding + textContainerInset.left
        let yPosition: CGFloat = (textContainerInset.top - textContainerInset.bottom) / 2
        let rect = CGRect(origin: CGPoint(x: xPosition, y: yPosition), size: placeholderSize)
        placeholder.draw(in: rect)
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let textView = ASGrowingInternalTextView(frame: frame)
        textView.isScrollEnabled = isScrollEnabled
        textView.shouldDisplayPlaceholder = shouldDisplayPlaceholder
        textView.isCaretHidden = isCaretHidden
        textView.placeholder = placeholder
        textView.text = text
        textView.font = font
        textView.textColor = textColor
        textView.textAlignment = textAlignment
        textView.isEditable = isEditable
        textView.selectedRange = selectedRange
        textView.dataDetectorTypes = dataDetectorTypes
        textView.returnKeyType = returnKeyType
        textView.keyboardType = keyboardType
        textView.enablesReturnKeyAutomatically = enablesReturnKeyAutomatically

        textView.textContainerInset = textContainerInset
        textView.textContainer.lineFragmentPadding = textContainer.lineFragmentPadding
        textView.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator
        textView.contentInset = contentInset
        textView.contentMode = contentMode

        return textView
    }
    
    private func sizeForAttributedString(_ attributedString: NSAttributedString) -> CGSize {
        let size = attributedString.size()
        return CGRect(origin: .zero, size: size).integral.size
    }
}
