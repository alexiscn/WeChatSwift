//
//  ChatRoomBackgroundSettingViewController.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/8/4.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class ChatRoomBackgroundSettingViewController: ASViewController<ASDisplayNode> {
    
    private var dataSource: [ChatRoomBackgroundItem] = []
    
    private var doneButton: UIButton?
    
    private var currentSelectIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    
    private let collectionNode: ASCollectionNode
    
    init() {
        
        let padding: CGFloat = 8.0
        let spacing: CGFloat = 4.0
        let itemWidth = CGFloat(floorf(Float((Constants.screenWidth - 2 * padding - 2 * spacing)/3)))
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
        
        collectionNode = ASCollectionNode(collectionViewLayout: layout)
        
        super.init(node: ASDisplayNode())
        node.addSubnode(collectionNode)
        collectionNode.dataSource = self
        collectionNode.delegate = self
        
        setupDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        collectionNode.frame = view.bounds
        collectionNode.backgroundColor = .clear
        navigationItem.title = "选择背景图"
        
        let cancelButton = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelButtonClicked))
        cancelButton.tintColor = .black
        navigationItem.leftBarButtonItem = cancelButton
        
        let doneButton = UIButton(type: .system)
        doneButton.layer.cornerRadius = 5
        doneButton.layer.masksToBounds = true
        doneButton.frame.size = CGSize(width: 56, height: 30)
        doneButton.backgroundColor = Colors.Brand
        doneButton.setBackgroundImage(UIImage(color: Colors.Brand_120), for: .disabled)
        doneButton.setBackgroundImage(UIImage(color: Colors.Brand), for: .normal)
        doneButton.setTitle("完成", for: .normal)
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneButton)
        doneButton.addTarget(self, action: #selector(doneButtonClicked), for: .touchUpInside)
        self.doneButton = doneButton
    }
    
    private func setupDataSource() {
        dataSource.append(ChatRoomBackgroundItem(imageName: nil, thumbImageName: nil, isSelected: true))
        for i in 1 ... 8 {
            let imageName = "ChatBackground_0\(i)"
            let thumbImageName = "ChatBackgroundThumb_0\(i)"
            let item = ChatRoomBackgroundItem(imageName: imageName, thumbImageName: thumbImageName, isSelected: false)
            dataSource.append(item )
        }
    }
}

// MARK: - Event Handlers
extension ChatRoomBackgroundSettingViewController {
    
    @objc private func cancelButtonClicked() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func doneButtonClicked() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - ASCollectionDelegate & ASCollectionDataSource
extension ChatRoomBackgroundSettingViewController: ASCollectionDelegate, ASCollectionDataSource {
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let background = dataSource[indexPath.row]
        let block: ASCellNodeBlock = {
            return ChatRoomBackgroundSettingCellNode(backgroundItem: background)
        }
        return block
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        dataSource[currentSelectIndexPath.row].isSelected = false
        dataSource[indexPath.row].isSelected = true
        collectionNode.reloadItems(at: [currentSelectIndexPath, indexPath])
        currentSelectIndexPath = indexPath
        
        let userSettings = AppContext.current.userSettings
        userSettings.globalBackgroundImage = dataSource[indexPath.row].imageName
    }
}


class ChatRoomBackgroundItem {
    var imageName: String?
    var thumbImageName: String?
    var isSelected: Bool
    
    var thumb: UIImage? {
        if let name = thumbImageName {
            return UIImage(named: name)
        }
        return nil
    }
    
    init(imageName: String?, thumbImageName: String?, isSelected: Bool) {
        self.imageName = imageName
        self.thumbImageName = thumbImageName
        self.isSelected = isSelected
    }
}
