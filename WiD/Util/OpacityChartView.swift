//
//  OpacityChartView.swift
//  WiD
//
//  Created by jjkim on 2023/10/29.
//

import SwiftUI

struct OpacityChartView: View {
    let date: Date
    let wiDList: [WiD]
    let totalDuration: TimeInterval
    let opacity: Double
    
    init(date: Date, wiDList: [WiD]) {
        self.date = date
        self.wiDList = wiDList
        self.totalDuration = wiDList.map { $0.duration }.reduce(0, +)
        
        let maxDuration: Double = 60 * 60 * 10
        
        if totalDuration <= maxDuration / 5 {
            self.opacity = 0.2
        } else if totalDuration <= maxDuration * 2 / 5 {
            self.opacity = 0.4
        } else if totalDuration <= maxDuration * 3 / 5 {
            self.opacity = 0.6
        } else if totalDuration <= maxDuration * 4 / 5 {
            self.opacity = 0.8
        } else {
            self.opacity = 1.0
        }
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Rectangle()
                    .fill(wiDList.isEmpty ? .white : Color(wiDList[0].title).opacity(opacity))
                    .frame(width: geo.size.width * 0.9, height: geo.size.width * 0.9)
                    
                Text(formatDate(date, format: "d"))
                    .font(.system(size: 14))
//                    .fontWeight(wiDList.isEmpty ? nil : .bold)
                    .foregroundColor(wiDList.isEmpty ? .gray : .black)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .aspectRatio(contentMode: .fit)
    }
}

struct ExampleOpacityChartView: View {
    let title: String
    let opacity: Double
    
    init(title: String, opacity: Double) {
        self.title = title
        self.opacity = opacity
    }

    var body: some View {
        Rectangle()
            .fill(Color(title).opacity(opacity))
            .frame(width: 10, height: 10)
    }
}

struct OpacityChartView_Previews: PreviewProvider {
    static var previews: some View {
        OpacityChartView(date: Date(), wiDList: [])
    }
}
