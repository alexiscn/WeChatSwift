//
//  WebViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/29.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    private let url: URL
    
    private var webView: WCWebView!
    private var progressBar: UIProgressView!
    private var addressLabel: UILabel!
    private var estimatedProgressObserver: NSObject?
    
    init(url: URL, presentModal: Bool = false, extraInfo: [String: Any] = [:]) {
        if url.scheme == nil {
            self.url = URL(string: "http://" + url.absoluteString)!
        } else {
            self.url = url
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("WebViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        
        setupAddressLabel()
        setupWebView()
        setupProgressBar()
        observeProgress()
    
        let request = URLRequest(url: url)
        webView.load(request)
        
        let moreButtonItem = UIBarButtonItem(image: Constants.moreImage, style: .done, target: self, action: #selector(moreButtonClicked))
        navigationItem.rightBarButtonItem = moreButtonItem
    }
    
    private func setupWebView() {
        let configuration = WKWebViewConfiguration()
        let javascript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
        let script = WKUserScript(source: javascript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let usercontroller = WKUserContentController()
        usercontroller.addUserScript(script)
        configuration.userContentController = usercontroller
        
        webView = WCWebView(frame: .zero, configuration: configuration)
        webView.delegate = self
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(webView)
        webView.scrollView.backgroundColor = .clear
    }
    
    private func setupAddressLabel() {
        addressLabel = UILabel()
        addressLabel.frame = CGRect(x: 10, y: 6, width: view.bounds.width - 20, height: 15)
        addressLabel.font = UIFont.systemFont(ofSize: 12)
        addressLabel.textColor = UIColor(white: 0, alpha: 0.3)
        addressLabel.textAlignment = .center
        view.addSubview(addressLabel)
    }

    private func setupProgressBar() {
        let frame = CGRect(x: 0, y: Constants.topInset + Constants.statusBarHeight, width: Constants.screenWidth, height: 3)
        progressBar = UIProgressView(frame: frame)
        progressBar.backgroundColor = UIColor(hexString: "#00BF12")
        progressBar.progressTintColor = UIColor(hexString: "#00BF12")
        progressBar.progress = 0
        view.addSubview(progressBar)
    }
    
    private func observeProgress() {
        estimatedProgressObserver = webView.observe(\.estimatedProgress, options: .new) { [weak self] (webView, _) in
            self?.progressBar.progress = Float(webView.estimatedProgress)
            self?.progressBar.isHidden = webView.estimatedProgress == 1.0
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let y = Constants.topInset + Constants.statusBarHeight
        webView.frame = CGRect(x: 0, y: y, width: view.bounds.width, height: view.bounds.height - y)
    }
}

// MARK: - Event Handlers
extension WebViewController {
    
    @objc private func moreButtonClicked() {
        let items = [
            ScrollActionSheetItem(action: .sendToFriend, title: "发送给朋友", iconImage: UIImage(named: "Action_Share_60x60_")),
            ScrollActionSheetItem(action: .sendToMoment, title: "发送到朋友圈", iconImage: UIImage(named: "Action_Moments_60x60_")),
            ScrollActionSheetItem(action: .favorite, title: "收藏", iconImage: UIImage(named: "Action_MyFavAdd_60x60_")),
            ScrollActionSheetItem(action: .openInSafari, title: "在Safari中打开", iconImage: UIImage(named: "AS_safari_60x60_"))
        ]
        
        let bottomItems = [
            ScrollActionSheetItem(action: .floating, title: "浮窗", iconImage: UIImage(named: "Action_Expose_60x60_")),
            ScrollActionSheetItem(action: .report, title: "投诉", iconImage: UIImage(named: "Action_Expose_60x60_")),
            ScrollActionSheetItem(action: .copyLink, title: "复制链接", iconImage: UIImage(named: "Action_Copy_60x60_")),
            ScrollActionSheetItem(action: .floating, title: "刷新", iconImage: UIImage(named: "Action_Refresh_60x60_")),
            ScrollActionSheetItem(action: .searchInPage, title: "搜索页面内容", iconImage: UIImage(named: "Action_SearchInPage_60x60_")),
            ScrollActionSheetItem(action: .adjustFont, title: "调整字体", iconImage: UIImage(named: "Action_Font_60x60_")),
        ]
        var title: String = ""
        if let host = webView.url?.host {
            title = "此网页由 \(host) 提供"
        }
        let actionSheet = ScrollActionSheet(title: title, items: items, bottomItems: bottomItems)
        actionSheet.show()
    }
    
}

// MARK: - WCWebViewDelegate
extension WebViewController: WCWebViewDelegate {
    
    var allowInlineMediaPlay: Bool { return true }
    
    func webView(_ webView: WCWebView, didFinishLoad navigation: WKNavigation) {
        navigationItem.title = webView.title
        if let host = webView.url?.host {
            addressLabel.text = "此网页由 \(host) 提供"
        }
    }
}
