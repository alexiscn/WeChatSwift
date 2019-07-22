//
//  Expression.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/7/10.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation
import UIKit

struct Expression: Codable, Emoticon {
    
    var title: String? = nil
    
    var thumbImage: UIImage? { return UIImage.as_imageNamed(icon) }

    static var all: [Expression] = {
        guard let path = Bundle.main.path(forResource: "Expressions", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
                return []
        }
        do {
            let expressions = try JSONDecoder().decode([Expression].self, from: data)
            return expressions
        } catch {
            print(error)
        }
        return []
    }()
    
    var icon: String
    var zh: String
    var code: String
    
    var text: String {
        return "[\(zh)]"
    }
    
    func match(text: String) -> Bool {
        return self.text == text
    }
}
