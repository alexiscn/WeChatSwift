//
//  WCWebViewDelegate.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/29.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import WebKit

protocol WCWebViewDelegate: class {
    
    var allowInlineMediaPlay: Bool { get }

    func webView(_ webView: WCWebView, didFinishLoad navigation: WKNavigation)
}


extension WCWebViewDelegate {
    var allowInlineMediaPlay: Bool { return false }

}
