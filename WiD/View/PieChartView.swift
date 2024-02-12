//
//  PieChartUtil.swift
//  WiD
//
//  Created by jjkim on 2023/07/15.
//

import SwiftUI

/*
 부모 뷰의 타이머에 의해 파이 차트가 계속 갱신되는 듯?
 */
struct DatePieChartView: View {
    private let wiDList: [WiD]
    
    private var pieChartDataArray: [PieData] {
        let totalMinutes: TimeInterval = 60.0 * 24.0 // 24시간(1440분)으로 표현함. 원래 TimeInterval 단위는 초(second)
        var startMinutes: Int = 0
        var array: [PieData] = []

        // 비어 있는 시간대에 대한 PieChartData 생성
        if wiDList.isEmpty {
            let noPieChartData = PieData(value: .degrees(360.0), color: Color("Black-White"))
            array.append(noPieChartData)
        } else {
            for wid in wiDList {
                let startMinutesComponents = Calendar.current.dateComponents([.hour, .minute], from: wid.start)
                let startMinutesValue = (startMinutesComponents.hour ?? 0) * 60 + (startMinutesComponents.minute ?? 0)

                // 비어 있는 시간대의 엔트리 추가
                if startMinutesValue > startMinutes {
                    let emptyMinutes = startMinutesValue - startMinutes
                    let emptyPieChartData = PieData(value: .degrees(Double(emptyMinutes) / totalMinutes * 360.0), color: Color("Black-White"))
                    array.append(emptyPieChartData)
                }

                // 엔트리 셋에 해당 WiD 객체의 시간대를 추가
                let durationMinutes = Int(wid.duration / 60)
                let widPieChartData = PieData(value: .degrees(Double(durationMinutes) / totalMinutes * 360.0), color: Color(wid.title))
                array.append(widPieChartData)

                // 시작 시간 업데이트
                startMinutes = startMinutesValue + durationMinutes
            }

            // 마지막 WiD 객체 이후의 비어 있는 시간대의 엔트리 추가
            if startMinutes < 24 * 60 {
                let emptyMinutes = 24 * 60 - startMinutes
                let emptyPieChartData = PieData(value: .degrees(Double(emptyMinutes) / totalMinutes * 360.0), color: Color("Black-White"))
                array.append(emptyPieChartData)
            }
        }
        return array
    }
    
    var totalDurationPercentage: Int {
        let totalMinutesInDay = 60 * 24
        var totalDurationMinutes: Int = 0

        for wid in wiDList {
            totalDurationMinutes += Int(wid.duration / 60) // Convert duration to minutes
        }

        return Int(Double(totalDurationMinutes) / Double(totalMinutesInDay) * 100)
    }

    init(wiDList: [WiD]) {
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
//                    .frame(width: geo.size.width * 0.95, height: geo.size.width * 0.95)
                    .foregroundColor(Color("White-Black"))
                
                // 숫자 텍스트
                ForEach(1...24, id: \.self) { number in
                    let adjustedNumber = (number - 1) % 12 + 1
                    let numberTextangle = getAngle(for: number)
                    let numberTextRadius = geo.size.width * 0.45 // 텍스트가 표시되는 원의 반지름

                    let x = cos(numberTextangle.radians) * numberTextRadius
                    let y = sin(numberTextangle.radians) * numberTextRadius

                    Text("\(adjustedNumber)")
                        .font(.system(size: geo.size.width / 15, weight: .medium))
                        .position(x: geo.size.width / 2 + x, y: geo.size.width / 2 + y)
                        .foregroundColor(Color("White-Black"))
                }
                
//                Text("WiD")
//                    .position(x: geo.size.width / 2, y: geo.size.width / 3)
//                    .font(.custom("Acme-Regular", size: geo.size.width / 8))
                
                Text("오후 | 오전")
                    .font(.system(size: geo.size.width / 15, weight: .medium))
                    .position(x: geo.size.width / 2, y: geo.size.width / 3)
                
                Text("\(totalDurationPercentage)%")
//                    .font(.system(size: geo.size.width / 5, weight: .heavy))
                    .font(.system(size: geo.size.width / 5, weight: .black))
//                    .position(x: geo.size.width / 2, y: geo.size.width / 2)
                
                Text("\(getDurationString(getTotalDurationFromWiDList(wiDList: wiDList), mode: 1)) / 24시간")
                    .font(.system(size: geo.size.width / 15, weight: .medium))
                    .position(x: geo.size.width / 2, y: geo.size.width / 1.5)
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

func getAngle(for number: Int) -> Angle {
    let degreesPerNumber = 360.0 / 24
    let angle = degreesPerNumber * Double(number) - 90
    return .degrees(angle)
}

struct PeriodPieChartView: View {
    private let date: Date
    private let wiDList: [WiD]
    
    private var pieChartDataArray: [PieData] {
        let totalMinutes: TimeInterval = 60.0 * 24.0 // 24시간(1440분)으로 표현함. 원래 TimeInterval 단위는 초(second)
        var startMinutes: Int = 0
        var array: [PieData] = [] // Create a mutable array to store data

        // 비어 있는 시간대에 대한 PieChartData 생성
        if wiDList.isEmpty {
            let noPieChartData = PieData(value: .degrees(360.0), color: Color("Black-White"))
            array.append(noPieChartData)
        } else {
            for wid in wiDList {
                let startMinutesComponents = Calendar.current.dateComponents([.hour, .minute], from: wid.start)
                let startMinutesValue = (startMinutesComponents.hour ?? 0) * 60 + (startMinutesComponents.minute ?? 0)

                // 비어 있는 시간대의 엔트리 추가
                if startMinutesValue > startMinutes {
                    let emptyMinutes = startMinutesValue - startMinutes
                    let emptyPieChartData = PieData(value: .degrees(Double(emptyMinutes) / totalMinutes * 360.0), color: Color("Black-White"))
                    array.append(emptyPieChartData)
                }

                // 엔트리 셋에 해당 WiD 객체의 시간대를 추가
                let durationMinutes = Int(wid.duration / 60)
                let widPieChartData = PieData(value: .degrees(Double(durationMinutes) / totalMinutes * 360.0), color: Color(wid.title))
                array.append(widPieChartData)

                // 시작 시간 업데이트
                startMinutes = startMinutesValue + durationMinutes
            }

            // 마지막 WiD 객체 이후의 비어 있는 시간대의 엔트리 추가
            if startMinutes < 24 * 60 {
                let emptyMinutes = 24 * 60 - startMinutes
                let emptyPieChartData = PieData(value: .degrees(Double(emptyMinutes) / totalMinutes * 360.0), color: Color("Black-White"))
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
                    .foregroundColor(Color("White-Black"))
                
                Text(getDateString(date, format: "d"))
                    .font(.system(size: geo.size.width / 3, weight: .medium))
                    .fontWeight(pieChartDataArray.count == 1 ? nil : .bold)
//                    .foregroundColor(pieChartDataArray.count == 1 ? Color("LightGray-Gray") : Color("Black-White"))
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

//struct Line: Shape {
//    var start: CGPoint
//    var end: CGPoint
//
//    init(start: CGPoint, end: CGPoint) {
//        self.start = start
//        self.end = end
//    }
//
//    func path(in rect: CGRect) -> Path {
//        var path = Path()
//
//        // Use the provided start and end points
//        path.move(to: start)
//        path.addLine(to: end)
//
//        return path
//    }
//}

struct PieData {
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

//struct BatteryView: View {
//    private let battery: Int
//    private let fillWidth: CGFloat
//    private let fillColor: Color
//
//    init(battery: Int) {
//        self.battery = battery
//        self.fillWidth = (CGFloat(battery) / 100) * UIScreen.main.bounds.size.width / 10
//
//        if battery <= 25 {
//            self.fillColor = .red
//        } else if battery <= 50 {
//            self.fillColor = .orange
//        } else {
//            self.fillColor = .green
//        }
//    }
//
//    var body: some View {
//        HStack(spacing: 0) {
//            ZStack {
//                ZStack(alignment: .leading) {
//                    // 배터리 칸
//                    RoundedRectangle(cornerRadius: 5)
//                        .fill(.white)
//                        .background(RoundedRectangle(cornerRadius: 5)
//                            .stroke(.black, lineWidth: 1)
//                        )
//                        .frame(width: UIScreen.main.bounds.size.width / 10, height: UIScreen.main.bounds.size.width / 20)
//
//                    // 배터리 잔량 표시
//                    RoundedRectangle(cornerRadius: 5)
//                        .fill(fillColor)
//                        .padding(2)
//                        .frame(width: fillWidth, height: UIScreen.main.bounds.size.width / 20)
//                }
//
//                Text("\(battery)%")
//            }
//
//            Rectangle()
//                .frame(width: UIScreen.main.bounds.size.width / 150, height: UIScreen.main.bounds.size.width / 50)
//        }
//    }
//}

struct PieChartView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
//            PeriodPieChartView(date: Date(), wiDList: [])
//
//            PeriodPieChartView(date: Date(), wiDList: [])
//                .environment(\.colorScheme, .dark)
            
            DatePieChartView(wiDList: [])
            
            DatePieChartView(wiDList: [])
                .environment(\.colorScheme, .dark)
        }
    }
}
