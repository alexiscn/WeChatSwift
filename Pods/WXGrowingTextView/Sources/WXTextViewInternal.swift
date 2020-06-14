//
//  WXTextViewInternal.h
//  WXGrowingTextView
//
//  Created by xu.shuifeng on 2020/6/9.
//  Copyright © 2020 alexiscn. All rights reserved.
//

import UIKit

public class WXTextViewInternal: UITextView {
    
    private var isScrollEnabledTemp = false
    
    /// The text of the text view.
    public override var text: String! {
        willSet {
            // If one of GrowingTextView's superviews is a scrollView, and self.scrollEnabled is false,
            // setting the text programatically will cause UIKit to search upwards until it finds a scrollView with scrollEnabled true,
            // then scroll it erratically. Setting scrollEnabled temporarily to true prevents this.
            isScrollEnabledTemp = self.isScrollEnabled
            isScrollEnabled = true
        }
        didSet {
            isScrollEnabled = isScrollEnabledTemp
        }
    }
    
    /// A Boolean value indicating whether the receiver displays placeholder.
    public var displayPlaceholder: Bool = true {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The placeholder of text view.
    public var placeholder: String? = nil {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The color of the placeholder. The default value is UIColor.gray .
    public var placeholderColor: UIColor = .gray {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The font of the placeholder. The default value is UIFont.systemFont(ofSize: 15) .
    public var placeholderFont: UIFont = UIFont.systemFont(ofSize: 15)
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let placehoder = placeholder, displayPlaceholder else {
            return
        }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignment
        
        let size = (placehoder as NSString).size(withAttributes: [
            .font: placeholderFont
        ])
        let x = textContainer.lineFragmentPadding + textContainerInset.left
        let y = textContainerInset.top + contentInset.top
        let rect = CGRect(x: x, y: y, width: size.width, height: size.height)
        (placehoder as NSString).draw(in: rect, withAttributes: [
            .font: placeholderFont,
            .foregroundColor: placeholderColor,
            .paragraphStyle: paragraphStyle
        ])
    }
}
