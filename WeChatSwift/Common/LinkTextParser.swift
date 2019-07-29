//
//  LinkTextParser.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/27.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation

struct LinkParserResult {
    var range: NSRange
    var url: URL?
}

class LinkTextParser {
    
    private let pattern = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
    //[-a-zA-Z0-9@:%_+.~#?&//=]{1,256}\.[a-z]{2,4}\b([-a-zA-Z0-9@:%_+.~#?&//=]*)?
    
    static let shared = try! LinkTextParser()
    
    private let regex: NSRegularExpression
    
    private init() throws {
        regex = try NSRegularExpression(pattern: pattern, options: [])
    }
    
    func containsLink(text: String) -> Bool {
        return regex.firstMatch(in: text, options: .withoutAnchoringBounds, range: NSRange(location: 0, length: text.count)) != nil
    }
    
    func match(text: String) -> [LinkParserResult] {
        let matches = regex.matches(in: text, options: .withoutAnchoringBounds, range: NSRange(location: 0, length: text.count))
        var list: [LinkParserResult] = []
        for match in matches {
            let range = match.range
            let start = text.index(text.startIndex, offsetBy: range.location)
            let end = text.index(text.startIndex, offsetBy: range.location + range.length)
            let value = String(text[start..<end])
            list.append(LinkParserResult(range: range, url: URL(string: value)))
        }
        return list
    }
}
