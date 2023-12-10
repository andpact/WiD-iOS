//
//  LineChartView.swift
//  WiD
//
//  Created by jjkim on 2023/12/05.
//

import SwiftUI
import DGCharts

/*
 wiDList, startDate, finishDate 모두 오전 12:00:00 맞춰서 전달해야 한다.
 */
struct LineGraphView: UIViewRepresentable {
    // WiD
    private let wiDList: [WiD]
    private let totalDurationDictionary: [Date: TimeInterval]
    
    // 제목
    private let title: String
    
    // 날짜
    private let calendar = Calendar.current
    private let startDate: Date
    private let finishDate: Date
    
    // 데이터
    private let dateList: [String]
    private let entryList: [ChartDataEntry]
    
    // wiDList, startDate, finishDate 모두 오전 12:00:00으로 설정되서 넘어옴.
    init(title: String, wiDList: [WiD], startDate: Date, finishDate: Date) {
        self.title = title
        
        self.wiDList = wiDList
        self.totalDurationDictionary = getTotalDurationDictionaryByDate(wiDList: wiDList)
        
        self.startDate = startDate
        self.finishDate = finishDate
 
        var dates: [String] = []
        var entries: [ChartDataEntry] = []
        
        let dayCount = calendar.dateComponents([.day], from: startDate, to: finishDate).day ?? 0

        for index in 0...dayCount {
            let currentDate = calendar.date(byAdding: .day, value: index, to: startDate)!
                        
            let day = calendar.component(.day, from: currentDate)
            let dateString = "\(day)일"

            dates.append(dateString)
            
            let xValue = Double(index)

            let yValue: TimeInterval
            if let duration = totalDurationDictionary[currentDate] {
                yValue = duration / (60 * 60)
            } else {
                yValue = 0
            }

            let entry = ChartDataEntry(x: xValue, y: yValue)
            entries.append(entry)
        }

        self.dateList = dates
        self.entryList = entries
    }
    
    func makeUIView(context: Context) -> LineChartView {
        return LineChartView()
    }

    // makeUIView가 아닌 updateUIView에 작성해야 선 그래프가 정상 동작, 갱신이 된다.
    func updateUIView(_ uiView: LineChartView, context: Context) {
        // 데이터
        let dataSet = LineChartDataSet(entries: entryList, label: "단위 : 시간")
//        dataSet.valueFormatter = LineGraphDataValueFormatter()
        dataSet.drawValuesEnabled = false
        dataSet.setColor(.black) // 선 색상
        dataSet.lineWidth = 2 // 선 굵기
//        dataSet.valueFont = UIFont.systemFont(ofSize: 14) // 데이터 글자 크기
        dataSet.drawCirclesEnabled = false // 선 꼭지점 원 표시
        dataSet.mode = .horizontalBezier // 선 스타일
        dataSet.drawFilledEnabled = true // 선 아래 공간 채우기
        
        let startColor: NSUIColor // 그라디언트 시작 색
        switch title {
        case "ALL":
            startColor = NSUIColor(named: "ALL") ?? .gray
        case "STUDY":
            startColor = NSUIColor(named: "STUDY") ?? .red
        case "WORK":
            startColor = NSUIColor(named: "WORK") ?? .blue
        case "EXERCISE":
            startColor = NSUIColor(named: "EXERCISE") ?? .green
        case "HOBBY":
            startColor = NSUIColor(named: "HOBBY") ?? .orange
        case "PLAY":
            startColor = NSUIColor(named: "PLAY") ?? .yellow
        case "MEAL":
            startColor = NSUIColor(named: "MEAL") ?? .brown
        case "SHOWER":
            startColor = NSUIColor(named: "SHOWER") ?? .purple
        case "TRAVEL":
            startColor = NSUIColor(named: "TRAVEL") ?? .cyan
        case "SLEEP":
            startColor = NSUIColor(named: "SLEEP") ?? .magenta
        case "ETC":
            startColor = NSUIColor(named: "ETC") ?? .black
        default:
            startColor = NSUIColor.white
        }
        let endColor = NSUIColor.white // 그라디언트 끝 색
        let gradientColors = [startColor.cgColor, endColor.cgColor] as CFArray
        let colorLocations: [CGFloat] = [1.0, 0.0]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors, locations: colorLocations)
        dataSet.fillAlpha = 1
        dataSet.fill = LinearGradientFill(gradient: gradient!, angle: 90.0)
        
        // 차트 설정
        uiView.data = LineChartData(dataSet: dataSet)
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
        axisLeft.labelFont = UIFont.systemFont(ofSize: 14) // 축 라벨 글자 크기

        // 오른쪽 축
        let axisRight = uiView.rightAxis
        axisRight.drawAxisLineEnabled = false // 축 표시 여부
        axisRight.drawGridLinesEnabled = false // 그리드 라인
        axisRight.drawLabelsEnabled = false // 라벨
    }
}

//class LineGraphDataValueFormatter: NSObject, ValueFormatter {
//    func stringForValue(_ value: Double,
//                        entry: ChartDataEntry,
//                        dataSetIndex: Int,
//                        viewPortHandler: ViewPortHandler?) -> String {
//        // value가 0이면 빈 문자열 반환
//        guard value != 0 else {
//            return ""
//        }
//
//        let valueWithoutDecimalPart = String(format: "%.1f", value)
//        return "\(valueWithoutDecimalPart)"
//    }
//}

struct LineGraphView_Previews: PreviewProvider {
    static var previews: some View {
        let calendar = Calendar.current
        let days = 30
        let tmpWiDList = getRandomWiDList(days: days)

        // currentDate의 시간을 오전 12:00:00으로 맞춰줌.
        let startDate = calendar.startOfDay(for: Date())
        let finishDate = calendar.date(byAdding: .day, value: days - 1, to: startDate) ?? Date()

        LineGraphView(title: "STUDY", wiDList: tmpWiDList, startDate: startDate, finishDate: finishDate)
            .aspectRatio(1.5 / 1.0, contentMode: .fit)
    }
}
