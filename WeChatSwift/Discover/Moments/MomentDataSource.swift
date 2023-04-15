//
//  MomentDataSource.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/1.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation

typealias MomentDataFetchCompletion = (_ success: Bool, _ newsCount: Int) -> Void

class MomentDataSource {
    
    private var moments: [Moment] = []
    
    init() {
        moments = MockFactory.shared.moments()
    }
    
    func numberOfItems() -> Int {
        return moments.count
    }
    
    func item(at indexPath: IndexPath) -> Moment {
        return moments[indexPath.row]
    }
    
    func fetchNext(completion: @escaping MomentDataFetchCompletion) {
        
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 2, execute: { [unowned self] in
            DispatchQueue.main.async {
                let newMoments = MockFactory.shared.moments()
                self.moments.append(contentsOf: newMoments)
                completion(true, newMoments.count)
            }
            
        })
    }
}
