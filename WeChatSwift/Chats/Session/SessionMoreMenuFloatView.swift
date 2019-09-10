//
//  SessionMoreMenuFloatView.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/18.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

class SessionMoreFrameFloatView: UIButton {
    
    var delegate: SessionMoreMenuViewDelegate? {
        didSet {
            menuView?.delegate = delegate
        }
    }
    
    private var menuView: SessionMoreMenuView?
    private var menuViewFrame: CGRect = .zero
    
    private var menus: [SessionMoreItem] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let groupChatMenu = SessionMoreItem(type: .groupChats,
                                            title: LocalizedString("MainFrame_RBtnCreateChat"),
                                            icon: "icons_filled_chats")
        let addFriendMenu = SessionMoreItem(type: .addFriends,
                                            title: LocalizedString("MainFrame_RBtnAddFriend"),
                                            icon: "icons_filled_add-friends")
        let scanMenu = SessionMoreItem(type: .scan,
                                       title: LocalizedString("MainFrame_RBtnScan"),
                                       icon: "icons_filled_scan")
        let payMenu = SessionMoreItem(type: .money,
                                      title: LocalizedString("WCPay_FacingReceiveMoney_OfflinePay_Title"),
                                      icon: "icons_filled_pay")
        menus = [groupChatMenu, addFriendMenu, scanMenu, payMenu]
        
        let longestTitle = menus.sorted(by: { $0.title > $1.title }).first!.title
        print(longestTitle)
        
        let menuWidth: CGFloat = 160.0
        let menuHeight: CGFloat = 56.0
        let paddingTop: CGFloat = 0.0
        let paddingRight: CGFloat = 8.0
        
        let menuView = SessionMoreMenuView(itemHeight: menuHeight, itemWidth: menuWidth, menus: menus)
        menuView.frame.origin = CGPoint(x: bounds.width - menuWidth - paddingRight, y: paddingTop)
        menuView.transform = .identity
        menuView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(menuView)
        
        self.menuViewFrame = menuView.frame
        self.menuView = menuView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(in view: UIView) {
        self.removeFromSuperview()
        self.menuView?.frame = menuViewFrame // reset frame
        view.addSubview(self)
        self.alpha = 0.0
        UIView.animate(withDuration: 0.15) {
            self.alpha = 1.0
        }
    }
    
    func hide(animated: Bool = true) {
        let duration: TimeInterval = animated ? 0.2: 0.0
        UIView.animate(withDuration: duration, animations: {
            let scale: CGFloat = 0.7
            self.menuView?.transform = CGAffineTransform(scaleX: scale, y: scale)
            self.menuView?.frame.origin.x = self.menuViewFrame.origin.x + self.menuViewFrame.width * scale/2 - 12 // To keep arrow stick
            self.menuView?.frame.origin.y = self.menuViewFrame.origin.y
            self.menuView?.alpha = 0.0
        }) { _ in
            self.menuView?.alpha = 1.0
            self.menuView?.transform = .identity
            self.removeFromSuperview()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if superview != nil {
            hide()
        }
        super.touchesBegan(touches, with: event)
    }
}
