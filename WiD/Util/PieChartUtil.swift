//
//  PieChartUtil.swift
//  WiD
//
//  Created by jjkim on 2023/07/15.
//

import SwiftUI

struct PieChartView: View {
    var data: [ChartData]

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 원형 차트
                ForEach(0..<data.count, id: \.self) { index in
                    PieSlice(startAngle: getStartAngle(for: index), endAngle: getEndAngle(for: index))
                        .foregroundColor(data[index].color)
                }

                // 중앙에 원
//                Circle()
//                    .frame(width: geometry.size.width * 0.6, height: geometry.size.width * 0.6)
//                    .foregroundColor(.white)
                
                // 숫자 텍스트
//                ForEach(1...24, id: \.self) { number in
//                    let angle = getAngle(for: number)
//                    let radius = geometry.size.width * 0.4 / 2 // 원의 반지름
//                    
//                    let x = cos(angle.radians) * radius
//                    let y = sin(angle.radians) * radius
//                    
//                    Text("\(number)")
//                        .position(x: geometry.size.width / 4 + x, y: geometry.size.width / 4 + y)
//                }
            }
            .border(Color.blue)
            .frame(width: geometry.size.width * 1, height: geometry.size.width * 1)
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
