//
//  MomentOperationMenuView.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/4.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

class MomentOperationMenuView: UIView {
    
    weak var delegate: MomentOperationMenuViewDelegate?
    
    private let backgroundImageView: UIImageView
    private let clipView: UIView
    private let likeButton: UIButton
    private let lineView: UIImageView
    private let commentButton: UIButton
    
    private var moment: Moment?
    
    private let width: CGFloat = 180
    
    private let height: CGFloat = 39.0
    
    init() {
        
        backgroundImageView = UIImageView()
        backgroundImageView.image = UIImage(named: "AlbumOperateMoreViewBkg_40x39_")
        
        clipView = UIView()
        clipView.clipsToBounds = true
        
        let highlightBackgroundImage = UIImage.as_resizableRoundedImage(withCornerRadius: 0, cornerColor: nil, fill: UIColor(white: 0, alpha: 0.5))
        
        likeButton = UIButton()
        likeButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        likeButton.setTitle("赞", for: .normal)
        likeButton.setTitleColor(.white, for: .normal)
        likeButton.setTitle("取消", for: .selected)
        likeButton.setTitleColor(.white, for: .selected)
        likeButton.setImage(UIImage(named: "AlbumLike_20x20_"), for: .normal)
        likeButton.setImage(UIImage(named: "AlbumLikeHL_20x20_"), for: .highlighted)
        likeButton.setBackgroundImage(highlightBackgroundImage, for: .highlighted)
        likeButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: -4)
        
        lineView = UIImageView()
        lineView.image = UIImage(named: "AlbumCommentLine_0x24_")
        
        commentButton = UIButton()
        commentButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        commentButton.setTitle("评论", for: .normal)
        commentButton.setTitleColor(.white, for: .normal)
        commentButton.setImage(UIImage(named: "AlbumCommentSingleA_20x20_"), for: .normal)
        commentButton.setImage(UIImage(named: "AlbumCommentSingleAHL_20x20_"), for: .highlighted)
        commentButton.setBackgroundImage(highlightBackgroundImage, for: .highlighted)
        commentButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: -4)
        
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        super.init(frame: frame)
        
        addSubview(clipView)
        clipView.addSubview(backgroundImageView)
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
        clipsToBounds = true
        layer.cornerRadius = 4
        layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func likeButtonClicked() {
        guard let moment = moment else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            moment.liked = !moment.liked
            self.updateLikeButton()
            self.delegate?.operationMenuView(self, onLikeMoment: moment)
        }
    }
    
    @objc private func commentButtonClicked() {
        guard let moment = moment else { return }
        delegate?.operationMenuView(self, onCommentMoment: moment)
    }
    
    func hide(animated: Bool) {
        
        if animated {
            UIView.animate(withDuration: 0.25, animations: {
                self.clipView.frame.origin.x = self.frame.width
            }) { _ in
                self.removeFromSuperview()
            }
        } else {
            removeFromSuperview()
        }
    }
    
    func show(with moment: Moment, at point: CGPoint, inside view: UIView) {
        self.moment = moment
        
        updateLikeButton()
        
        self.removeFromSuperview() 
        view.addSubview(self)
        self.frame.origin = point
        self.clipView.frame.origin.x = self.bounds.width
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1.0
            self.clipView.frame.origin.x = 0
        }
    }
    
    private func updateLikeButton() {
        guard let moment = moment else { return }
        let title = moment.liked ? "取消": "赞"
        likeButton.setTitle(title, for: .normal)
    }
}

protocol MomentOperationMenuViewDelegate: class {
    
    func operationMenuView(_ menuView: MomentOperationMenuView, onLikeMoment moment: Moment)
    
    func operationMenuView(_ menuView: MomentOperationMenuView, onCommentMoment moment: Moment)
    
}
