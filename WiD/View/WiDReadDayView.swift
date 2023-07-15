//
//  WiDReadView.swift
//  WiD
//
//  Created by jjkim on 2023/07/08.
//

import SwiftUI

struct WiDReadDayView: View {
    @State private var wiDs: [WiD] = []
    private let wiDService = WiDService()
    
    @State private var currentDate: Date = Date()
    
    var body: some View {
        VStack {
            HStack {
                HStack {
                    Text(formatDate(currentDate, format: "yyyy.MM.dd"))
                    
                    Text(formatWeekday(currentDate))
                }
                .frame(maxWidth: .infinity)
                
                Button(action: {
                    currentDate = Date()
                }) {
                    Text("현재")
                }
                
                Button(action: {
                    currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
                    wiDs = wiDService.selectWiDsByDate(date: currentDate)
                }) {
                    Image(systemName: "chevron.left")
                }
                
                Button(action: {
                    currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
                    wiDs = wiDService.selectWiDsByDate(date: currentDate)
                }) {
                    Image(systemName: "chevron.right")
                }
                .disabled(Calendar.current.isDateInToday(currentDate))
            }
            .border(Color.black)
            
            PieChartView(data: fetchChartData())
                .border(Color.red)
            
//            VStack {
//                HStack {
//                    Text("제목")
//                        .frame(maxWidth: .infinity)
//                    Text("총합")
//                        .frame(maxWidth: .infinity)
//                }
//            }
//            .border(Color.black)
            Text(formatDate(updateFirstDayOfWeek(for: currentDate), format: "MM.dd E"))
            
            VStack {
                HStack {
                    Text("순서")
                        .frame(maxWidth: .infinity)
                    Text("제목")
                        .frame(maxWidth: .infinity)
                    Text("시작")
                        .frame(maxWidth: .infinity)
                    Text("종료")
                        .frame(maxWidth: .infinity)
                    Text("경과")
                        .frame(maxWidth: .infinity)
                    Text("자세히")
                        .frame(maxWidth: .infinity)
                }

                ForEach(Array(wiDs.enumerated()), id: \.element.id) { (index, wid) in
                    NavigationLink(destination: WiDView(clickedWiDId: wid.id)) {
                        HStack {
                            Text("\(index + 1)")
                                .frame(maxWidth: .infinity)
                            Text(wid.title)
                                .frame(maxWidth: .infinity)
                            Text(formatTime(wid.start, format: "HH:mm"))
                                .frame(maxWidth: .infinity)
                            Text(formatTime(wid.finish, format: "HH:mm"))
                                .frame(maxWidth: .infinity)
                            Text(formatDuration(wid.duration, isClickedWiD: false))
                                .frame(maxWidth: .infinity)
                            Text("(\(wid.detail.count))")
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
            .frame(maxHeight: .infinity)
            .border(Color.black)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .border(Color.black)
        .padding(.horizontal)
        .onAppear {
            wiDs = wiDService.selectWiDsByDate(date: currentDate)
        }
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

struct WiDReadView_Previews: PreviewProvider {
    static var previews: some View {
        WiDReadDayView()
    }
}
