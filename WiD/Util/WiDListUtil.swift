//
//  WiDListUtil.swift
//  WiD
//
//  Created by jjkim on 2023/11/15.
//

import SwiftUI

func getDailyTotalDuration(wiDList: [WiD]) -> TimeInterval {
    let totalDuration = wiDList.reduce(0) { $0 + $1.duration }
    return totalDuration
}

func getDailyTotalDurationPercentage(wiDList: [WiD]) -> Int {
    let totalDuration = getDailyTotalDuration(wiDList: wiDList)
    let totalSecondsIn24Hours: TimeInterval = 24 * 60 * 60
    
    if totalSecondsIn24Hours > 0 {
        let percentage = Int((totalDuration / totalSecondsIn24Hours) * 100)
        return min(percentage, 100) // Ensure the percentage is within [0, 100] range
    } else {
        return 0
    }
}
