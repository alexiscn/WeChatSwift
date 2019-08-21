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
    
    private let artistNode: EmoticonDetailArtistNode
    
    private let copyRightNode: ASTextNode
    
    init() {
        
        scrollNode = ASScrollNode()
        
        coverNode = ASNetworkImageNode()
        
        copyRightNode = ASTextNode()
        
        artistNode = EmoticonDetailArtistNode(artist: MockFactory.shared.users.last!.toContact())
        
        super.init(node: ASDisplayNode())
        
        node.addSubnode(scrollNode)
        
        scrollNode.addSubnode(coverNode)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        
        navigationItem.title = "小刘鸭第二弹"
        
        let rightButton = UIBarButtonItem(image: UIImage.SVGImage(named: "icons_outlined_share"), style: .plain, target: self, action: #selector(handleRightButtonClicked))
        navigationItem.rightBarButtonItem = rightButton
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
