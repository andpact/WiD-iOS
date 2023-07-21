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
            
            HStack {
                PieChartView(data: fetchChartData(date: currentDate), date: currentDate, isForOne: true)
                    .border(Color.red)
                
                VStack {
                    HStack {
                        Rectangle()
                            .fill(Color("light_gray"))
                            .frame(width: 10, height: 20)
                        
                        Text("제목")
                        
                        Text("총합")
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color("light_gray"))
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                    
                    ForEach(sortedTotalDurationDictionary, id: \.key) { (title, duration) in
                        HStack {
                            Rectangle()
                                .fill(Color(title))
                                .frame(width: 10, height: 20)
                            
                            Text(titleDictionary[title] ?? "")
                            
                            Text(formatDuration(duration, isClickedWiD: false))
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color("light_gray"))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                    }
                }
            }
            
            VStack {
                HStack {
                    Rectangle()
                        .fill(Color("light_gray"))
                        .frame(width: 10, height: 20)
                    
                    Text("순서")

                    Text("제목")

                    Text("시작")

                    Text("종료")

                    Text("경과")

                    Text("자세히")
                }
                .frame(maxWidth: .infinity)
                .background(Color("light_gray"))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)

                ForEach(Array(wiDs.enumerated()), id: \.element.id) { (index, wiD) in
                    
                    NavigationLink(destination: WiDView(clickedWiDId: wiD.id)) {
                        HStack {
                            Rectangle()
                                .fill(Color(wiD.title))
                                .frame(width: 10, height: 20)
                            
                            Text("\(index + 1)")

                            Text(titleDictionary[wiD.title] ?? "")

                            Text(formatTime(wiD.start, format: "HH:mm"))

                            Text(formatTime(wiD.finish, format: "HH:mm"))

                            Text(formatDuration(wiD.duration, isClickedWiD: false))

                            Text("(\(wiD.detail.count))")
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color("light_gray"))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                    }
                }
            }
            .frame(maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
