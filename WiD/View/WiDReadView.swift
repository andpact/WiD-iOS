//
//  WiDReadView.swift
//  WiD
//
//  Created by jjkim on 2023/07/08.
//

import SwiftUI

struct WiDReadView: View {
    @State private var wiDs: [WiD] = []
    private let wiDService = WiDService()
    
    @State private var currentDate: Date = Date()
    
//    @State private var totalDurationForTitle: [String: TimeInterval] = [:]
//
//    private let allTitleCases: [Title] = [.study, .work, .reading, .exercise, .hobby, .meal, .shower, .travel, .sleep, .other]
//
//    init() {
//        for title in allTitleCases {
//            totalDurationForTitle[title.stringValue] = 0
//        }
//    }
    
    var body: some View {
        VStack {
            HStack {
                HStack {
                    Text(formatDate(currentDate, format: "yyyy.MM.dd"))
                    
                    Text(formatWeekday(currentDate))
                }
                .frame(maxWidth: .infinity)
                
                Text("현재")
                
                Button(action: {
                    currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
                    fetchWiDs()
                }) {
                    Image(systemName: "chevron.left")
                }
                
                Button(action: {
                    currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
                    fetchWiDs()
                }) {
                    Image(systemName: "chevron.right")
                }
            }
            .border(Color.black)
            
            PieChartView(data: fetchChartData())
                .border(Color.black)
            
//            VStack {
//                HStack {
//                    Text("제목")
//                        .frame(maxWidth: .infinity)
//                    Text("총합")
//                        .frame(maxWidth: .infinity)
//                }
//
//                ForEach(totalDurationForTitle.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
//                    if value > 0 {
//                        HStack {
//                            Text(key)
//                                .frame(maxWidth: .infinity)
//                            Text(formatDuration(value))
//                                .frame(maxWidth: .infinity)
//                        }
//                    }
//                }
//            }
//            .border(Color.black)
            
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
                    HStack {
                        Text("\(index + 1)")
                            .frame(maxWidth: .infinity)
                        Text(wid.title)
                            .frame(maxWidth: .infinity)
                        Text(formatTime(wid.start, format: "HH:mm"))
                            .frame(maxWidth: .infinity)
                        Text(formatTime(wid.finish, format: "HH:mm"))
                            .frame(maxWidth: .infinity)
                        Text(formatDuration(wid.duration))
                            .frame(maxWidth: .infinity)
                        Text("...")
                            .frame(maxWidth: .infinity)
                    }
                }
            }
//            .frame(maxHeight: .infinity)
            .border(Color.black)
            
            Button(action: {
                deleteAllWiDs()
            }) {
                Text("모두 삭제")
                    .foregroundColor(.red)
            }
        }
        .frame(maxHeight: .infinity)
        .border(Color.black)
        .padding()
        .onAppear {
            fetchWiDs()
        }
    }
    
    func formatDate(_ date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    func formatWeekday(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        return dateFormatter.string(from: date)
    }
    
    func formatTime(_ date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    func formatDuration(_ interval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: interval) ?? ""
    }
    
    func fetchWiDs() {
        wiDs = wiDService.selectWiDsByDate(date: currentDate)
    }
    
    func fetchChartData() -> [ChartData] {
        
        let totalMinutes: TimeInterval = 60.0 * 24.0 // 24시간(1440분)으로 표현함. 원래 TimeInterval 단위는 초(second)

        var startMinutes: Int = 0
        var chartDataArray: [ChartData] = []

        // 비어 있는 시간대에 대한 ChartData 생성
        if wiDs.isEmpty {
            let noDataChartData = ChartData(value: .degrees(360.0), color: .gray) // 색상은 필요에 따라 변경 가능
            chartDataArray.append(noDataChartData)
        } else {
            for wid in wiDs {
                // Calculate the total duration for each title
//                if let currentTotalDuration = totalDurationForTitle[wid.title] {
//                    totalDurationForTitle[wid.title] = currentTotalDuration + wid.duration
//                }
                
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

    func deleteAllWiDs() {
        wiDService.deleteAllWiDs()
        fetchWiDs()
    }
}

struct WiDReadView_Previews: PreviewProvider {
    static var previews: some View {
        WiDReadView()
    }
}

struct PieChartView: View {
    var data: [ChartData]

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<data.count, id: \.self) { index in
                    PieSlice(startAngle: getStartAngle(for: index), endAngle: getEndAngle(for: index))
                        .foregroundColor(data[index].color)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.width)
        }
    }
    
    func getStartAngle(for index: Int) -> Angle {
        var startAngle: Angle = .degrees(-90)
        for i in 0..<index {
            startAngle += data[i].value
        }
        return startAngle
    }

    func getEndAngle(for index: Int) -> Angle {
        var endAngle: Angle = .degrees(-90)
        for i in 0...index {
            endAngle += data[i].value
        }
        return endAngle
    }
}

struct ChartData {
    var value: Angle
    var color: Color
}

struct PieSlice: Shape {
    var startAngle: Angle
    var endAngle: Angle
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        path.move(to: center)
        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        path.closeSubpath()
        
        return path
    }
}
