//
//  ManualViewTmp.swift
//  WiD
//
//  Created by jjkim on 2023/10/25.
//

import SwiftUI

struct ManualViewTmp: View {
    private let wiDService = WiDService()
    
    @State private var currentDate = Date()
    @State private var wiDList: [WiD] = []

    init() {
        self._wiDList = State(initialValue: wiDService.selectWiDsByDate(date: currentDate))
    }
    
    var body: some View {
        HStack(spacing: 0) {
            VStack {
                Text("0시")
                
                BarChartView(wiDList: wiDList)
                
                Text("24시")
            }
            .frame(maxWidth: UIScreen.main.bounds.size.width * 0.4, maxHeight: .infinity)
            .border(.red)
            
            VStack {
                Text("날짜")
                
                DatePicker("", selection: $currentDate, displayedComponents: .date)
                    .labelsHidden()
                
                Text("제목")
                
                Text("시작")
                
                Text("종료")
                
                Text("경과")
                
                Text("등록")
            }
            .frame(maxWidth: UIScreen.main.bounds.size.width * 0.6, maxHeight: .infinity)
            .border(.blue)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onChange(of: currentDate) { newValue in
            wiDList = wiDService.selectWiDsByDate(date: newValue)
        }
    }
}

struct ManualViewTmp_Previews: PreviewProvider {
    static var previews: some View {
        ManualViewTmp()
    }
}
