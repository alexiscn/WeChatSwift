//
//  MomentsViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/4.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class MomentsViewController: ASViewController<ASDisplayNode> {

    private let tableNode: ASTableNode = ASTableNode(style: .plain)
    private let dataSource = MomentDataSource()
    private let header: MomentHeaderNode = MomentHeaderNode()
    
    private var newMessage: MomentNewMessage?
    private var hasNewMessage: Bool { return newMessage != nil }
    private var isLoadingMoments = false
    private var rightBarItem: UIBarButtonItem?
    
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
        
        let rightButtonImage = UIImage.SVGImage(named: "icons_filled_camera")?.withRenderingMode(.alwaysTemplate)
        let rightButtonItem = UIBarButtonItem(image: rightButtonImage, style: .done, target: self, action: #selector(handleRightBarButtonTapped(_:)))
        navigationItem.rightBarButtonItem = rightButtonItem
        self.rightBarItem = rightButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle = .black
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.barStyle = .default
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
    
    private func updateNavigationBarTintColor(_ color: UIColor) {
        if color == navigationController?.navigationBar.tintColor {
            return
        }
        navigationController?.navigationBar.tintColor = color
    }
    
    private func updateStatusBarStyle(_ style: UIBarStyle) {
        if style == navigationController?.navigationBar.barStyle {
            return
        }
        navigationController?.navigationBar.barStyle = style
    }
    
    private func update(offset: CGFloat) {
        
    }
}

// MARK: - Event Handlers
extension MomentsViewController {
    @objc private func handleRightBarButtonTapped(_ sender: Any) {
        
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
        //print(y)
        
        // 307: TableNode Header Height
        // 70: Avatar Height
        // 30: Avatar Bottom Offset
        // 44: Navigation Bar Height
        let barHeight: CGFloat = 44.0
        let threshold: CGFloat = 307.0 - 70 - 30 - barHeight - Constants.statusBarHeight
        if y < threshold {
            updateNavigationBarTintColor(.white)
        } else if y < threshold + barHeight {
            let alpha = 1 - (y - threshold)/barHeight
            updateNavigationBarTintColor(UIColor(white: 1, alpha: alpha))
            updateStatusBarStyle(.black)
//            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        } else {
            let progress = (y - threshold - barHeight)/barHeight
            let alpha = min(progress, 1)
            updateNavigationBarTintColor(UIColor(white: 0, alpha: alpha))
            updateStatusBarStyle(.default)
//            print(alpha)
//            let image = UIImage(color: UIColor(hexString: "#EDEDED", alpha: Float(alpha)))
//            navigationController?.navigationBar.setBackgroundImage(image, for: .default)
        }
    }
}
