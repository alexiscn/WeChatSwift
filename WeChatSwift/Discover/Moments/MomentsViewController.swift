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
    private var statusBarStyle: UIStatusBarStyle = .lightContent
    private let header: MomentHeaderNode = MomentHeaderNode()
    
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

        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        
        tableNode.frame = view.bounds
        tableNode.view.allowsSelection = false
        tableNode.view.separatorStyle = .none
        tableNode.leadingScreensForBatching = 2
        
        let tableHeader = UIView()
        tableHeader.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 307)
        header.frame = tableHeader.bounds
        tableHeader.addSubnode(header)
        tableNode.view.tableHeaderView = tableHeader
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
}

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
