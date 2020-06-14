//
//  MommentCommentInputView.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2020/6/13.
//  Copyright © 2020 alexiscn. All rights reserved.
//

import UIKit
import WXGrowingTextView

protocol MommentCommentInputView: class {
    
}

class MomentCommentInputView: UIView {
    
    private let textView: WXGrowingTextView
    
    private let emoticonButton: UIButton
    
    override init(frame: CGRect) {
        
        textView = WXGrowingTextView()
        textView.placeholder = "评论"
        
        emoticonButton = UIButton(type: .custom)
        
        super.init(frame: frame)
        
        addSubview(textView)
        addSubview(emoticonButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
