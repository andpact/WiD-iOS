//
//  WiDReadView.swift
//  WiD
//
//  Created by jjkim on 2023/07/08.
//

import SwiftUI

struct WiDReadDayView: View {
    private let wiDService = WiDService()
    
    @State private var wiDs: [WiD] = []
    @State private var currentDate: Date = Date() {
        didSet {
            wiDs = wiDService.selectWiDsByDate(date: currentDate)
        }
    }
    
    private var totalDurationDictionary: [String: TimeInterval] {
        var result: [String: TimeInterval] = [:]

        for wiD in wiDs {
            if let currentDuration = result[wiD.title] {
                result[wiD.title] = currentDuration + wiD.duration
            } else {
                result[wiD.title] = wiD.duration
            }
        }

        return result
    }
    
    private var sortedTotalDurationDictionary: [(key: String, value: TimeInterval)] {
        totalDurationDictionary.sorted { $0.value > $1.value }
    }
    
    var body: some View {
        VStack {
            HStack {
                HStack {
                    Text(formatDate(currentDate, format: "yyyy.MM.dd"))
                    
                    Text(formatWeekday(currentDate))
                        .foregroundColor(Calendar.current.component(.weekday, from: currentDate) == 1 ? .red : (Calendar.current.component(.weekday, from: currentDate) == 7 ? .blue : .black))
                }
                .frame(maxWidth: .infinity)
                
                Button(action: {
                    currentDate = Date()
                }) {
                    Text("현재")
                }
                
                Button(action: {
                    currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
                }) {
                    Image(systemName: "chevron.left")
                }
                
                Button(action: {
                    currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
                }) {
                    Image(systemName: "chevron.right")
                }
                .disabled(Calendar.current.isDateInToday(currentDate))
            }
            .border(Color.black)
            
            HStack {
                PieChartView(data: fetchChartData(date: currentDate), date: currentDate, isForOne: true)
                    .border(Color.red)
                
                VStack {
                    HStack {
                        Text("제목")
                        
                        Text("총합")
                    }
                    ForEach(sortedTotalDurationDictionary, id: \.key) { (title, duration) in
                        HStack {
                            Text(title)
                            Text(formatDuration(duration, isClickedWiD: false))
                        }
                    }
                }
                .border(Color.black)
            }
            
            VStack {
                HStack {
                    Text("순서")
                        .frame(maxWidth: .infinity)
                    Text("제목")
                        .frame(maxWidth: .infinity)
                    Text("시작")
                        .frame(maxWidth: .infinity)
                    Text("종료")
                        .frame(maxWidth: .infinity)
                    Text("경과")
                        .frame(maxWidth: .infinity)
                    Text("자세히")
                        .frame(maxWidth: .infinity)
                }

                ForEach(Array(wiDs.enumerated()), id: \.element.id) { (index, wiD) in
                    
                    NavigationLink(destination: WiDView(clickedWiDId: wiD.id)) {
                        HStack {
                            Text("\(index + 1)")
                                .frame(maxWidth: .infinity)
                            Text(wiD.title)
                                .frame(maxWidth: .infinity)
                            Text(formatTime(wiD.start, format: "HH:mm"))
                                .frame(maxWidth: .infinity)
                            Text(formatTime(wiD.finish, format: "HH:mm"))
                                .frame(maxWidth: .infinity)
                            Text(formatDuration(wiD.duration, isClickedWiD: false))
                                .frame(maxWidth: .infinity)
                            Text("(\(wiD.detail.count))")
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
            .frame(maxHeight: .infinity)
            .border(Color.black)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .border(Color.black)
        .padding(.horizontal)
        .onAppear() {
            wiDs = wiDService.selectWiDsByDate(date: currentDate)
        }
    }
}

struct WiDReadView_Previews: PreviewProvider {
    static var previews: some View {
        WiDReadDayView()
    }
}
