//
//  ChatRoomBackgroundSettingViewController.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/8/4.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class ChatRoomBackgroundSettingViewController: ASViewController<ASCollectionNode> {
    
    private var dataSource: [String] = []
    
    private var doneButton: UIButton?
    
    init() {
        
        let padding: CGFloat = 12.0
        let spacing: CGFloat = 6.0
        let itemWidth = CGFloat(floorf(Float((Constants.screenWidth - 2 * padding - 2 * spacing)/3)))
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
        
        super.init(node: ASCollectionNode(collectionViewLayout: layout))
        node.dataSource = self
        node.delegate = self
        
        for i in 1 ... 9 {
            dataSource.append(String(i))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        
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
        let block: ASCellNodeBlock = {
            return ChatRoomBackgroundSettingCellNode(string: "1")
        }
        return block
    }
}

