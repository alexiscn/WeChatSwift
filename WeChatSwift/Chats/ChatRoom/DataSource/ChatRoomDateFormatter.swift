//
//  ChatRoomDateFormatter.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/14.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation

/*
 https://kf.qq.com/faq/161224e2i22a161224qqYfAR.html
 微信聊天消息时间显示说明
 1、当天的消息，以每5分钟为一个跨度的显示时间；
 2、消息超过1天、小于1周，显示星期+收发消息的时间；
 3、消息大于1周，显示手机收发时间的日期。
 
 https://36kr.com/p/5213185
 12时
 0点到6点时为“凌晨”
 6点到12点时为“上午”
 12点到24点时为“下午”
 
 */

class ChatRoomDateFormatter {
    
    func formatTimestamp(_ timestamp: TimeInterval) -> String? {
        let nowTimestamp = Date().timeIntervalSince1970
        let day: TimeInterval = 24 * 60 * 60
        let intervals = nowTimestamp - timestamp
        if timestamp >= nowTimestamp {
            return "11:20"
        }
        if intervals >= 7 * day {
            return "2019年7月22号 下午7:00"
        } else if intervals > day {
            return "星期一 上午8:14"
        } else if intervals > 0 {
            return "下午2:14"
        } else {
            return "下午2:14"
        }
    }
}
