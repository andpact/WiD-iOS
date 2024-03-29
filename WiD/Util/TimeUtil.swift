//
//  DateTimeDurationUtil.swift
//  WiD
//
//  Created by jjkim on 2023/07/15.
//

import SwiftUI
import Foundation

func getTimeString(_ date: Date) -> String {
    print("TimeUtil : getTimeString executed")
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "a hh:mm:ss"
    return dateFormatter.string(from: date)
}

func getVerticalTimeView(_ time: Int) -> some View {
    print("TimeUtil : getVerticalTimeView executed")
    
    let hours = time / 3600
    let minutes = (time % 3600) / 60
    let seconds = time % 60

//    return VStack(alignment: .trailing, spacing: 0) {
    return VStack(spacing: 0) {
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
                .foregroundColor(seconds == 0 ? Color("DarkGray") : nil)
        }
    }
    .font(.custom("ChivoMono-BlackItalic", size: 120))
}

/**
 폰트는 화면에서 각각 지정함.
 */
func getHorizontalTimeView(_ time: Int) -> some View {
    print("TimeUtil : getHorizontalTimeView executed")
    
    let hours = time / 3600
    let minutes = (time % 3600) / 60
    let seconds = time % 60

    return HStack {
        Text("\(hours):\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))")
    }
}
