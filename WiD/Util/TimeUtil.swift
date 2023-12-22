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

    var hourViews: [Text] = []
    var minuteViews: [Text] = []
    var secondViews: [Text] = []

    if 0 < hours {
        hourViews.append(
            Text("\(hours)")
                .font(.system(size: 80, weight: .medium, design: .monospaced))
        )
        hourViews.append(
            Text("h")
                .font(.system(size: 20, weight: .light, design: .monospaced))
        )
        
        minuteViews.append(
            Text(String(format: "%02d", minutes))
                .font(.system(size: 80, weight: .medium, design: .monospaced))
        )

        minuteViews.append(
            Text("m")
                .font(.system(size: 20, weight: .light, design: .monospaced))
        )
        
        secondViews.append(
            Text(String(format: "%02d", seconds))
                .font(.system(size: 80, weight: .medium, design: .monospaced))
        )
        
        secondViews.append(
            Text("s")
                .font(.system(size: 20, weight: .light, design: .monospaced))
        )
    } else if 0 < minutes {
        minuteViews.append(
            Text("\(minutes)")
                .font(.system(size: 80, weight: .medium, design: .monospaced))
        )

        minuteViews.append(
            Text("m")
                .font(.system(size: 20, weight: .light, design: .monospaced))
        )
        
        secondViews.append(
            Text(String(format: "%02d", seconds))
                .font(.system(size: 80, weight: .medium, design: .monospaced))
        )
        
        secondViews.append(
            Text("s")
                .font(.system(size: 20, weight: .light, design: .monospaced))
        )
    } else {
        secondViews.append(
            Text("\(seconds)")
                .font(.system(size: 80, weight: .medium, design: .monospaced))
        )
        
        secondViews.append(
            Text("s")
                .font(.system(size: 20, weight: .light, design: .monospaced))
        )
    }

    return VStack(alignment: .trailing, spacing: 0) {
        // 시간(단위에 패딩을 설정해서 숫자와 높이를 맞춤.)
        HStack(alignment: .bottom, spacing: 0) {
            ForEach(hourViews.indices, id: \.self) { index in
                hourViews[index]
                    .padding(index == 0 ? [] : .bottom)
            }
        }

        // 분
        HStack(alignment: .bottom, spacing: 0) {
            ForEach(minuteViews.indices, id: \.self) { index in
                minuteViews[index]
                    .padding(index == 0 ? [] : .bottom)
            }
        }

        // 초
        HStack(alignment: .bottom, spacing: 0) {
            ForEach(secondViews.indices, id: \.self) { index in
                secondViews[index]
                    .padding(index == 0 ? [] : .bottom)
            }
        }
    }
}

func formatTimerTime(_ time: Int) -> some View {
    let hours = time / 3600
    let minutes = (time % 3600) / 60
    let seconds = time % 60

    var hourViews: [Text] = []
    var minuteViews: [Text] = []
    var secondViews: [Text] = []

    if 0 < hours {
        hourViews.append(
            Text("\(hours)")
                .font(.system(size: 80, weight: .medium, design: .monospaced))
        )
        hourViews.append(
            Text("h")
                .font(.system(size: 20, weight: .light, design: .monospaced))
        )
        
        minuteViews.append(
            Text(String(format: "%02d", minutes))
                .font(.system(size: 80, weight: .medium, design: .monospaced))
        )

        minuteViews.append(
            Text("m")
                .font(.system(size: 20, weight: .light, design: .monospaced))
        )
        
        secondViews.append(
            Text(String(format: "%02d", seconds))
                .font(.system(size: 80, weight: .medium, design: .monospaced))
        )
        
        secondViews.append(
            Text("s")
                .font(.system(size: 20, weight: .light, design: .monospaced))
        )
    } else if 0 < minutes {
        minuteViews.append(
            Text("\(minutes)")
                .font(.system(size: 80, weight: .medium, design: .monospaced))
        )

        minuteViews.append(
            Text("m")
                .font(.system(size: 20, weight: .light, design: .monospaced))
        )
        
        secondViews.append(
            Text(String(format: "%02d", seconds))
                .font(.system(size: 80, weight: .medium, design: .monospaced))
        )
        
        secondViews.append(
            Text("s")
                .font(.system(size: 20, weight: .light, design: .monospaced))
        )
    } else {
        secondViews.append(
            Text("\(seconds)")
                .font(.system(size: 80, weight: .medium, design: .monospaced))
        )
        
        secondViews.append(
            Text("s")
                .font(.system(size: 20, weight: .light, design: .monospaced))
        )
    }

    return HStack {
        // 시간(단위에 패딩을 설정해서 숫자와 높이를 맞춤.
        HStack(alignment: .bottom, spacing: 0) {
            ForEach(hourViews.indices, id: \.self) { index in
                hourViews[index]
                    .padding(index == 0 ? [] : .bottom)
            }
        }

        // 분
        HStack(alignment: .bottom, spacing: 0) {
            ForEach(minuteViews.indices, id: \.self) { index in
                minuteViews[index]
                    .padding(index == 0 ? [] : .bottom)
            }
        }

        // 초
        HStack(alignment: .bottom, spacing: 0) {
            ForEach(secondViews.indices, id: \.self) { index in
                secondViews[index]
                    .padding(index == 0 ? [] : .bottom)
            }
        }
    }
}
