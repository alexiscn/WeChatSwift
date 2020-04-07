//
//  EmoticonStoreViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/25.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class EmoticonStoreViewController: ASViewController<ASDisplayNode> {

    private var segmentControl: UISegmentedControl!
    
    private lazy var wechatEmoticonsVC = WeChatEmoticonsViewController()

    private lazy var moreEmoticonsVC = MoreEmoticonsViewController()
    
    private var selectedIndex: Int = -1
    
    private var presented: Bool = false
    
    init(presented: Bool = false) {
        self.presented = presented
        super.init(node: ASDisplayNode())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        
        setupNavigationBar()
        
        updateSegmentSelected(0)
    }
    
    private func setupNavigationBar() {
        
        let friendsEmoticonTitle = LocalizedString("Emotion_Store_Segment_Friends_Emoticon")
        let moreEmoticonTitle = LocalizedString("Emotion_Store_Segment_Individual")
        
        segmentControl = UISegmentedControl(items: [friendsEmoticonTitle, moreEmoticonTitle])
        segmentControl.frame = CGRect(x: 0, y: 0, width: 191.0, height: 29.0)
        segmentControl.selectedSegmentIndex = 0
        segmentControl.tintColor = UIColor(hexString: "#181818")
        segmentControl.addTarget(self, action: #selector(handleSegmentControlValueChanged(_:)), for: .valueChanged)
        
        navigationItem.titleView = segmentControl
        
        let rightButton = UIBarButtonItem(image: UIImage.SVGImage(named: "icons_outlined_setting"), style: .done, target: self, action: #selector(handleRightBarButtonTapped(_:)))
        navigationItem.rightBarButtonItem = rightButton
        
        if presented {
            let closeButton = UIBarButtonItem(title: LanguageManager.Common.close(), style: .plain, target: self, action: #selector(handleCloseButtonTapped(_:)))
            closeButton.tintColor = UIColor(hexString: "#181818") //Colors.black
            navigationItem.leftBarButtonItem = closeButton
        }
    }
    
    private func updateSegmentSelected(_ newIndex: Int) {
        
        if newIndex == selectedIndex { return }
        selectedIndex = newIndex
        
        if selectedIndex == 0 {
            removeController(moreEmoticonsVC)
            addController(wechatEmoticonsVC)
        } else {
            removeController(wechatEmoticonsVC)
            addController(moreEmoticonsVC)
        }
        view.bringSubviewToFront(wx_navigationBar)
    }
    
    private func addController(_ controller: UIViewController) {
        addChild(controller)
        controller.view.frame = view.bounds
        view.addSubview(controller.view)
        controller.didMove(toParent: self)
    }
    
    private func removeController(_ controller: UIViewController) {
        controller.view.removeFromSuperview()
        controller.removeFromParent()
        controller.didMove(toParent: nil)
    }
    
}


// MARK: - Event Hanlders
extension EmoticonStoreViewController {
    
    @objc private func handleRightBarButtonTapped(_ sender: Any) {
        let emoticonManageVC = EmoticonManageViewController()
        navigationController?.pushViewController(emoticonManageVC, animated: true)
    }
    
    @objc private func handleCloseButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleSegmentControlValueChanged(_ sender: Any) {
        updateSegmentSelected(segmentControl.selectedSegmentIndex)
    }
}
