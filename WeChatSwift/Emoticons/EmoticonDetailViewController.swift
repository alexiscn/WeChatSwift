//
//  EmoticonDetailViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/25.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class EmoticonDetailViewController: ASViewController<ASDisplayNode> {

    private let scrollNode: ASScrollNode
    
    private let coverNode: ASNetworkImageNode
    
    private let copyRightNode: ASTextNode
    
    init() {
        
        scrollNode = ASScrollNode()
        
        coverNode = ASNetworkImageNode()
        
        copyRightNode = ASTextNode()
        
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
    }
    


}
