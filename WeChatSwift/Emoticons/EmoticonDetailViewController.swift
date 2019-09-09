//
//  EmoticonDetailViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/25.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit
import WXActionSheet

class EmoticonDetailViewController: ASViewController<ASDisplayNode> {

    private let scrollNode: ASScrollNode
    
    private let coverNode: ASNetworkImageNode
    
    private let descNode: EmoticonDetailPackageDescNode
    
    private let artistNode: EmoticonDetailArtistNode
    
    private let copyRightNode: ASTextNode
    
    init(emoticon: StoreEmoticonItem) {
        
        scrollNode = ASScrollNode()
        
        coverNode = ASNetworkImageNode()
        coverNode.backgroundColor = .red
        
        descNode = EmoticonDetailPackageDescNode(string: "11")
        
        copyRightNode = ASTextNode()
        
        artistNode = EmoticonDetailArtistNode(artist: MockFactory.shared.contacts().first!)
        
        super.init(node: ASDisplayNode())
        
        node.addSubnode(scrollNode)
        
        scrollNode.addSubnode(coverNode)
        scrollNode.addSubnode(descNode)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        
        scrollNode.frame = node.bounds
        
        navigationItem.title = "小刘鸭第二弹"
        
        let rightButton = UIBarButtonItem(image: UIImage.SVGImage(named: "icons_outlined_share"), style: .plain, target: self, action: #selector(handleRightButtonClicked))
        navigationItem.rightBarButtonItem = rightButton
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        coverNode.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 211)
        descNode.frame = CGRect(x: 0, y: 211, width: view.bounds.width, height: descNode.frame.height)
    }

}

// MARK: - Event Handlers
extension EmoticonDetailViewController {
 
    @objc private func handleRightButtonClicked() {
        let actionSheet = WXActionSheet(cancelButtonTitle: "取消")
        actionSheet.add(WXActionSheetItem(title: "分享给好友", handler: { _ in
            
        }))
        actionSheet.add(WXActionSheetItem(title: "分享到朋友圈", handler: { _ in
            
        }))
        actionSheet.show()
    }
    
}
