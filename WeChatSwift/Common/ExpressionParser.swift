//
//  ExpressionParser.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/22.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit

fileprivate struct ExpressionRegexResult {
    var range: NSRange
    var text: String
    var expression: String?
}

class ExpressionParser {
    
    static let shared = try? ExpressionParser()
    
    private let regex: NSRegularExpression
    
    private init() throws {
        regex = try NSRegularExpression(pattern: pattern, options: [])
    }
    
    private let pattern = "\\[/?[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]"
    
    func attributedText(with attributedText: NSAttributedString) -> NSAttributedString {
        let regexes = parse(text: attributedText.string)
        if regexes.count == 0 {
            return attributedText
        }
        
        let result = NSMutableAttributedString(attributedString: attributedText)
        var offset: Int = 0
        let descender = UIFont.systemFont(ofSize: 17).descender
        for regex in regexes {
            if let expression = regex.expression {
                let attachment = NSTextAttachment()
                attachment.image = UIImage(named: expression)
                attachment.bounds = CGRect(x: 0, y: descender, width: 21, height: 21)
                let attachmentText = NSAttributedString(attachment: attachment)
                result.replaceCharacters(in: NSRange(location: offset, length: regex.range.length), with: attachmentText)
                offset += attachmentText.length
            } else {
                offset += regex.range.length
            }
        }
        return result
    }
    
    private func parse(text: String) -> [ExpressionRegexResult] {
        guard text.count > 2 else { return [] }
        
        let length = text.count
        let matches = regex.matches(in: text, options: [], range: NSRange(location: 0, length: length))
        if matches.count == 0 {
            return []
        }
        let expressions = Expression.all
        
        var resultList: [ExpressionRegexResult] = []
        var offset: Int = 0
        for (index, match) in matches.enumerated() {
            // 处理匹配到之前的
            if match.range.location > offset {
                let range = NSRange(location: offset, length: match.range.location - offset)
                let subText = text.subStringInRange(range)
                resultList.append(ExpressionRegexResult(range: range, text: subText, expression: nil))
            }
            // 处理匹配到的结果
            let innerText = text.subStringInRange(match.range)
            let emoji = expressions.first(where: { $0.text == innerText })
            let result = ExpressionRegexResult(range: match.range, text: innerText, expression: emoji?.icon)
            resultList.append(result)
            offset = match.range.location + match.range.length
            
            // 处理匹配之后的
            if index == matches.count - 1 {
                if length - offset > 0 {
                    let range = NSRange(location: offset, length: length - offset)
                    let subText = text.subStringInRange(range)
                    resultList.append(ExpressionRegexResult(range: range, text: subText, expression: nil))
                }
            }
        }
        return resultList
    }
    
}

extension String {
    func subStringInRange(_ range: NSRange) -> String {
        let start = self.index(startIndex, offsetBy: range.location)
        let end = self.index(start, offsetBy: range.length)
        return String(self[start..<end])
    }
}
