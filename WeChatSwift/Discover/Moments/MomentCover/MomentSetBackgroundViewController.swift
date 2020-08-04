//
//  MomentSetBackgroundViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/16.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit
import PINRemoteImage

class MomentSetBackgroundViewController: ASDKViewController<ASDisplayNode> {
    
    private let tableNode = ASTableNode(style: .plain)
    
    private var dataSource: [MomentBackgroundGroup] = []
    
    override init() {
        super.init(node: ASDisplayNode())
        node.addSubnode(tableNode)
        tableNode.dataSource = self
        tableNode.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = UIColor(hexString: "#303030")
        tableNode.backgroundColor = .clear
        tableNode.frame = node.bounds
        tableNode.view.separatorStyle = .none
        tableNode.allowsSelection = false
        
        navigationItem.title = "更换相册封面"
        
        setupDataSource()
    }
    
    private func setupDataSource() {
        guard let path = Bundle.main.path(forResource: "MomentCoverBackground", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            return
        } 
        
        do {
            let model = try JSONDecoder().decode(MomentBackgroundModel.self, from: data)
            dataSource = model.photos
            setupTableHeader(artist: model.artist)
        } catch {
            print(error)
        }
    }
    
    private func setupTableHeader(artist: MomentBackgroundArtist) {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 172))
        let headerNode = MomentSetBackgroundHeaderNode(artist: artist)
        headerNode.frame = headerView.bounds
        headerView.addSubnode(headerNode)
        tableNode.view.tableHeaderView = headerView
    }
}

// MARK: - ASTableDelegate & ASTableDataSource
extension MomentSetBackgroundViewController: ASTableDelegate, ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let group = dataSource[indexPath.row]
        let block: ASCellNodeBlock = { [weak self] in
            let cellNode = MomentSetBackgroundCellNode(group: group)
            cellNode.delegate = self
            return cellNode
        }
        return block
    }
    
}

// MARK: - MomentSetBackgroundCellNodeDelegate
extension MomentSetBackgroundViewController: MomentSetBackgroundCellNodeDelegate {
    
    func momentSetBackgroundCellDidSelectBackground(_ background: MomentBackground, images: [MomentBackground]) {
        print(background)
        // TODO: - Preview
        guard let url = background.url else { return }
        PINRemoteImageManager.shared().downloadImage(with: url) { result in
            DispatchQueue.main.async {
                if let image = result.image {
                    AppContext.current.momentCoverManager.update(cover: image)
                }
            }
        }
    }
}
