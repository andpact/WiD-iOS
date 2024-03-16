//
//  WiDUtil.swift
//  WiD
//
//  Created by jjkim on 2023/07/15.
//

import SwiftUI

/**
 username 프로퍼티 추가해야 할 듯.
 */
struct WiD {
    var id: Int
//    var username: String
    var date: Date
    var title: String
    var start: Date
    var finish: Date
    var duration: TimeInterval
    
    init(id: Int, date: Date, title: String, start: Date, finish: Date, duration: TimeInterval) {
        self.id = id
        self.date = date
        self.title = title
        self.start = start
        self.finish = finish
        self.duration = duration
    }
}
