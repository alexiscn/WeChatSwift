//
//  ChatRoomViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit
import WXActionSheet

class ChatRoomViewController: ASViewController<ASDisplayNode> {
    
    private let sessionID: String
    
    private let dataSource: ChatRoomDataSource
    
    private let user: MockFactory.MockUser
    
    private let inputNode = ChatRoomKeyboardNode()
    
    private let tableNode = ASTableNode(style: .plain)
    
    init(sessionID: String) {
        self.sessionID = sessionID
        self.dataSource = ChatRoomDataSource(sessionID: sessionID)
        self.user = MockFactory.shared.users.first(where: { $0.identifier == sessionID })!
        
        super.init(node: ASDisplayNode())

        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        tableNode.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
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
        
        setNavigationBarTitle(user.name)
        let moreButtonItem = UIBarButtonItem(image: UIImage.SVGImage(named: "icons_filled_more"), style: .done, target: self, action: #selector(moreButtonClicked))
        navigationItem.rightBarButtonItem = moreButtonItem
        
        tableNode.allowsSelection = false
        tableNode.view.separatorStyle = .none
        tableNode.dataSource = self
        tableNode.delegate = self
        tableNode.view.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        tableNode.frame = CGRect(x: 0, y: 0, width: Constants.screenWidth, height: Constants.screenHeight - 34 - 60)
        inputNode.tableNode = tableNode
        inputNode.delegate = self
        
        dataSource.tableNode = tableNode
        
        scrollToLastMessage(animated: false)
        
        navigationController?.interactivePopGestureRecognizer?.addTarget(self, action: #selector(handlePopGesture(_:)))
    }
    
    func sendMediaAssets(_ assets: [MediaAsset]) {
        for mediaAsset in assets {
            // TODO
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
        let actionSheet = WXActionSheet(cancelButtonTitle: "取消")
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
        let contact = Contact()
        contact.name = user.name
        contact.avatar = UIImage.as_imageNamed(user.avatar)
        let contactVC = ContactInfoViewController(contact: contact)
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
            
            let albumPickerVC = AlbumPickerViewController()
            albumPickerVC.selectionHandler = selectionHandler
            let assetPickerVC = AssetPickerViewController()
            assetPickerVC.selectionHandler = selectionHandler
            let nav = WCNavigationController()
            nav.setViewControllers([albumPickerVC, assetPickerVC], animated: false)
            present(nav, animated: true, completion: nil)
        case .location:
            showSendLocationActionSheet()
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
        let nav = WCNavigationController(rootViewController: emoticonManageVC)
        present(nav, animated: true, completion: nil)
    }
    
    func keyboardEmoticonAddButtonPressed() {
        let emoticonStoreVC = EmoticonStoreViewController(presented: true)
        let nav = WCNavigationController(rootViewController: emoticonStoreVC)
        present(nav, animated: true, completion: nil)
    }
}

// MARK: - MessageCellNodeDelegate
extension ChatRoomViewController: MessageCellNodeDelegate {
    
    func messageCell(_ cellNode: MessageCellNode, didTapAvatar userID: String) {
        let contact = Contact()
        contact.name = user.name
        contact.avatar = UIImage.as_imageNamed(user.avatar)
        let contactVC = ContactInfoViewController(contact: contact)
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
}
