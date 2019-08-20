//
//  MomentsViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/4.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit
import WXActionSheet

class MomentsViewController: ASViewController<ASDisplayNode> {

    // View
    private let tableNode: ASTableNode = ASTableNode(style: .plain)
    private let header: MomentHeaderNode = MomentHeaderNode()
    private var titleView: UILabel?
    private var operationMenuView: MomentOperationMenuView?
    private var rightBarButton: UIButton?
    
    private let dataSource = MomentDataSource()
    private var statusBarStyle = UIStatusBarStyle.lightContent
    private var barTintColor: UIColor = .white
    private var newMessage: MomentNewMessage?
    private var hasNewMessage: Bool { return newMessage != nil }
    private var isLoadingMoments = false
    
    init() {
        super.init(node: ASDisplayNode())
        
        node.addSubnode(tableNode)
        
        tableNode.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableNode.delegate = self
        tableNode.dataSource = self
        newMessage = MomentNewMessage(userAvatar: UIImage(named: "JonSnow.jpg"), unread: 5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableNode.frame = view.bounds
        tableNode.backgroundColor = UIColor(hexString: "#333333")
        tableNode.view.allowsSelection = false
        tableNode.view.separatorStyle = .none
        tableNode.leadingScreensForBatching = 2
        
        let tableHeader = UIView()
        tableHeader.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 307)
        header.frame = tableHeader.bounds
        tableHeader.addSubnode(header)
        tableNode.view.tableHeaderView = tableHeader
        header.avatarTapHandler = { [weak self] in
            self?.onHeaderAvatarClicked()
        }
        header.coverTapHandler = { [weak self] in
            self?.onHeaderCoverClicked()
        }
        
        let titleLabel = UILabel()
        titleLabel.text = "朋友圈"
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        navigationItem.titleView = titleLabel
        self.titleView = titleLabel
        
        let rightButtonImage = UIImage.SVGImage(named: "icons_filled_camera")?.withRenderingMode(.alwaysTemplate)
        let rightButtonOutlinedImage = UIImage.SVGImage(named: "icons_outlined_camera")?.withRenderingMode(.alwaysTemplate)
        let rightButton = UIButton(type: .custom)
        rightButton.setImage(rightButtonImage, for: .normal)
        rightButton.setImage(rightButtonOutlinedImage, for: .selected)
        rightButton.addTarget(self, action: #selector(handleRightBarButtonTapped(_:)), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        rightBarButton = rightButton
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressRightBarButtonGesture(_:)))
        rightButton.addGestureRecognizer(longPressGesture)
        
        wc_navigationBar.alpha = 0.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let offset = self.tableNode.contentOffset.y
        let barHeight: CGFloat = 44.0
        let threshold: CGFloat = 307.0 - 70 - 30 - barHeight - Constants.statusBarHeight
        let progress = (offset - threshold - barHeight)/barHeight
        let alpha = max(0, min(progress, 1))
        self.titleView?.isHidden = alpha == 0.0
    }
    
    private func fetchNextMoments(with context: ASBatchContext) {
        DispatchQueue.main.async {
            if self.isLoadingMoments { return }
            
            self.isLoadingMoments = true
            self.dataSource.fetchNext(completion: { [unowned self] (succes, newCount) in
                self.isLoadingMoments = false
                self.addRows(newMomentsCount: newCount)
                context.completeBatchFetching(true)
            })
        }
    }
    
    private func presentPublishMomentViewController() {
        let publishMomentVC = PublishMomentViewController(source: .text)
        let nav = WCNavigationController(rootViewController: publishMomentVC)
        present(nav, animated: true, completion: nil)
    }
    
    private func presentPublishMediaMomentViewController(_ assets: [MediaAsset]) {
        let publishMomentVC = PublishMomentViewController(source: .media(assets))
        let nav = WCNavigationController(rootViewController: publishMomentVC)
        present(nav, animated: true, completion: nil)
    }
    
    private func presentPickAssetViewController() {
        let selectionHandler = { [weak self] (selectedAssets: [MediaAsset]) in
            self?.dismiss(animated: true, completion: nil)
            self?.presentPublishMediaMomentViewController(selectedAssets)
        }
        
        let configuration = AssetPickerConfiguration.configurationForPublishMoment()
        let albumPickerVC = AlbumPickerViewController(configuration: configuration)
        albumPickerVC.selectionHandler = selectionHandler
        let assetPickerVC = AssetPickerViewController(configuration: configuration)
        assetPickerVC.selectionHandler = selectionHandler
        let nav = WCNavigationController()
        nav.setViewControllers([albumPickerVC, assetPickerVC], animated: false)
        present(nav, animated: true, completion: nil)
    }
    
    private func navigateToPickCover() {
        let coverCustomizeVC = MomentCoverCustomizeViewController()
        navigationController?.pushViewController(coverCustomizeVC, animated: true)
    }
    
    private func addRows(newMomentsCount: Int) {
        let indexRange = (dataSource.numberOfItems() - newMomentsCount..<dataSource.numberOfItems())
        let section = hasNewMessage ? 1: 0
        let indexPaths = indexRange.map { return IndexPath(item: $0, section: section) }
        tableNode.insertRows(at: indexPaths, with: .none)
    }
    
    private func updateStatusBarStyle(_ style: UIStatusBarStyle) {
        if style != statusBarStyle {
            statusBarStyle = style
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    
    override var wc_barTintColor: UIColor? { return barTintColor }
}

// MARK: - Event Handlers
extension MomentsViewController {
    
    @objc private func handleRightBarButtonTapped(_ sender: Any) {
        let actionSheet = WXActionSheet(cancelButtonTitle: "取消")
        actionSheet.add(WXActionSheetItem(title: "拍摄", desc: "照片或视频", handler: { _ in
            
        }))
        actionSheet.add(WXActionSheetItem(title: "从手机相册中选择", handler: { [weak self] _ in
            self?.presentPickAssetViewController()
        }))
        actionSheet.show()
    }
    
    @objc private func handleLongPressRightBarButtonGesture(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            presentPublishMomentViewController()
        }
    }
    
    private func onHeaderAvatarClicked() {
        guard let contact = MockFactory.shared.users.first?.toContact() else {
            return
        }
        let contactInfoVC = ContactInfoViewController(contact: contact)
        navigationController?.pushViewController(contactInfoVC, animated: true)
    }
    
    private func onHeaderCoverClicked() {
        let actionSheet = WXActionSheet(cancelButtonTitle: "取消")
        actionSheet.add(WXActionSheetItem(title: "更换相册封面", handler: { [weak self] _ in
            self?.navigateToPickCover()
        }))
        actionSheet.show()
    }
    
}

// MARK: - ASTableDelegate & ASTableDataSource
extension MomentsViewController: ASTableDelegate, ASTableDataSource {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return hasNewMessage ? 2: 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        
        if hasNewMessage && section == 0 {
            return 1
        }
        return dataSource.numberOfItems()
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        
        if let message = self.newMessage, indexPath.section == 0 {
            let block: ASCellNodeBlock = {
                return MomentNewMessageCellNode(newMessage: message)
            }
            return block
        } else {
            let moment = dataSource.item(at: indexPath)
            let block: ASCellNodeBlock = { [weak self] in
                let momentCellNode = MomentCellNode(moment: moment)
                momentCellNode.delegate = self
                return momentCellNode
            }
            return block
        }
    }
    
    func shouldBatchFetch(for tableNode: ASTableNode) -> Bool {
        return true
    }
    
    func tableNode(_ tableNode: ASTableNode, willBeginBatchFetchWith context: ASBatchContext) {
        fetchNextMoments(with: context)
    }
}

// MARK: - UIScrollViewDelegate

extension MomentsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        //print(y)
        
        // 307: TableNode Header Height
        // 70: Avatar Height
        // 30: Avatar Bottom Offset
        // 44: Navigation Bar Height
        let barHeight: CGFloat = 44.0
        let threshold: CGFloat = 307.0 - 70 - 30 - barHeight - Constants.statusBarHeight
        //print("threshold:\(threshold)")
        if y < threshold {
            wc_navigationBar.alpha = 0.0
            updateStatusBarStyle(.lightContent)
            titleView?.alpha = 0
            titleView?.isHidden = true
            barTintColor = .white
            rightBarButton?.isSelected = false
        } else if y < threshold + barHeight {
            //let alpha = (y - threshold)/barHeight
            updateStatusBarStyle(.default)
            titleView?.alpha = 0
            titleView?.isHidden = true
            barTintColor = .black
            rightBarButton?.isSelected = true
        } else {
            let progress = (y - threshold - barHeight)/barHeight
            let alpha = max(0, min(progress, 1))
            wc_navigationBar.alpha = alpha
            titleView?.alpha = alpha
            titleView?.isHidden = alpha == 0.0
            updateStatusBarStyle(.default)
            barTintColor = .black
            rightBarButton?.isSelected = true
        }
        if navigationController?.navigationBar.tintColor != barTintColor {
            navigationController?.navigationBar.tintColor = barTintColor
        }
    }
}

// MARK: - MomentCellNodeDelegate
extension MomentsViewController: MomentCellNodeDelegate {
    
    func momentCellNode(_ cellNode: MomentCellNode, didPressedMoreButton moreButton: ASButtonNode, moment: Moment) {
        if let menuView = operationMenuView {
            menuView.hide(animated: true)
            operationMenuView = nil
        } else {
            let frame = moreButton.view.convert(moreButton.bounds, to: self.view)
            let point = CGPoint(x: frame.origin.x - 2, y: frame.origin.y + (frame.height - 39.0)/2.0)
            let menuView = MomentOperationMenuView(frame: CGRect(x: 0, y: 0, width: 180, height: 39))
            menuView.show(with: moment, at: point, inside: self.view)
            self.operationMenuView = menuView
        }
    }
    
    func momentCellNode(_ cellNode: MomentCellNode, didPressedUserAvatar userID: String) {
        guard let user = MockFactory.shared.users.first(where: { $0.identifier == userID }) else {
            return
        }
        let contact = user.toContact()
        let contactInfoVC = ContactInfoViewController(contact: contact)
        navigationController?.pushViewController(contactInfoVC, animated: true)
    }
    
    func momentCellNode(_ cellNode: MomentCellNode, didTapImage image: MomentMedia, thumbImage: UIImage?, tappedView: UIView?) {
        
        let ds = PhotoBrowserNetworkDataSource(numberOfItems: 1, placeholders: [thumbImage], remoteURLs: [image.url])
        let trans = PhotoBrowserZoomTransitioning { (browser, index, view) -> UIView? in
            return tappedView
        }
        let browser = PhotoBrowserViewController(dataSource: ds, transDelegate: trans)
        browser.show(pageIndex: 0, in: self)
    }
 
    func momentCellNode(_ cellNode: MomentCellNode, didTapImage index: Int, mulitImage: MomentMultiImage, thumbs: [UIImage?], tappedView: UIView?) {
        let count = mulitImage.images.count
        let imageURLs = mulitImage.images.map { return $0.url }
        let ds = PhotoBrowserNetworkDataSource(numberOfItems: count, placeholders: thumbs, remoteURLs: imageURLs)
        let trans = PhotoBrowserZoomTransitioning { (browser, index, view) -> UIView? in
            return tappedView
        }
        let browser = PhotoBrowserViewController(dataSource: ds, transDelegate: trans)
        browser.show(pageIndex: index, in: self)
    }
}
