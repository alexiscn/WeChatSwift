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
        var moment = DiscoverModel(type: .moment, title: LocalizedString("FF_Entry_Album"), icon: "icons_outlined_colorful_moment")
        moment.unreadCount = 2
        sections.append(DiscoverSection(models: [moment]))
        
        sections.append(DiscoverSection(models: [
            DiscoverModel(type: .scan, title: LocalizedString("FF_Entry_Scan"), icon: "icons_outlined_scan", color: Colors.Indigo),
            DiscoverModel(type: .shake, title: LocalizedString("FF_Entry_Shake"), icon: "icons_outlined_shake", color: Colors.Indigo)]
        ))
        
        sections.append(DiscoverSection(models: [
            DiscoverModel(type: .news, title: LocalizedString("FF_Entry_Browse"), icon: "icons_outlined_news", color: Colors.Yellow),
            DiscoverModel(type: .news, title: LocalizedString("FF_Entry_Search"), icon: "icons_filled_search-logo", color: Colors.Red)
            ]))
        
        sections.append(DiscoverSection(models: [DiscoverModel(type: .nearby, title: LocalizedString("FF_Entry_PeopleNearBy"), icon: "icons_outlined_nearby", color: Colors.Indigo)]))
        
        if LanguageManager.shared.current == .simplefiedChinese {
        sections.append(DiscoverSection(models: [
            DiscoverModel(type: .shop, title: "购物", icon: "icons_outlined_shop", color: Colors.Orange),
            DiscoverModel(type: .game, title: LocalizedString("MainFrame_RBtnGame"), icon: "icons_outlined_colorful_game")]))
        } else {
            sections.append(DiscoverSection(models: [ DiscoverModel(type: .game, title: LocalizedString("MainFrame_RBtnGame"), icon: "icons_outlined_colorful_game")]))
        }
        
        sections.append(DiscoverSection(models: [DiscoverModel(type: .miniProgram, title: LocalizedString("WCAppBrand_Name"), icon: "icons_outlined_miniprogram", color: Colors.Purple)]))
        return sections
    }
}
