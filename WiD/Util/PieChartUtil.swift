//
//  PieChartUtil.swift
//  WiD
//
//  Created by jjkim on 2023/07/15.
//

import SwiftUI

struct TmpPieChartView: View {
    let date: Date
    let wiDList: [WiD]
    
    var pieChartDataArray: [PieChartData] {
        let totalMinutes: TimeInterval = 60.0 * 24.0 // 24시간(1440분)으로 표현함. 원래 TimeInterval 단위는 초(second)
        var startMinutes: Int = 0
        var array: [PieChartData] = [] // Create a mutable array to store data

        // 비어 있는 시간대에 대한 PieChartData 생성
        if wiDList.isEmpty {
            let noPieChartData = PieChartData(value: .degrees(360.0), color: Color("light_gray"))
            array.append(noPieChartData)
        } else {
            for wid in wiDList {
                let startMinutesComponents = Calendar.current.dateComponents([.hour, .minute], from: wid.start)
                let startMinutesValue = (startMinutesComponents.hour ?? 0) * 60 + (startMinutesComponents.minute ?? 0)

                // 비어 있는 시간대의 엔트리 추가
                if startMinutesValue > startMinutes {
                    let emptyMinutes = startMinutesValue - startMinutes
                    let emptyPieChartData = PieChartData(value: .degrees(Double(emptyMinutes) / totalMinutes * 360.0), color: Color("light_gray"))
                    array.append(emptyPieChartData)
                }

                // 엔트리 셋에 해당 WiD 객체의 시간대를 추가
                let durationMinutes = Int(wid.duration / 60)
                let widPieChartData = PieChartData(value: .degrees(Double(durationMinutes) / totalMinutes * 360.0), color: Color(wid.title))
                array.append(widPieChartData)

                // 시작 시간 업데이트
                startMinutes = startMinutesValue + durationMinutes
            }

            // 마지막 WiD 객체 이후의 비어 있는 시간대의 엔트리 추가
            if startMinutes < 24 * 60 {
                let emptyMinutes = 24 * 60 - startMinutes
                let emptyPieChartData = PieChartData(value: .degrees(Double(emptyMinutes) / totalMinutes * 360.0), color: Color("light_gray"))
                array.append(emptyPieChartData)
            }
        }
        return array
    }
    
    init(date: Date, wiDList: [WiD]) {
        self.date = date
        self.wiDList = wiDList
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(0..<pieChartDataArray.count, id: \.self) { index in
                    PieSliceView(startAngle: getStartAngle(for: index), endAngle: getEndAngle(for: index))
                        .foregroundColor(pieChartDataArray[index].color)
                }

                // 중앙에 원
                Circle()
                    .frame(width: geo.size.width * 0.8, height: geo.size.width * 0.8)
                    .foregroundColor(.white)
                
                Text(formatDate(date, format: "d"))
                    .font(.system(size: 14))
                    .fontWeight(pieChartDataArray.count == 1 ? nil : .bold)
                    .foregroundColor(pieChartDataArray.count == 1 ? .gray : .black)
            }
        }
        .aspectRatio(contentMode: .fit)
    }
    
    func getStartAngle(for index: Int) -> Angle {
        var startAngle: Angle = .degrees(-90)
        for i in 0..<index {
            startAngle += pieChartDataArray[i].value
        }
        return startAngle
    }

    func getEndAngle(for index: Int) -> Angle {
        var endAngle: Angle = .degrees(-90)
        for i in 0...index {
            endAngle += pieChartDataArray[i].value
        }
        return endAngle
    }
}

struct PieChartView: View {
    var pieChartData: [PieChartData]
    var date: Date
    var isForOne: Bool
    var isEmpty: Bool
    
    init(pieChartData: [PieChartData], date: Date, isForOne: Bool, isEmpty: Bool) {
        self.pieChartData = pieChartData
        self.date = date
        self.isForOne = isForOne
        self.isEmpty = isEmpty
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(0..<pieChartData.count, id: \.self) { index in
                    PieSliceView(startAngle: getStartAngle(for: index), endAngle: getEndAngle(for: index))
                        .foregroundColor(pieChartData[index].color)
                        
                }

                // 중앙에 원
                Circle()
                    .frame(width: geo.size.width * 0.8, height: geo.size.width * 0.8)
                    .foregroundColor(.white)

                if isForOne {
                    // 숫자 텍스트
                    ForEach(1...24, id: \.self) { number in
                        let adjustedNumber = (number - 1) % 12 + 1
                        let angle = getAngle(for: number)
                        let radius = geo.size.width * 0.47 // 원의 반지름

                        let x = cos(angle.radians) * radius
                        let y = sin(angle.radians) * radius

                        Text("\(adjustedNumber)")
                            .font(.system(size: 10))
                            .position(x: geo.size.width / 2 + x, y: geo.size.width / 2 + y)
                    }
                    
                    Text("오후 | 오전")
//                        .position(x: geo.size.width / 2, y: geo.size.width / 2)
                        .foregroundColor(pieChartData.count == 1 ? .gray : .black)
                    
                } else {                    
                    if !isEmpty {
                        // 날짜 텍스트
                        Text(formatDate(date, format: "d"))
                            .font(.system(size: geo.size.width * 0.2))
                            .fontWeight(pieChartData.count == 1 ? nil : .bold)
//                            .position(x: geo.size.width / 2, y: geo.size.width / 2)
                            .foregroundColor(pieChartData.count == 1 ? .gray : .black)

                    }
                }
            }
        }
        .aspectRatio(contentMode: .fit)
    }

    func getStartAngle(for index: Int) -> Angle {
        var startAngle: Angle = .degrees(-90)
        for i in 0..<index {
            startAngle += pieChartData[i].value
        }
        return startAngle
    }

    func getEndAngle(for index: Int) -> Angle {
        var endAngle: Angle = .degrees(-90)
        for i in 0...index {
            endAngle += pieChartData[i].value
        }
        return endAngle
    }
    
    func getAngle(for number: Int) -> Angle {
        let degreesPerNumber = 360.0 / 24
        let angle = degreesPerNumber * Double(number) - 90
        return .degrees(angle)
    }
}

struct PieChartData {
    var value: Angle
    var color: Color
    
    init(value: Angle, color: Color) {
        self.value = value
        self.color = color
    }
}

struct PieSliceView: Shape {
    var startAngle: Angle
    var endAngle: Angle
    
    init(startAngle: Angle, endAngle: Angle) {
        self.startAngle = startAngle
        self.endAngle = endAngle
    }

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

func fetchPieChartData(date: Date) -> [PieChartData] {
    
    let wiDService = WiDService()
    let wiDList: [WiD] = wiDService.selectWiDsByDate(date: date)
    
    let totalMinutes: TimeInterval = 60.0 * 24.0 // 24시간(1440분)으로 표현함. 원래 TimeInterval 단위는 초(second)
    var startMinutes: Int = 0
    var pieChartDataArray: [PieChartData] = []

    // 비어 있는 시간대에 대한 PieChartData 생성
    if wiDList.isEmpty {
        let noPieChartData = PieChartData(value: .degrees(360.0), color: Color("light_gray"))
        pieChartDataArray.append(noPieChartData)
    } else {
        for wid in wiDList {
            let startMinutesComponents = Calendar.current.dateComponents([.hour, .minute], from: wid.start)
            let startMinutesValue = (startMinutesComponents.hour ?? 0) * 60 + (startMinutesComponents.minute ?? 0)

            // 비어 있는 시간대의 엔트리 추가
            if startMinutesValue > startMinutes {
                let emptyMinutes = startMinutesValue - startMinutes
                let emptyPieChartData = PieChartData(value: .degrees(Double(emptyMinutes) / totalMinutes * 360.0), color: Color("light_gray"))
                pieChartDataArray.append(emptyPieChartData)
            }

            // 엔트리 셋에 해당 WiD 객체의 시간대를 추가
            let durationMinutes = Int(wid.duration / 60)
            let widPieChartData = PieChartData(value: .degrees(Double(durationMinutes) / totalMinutes * 360.0), color: Color(wid.title))
            pieChartDataArray.append(widPieChartData)

            // 시작 시간 업데이트
            startMinutes = startMinutesValue + durationMinutes
        }
        
        // 마지막 WiD 객체 이후의 비어 있는 시간대의 엔트리 추가
        if startMinutes < 24 * 60 {
            let emptyMinutes = 24 * 60 - startMinutes
            let emptyPieChartData = PieChartData(value: .degrees(Double(emptyMinutes) / totalMinutes * 360.0), color: Color("light_gray"))
            pieChartDataArray.append(emptyPieChartData)
        }
    }
    return pieChartDataArray
}
