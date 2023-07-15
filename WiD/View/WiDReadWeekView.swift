//
//  WiDReadWeekView.swift
//  WiD
//
//  Created by jjkim on 2023/07/14.
//

import SwiftUI

struct WiDReadWeekView: View {
    @State private var wiDs: [WiD] = []
    private let wiDService = WiDService()
    
    @State private var currentDate: Date = Date()
    
    var body: some View {
        VStack {
            HStack {
                HStack {
                    Text(formatDate(currentDate, format: "yyyy년"))
                        
                    Text("\(weekNumber(for: currentDate))번째 주")
                }
                .frame(maxWidth: .infinity)

                Button(action: {
                    currentDate = Date()
                }) {
                    Text("현재")
                }
                
                Button(action: {
                    currentDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: currentDate) ?? currentDate
                }) {
                    Image(systemName: "chevron.left")
                }

                Button(action: {
                    currentDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: currentDate) ?? currentDate
                }) {
                    Image(systemName: "chevron.right")
                }
                .disabled(Calendar.current.isDateInToday(currentDate))
            }
            .border(Color.black)
            
            HStack(spacing: 0) {
                ForEach(1...7, id: \.self) { index in
                    let textColor = index == 7 ? Color.red : (index == 6 ? Color.blue : Color.black)
                    
                    Text(formatWeekdayLetter(index))
                        .frame(maxWidth: .infinity)
                        .foregroundColor(textColor)
                }
            }
            .frame(maxWidth: .infinity)
            
            HStack(spacing: 0) {

            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .border(Color.black)
        .padding(.horizontal)
    }
    
    private func fetchChartData() -> [ChartData] {

        let totalMinutes: TimeInterval = 60.0 * 24.0 // 24시간(1440분)으로 표현함. 원래 TimeInterval 단위는 초(second)

        var startMinutes: Int = 0
        var chartDataArray: [ChartData] = []

        // 비어 있는 시간대에 대한 ChartData 생성
        if wiDs.isEmpty {
            let noDataChartData = ChartData(value: .degrees(360.0), color: .gray) // 색상은 필요에 따라 변경 가능
            chartDataArray.append(noDataChartData)
        } else {
            for wid in wiDs {
                let startMinutesComponents = Calendar.current.dateComponents([.hour, .minute], from: wid.start)
                let startMinutesValue = (startMinutesComponents.hour ?? 0) * 60 + (startMinutesComponents.minute ?? 0)

                // 비어 있는 시간대의 엔트리 추가
                if startMinutesValue > startMinutes {
                    let emptyMinutes = startMinutesValue - startMinutes
                    let emptyChartData = ChartData(value: .degrees(Double(emptyMinutes) / totalMinutes * 360.0), color: .gray)
                    chartDataArray.append(emptyChartData)
                }

                // 엔트리 셋에 해당 WiD 객체의 시간대를 추가
                let durationMinutes = Int(wid.duration / 60)
                let widChartData = ChartData(value: .degrees(Double(durationMinutes) / totalMinutes * 360.0), color: Color(wid.title))
                chartDataArray.append(widChartData)

                // 시작 시간 업데이트
                startMinutes = startMinutesValue + durationMinutes
            }
        }

        // 마지막 WiD 객체 이후의 비어 있는 시간대의 엔트리 추가
        if startMinutes < 24 * 60 {
            let emptyMinutes = 24 * 60 - startMinutes
            let emptyChartData = ChartData(value: .degrees(Double(emptyMinutes) / totalMinutes * 360.0), color: .gray)
            chartDataArray.append(emptyChartData)
        }

        return chartDataArray
    }
}

struct WiDReadWeekView_Previews: PreviewProvider {
    static var previews: some View {
        WiDReadWeekView()
    }
}
