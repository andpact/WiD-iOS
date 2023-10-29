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

        if totalDuration <= 2 * 60 * 60 {
            self.opacity = 0.2
        } else if totalDuration <= 4 * 60 * 60 {
            self.opacity = 0.4
        } else if totalDuration <= 6 * 60 * 60 {
            self.opacity = 0.6
        } else if totalDuration <= 8 * 60 * 60 {
            self.opacity = 0.8
        } else {
            self.opacity = 1.0
        }
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Rectangle()
                    .opacity(opacity)
                    .background(RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1)
                        .background(wiDList.isEmpty ? Color("light_gray").opacity(0.5) : Color(wiDList[0].title))
                    )
                    .padding(4)
                
                Text(formatDate(date, format: "d"))
                    .font(.system(size: 14))
                    .fontWeight(wiDList.isEmpty ? nil : .bold)
                    .foregroundColor(wiDList.isEmpty ? .gray : .black)
            }
        }
        .aspectRatio(contentMode: .fit)
    }
}

struct OpacityChartView_Previews: PreviewProvider {
    static var previews: some View {
        OpacityChartView(date: Date(), wiDList: [])
    }
}
