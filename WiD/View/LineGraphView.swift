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
    private let dateList: [String] // startDate, finishDate가 갱신되어 넘어올 때, 포매터에 있는 dateList를 갱신해야 하니 @State로 선언함.
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
            let xValue = Double(index)

            let yValue: TimeInterval
            if let duration = totalDurationDictionary[currentDate] {
                yValue = duration / (60 * 60)
            } else {
                yValue = 0
            }

            let entry = ChartDataEntry(x: xValue, y: yValue)
            entries.append(entry)

            let dateString = String(calendar.component(.day, from: currentDate)) + "일"
            dates.append(dateString)
        }

        self.dateList = dates
        self.entryList = entries
    }
    
    func makeUIView(context: Context) -> LineChartView {
        return LineChartView()
    }

    // updateUIView에 작성해야 선 그래프가 정상 동작한다.
    func updateUIView(_ uiView: LineChartView, context: Context) {
        // 데이터
        let dataSet = LineChartDataSet(entries: entryList)
        dataSet.valueFormatter = DataValueFormatter()
        dataSet.setColor(.black) // 선 색상
        dataSet.lineWidth = 2 // 선 굵기
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
        uiView.legend.enabled = false
        uiView.chartDescription.text = "단위 : 시간"
        uiView.chartDescription.yOffset = 190.0
        uiView.dragEnabled = false
        uiView.pinchZoomEnabled = false
        uiView.scaleXEnabled = false
        uiView.scaleYEnabled = false
        uiView.data = LineChartData(dataSet: dataSet)

        // x축
        let xAxis = uiView.xAxis
        xAxis.labelPosition = .bottom // 축 위치
        xAxis.drawGridLinesEnabled = false // 그리드 라인
        xAxis.drawAxisLineEnabled = false // 축선 표시
        xAxis.granularity = 1 // 축 라벨 표시 간격
//        xAxis.valueFormatter = XAxisValueFormatter(dateList: dateList)
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

struct LineGraphView_Previews: PreviewProvider {
    static var previews: some View {
        let calendar = Calendar.current

        let tmpWiDList = createTempWiDList()

        // currentDate의 시간을 오전 12:00:00으로 맞춰줌.
        let startDate = calendar.startOfDay(for: Date())
        let finishDate = calendar.date(byAdding: .day, value: 6, to: startDate) ?? Date()

        LineGraphView(title: "STUDY", wiDList: tmpWiDList, startDate: startDate, finishDate: finishDate)
            .aspectRatio(2.0 / 1.0, contentMode: .fit)
    }
}

func createTempWiDList() -> [WiD] {
    var tempWiDList: [WiD] = []

    let calendar = Calendar.current
    let startDate = Date()
    let finishDate = calendar.date(byAdding: .day, value: 6, to: startDate) ?? Date()

    // currentDate의 시간을 오전 12:00:00으로 설정.
    var currentDate = calendar.startOfDay(for: startDate)

    while currentDate <= finishDate {
        let wiD = WiD(id: 0,
                      date: currentDate,
                      title: "STUDY",
                      start: Date(),
                      finish: Date(),
                      duration: 3 * 60 * 60,
                      detail: "Detail"
        )

        tempWiDList.append(wiD)

        let randomMinutes = Int(arc4random_uniform(60))
        let randomSeconds = Int(arc4random_uniform(60))

        let randomDuration = TimeInterval((randomMinutes * 60) + randomSeconds)
        let wiD2 = WiD(id: 0,
                      date: currentDate,
                      title: "STUDY",
                      start: Date(),
                      finish: Date(),
                      duration: randomDuration,
                      detail: "Detail"
        )

        tempWiDList.append(wiD2)

        currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
    }

    return tempWiDList
}

//class XAxisValueFormatter: NSObject, AxisValueFormatter {
//    private let dateList: [String]
//
//    init(dateList: [String]) {
//        self.dateList = dateList
//    }
//
//    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
//        return "\(dateList[Int(value)])일"
//    }
//}

class DataValueFormatter : NSObject, ValueFormatter {
    func stringForValue(_ value: Double,
                        entry: ChartDataEntry,
                        dataSetIndex: Int,
                        viewPortHandler: ViewPortHandler?) -> String {
        let valueWithoutDecimalPart = String(format: "%.1f", value)
        return "\(valueWithoutDecimalPart)"
    }
}
