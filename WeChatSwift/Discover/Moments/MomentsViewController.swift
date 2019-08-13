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

    private let tableNode: ASTableNode = ASTableNode(style: .plain)
    private let dataSource = MomentDataSource()
    private let header: MomentHeaderNode = MomentHeaderNode()
    private var statusBarStyle = UIStatusBarStyle.lightContent
    private var barTintColor: UIColor = .white
    private var newMessage: MomentNewMessage?
    private var hasNewMessage: Bool { return newMessage != nil }
    private var isLoadingMoments = false
    private var rightBarItem: UIBarButtonItem?
    private var titleView: UILabel?
    private var operationMenuView: MomentOperationMenuView?
    
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
        
        let titleLabel = UILabel()
        titleLabel.text = "朋友圈"
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        navigationItem.titleView = titleLabel
        self.titleView = titleLabel
        
        let rightButtonImage = UIImage.SVGImage(named: "icons_filled_camera")?.withRenderingMode(.alwaysTemplate)
        let rightButtonItem = UIBarButtonItem(image: rightButtonImage, style: .done, target: self, action: #selector(handleRightBarButtonTapped(_:)))
        navigationItem.rightBarButtonItem = rightButtonItem
        self.rightBarItem = rightButtonItem
        
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
    
    private func update(offset: CGFloat) {
        
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
        actionSheet.add(WXActionSheetItem(title: "从手机相册中选择", handler: { _ in
            
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
            let block: ASCellNodeBlock = {
                return MomentCellNode(moment: moment)
            }
            return block
        }
    }
    
    func shouldBatchFetch(for tableNode: ASTableNode) -> Bool {
        return true
    }
    
    func tableNode(_ tableNode: ASTableNode, willBeginBatchFetchWith context: ASBatchContext) {
        print("willBeginBatchFetchWith")
        fetchNextMoments(with: context)
    }
}

// MARK: - UIScrollViewDelegate

extension MomentsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        print(y)
        
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
        } else if y < threshold + barHeight {
            //let alpha = (y - threshold)/barHeight
            updateStatusBarStyle(.default)
            titleView?.alpha = 0
            titleView?.isHidden = true
            barTintColor = .black
        } else {
            let progress = (y - threshold - barHeight)/barHeight
            let alpha = max(0, min(progress, 1))
            wc_navigationBar.alpha = alpha
            titleView?.alpha = alpha
            titleView?.isHidden = alpha == 0.0
            updateStatusBarStyle(.default)
            barTintColor = .black
        }
        if navigationController?.navigationBar.tintColor != barTintColor {
            navigationController?.navigationBar.tintColor = barTintColor
        }
    }
}

// MARK: - MomentCellNodeDelegate
extension MomentsViewController: MomentCellNodeDelegate {
    
    func momentCellNode(_ cellNode: MomentCellNode, didPressedMoreButton moreButton: ASButtonNode) {
        
    }
    
}
