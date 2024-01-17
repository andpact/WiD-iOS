//
//  DurationUtil.swift
//  WiD
//
//  Created by jjkim on 2023/12/01.
//

import Foundation

/**
 Duration -> H시간 m분 s초 (ex. 10시간 30분 30초)
 */
func formatDuration(_ interval: TimeInterval, mode: Int) -> String {
    // mode 1. H시간 (10.5시간), m분 (30.5분)
    // mode 3. H시간 m분 s초 (10시간 30분 30초)
    
    let hours = Int(interval) / (60 * 60)
    let minutes = (Int(interval) / 60) % 60
    let seconds = Int(interval) % 60

    switch mode {
    case 1:
        let totalHours = Double(hours) + (Double(minutes) / 60.0)
        let totalMinutes = Double(minutes) + (Double(seconds) / 60.0)

        if totalHours >= 1.1 {
            let formattedTotalHours = ((totalHours * 10).rounded() / 10).truncatingRemainder(dividingBy: 1.0) == 0.0 ?
                String(format: "%.0f", totalHours) :
                String(format: "%.1f", totalHours)
            return "\(formattedTotalHours)시간"
        } else if totalHours >= 1.0 {
            return "\(hours)시간"
        } else if totalMinutes >= 1.1 {
            let formattedTotalMinutes = ((totalMinutes * 10).rounded() / 10).truncatingRemainder(dividingBy: 1.0) == 0.0 ?
                String(format: "%.0f", totalMinutes) :
                String(format: "%.1f", totalMinutes)
            return "\(formattedTotalMinutes)분"
        } else if totalMinutes >= 1.0 {
            return "\(minutes)분"
        } else {
            return "\(seconds)초"
        }

    case 3:
        if hours > 0 && minutes == 0 && seconds == 0 {
            return String(format: "%d시간", hours)
        } else if hours > 0 && minutes > 0 && seconds == 0 {
            return String(format: "%d시간 %d분", hours, minutes)
        } else if hours > 0 && minutes == 0 && seconds > 0 {
            return String(format: "%d시간 %d초", hours, seconds)
        } else if hours > 0 {
            return String(format: "%d시간 %d분 %d초", hours, minutes, seconds)
        } else if minutes > 0 && seconds == 0 {
            return String(format: "%d분", minutes)
        } else if minutes > 0 {
            return String(format: "%d분 %d초", minutes, seconds)
        } else {
            return String(format: "%d초", seconds)
        }

    default:
        fatalError("Invalid mode value")
    }
}

/**
 소수점 첫째 자리가 0일 때 자르기
 */
//    private let percentageFormatter: NumberFormatter = {
//       let formatter = NumberFormatter()
//       formatter.numberStyle = .percent
//       formatter.minimumFractionDigits = 0
//       formatter.maximumFractionDigits = 1
//       return formatter
//    }()

//    if let formattedPercentage = percentageFormatter.string(from: NSNumber(value: Double(remainingPercentage) / 100.0)) {
//        Text(formattedPercentage)
//            .font(.system(size: 40, weight: .black, design: .monospaced))
//    }
