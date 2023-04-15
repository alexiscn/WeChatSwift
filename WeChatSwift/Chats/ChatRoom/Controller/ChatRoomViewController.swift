//
//  ChatRoomViewController.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/7/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit
import WXActionSheet
import PINRemoteImage

class ChatRoomViewController: ASDKViewController<ASDisplayNode> {
    
    private let sessionID: String
    
    private let dataSource: ChatRoomDataSource
    
    private let user: MockData.User
    
    private let inputNode = ChatRoomKeyboardNode()
    
    private let backgroundImageNode = ASImageNode()
    
    private let tableNode = ASTableNode(style: .plain)
    
    internal var menuMessage: Message?
    
    init(sessionID: String) {
        self.sessionID = sessionID
        self.dataSource = ChatRoomDataSource(sessionID: sessionID)
        self.user = MockFactory.shared.user(with: sessionID)!
        
        super.init(node: ASDisplayNode())

        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        tableNode.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        backgroundImageNode.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        node.addSubnode(backgroundImageNode)
        node.addSubnode(tableNode)
        node.addSubnode(inputNode)
    }
    
    deinit {
        print("chatRoom deinit")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = user.name
        let moreButtonItem = UIBarButtonItem(image: Constants.moreImage, style: .done, target: self, action: #selector(moreButtonClicked))
        navigationItem.rightBarButtonItem = moreButtonItem
        
        if let backgroundImageName = AppContext.current.userSettings.globalBackgroundImage {
            backgroundImageNode.image = UIImage.as_imageNamed(backgroundImageName)
        }
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        backgroundImageNode.frame = view.bounds
        
        tableNode.allowsSelection = false
        tableNode.view.separatorStyle = .none
        tableNode.dataSource = self
        tableNode.delegate = self
        tableNode.view.backgroundColor = .clear
        tableNode.frame = CGRect(x: 0, y: 0, width: Constants.screenWidth, height: Constants.screenHeight - 56 - Constants.bottomInset)
        inputNode.tableNode = tableNode
        inputNode.delegate = self
        
        dataSource.tableNode = tableNode
        
        scrollToLastMessage(animated: false)
        
        navigationController?.interactivePopGestureRecognizer?.addTarget(self, action: #selector(handlePopGesture(_:)))
    }
    
    func sendMediaAssets(_ assets: [MediaAsset]) {
        for mediaAsset in assets {
            if mediaAsset.asset.mediaType == .image {
                let thumbImage = mediaAsset.asset.thumbImage(with: CGSize(width: 500, height: 500))
                let imageMsg = ImageMessage(image: thumbImage, size: mediaAsset.asset.pixelSize)
                let message = Message()
                message.chatID = sessionID
                message.content = .image(imageMsg)
                message.senderID = AppContext.current.userID
                message.localMsgID = UUID().uuidString
                message.time = Int(Date().timeIntervalSinceNow)
                dataSource.append(message)
            } else if mediaAsset.asset.mediaType == .video {
                let thumbImage = mediaAsset.asset.thumbImage(with: CGSize(width: 500, height: 500))
                let duration = mediaAsset.asset.duration
                let size = mediaAsset.asset.pixelSize
                let videoMsg = VideoMessage(url: nil, thumb: thumbImage, size: size, fileSize: 0, duration: Float(duration))
                let message = Message()
                message.chatID = sessionID
                message.content = .video(videoMsg)
                message.senderID = AppContext.current.userID
                message.localMsgID = UUID().uuidString
                message.time = Int(Date().timeIntervalSinceNow)
                dataSource.append(message)
            }
        }
    }
    
    func scrollToLastMessage(animated: Bool) {
        DispatchQueue.main.async {
            let last = self.dataSource.numberOfRows() - 1
            if last > 0 {
                let indexPath = IndexPath(row: last, section: 0)
                self.tableNode.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            }
        }
    }
    
    private func showSendLocationActionSheet() {
        let actionSheet = WXActionSheet(cancelButtonTitle: LanguageManager.Common.cancel())
        actionSheet.add(WXActionSheetItem(title: "发送位置", handler: { [weak self] _ in
            self?.sendLocation()
        }))
        actionSheet.add(WXActionSheetItem(title: "共享实时位置", handler: { _ in
                    
        }))
        actionSheet.show()
    }
    
    private func sendLocation() {
        let message = Message()
        message.chatID = sessionID
        
        message.content = .location(LocationMessage(coordinate: CLLocationCoordinate2DMake(39.996074, 116.480813), thumbImage: UIImage(named: "location_thumb"), title: "望京SOHOT2(北京市朝阳区)", subTitle: "北京市朝阳区阜通东大街"))
        message.senderID = AppContext.current.userID
        message.localMsgID = UUID().uuidString
        message.time = Int(Date().timeIntervalSinceNow)
        dataSource.append(message)
    }
    
    private func showLongPressImageActionSheet(imageMsg: ImageMessage) {
        let actionSheet = WXActionSheet(cancelButtonTitle: LanguageManager.Common.cancel())
        actionSheet.add(WXActionSheetItem(title: "发送给朋友", handler: { _ in
            
        }))
        actionSheet.add(WXActionSheetItem(title: "收藏", handler: { _ in
            
        }))
        actionSheet.add(WXActionSheetItem(title: "保存图片", handler: { _ in
            
        }))
        actionSheet.add(WXActionSheetItem(title: "编辑", handler: { _ in
            
        }))
        actionSheet.add(WXActionSheetItem(title: "定位到聊天", handler: { _ in
            
        }))
        actionSheet.show()
    }
    
    private func previewImages(imageMsg: ImageMessage, originView: UIView) {
        var ds: PhotoBrowserDataSource
        if let image = imageMsg.image {
            ds = PhotoBrowserLocalDataSource(numberOfItems: 1, images: [image])
        } else {
            let thumb = originView.toImage()
            ds = PhotoBrowserNetworkDataSource(numberOfItems: 1, placeholders: [thumb], remoteURLs: [imageMsg.url])
        }
        let trans = PhotoBrowserZoomTransitioning { (browser, index, view) -> UIView? in
            return originView
        }
        let delegate = PhotoBrowserDefaultDelegate()
        delegate.longPressedHandler = { [weak self] (browser, index, image, gesture) in
            self?.showLongPressImageActionSheet(imageMsg: imageMsg)
        }
        let browser = PhotoBrowserViewController(dataSource: ds, transDelegate: trans, delegate: delegate)
        browser.show(pageIndex: 0, in: self)
    }
    
    private func previewVideo(videoMsg: VideoMessage, originView: UIView) {
        print("TODO")
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
}

// MARK: - Event Handlers

extension ChatRoomViewController {
    
    @objc private func handlePopGesture(_ gesture: UIGestureRecognizer) {
        switch gesture.state {
        case .began:
            inputNode.isSwipeBackGestureCauseKeyboardDismiss = true
        case .cancelled, .ended:
            inputNode.isSwipeBackGestureCauseKeyboardDismiss = false
        default:
            inputNode.isSwipeBackGestureCauseKeyboardDismiss = true
        }
    }
    
    @objc private func moreButtonClicked() {
        let contact = user.toContact()
        let contactVC = ChatRoomContactInfoViewController(contact: contact)
        navigationController?.pushViewController(contactVC, animated: true)
    }
    
    
}

// MARK: - ASTableDataSource & ASTableDelegate
extension ChatRoomViewController: ASTableDataSource, ASTableDelegate {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfRows()
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let message = dataSource.itemAtIndexPath(indexPath)
        let nodeBlock: ASCellNodeBlock = {
            let cellNode = ChatRoomCellNodeFactory.node(for: message)
            cellNode.delegate = self
            return cellNode
        }
        return nodeBlock
    }
}

// MARK: - UIScrollViewDelegate

extension ChatRoomViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        inputNode.dismissKeyboard()
    }
}


// MARK: - ChatRoomKeyboardNodeDelegate

extension ChatRoomViewController: ChatRoomKeyboardNodeDelegate {
    
    func keyboard(_ keyboard: ChatRoomKeyboardNode, didSendText text: String) {
        let message = Message()
        message.chatID = sessionID
        message.content = .text(text)
        message.senderID = AppContext.current.userID
        message.localMsgID = UUID().uuidString
        message.time = Int(Date().timeIntervalSinceNow)
        dataSource.append(message)
        
        inputNode.clearText()
    }
    
    func keyboard(_ keyboard: ChatRoomKeyboardNode, didSelectToolItem tool: ChatRoomTool) {
        switch tool {
        case .album:
            let selectionHandler = { [weak self] (selectedAssets: [MediaAsset]) in
                self?.sendMediaAssets(selectedAssets)
                self?.dismiss(animated: true, completion: nil)
            }
            let configuration = AssetPickerConfiguration.configurationForChatRoom()
            let albumPickerVC = AlbumPickerViewController(configuration: configuration)
            albumPickerVC.selectionHandler = selectionHandler
            let assetPickerVC = AssetPickerViewController(configuration: configuration)
            assetPickerVC.selectionHandler = selectionHandler
            let nav = UINavigationController()
            nav.setViewControllers([albumPickerVC, assetPickerVC], animated: false)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
        case .camera:
            let sightCameraVC = SightCameraViewController()
            sightCameraVC.modalPresentationCapturesStatusBarAppearance = true
            sightCameraVC.modalTransitionStyle = .coverVertical
            sightCameraVC.modalPresentationStyle = .overCurrentContext
            present(sightCameraVC, animated: true, completion: nil)
        case .location:
            showSendLocationActionSheet()
        case .redPacket:
            let makeRedEnvelopeVC = MakeRedEnvelopeViewController()
            let nav = UINavigationController(rootViewController: makeRedEnvelopeVC)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
        default:
            break
        }
    }
    
    func keyboard(_ keyboard: ChatRoomKeyboardNode, didSendSticker sticker: WCEmotion) {
        let message = Message()
        message.chatID = sessionID
        message.content = .emoticon(EmoticonMessage(md5: sticker.name, packageID: sticker.packageID, title: sticker.title))
        message.senderID = AppContext.current.userID
        message.localMsgID = UUID().uuidString
        message.time = Int(Date().timeIntervalSinceNow)
        dataSource.append(message)
    }
    
    func keyboardAddFavoriteEmoticonButtonPressed() {
        
    }
    
    func keyboard(_ keyboard: ChatRoomKeyboardNode, didSendGameEmoticon game: FavoriteEmoticon) {
        switch game.type {
        case .dice:
            let message = Message()
            message.chatID = sessionID
            message.content = .game(GameMessage(gameType: .dice))
            message.senderID = AppContext.current.userID
            message.localMsgID = UUID().uuidString
            message.time = Int(Date().timeIntervalSinceNow)
            dataSource.append(message)
        default:
            break
        }
    }
    
    func keyboardEmoticonSettingsButtonPressed() {
        let emoticonManageVC = EmoticonManageViewController()
        emoticonManageVC.isPresented = true
        let nav = UINavigationController(rootViewController: emoticonManageVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func keyboardEmoticonAddButtonPressed() {
        let emoticonStoreVC = EmoticonStoreViewController(presented: true)
        let nav = UINavigationController(rootViewController: emoticonStoreVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
}

// MARK: - MessageCellNodeDelegate
extension ChatRoomViewController: MessageCellNodeDelegate {
    
    func messageCell(_ cellNode: MessageCellNode, didTapAvatar userID: String) {
        guard let user = MockFactory.shared.user(with: userID) else {
            return
        }
        let contactVC = ContactInfoViewController(contact: user.toContact())
        navigationController?.pushViewController(contactVC, animated: true)
    }
    
    func messageCell(_ cellNode: MessageCellNode, didLongPressedAvatar userID: String) {
        
    }
    
    func messageCell(_ cellNode: MessageCellNode, didTapContent content: MessageContent) {
        switch content {
        case .emoticon(let emoticonMsg):
            let controller = ChatRoomEmoticonPreviewViewController(emoticon: emoticonMsg)
            navigationController?.pushViewController(controller, animated: true)
        case .location(let locationMsg):
            let controller = ChatRoomMapViewController(location: locationMsg)
            navigationController?.pushViewController(controller, animated: true)
        case .image(let imageMsg):
            let originView = (cellNode.contentNode as? MessageImageContentNode)?.imageView ?? cellNode.contentNode.view
            previewImages(imageMsg: imageMsg, originView: originView)
        case .video(let videoMsg):
            let originView = (cellNode.contentNode as? VideoContentNode)?.imageView ?? cellNode.contentNode.view
            previewVideo(videoMsg: videoMsg, originView: originView)
        default:
            break
        }
    }
    
    func messageCell(_ cellNode: MessageCellNode, didTapLink url: URL?) {
        if let url = url {
            let webVC = WebViewController(url: url)
            navigationController?.pushViewController(webVC, animated: true)
            inputNode.dismissKeyboard()
        }
    }
    
    func messageCell(_ cellNode: MessageCellNode, showMenus menus: [MessageMenuAction], message: Message, targetRect: CGRect, targetView: UIView) {
        self.becomeFirstResponder()
        self.menuMessage = message
        showMenus(menus, targetRect: targetRect, targetView: targetView)
    }
}
