//
//  PieGraphView.swift
//  WiD
//
//  Created by jjkim on 2024/02/07.
//

import SwiftUI
import DGCharts

struct DatePieGraphView: UIViewRepresentable {
    private let wiDList: [WiD]
    private let entryList: [PieChartDataEntry]
    private let colorList: [NSUIColor]
    private let calendar = Calendar.current
    
    init(wiDList: [WiD]) {
        self.wiDList = wiDList
        
        let totalMinutes = 24 * 60 // 24시간을 분 단위로 계산합니다.
        var currentMinute = 0
        
        var entries: [PieChartDataEntry] = []
        var colors: [NSUIColor] = []
        
        for wiD in wiDList {
            let startComponents = calendar.dateComponents([.hour, .minute], from: wiD.start)
            let startMinutes = startComponents.hour! * 60 + startComponents.minute!
            
            let finishComponents = calendar.dateComponents([.hour, .minute], from: wiD.finish)
            let finishMinutes = finishComponents.hour! * 60 + finishComponents.minute!
            
            // 비어 있는 시간대의 엔트리 추가
            if startMinutes > currentMinute {
                let emptyMinutes = startMinutes - currentMinute
                entries.append(PieChartDataEntry(value: Double(emptyMinutes), label: ""))
//                colors.append(NSUIColor(named: "Black-White")!)
                colors.append(NSUIColor(named: "White-Black")!)
            }
            
            // WiD 객체의 시간대 엔트리 추가
            let durationMinutes = finishMinutes - startMinutes
            entries.append(PieChartDataEntry(value: Double(durationMinutes), label: wiD.title))
            colors.append(NSUIColor(named: wiD.title)!)
            
            currentMinute = finishMinutes
        }
        
        // 마지막 WiD 객체 이후의 비어 있는 시간대의 엔트리 추가
        if currentMinute < totalMinutes {
            let emptyMinutes = totalMinutes - currentMinute
            entries.append(PieChartDataEntry(value: Double(emptyMinutes), label: ""))
//            colors.append(NSUIColor(named: "Black-White")!)
            colors.append(NSUIColor(named: "White-Black")!)
        }
        
        self.entryList = entries
        self.colorList = colors
    }

    func makeUIView(context: Context) -> PieChartView {
        return PieChartView()
    }
    
    func updateUIView(_ uiView: PieChartView, context: Context) {
        // 데이터
        let dataSet = PieChartDataSet(entries: entryList, label: "dd")
        dataSet.drawValuesEnabled = false
        dataSet.highlightEnabled = false
        dataSet.colors = colorList
        
        // 차트 설정
        uiView.drawEntryLabelsEnabled = false
        uiView.drawHoleEnabled = true
        uiView.rotationEnabled = false
        uiView.holeColor = NSUIColor(named: "Transparent")
        uiView.holeRadiusPercent = 0.8
        uiView.legend.enabled = false
        uiView.usePercentValuesEnabled = false
        uiView.data = PieChartData(dataSet: dataSet)
    }
}

struct PieGraphView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DatePieGraphView(wiDList: getRandomWiDList(days: 1))
                .aspectRatio(1.0 / 1.0, contentMode: .fit)
            
            DatePieGraphView(wiDList: getRandomWiDList(days: 1))
                .aspectRatio(1.0 / 1.0, contentMode: .fit)
                .environment(\.colorScheme, .dark)
        }
    }
}
