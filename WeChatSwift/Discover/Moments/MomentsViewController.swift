//
//  MomentsViewController.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/7/4.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit
import WXActionSheet

class MomentsViewController: ASDKViewController<ASDisplayNode> {

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
    private var menuMoment: Moment?
    private var menuMomentCellNode: MomentCellNode?
    
    override init() {
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
        
        setupNavigationBar()
        setupTapGesture()
        registerNotifications()
    }
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleCoverDidUpdatedNotification(_:)), name: .momentCoverDidUpdated, object: nil)
    }
    
    private func setupNavigationBar() {
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
        
        wx_navigationBar.alpha = 0.0
    }
    
    private func setupTapGesture() {
        tableNode.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        tap.delegate = self
        tableNode.view.addGestureRecognizer(tap)
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
        let nav = UINavigationController(rootViewController: publishMomentVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    private func presentPublishMediaMomentViewController(_ assets: [MediaAsset]) {
        let publishMomentVC = PublishMomentViewController(source: .media(assets))
        let nav = UINavigationController(rootViewController: publishMomentVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    private func presentSightCameraViewController() {
        let sightCameraVC = SightCameraViewController()
        sightCameraVC.modalPresentationCapturesStatusBarAppearance = true
        sightCameraVC.modalTransitionStyle = .coverVertical
        sightCameraVC.modalPresentationStyle = .overCurrentContext
        present(sightCameraVC, animated: true, completion: nil)
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
        let nav = UINavigationController()
        nav.setViewControllers([albumPickerVC, assetPickerVC], animated: false)
        nav.modalPresentationStyle = .fullScreen
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
    
    override var wx_barTintColor: UIColor? { return barTintColor }
}

// MARK: - Event Handlers
extension MomentsViewController {
    
    @objc private func handleRightBarButtonTapped(_ sender: Any) {
        let actionSheet = WXActionSheet(cancelButtonTitle: LanguageManager.Common.cancel())
        actionSheet.add(WXActionSheetItem(title: "拍摄", desc: "照片或视频", handler: { [weak self] _ in
            self?.presentSightCameraViewController()
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
        let contact = AppContext.current.me.toContact()
        let contactInfoVC = ContactInfoViewController(contact: contact)
        navigationController?.pushViewController(contactInfoVC, animated: true)
    }
    
    private func onHeaderCoverClicked() {
        let actionSheet = WXActionSheet(cancelButtonTitle: LanguageManager.Common.cancel())
        actionSheet.add(WXActionSheetItem(title: "更换相册封面", handler: { [weak self] _ in
            self?.navigateToPickCover()
        }))
        actionSheet.show()
    }
    
    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        hideOperationMenu(animated: true)
    }
    
    private func hideOperationMenu(animated: Bool) {
        if let menuView = operationMenuView {
            menuView.hide(animated: animated)
            operationMenuView = nil
            menuMoment = nil
            menuMomentCellNode = nil
        }
    }
    
    @objc private func handleCoverDidUpdatedNotification(_ notification: Notification) {
        guard let image = notification.object as? UIImage else { return }
        header.updateCover(image)
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
        
        hideOperationMenu(animated: false)
        
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
            wx_navigationBar.alpha = 0.0
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
            wx_navigationBar.alpha = alpha
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
        
        if let currentMoment = menuMoment, currentMoment == moment {
            hideOperationMenu(animated: true)
            return
        }
        hideOperationMenu(animated: false)
        
        let frame = moreButton.view.convert(moreButton.bounds, to: self.view)
        let point = CGPoint(x: frame.origin.x - 2 - 180.0, y: frame.origin.y + (frame.height - 39.0)/2.0)
        let menuView = MomentOperationMenuView()
        menuView.show(with: moment, at: point, inside: self.view)
        menuView.delegate = self
        
        self.operationMenuView = menuView
        self.menuMoment = moment
        self.menuMomentCellNode = cellNode
    }
    
    func momentCellNode(_ cellNode: MomentCellNode, didPressedUser userID: String) {
        guard let user = MockFactory.shared.user(with: userID) else {
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
        let delegate = PhotoBrowserDefaultDelegate()
        let browser = PhotoBrowserViewController(dataSource: ds, transDelegate: trans, delegate: delegate)
        browser.show(pageIndex: 0, in: self)
    }
 
    func momentCellNode(_ cellNode: MomentCellNode, didTapImage index: Int, mulitImage: MomentMultiImage, thumbs: [UIImage?], tappedView: UIView?) {
        let count = mulitImage.images.count
        let imageURLs = mulitImage.images.map { return $0.url }
        let ds = PhotoBrowserNetworkDataSource(numberOfItems: count, placeholders: thumbs, remoteURLs: imageURLs)
        let trans = PhotoBrowserZoomTransitioning { (browser, index, view) -> UIView? in
            return tappedView
        }
        let delegate = PhotoBrowserDefaultDelegate()
        let browser = PhotoBrowserViewController(dataSource: ds, transDelegate: trans, delegate: delegate)
        browser.show(pageIndex: index, in: self)
    }
    
    func momentCellNode(_ cellNode: MomentCellNode, didTapWebPage webpage: MomentWebpage) {
        guard let url = webpage.url else { return }
        
        let webVC = WebViewController(url: url)
        navigationController?.pushViewController(webVC, animated: true)
    }
}

// MARK: - MomentOperationMenuViewDelegate
extension MomentsViewController: MomentOperationMenuViewDelegate {
    
    func operationMenuView(_ menuView: MomentOperationMenuView, onLikeMoment moment: Moment) {
        let me = AppContext.current.me
        if moment.liked {
            if !moment.likes.contains(where: { $0.userID == me.identifier }) {
                let user = MomentLikeUser(userID: me.identifier, username: me.name)
                moment.likes.append(user)
                menuMomentCellNode?.addLike()
            }
        } else {
            if let index = moment.likes.firstIndex(where: { $0.userID == me.identifier }) {
                moment.likes.remove(at: index)
                menuMomentCellNode?.deleteLike()
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.hideOperationMenu(animated: true)
        }
    }
    
    func operationMenuView(_ menuView: MomentOperationMenuView, onCommentMoment moment: Moment) {
        // TODO: show comment input panel Check whether should ajust table
        let comment = MomentComment()
        comment.commentId = UUID().uuidString
        comment.content = "哈哈哈哈"
        comment.userID = AppContext.current.userID
        comment.nickname = AppContext.current.name
        moment.comments.append(comment)
        menuMomentCellNode?.addComment(comment)
        hideOperationMenu(animated: true)
    }
}

// MARK: - UIGestureRecognizerDelegate
extension MomentsViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
