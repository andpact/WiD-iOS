//
//  WiDReadWeekView.swift
//  WiD
//
//  Created by jjkim on 2023/07/14.
//

import SwiftUI

struct WiDReadWeekView: View {
    private let wiDService = WiDService()
    
    @State private var wiDs: [WiD] = []
    
    @State private var currentDate: Date = Date() // 현재 날짜가 몇 번째 주인지 표시하기 위한 용도.
        
    @State private var firstDayOfWeek: Date = getFirstDayOfWeek(for: Date()) { // 파이 차트를 표시하기 위한 용도
        didSet {
            var allWiDs: [WiD] = []
            
            // Loop through the dates for each day of the week
            for index in 0..<7 {
                let date = Calendar.current.date(byAdding: .day, value: index, to: firstDayOfWeek) ?? firstDayOfWeek
                let wiDsForDate = wiDService.selectWiDsByDate(date: date)
                allWiDs.append(contentsOf: wiDsForDate)
            }
            
            wiDs = allWiDs
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
    
    private var bestDurationDictionary: [String: TimeInterval] {
        var result: [String: TimeInterval] = [:]

        for wiD in wiDs {
            if let currentBestDuration = result[wiD.title] {
                if wiD.duration > currentBestDuration {
                    result[wiD.title] = wiD.duration

                }
            } else {
                result[wiD.title] = wiD.duration
            }
        }

        return result
    }
    
    private var bestDayDictionary: [String: Date] {
        var result: [String: Date] = [:]

        for wiD in wiDs {
            if result[wiD.title] != nil {
                if wiD.duration > (totalDurationDictionary[wiD.title] ?? 0) {
                    result[wiD.title] = wiD.date
                }
            } else {
                result[wiD.title] = wiD.date
            }
        }

        return result
    }
    
    var body: some View {
        VStack {
            // 날짜 표시
            HStack {
                Text("WiD")
                    .font(.custom("Acme-Regular", size: 20))
                    .padding(.horizontal, 8)
                    .foregroundColor(.white)
                    .background(.black)
                    .cornerRadius(5)
                    .padding(.horizontal, 8)
                
                HStack {
                    Text(formatDate(currentDate, format: "yyyy년"))
                        
                    Text("\(weekNumber(for: currentDate))번째 주")
                }
                .frame(maxWidth: .infinity)
                
                Button(action: {
                    withAnimation {
                        currentDate = Date()
                        firstDayOfWeek = getFirstDayOfWeek(for: Date())
                    }
                }) {
                    Image(systemName: "arrow.clockwise")
                }
                .padding(.horizontal, 8)
                
                Button(action: {
                    withAnimation {
                        firstDayOfWeek = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: firstDayOfWeek) ?? firstDayOfWeek
                        currentDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: currentDate) ?? currentDate
                    }
                }) {
                    Image(systemName: "chevron.left")
                }
                .padding(.horizontal, 8)

                Button(action: {
                    withAnimation {
                        firstDayOfWeek = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: firstDayOfWeek) ?? firstDayOfWeek
                        currentDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: currentDate) ?? currentDate
                    }
                }) {
                    Image(systemName: "chevron.right")
                }
                .padding(.horizontal, 8)
                .disabled(Calendar.current.isDate(firstDayOfWeek, equalTo: getFirstDayOfWeek(for: Date()), toGranularity: .weekOfYear))
            }
            .padding(.bottom, 8)
            
            // 요일 표시
            HStack {
                ForEach(1...7, id: \.self) { index in
                    let textColor = index == 7 ? Color.red : (index == 6 ? Color.blue : Color.black)
                    
                    Text(formatWeekdayLetter(index))
                        .frame(maxWidth: .infinity)
                        .foregroundColor(textColor)
                }
            }
            
            // 파이 차트 표시
            HStack(spacing: 7) {
                ForEach(0..<7) { index in
                    PieChartView(data: fetchChartData(date: Calendar.current.date(byAdding: .day, value: index, to: firstDayOfWeek) ?? firstDayOfWeek), date: Calendar.current.date(byAdding: .day, value: index, to: firstDayOfWeek) ?? firstDayOfWeek, isForOne: false, isEmpty: false)
                }
            }
            .padding(.bottom, 8)
            
            // 제목 별 총합 표시
            VStack {
                HStack {
                    Rectangle()
                        .fill(Color("light_gray"))
                        .frame(width: 7, height: 20)

                    Text("제목")
                        .frame(width: 50)

                    Text("최고")
                        .frame(maxWidth: .infinity)

                    Text("총합")
                        .frame(maxWidth: 110)
                }
                .frame(maxWidth: .infinity)
                .background(Color("light_gray"))
                .cornerRadius(5)
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                
//                HStack {
//                    Rectangle()
//                        .fill(.red)
//                        .frame(width: 7, height: 20)
//
//                    Text("공부")
//                        .frame(width: 50)
//                        .border(.black)
//
//
//                    Text("99일 / 99시간 99분")
//                        .frame(maxWidth: .infinity)
//                        .border(.black)
//
//                    Text("999시간 99분")
//                        .frame(maxWidth: 110)
//                        .border(.black)
//                }
//                .frame(maxWidth: .infinity)
//                .background(Color("light_gray"))
//                .cornerRadius(5)
//                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                
                if sortedTotalDurationDictionary.isEmpty {
                    Spacer()
                    Text("표시할 데이터가 없습니다.")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)

                } else {
                    ScrollView {
                        ForEach(sortedTotalDurationDictionary, id: \.key) { (title, totalDuration) in
                            if let bestDuration = bestDurationDictionary[title], let bestDay = bestDayDictionary[title] {
                                
//                                let totalDurationOfWeek = 60 * 60 * 24 * 7
//                                let bestDurationPercentage = (Double(bestDuration) / Double(totalDurationOfWeek)) * 100
//                                let totalDurationPercentage = (Double(totalDuration) / Double(totalDurationOfWeek)) * 100
                                
                                HStack {
                                    Rectangle()
                                        .fill(Color(title))
                                        .frame(width: 7, height: 20)

                                    Text(titleDictionary[title] ?? "")
                                        .frame(width: 50)
                                    
//                                    Text("\(formatDate(bestDay, format: "d일")) / " + formatDuration(bestDuration, isClickedWiD: false) + " " +  String(format: "(%.1f%)", bestDurationPercentage))
                                    Text("\(formatDate(bestDay, format: "d일")) / " + formatDuration(bestDuration, isClickedWiD: false))
                                        .frame(maxWidth: .infinity)
                                    
//                                    Text(formatDuration(totalDuration, isClickedWiD: false) + " " + String(format: "(%.1f%)", totalDurationPercentage))
                                    Text(formatDuration(totalDuration, isClickedWiD: false))
                                        .frame(maxWidth: 110)
                                }
                                .frame(maxWidth: .infinity)
                                .background(Color("light_gray"))
                                .cornerRadius(5)
                                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                            }
                        }
                    }
                }
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal)
        .onAppear() {
            var allWiDs: [WiD] = []
            
            // Loop through the dates for each day of the week
            for index in 0..<7 {
                let date = Calendar.current.date(byAdding: .day, value: index, to: firstDayOfWeek) ?? firstDayOfWeek
                let wiDsForDate = wiDService.selectWiDsByDate(date: date)
                allWiDs.append(contentsOf: wiDsForDate)
            }
            withAnimation {
                wiDs = allWiDs
            }
        }
    }
}

struct WiDReadWeekView_Previews: PreviewProvider {
    static var previews: some View {
        WiDReadWeekView()
    }
}
