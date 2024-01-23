///
//  BarChartUtil.swift
//  WiD
//
//  Created by jjkim on 2023/10/25.
//

import SwiftUI
import DGCharts

//struct StackedVerticalBarChartView: View {
//    var wiDList: [WiD]
//    var barChartData: [StackedBarChartData]
//
//    init(wiDList: [WiD]) {
//        self.wiDList = wiDList
//
//        var startMinutes: Int = 0
//        let totalMinutes: Float = 24.0 * 60.0 // 24시간(1440분)으로 표현함. TimeInterval 단위는 초(second)를 사용함.
//
//        var data: [StackedBarChartData] = []
//
//        if wiDList.isEmpty {
//            let noPieChartData = StackedBarChartData(value: 1, color: Color("light_gray"))
//            data.append(noPieChartData)
//        } else {
//            for wid in wiDList {
//                let startMinutesComponents = Calendar.current.dateComponents([.hour, .minute], from: wid.start)
//                let startMinutesValue = (startMinutesComponents.hour ?? 0) * 60 + (startMinutesComponents.minute ?? 0)
//
//                // 비어 있는 시간대의 엔트리 추가
//                if startMinutesValue > startMinutes {
//                    let emptyMinutes = startMinutesValue - startMinutes
//                    let emptyPieChartData = StackedBarChartData(value: Float(emptyMinutes) / totalMinutes, color: Color("light_gray"))
//                    data.append(emptyPieChartData)
//                }
//
//                // 엔트리 셋에 해당 WiD 객체의 시간대를 추가
//                let durationMinutes = Int(wid.duration / 60)
//                let widPieChartData = StackedBarChartData(value: Float(durationMinutes) / totalMinutes, color: Color(wid.title))
//                data.append(widPieChartData)
//
//                // 시작 시간 업데이트
//                startMinutes = startMinutesValue + durationMinutes
//            }
//
//            // 마지막 WiD 객체 이후의 비어 있는 시간대의 엔트리 추가
//            if startMinutes < 24 * 60 {
//                let emptyMinutes = 24 * 60 - startMinutes
//                let emptyPieChartData = StackedBarChartData(value: Float(emptyMinutes) / totalMinutes, color: Color("light_gray"))
//                data.append(emptyPieChartData)
//            }
//        }
//
//        self.barChartData = data
//    }
//
//    var body: some View {
//        HStack {
//            VStack(spacing: 0) {
//                ForEach(0..<barChartData.count, id: \.self) { index in
//                    StackedVerticalBarView(data: barChartData[index])
//                        .foregroundColor(barChartData[index].color)
//                        .frame(height: UIScreen.main.bounds.size.height * 0.6 * CGFloat(barChartData[index].value))
//                }
//            }
//            .border(.gray)
//
//            VStack(spacing: 0) {
//                ForEach(0..<25, id: \.self) { hour in
//                    Text("\(hour)")
//                        .font(.system(size: 12))
//                        .frame(height: UIScreen.main.bounds.size.height * 0.6 / 24.2)
//                }
//            }
//        }
//    }
//}
//
//struct StackedVerticalBarView: View {
//    let data: StackedBarChartData
//
//    init(data: StackedBarChartData) {
//        self.data = data
//    }
//
//    var body: some View {
//        Rectangle()
//            .frame(width: 20)
//    }
//}
//
//struct StackedHorizontalBarChartView: View {
//    var wiDList: [WiD]
//    var barChartData: [StackedBarChartData]
//
//    init(wiDList: [WiD]) {
//        self.wiDList = wiDList
//
//        var startMinutes: Int = 0
//        let totalMinutes: Float = 24.0 * 60.0 // 24시간(1440분)으로 표현함. TimeInterval 단위는 초(second)를 사용함.
//
//        var data: [StackedBarChartData] = []
//
//        if wiDList.isEmpty {
//            let noPieChartData = StackedBarChartData(value: 1, color: Color("light_gray"))
//            data.append(noPieChartData)
//        } else {
//            for wid in wiDList {
//                let startMinutesComponents = Calendar.current.dateComponents([.hour, .minute], from: wid.start)
//                let startMinutesValue = (startMinutesComponents.hour ?? 0) * 60 + (startMinutesComponents.minute ?? 0)
//
//                // 비어 있는 시간대의 엔트리 추가
//                if startMinutesValue > startMinutes {
//                    let emptyMinutes = startMinutesValue - startMinutes
//                    let emptyPieChartData = StackedBarChartData(value: Float(emptyMinutes) / totalMinutes, color: Color("light_gray"))
//                    data.append(emptyPieChartData)
//                }
//
//                // 엔트리 셋에 해당 WiD 객체의 시간대를 추가
//                let durationMinutes = Int(wid.duration / 60)
//                let widPieChartData = StackedBarChartData(value: Float(durationMinutes) / totalMinutes, color: Color(wid.title))
//                data.append(widPieChartData)
//
//                // 시작 시간 업데이트
//                startMinutes = startMinutesValue + durationMinutes
//            }
//
//            // 마지막 WiD 객체 이후의 비어 있는 시간대의 엔트리 추가
//            if startMinutes < 24 * 60 {
//                let emptyMinutes = 24 * 60 - startMinutes
//                let emptyPieChartData = StackedBarChartData(value: Float(emptyMinutes) / totalMinutes, color: Color("light_gray"))
//                data.append(emptyPieChartData)
//            }
//        }
//
//        self.barChartData = data
//    }
//
//    var body: some View {
//        VStack(spacing: 8) {
//            HStack(spacing: 0) {
//                Text("오전")
//                    .bodyMedium()
//                    .frame(width: UIScreen.main.bounds.size.width * 0.4)
//
//                Divider()
//                    .background(.black)
//
//                Text("오후")
//                    .bodyMedium()
//                    .frame(width: UIScreen.main.bounds.size.width * 0.4)
//            }
//            .aspectRatio(contentMode: .fit)
//
//            HStack(spacing: 0) {
//                ForEach(0..<barChartData.count, id: \.self) { index in
//                    StackedHorizontalBarView(data: barChartData[index])
//                        .foregroundColor(barChartData[index].color)
//                        .frame(width: UIScreen.main.bounds.size.width * 0.8 * CGFloat(barChartData[index].value))
//                }
//            }
//            .border(.gray)
//
//            HStack(spacing: 0) {
//                ForEach(0..<13, id: \.self) { hour in
//                    Text("\(hour * 2 % 12 == 0 ? 12 : hour * 2 % 12)")
//                        .labelSmall()
//                        .frame(width: UIScreen.main.bounds.size.width * 0.8 / 12)
//                }
//            }
//        }
//    }
//}
//
//struct StackedHorizontalBarView: View {
//    let data: StackedBarChartData
//
//    init(data: StackedBarChartData) {
//        self.data = data
//    }
//
//    var body: some View {
//        Rectangle()
//            .frame(height: 20)
//    }
//}
//
//struct StackedBarChartData {
//    let value: Float
//    let color: Color
//
//    init(value: Float, color: Color) {
//        self.value = value
//        self.color = color
//    }
//}

struct VerticalBarChartView: UIViewRepresentable {
    // WiD
    private let wiDList: [WiD]
    
    // 날짜
    private let calendar = Calendar.current
    private let startDate: Date
    private let finishDate: Date
    
    // 데이터
    private var dateList: [String] = []
    private var entryList: [BarChartDataEntry] = []
    
    init(wiDList: [WiD], startDate: Date, finishDate: Date) {
        self.wiDList = wiDList
        
        self.startDate = startDate
        self.finishDate = finishDate
        
        let dayCount = calendar.dateComponents([.day], from: startDate, to: finishDate).day ?? 0
        
        for index in 0...dayCount {
            let currentDate = calendar.date(byAdding: .day, value: index, to: startDate)!

            let day = calendar.component(.day, from: currentDate)
            let dateString = "\(day)일"
            
            dateList.append(dateString)
            
            let filteredWiDList = wiDList.filter { wiD in
                return calendar.isDate(wiD.date, inSameDayAs: currentDate)
            }

            let xValue = Double(index)
            let yValue = Double(getTotalDurationPercentageFromWiDList(wiDList: filteredWiDList))

            let entry = BarChartDataEntry(x: xValue, y: yValue)
            entryList.append(entry)
        }
    }
    
    func makeUIView(context: Context) -> BarChartView {
        return BarChartView()
    }

    func updateUIView(_ uiView: BarChartView, context: Context) {
        // 데이터
        let dataSet = BarChartDataSet(entries: entryList, label: "단위 : 퍼센트")
        dataSet.drawValuesEnabled = false
//        dataSet.valueFormatter = VerticalBarChartDataValueFormatter()
//        dataSet.valueFont = UIFont.systemFont(ofSize: 14) // 데이터 글자 크기
        dataSet.setColor(NSUIColor(named: "AppYellow") ?? .gray) // 막대 색상
//        dataSet.barBorderColor = .black // 막대 테두리 색상
//        dataSet.barBorderWidth = 2 // 막대 테두리 굵기
        
        // 차트 설정
        uiView.data = BarChartData(dataSet: dataSet)
//        uiView.drawValueAboveBarEnabled = false // 값 차트 안에 표시하기
        uiView.legend.font = UIFont.systemFont(ofSize: 14) // 범례 글자 크기
        uiView.legend.form = .line // 범례 아이콘 형태
        uiView.legend.horizontalAlignment = .right // 범례 수평 정렬
        uiView.legend.verticalAlignment = .top // 범례 수직 정렬
        uiView.dragEnabled = false
        uiView.pinchZoomEnabled = false
        uiView.scaleXEnabled = false // x축 확대 허용 여부
        uiView.scaleYEnabled = false // y축 확대 허용 여부
        uiView.highlightPerTapEnabled = false // 클릭 허용 여부
        
        // x축
        let xAxis = uiView.xAxis
        xAxis.labelPosition = .bottom // 축 위치
        xAxis.drawGridLinesEnabled = false // 그리드 라인
        xAxis.drawAxisLineEnabled = false // 축선 표시
        xAxis.granularity = 1 // 축 라벨 표시 간격
        xAxis.labelFont = UIFont.systemFont(ofSize: 14) // 축 라벨 글자 크기
        xAxis.valueFormatter = IndexAxisValueFormatter(values: dateList)
        let labelCount = dateList.count <= 7 ? dateList.count / 1 : dateList.count / 3
        xAxis.setLabelCount(labelCount, force: false) // 라벨 표시 간격
        
        
        // 왼쪽 축
        let axisLeft = uiView.leftAxis
        axisLeft.drawAxisLineEnabled = false // 축 표시 여부
        axisLeft.drawGridLinesEnabled = true // 그리드 라인
        axisLeft.drawLabelsEnabled = true // 라벨
        axisLeft.granularity = 1 // 축 라벨 표시 간격
        axisLeft.labelFont = UIFont.systemFont(ofSize: 14) // 축 라벨 글자 크기

        // 오른쪽 축
        let axisRight = uiView.rightAxis
        axisRight.drawAxisLineEnabled = false // 축 표시 여부
        axisRight.drawGridLinesEnabled = false // 그리드 라인
        axisRight.drawLabelsEnabled = false // 라벨
    }
}

class VerticalBarChartDataValueFormatter : NSObject, ValueFormatter {
    func stringForValue(_ value: Double,
                        entry: ChartDataEntry,
                        dataSetIndex: Int,
                        viewPortHandler: ViewPortHandler?) -> String {
        
        // value가 0이면 빈 문자열 반환
        guard value != 0 else {
            return ""
        }
        
        // value가 100이면 "F" 반환
        if value == 100 {
            return "F"
        }
        
        let roundedValue = String(format: "%.0f", value)
        
        // value가 두 자릿수이면 두 줄로 표시
//        if roundedValue.count == 2 {
//            let firstDigit = roundedValue.first!
//            let secondDigit = roundedValue.last!
//            return "\(firstDigit)\n\(secondDigit)"
//        } else {
//            return roundedValue
//        }
        
        return "\(roundedValue)"
    }
}

struct BarChartView_Previews: PreviewProvider {
    static var previews: some View {
//        StackedVerticalBarChartView(wiDList: [])
//        StackedHorizontalBarChartView(wiDList: [])
        
        let calendar = Calendar.current
        let days = 30
        let tmpWiDList = getRandomWiDList(days: days)

        // currentDate의 시간을 오전 12:00:00으로 맞춰줌.
        let startDate = calendar.startOfDay(for: Date())
        let finishDate = calendar.date(byAdding: .day, value: days - 1, to: startDate) ?? Date()
        
        Group {
            VerticalBarChartView(wiDList: tmpWiDList, startDate: startDate, finishDate: finishDate)
                .aspectRatio(1.5 / 1.0, contentMode: .fit)
            
            VerticalBarChartView(wiDList: tmpWiDList, startDate: startDate, finishDate: finishDate)
                .aspectRatio(1.5 / 1.0, contentMode: .fit)
                .environment(\.colorScheme, .dark)
        }
    }
}
