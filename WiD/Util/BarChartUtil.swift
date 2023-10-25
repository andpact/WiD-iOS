//
//  BarChartUtil.swift
//  WiD
//
//  Created by jjkim on 2023/10/25.
//

import SwiftUI

struct BarChartView: View {
    var wiDList: [WiD]
    var barChartData: [BarChartData]
    
    init(wiDList: [WiD]) {
        self.wiDList = wiDList

        var startMinutes: Int = 0
        let totalMinutes: Float = 24.0 * 60.0 // 24시간(1440분)으로 표현함. TimeInterval 단위는 초(second)를 사용함.

        var data: [BarChartData] = []
        
        if wiDList.isEmpty {
            let noPieChartData = BarChartData(value: 1, color: Color("light_gray"))
            data.append(noPieChartData)
        } else {
            for wid in wiDList {
                let startMinutesComponents = Calendar.current.dateComponents([.hour, .minute], from: wid.start)
                let startMinutesValue = (startMinutesComponents.hour ?? 0) * 60 + (startMinutesComponents.minute ?? 0)

                // 비어 있는 시간대의 엔트리 추가
                if startMinutesValue > startMinutes {
                    let emptyMinutes = startMinutesValue - startMinutes
                    let emptyPieChartData = BarChartData(value: Float(emptyMinutes) / totalMinutes, color: Color("light_gray"))
                    data.append(emptyPieChartData)
                }

                // 엔트리 셋에 해당 WiD 객체의 시간대를 추가
                let durationMinutes = Int(wid.duration / 60)
                let widPieChartData = BarChartData(value: Float(durationMinutes) / totalMinutes, color: Color(wid.title))
                data.append(widPieChartData)

                // 시작 시간 업데이트
                startMinutes = startMinutesValue + durationMinutes
            }
            
            // 마지막 WiD 객체 이후의 비어 있는 시간대의 엔트리 추가
            if startMinutes < 24 * 60 {
                let emptyMinutes = 24 * 60 - startMinutes
                let emptyPieChartData = BarChartData(value: Float(emptyMinutes) / totalMinutes, color: Color("light_gray"))
                data.append(emptyPieChartData)
            }
        }

        self.barChartData = data
    }

    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<barChartData.count, id: \.self) { index in
                BarView(data: barChartData[index])
                    .foregroundColor(barChartData[index].color)
                    .frame(height: UIScreen.main.bounds.size.height * 0.6 * CGFloat(barChartData[index].value))
            }
        }
        .border(.black)
    }
}

struct BarChartData {
    let value: Float
    let color: Color
}

struct BarView: View {
    let data: BarChartData
    
    init(data: BarChartData) {
        self.data = data
    }

    var body: some View {
        Rectangle()
            .frame(width: 30)
    }
}

//struct BarChartView_Previews: PreviewProvider {
//    static var previews: some View {
//        BarChartView()
//    }
//}
