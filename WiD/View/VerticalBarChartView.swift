//
//  VerticalBarChartView.swift
//  WiD
//
//  Created by jjkim on 2023/12/09.
//

import SwiftUI
import DGCharts

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
            
            let dateString = "\(calendar.component(.day, from: currentDate))일"
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
        let dataSet = BarChartDataSet(entries: entryList)
        dataSet.valueFormatter = VerticalBarChartDataValueFormatter()
//        dataSet.setColor(.white) // 막대 색상
//        dataSet.barBorderColor = .black // 막대 테두리 색상
//        dataSet.barBorderWidth = 2 // 막대 테두리 굵기
        
        // 차트 설정
        uiView.data = BarChartData(dataSet: dataSet)
        uiView.legend.enabled = false
//        uiView.chartDescription.text = "단위 : 퍼센트"
//        uiView.barData?.barWidth = 0.7
        
        // x축
        let xAxis = uiView.xAxis
        xAxis.labelPosition = .bottom // 축 위치
        xAxis.drawGridLinesEnabled = false // 그리드 라인
        xAxis.drawAxisLineEnabled = false // 축선 표시
        xAxis.granularity = 1 // 축 라벨 표시 간격
        xAxis.valueFormatter = IndexAxisValueFormatter(values: dateList)
        
        // 왼쪽 축
        let axisLeft = uiView.leftAxis
        axisLeft.drawAxisLineEnabled = false // 축 표시 여부
        axisLeft.drawGridLinesEnabled = false // 그리드 라인
        axisLeft.drawLabelsEnabled = false // 라벨

        // 오른쪽 축
        let axisRight = uiView.rightAxis
        axisRight.drawAxisLineEnabled = false // 축 표시 여부
        axisRight.drawGridLinesEnabled = false // 그리드 라인
        axisRight.drawLabelsEnabled = false // 라벨
    }
}

struct VerticalBarChartView_Previews: PreviewProvider {
    static var previews: some  View {
        let calendar = Calendar.current

        let tmpWiDList = createTempWiDList()

        // currentDate의 시간을 오전 12:00:00으로 맞춰줌.
        let startDate = calendar.startOfDay(for: Date())
        let finishDate = calendar.date(byAdding: .day, value: 6, to: startDate) ?? Date()
        
        VerticalBarChartView(wiDList: tmpWiDList, startDate: startDate, finishDate: finishDate)
            .aspectRatio(1.5 / 1.0, contentMode: .fit)
    }
}

class VerticalBarChartDataValueFormatter : NSObject, ValueFormatter {
    func stringForValue(_ value: Double,
                        entry: ChartDataEntry,
                        dataSetIndex: Int,
                        viewPortHandler: ViewPortHandler?) -> String {
        let roundedValue = String(format: "%.0f", value)
        return "\(roundedValue)%"
    }
}
