//
//  WiDUtil.swift
//  WiD
//
//  Created by jjkim on 2023/07/15.
//

import SwiftUI

struct WiD {
    var id: Int
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
