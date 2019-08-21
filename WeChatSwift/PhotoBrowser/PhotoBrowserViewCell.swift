//
//  PhotoBrowserViewCell.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/17.
//  Copyright © 2019 alexiscn. All rights reserved.
//

// https://github.com/JiongXing/PhotoBrowser
import UIKit
import FLAnimatedImage

class PhotoBrowserViewCell: UICollectionViewCell {
    
    var tapHandler: RelayCommand?
    
    var panGestureChangedHandler: ((_ scale: CGFloat) -> Void)?
    
    var panGestureReleasedHandler: ((_ downSwipe: Bool) -> Void)?
    
    //var imageView = UIImageView()
    
    var imageView = FLAnimatedImageView()
    
    var playButton = UIButton(type: .custom)
    
    var scrollView = UIScrollView()
    
    private var beganFrame: CGRect = .zero
    private var beganTouch: CGPoint = .zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)
        
        scrollView.delegate = self
        scrollView.maximumZoomScale = 2.0
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        contentView.addGestureRecognizer(longPressGesture)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapGesture(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        contentView.addGestureRecognizer(doubleTapGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        contentView.addGestureRecognizer(tapGesture)
        tapGesture.require(toFail: doubleTapGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.delegate = self
        scrollView.addGestureRecognizer(panGesture)
        
        playButton.setImage(UIImage.as_imageNamed("MMVideoPreviewPlay_85x85_"), for: .normal)
        playButton.setImage(UIImage.as_imageNamed("MMVideoPreviewPlayHL_85x85_"), for: .highlighted)
        //imageView.addSubview(playButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        scrollView.frame = contentView.bounds
        scrollView.setZoomScale(1.0, animated: false)
        imageView.frame = fitFrame
        scrollView.setZoomScale(1.0, animated: false)
        
        playButton.frame = CGRect(x: (bounds.width - 85.0)/2.0, y: (bounds.height - 85.0)/2, width: 85, height: 85)
    }
    
    private var fitSize: CGSize {
        guard let imageSize = imageView.image?.size else { return bounds.size }
        var width: CGFloat
        var height: CGFloat
        if scrollView.bounds.width < scrollView.bounds.height {
            // 竖屏
            width = scrollView.bounds.width
            height = (imageSize.height / imageSize.width) * width
        } else {
            // 横屏
            height = scrollView.bounds.height
            width = (imageSize.width / imageSize.height) * height
            if width > scrollView.bounds.width {
                width = scrollView.bounds.width
                height = (imageSize.height / imageSize.width) * width
            }
        }
        return CGSize(width: width, height: height)
    }
    
    private var resettingCenter: CGPoint {
        let deltaWidth = bounds.width - scrollView.contentSize.width
        let offsetX = deltaWidth > 0 ? deltaWidth * 0.5 : 0
        let deltaHeight = bounds.height - scrollView.contentSize.height
        let offsetY = deltaHeight > 0 ? deltaHeight * 0.5 : 0
        return CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX,
                       y: scrollView.contentSize.height * 0.5 + offsetY)
    }
    
    private var fitFrame: CGRect {
        let size = fitSize
        let y = scrollView.bounds.height > size.height
            ? (scrollView.bounds.height - size.height) * 0.5 : 0
        let x = scrollView.bounds.width > size.width
            ? (scrollView.bounds.width - size.width) * 0.5 : 0
        return CGRect(x: x, y: y, width: size.width, height: size.height)
    }
    
    private func panResult(_ pan: UIPanGestureRecognizer) -> PanGestureResult {
        
        let translation = pan.translation(in: scrollView)
        let currentTouch = pan.location(in: scrollView)
        
        // 由下拉的偏移值决定缩放比例，越往下偏移，缩得越小。scale值区间[0.3, 1.0]
        let scale = min(1.0, max(0.3, 1 - translation.y / bounds.height))
        
        let width = beganFrame.size.width * scale
        let height = beganFrame.size.height * scale
        
        // 计算x和y。保持手指在图片上的相对位置不变。
        // 即如果手势开始时，手指在图片X轴三分之一处，那么在移动图片时，保持手指始终位于图片X轴的三分之一处
        let xRate = (beganTouch.x - beganFrame.origin.x) / beganFrame.size.width
        let currentTouchDeltaX = xRate * width
        let x = currentTouch.x - currentTouchDeltaX
        
        let yRate = (beganTouch.y - beganFrame.origin.y) / beganFrame.size.height
        let currentTouchDeltaY = yRate * height
        let y = currentTouch.y - currentTouchDeltaY
        
        return PanGestureResult(frame: CGRect(x: x.isNaN ? 0 : x, y: y.isNaN ? 0 : y, width: width, height: height), scale: scale)
    }
    
    private func resetImageView() {
        let size = fitSize
        let needResetSize = imageView.bounds.size.width < size.width
            || imageView.bounds.size.height < size.height
        UIView.animate(withDuration: 0.25) {
            self.imageView.center = self.resettingCenter
            if needResetSize {
                self.imageView.bounds.size = size
            }
        }
    }
}

// MARK: - Event Handlers
extension PhotoBrowserViewCell {
    
    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        tapHandler?()
    }
    
    @objc private func handleDoubleTapGesture(_ gesture: UITapGestureRecognizer) {
        if scrollView.zoomScale == 1.0 {
            let pointInView = gesture.location(in: imageView)
            let width = scrollView.bounds.size.width / scrollView.maximumZoomScale
            let height = scrollView.bounds.size.height / scrollView.maximumZoomScale
            let x = pointInView.x - (width / 2.0)
            let y = pointInView.y - (height / 2.0)
            scrollView.zoom(to: CGRect(x: x, y: y, width: width, height: height), animated: true)
        } else {
            scrollView.setZoomScale(1.0, animated: true)
        }
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        if imageView.image == nil {
            return
        }
        
        switch gesture.state {
        case .began:
            beganFrame = imageView.frame
            beganTouch = gesture.location(in: scrollView)
        case .changed:
            let result = panResult(gesture)
            imageView.frame = result.frame
            panGestureChangedHandler?(result.scale)
        case .ended, .cancelled:
            let result = panResult(gesture)
            imageView.frame = result.frame
            let isDownSwipe = gesture.velocity(in: self).y > 0
            panGestureReleasedHandler?(isDownSwipe)
            if !isDownSwipe {
                resetImageView()
            }
        default:
            resetImageView()
        }
    }
    
    @objc private func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            print("")
        }
    }
    
}

// MARK: - UIScrollViewDelegate
extension PhotoBrowserViewCell: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        imageView.center = resettingCenter
    }
}

// MARK: - UIGestureRecognizerDelegate
extension PhotoBrowserViewCell: UIGestureRecognizerDelegate {
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        guard let pan = gestureRecognizer as? UIPanGestureRecognizer else {
            return true
        }
        let velocity = pan.velocity(in: self)
        if velocity.y < 0 {
            return false
        }
        if abs(Int(velocity.x)) > Int(velocity.y) {
            return false
        }
        if scrollView.contentOffset.y > 0 {
            return false
        }
        return true
    }
}

fileprivate struct PanGestureResult {
    var frame: CGRect
    var scale: CGFloat
}
