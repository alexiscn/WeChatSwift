//
//  WXGrowingTextViewDelegate.swift
//  WXGrowingTextView
//
//  Created by xu.shuifeng on 2020/6/9.
//

import UIKit

@objc public protocol WXGrowingTextViewDelegate: class {
    
    /// Asks the delegate if editing should begin in the specified text view.
    /// - Parameter growingTextView: The text view for which editing is about to begin.
    @objc optional func growingTextViewShouldBeginEditing(_ growingTextView: WXGrowingTextView) -> Bool
    
    /// Tells the delegate that editing of the specified text view has begun.
    /// - Parameter growingTextView: The text view in which editing began.
    @objc optional func growingTextViewDidBeginEditing(_ growingTextView: WXGrowingTextView)
    
    /// Asks the delegate if editing should stop in the specified text view.
    /// - Parameter growingTextView: The text view for which editing is about to end.
    @objc optional func growingTextViewShouldEndEditing(_ growingTextView: WXGrowingTextView) -> Bool
    
    /// Tells the delegate that editing of the specified text view has ended.
    /// - Parameter growingTextView: The text view in which editing ended.
    @objc optional func growingTextViewDidEndEditing(_ growingTextView: WXGrowingTextView)
    
    /// Asks the delegate whether the specified text should be replaced in the text view.
    /// - Parameters:
    ///   - growingTextView: The text view containing the changes.
    ///   - range: The current selection range. If the length of the range is 0, range reflects the current insertion point. If the user presses the Delete key, the length of the range is 1 and an empty string object replaces that single character.
    ///   - text: The text to insert.
    @objc optional func growingTextView(_ growingTextView: WXGrowingTextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    
    /// Tells the delegate that the text or attributes in the specified text view were changed by the user.
    /// - Parameter growingTextView: The text view containing the changes.
    @objc optional func growingTextViewDidChange(_ growingTextView: WXGrowingTextView)
    
    /// Tells the delegate that the text selection changed in the specified text view.
    /// - Parameter growingTextView: The text view whose selection changed.
    @objc optional func growingTextViewDidChangeSelection(_ growingTextView: WXGrowingTextView)
    
    /// Tells the delegate if should return in the specified text view.
    /// - Parameter growingTextView: The text view is about to return.
    @objc optional func growingTextViewShouldReturn(_ growingTextView: WXGrowingTextView) -> Bool
    
    /// Tells the delegate that the text view is about to change height.
    /// - Parameters:
    ///   - growingTextView: The text view for which height is about to change.
    ///   - height: The height which text view will be changed to.
    @objc optional func growingTextView(_ growingTextView: WXGrowingTextView, willChangeHeight height: CGFloat)
        
    /// Tells the delegate that height of the specified text view has changed.
    /// - Parameters:
    ///   - growingTextView: The text view in which height changed.
    ///   - height: The height which text view changed to.
    @objc optional func growingTextView(_ growingTextView: WXGrowingTextView, didChangeHeight height: CGFloat)
}
