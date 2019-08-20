//
//  MomentOperationMenuView.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/4.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

class MomentOperationMenuView: UIView {
    
    private let backgroundImageView: UIImageView
    private let clipView: UIView
    private let likeButton: UIButton
    private let lineView: UIImageView
    private let commentButton: UIButton
    
    override init(frame: CGRect) {
        
        backgroundImageView = UIImageView()
        backgroundImageView.image = UIImage(named: "AlbumOperateMoreViewBkg_40x39_")
        
        clipView = UIView()
        clipView.clipsToBounds = true
        
        likeButton = UIButton()
        likeButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        likeButton.setTitle("赞", for: .normal)
        likeButton.setTitleColor(.white, for: .normal)
        
        lineView = UIImageView()
        lineView.image = UIImage(named: "AlbumCommentLine_0x24_")
        
        commentButton = UIButton()
        commentButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        commentButton.setTitle("评论", for: .normal)
        commentButton.setTitleColor(.white, for: .normal)
        
        super.init(frame: frame)
        
        addSubview(backgroundImageView)
        addSubview(clipView)
        clipView.addSubview(likeButton)
        clipView.addSubview(lineView)
        clipView.addSubview(commentButton)
        
        clipView.frame = bounds
        backgroundImageView.frame = bounds
        likeButton.frame = CGRect(x: 0, y: 0, width: bounds.width/2, height: bounds.height)
        lineView.frame = CGRect(x: 89.5, y: 7.5, width: 0.5, height: 24)
        commentButton.frame = CGRect(x: bounds.width/2, y: 0, width: bounds.width/2, height: bounds.height)
        
        likeButton.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(commentButtonClicked), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func likeButtonClicked() {
        
    }
    
    @objc private func commentButtonClicked() {
        
    }
    
    func hide(animated: Bool) {
        
        if animated {
            UIView.animate(withDuration: 0.25, animations: {
                self.frame = CGRect(x: self.frame.origin.x + 180, y: self.frame.origin.y, width: 0, height: self.frame.height)
            }) { _ in
                self.removeFromSuperview()
            }
        } else {
            removeFromSuperview()
        }
    }
    
    func show(with moment: Moment, at point: CGPoint, inside view: UIView) {
        view.addSubview(self)
        self.frame = CGRect(x: point.x - 180, y: point.y, width: 0, height: 39.0)
        UIView.animate(withDuration: 0.2, animations: {
            self.frame.size.width = 180
        }) { _ in
            
        }
    }
}
