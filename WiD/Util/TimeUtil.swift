//
//  DateTimeDurationUtil.swift
//  WiD
//
//  Created by jjkim on 2023/07/15.
//

import SwiftUI
import Foundation

func formatTime(_ date: Date, format: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: date)
}

func formatStopWatchTime(_ time: Int) -> some View {
    let hours = time / 3600
    let minutes = (time % 3600) / 60
    let seconds = time % 60

    return VStack(alignment: .trailing, spacing: 0) {
        if 0 < hours {
            Text("\(hours)")
                .frame(maxHeight: 90)
            
            Text(String(format: "%02d", minutes))
                .frame(maxHeight: 90)
            
            Text(String(format: "%02d", seconds))
                .frame(maxHeight: 90)
        } else if 0 < minutes {
            Text("\(minutes)")
                .frame(maxHeight: 90)
            
            Text(String(format: "%02d", seconds))
                .frame(maxHeight: 90)
        } else {
            Text("\(seconds)")
                .frame(maxHeight: 90)
        }
    }
}

func formatTimerTime(_ time: Int) -> some View {
    let hours = time / 3600
    let minutes = (time % 3600) / 60
    let seconds = time % 60

    return HStack {
        Text("\(hours):\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))")
    }
}
