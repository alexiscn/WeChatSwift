//
//  DiscoverManager.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/8/3.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation

class DiscoverManager {
    
    static let shared = DiscoverManager()
    
    private init() {
        
    }
    
    func discoverEntrance() -> [DiscoverSection] {
        var sections: [DiscoverSection] = []
        var moment = DiscoverModel(type: .moment, title: "朋友圈", icon: "icons_outlined_colorful_moment")
        moment.unreadCount = 2
        sections.append(DiscoverSection(models: [moment]))
        
        sections.append(DiscoverSection(models: [
            DiscoverModel(type: .scan, title: "扫一扫", icon: "icons_outlined_scan", color: Colors.Indigo),
            DiscoverModel(type: .shake, title: "摇一摇", icon: "icons_outlined_shake", color: Colors.Indigo)]
        ))
        
        sections.append(DiscoverSection(models: [
            DiscoverModel(type: .news, title: "看一看", icon: "icons_outlined_news", color: Colors.Yellow),
            DiscoverModel(type: .news, title: "搜一搜", icon: "icons_filled_search-logo", color: Colors.Red)
            ]))
        
        sections.append(DiscoverSection(models: [DiscoverModel(type: .nearby, title: "附近的人", icon: "icons_outlined_nearby", color: Colors.Indigo)]))
        sections.append(DiscoverSection(models: [
            DiscoverModel(type: .shop, title: "购物", icon: "icons_outlined_shop", color: Colors.Orange),
            DiscoverModel(type: .game, title: "游戏", icon: "icons_outlined_colorful_game")]))
        sections.append(DiscoverSection(models: [DiscoverModel(type: .miniProgram, title: "小程序", icon: "icons_outlined_miniprogram", color: Colors.Purple)]))
        return sections
    }
}
