//
//  PieChartUtil.swift
//  WiD
//
//  Created by jjkim on 2023/07/15.
//

import SwiftUI

struct PieChartView: View {
    var data: [ChartData]
    var date: Date
    var isForOne: Bool
    var isEmpty: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<data.count, id: \.self) { index in
                    PieSlice(startAngle: getStartAngle(for: index), endAngle: getEndAngle(for: index))
                        .foregroundColor(data[index].color)
                        
                }
//                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)

                // 중앙에 원
                Circle()
                    .frame(width: geometry.size.width * 0.6, height: geometry.size.width * 0.6)
                    .foregroundColor(.white)

                if isForOne {
                    // 숫자 텍스트
                    ForEach(1...24, id: \.self) { number in
                        let angle = getAngle(for: number)
                        let radius = geometry.size.width * 0.45 // 원의 반지름

                        let x = cos(angle.radians) * radius
                        let y = sin(angle.radians) * radius

                        Text("\(number)")
                            .font(.system(size: 8))
                            .position(x: geometry.size.width / 2 + x, y: geometry.size.width / 2 + y)
                    }
                    
                    Text("WiD")
                        .font(.custom("Acme-Regular", size: 30))
                        .position(x: geometry.size.width / 2, y: geometry.size.width / 2)
                        .foregroundColor(data.count == 1 ? .gray : .black)
                    
                } else {                    
                    if !isEmpty {
                        // 날짜 텍스트
                        Text(formatDate(date, format: "d"))
                            .font(.system(size: geometry.size.width * 0.2, weight: .bold, design: .default))
                            .position(x: geometry.size.width / 2, y: geometry.size.width / 2)
                            .foregroundColor(data.count == 1 ? .gray : .black)

                    }
                }
            }
        }
        .aspectRatio(contentMode: .fit)
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
    
    func getAngle(for number: Int) -> Angle {
        let degreesPerNumber = 360.0 / 24
        let angle = degreesPerNumber * Double(number) - 90
        return .degrees(angle)
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

func fetchChartData(date: Date) -> [ChartData] {
    
    let wiDService = WiDService()
    let wiDs: [WiD] = wiDService.selectWiDsByDate(date: date)
    
    let totalMinutes: TimeInterval = 60.0 * 24.0 // 24시간(1440분)으로 표현함. 원래 TimeInterval 단위는 초(second)

    var startMinutes: Int = 0
    var chartDataArray: [ChartData] = []

    // 비어 있는 시간대에 대한 ChartData 생성
    if wiDs.isEmpty {
        let noDataChartData = ChartData(value: .degrees(360.0), color: Color("light_gray"))
        chartDataArray.append(noDataChartData)
    } else {
        for wid in wiDs {
            let startMinutesComponents = Calendar.current.dateComponents([.hour, .minute], from: wid.start)
            let startMinutesValue = (startMinutesComponents.hour ?? 0) * 60 + (startMinutesComponents.minute ?? 0)

            // 비어 있는 시간대의 엔트리 추가
            if startMinutesValue > startMinutes {
                let emptyMinutes = startMinutesValue - startMinutes
                let emptyChartData = ChartData(value: .degrees(Double(emptyMinutes) / totalMinutes * 360.0), color: Color("light_gray"))
                chartDataArray.append(emptyChartData)
            }

            // 엔트리 셋에 해당 WiD 객체의 시간대를 추가
            let durationMinutes = Int(wid.duration / 60)
            let widChartData = ChartData(value: .degrees(Double(durationMinutes) / totalMinutes * 360.0), color: Color(wid.title))
            chartDataArray.append(widChartData)

            // 시작 시간 업데이트
            startMinutes = startMinutesValue + durationMinutes
        }
        
        // 마지막 WiD 객체 이후의 비어 있는 시간대의 엔트리 추가
        if startMinutes < 24 * 60 {
            let emptyMinutes = 24 * 60 - startMinutes
            let emptyChartData = ChartData(value: .degrees(Double(emptyMinutes) / totalMinutes * 360.0), color: Color("light_gray"))
            chartDataArray.append(emptyChartData)
        }
    }
    return chartDataArray
}
