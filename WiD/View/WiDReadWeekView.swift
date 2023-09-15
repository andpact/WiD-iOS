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
    
    // 각 제목별 날짜별 종합 시간을 추적하기 위한 맵
    private var titleDateDurations: [String: [Date: TimeInterval]] {
        var map = [String: [Date: TimeInterval]]()

        for wiD in wiDs {
            let title = wiD.title
            let date = wiD.date
            let duration = wiD.duration

            // 각 제목에 대한 맵 가져오기
            var titleMap = map[title] ?? [Date: TimeInterval]()

            // 날짜별 시간 누적
            if let existingDuration = titleMap[date] {
                titleMap[date] = existingDuration + duration
            } else {
                titleMap[date] = duration
            }

            map[title] = titleMap
        }
        return map
    }
    
    // 최저, 최고, 평균, 종합 시간 계산
    private var titleStats: [String: TitleStats] {
        var map = [String: TitleStats]()

        for (title, dateDurations) in titleDateDurations {
            let minDuration = dateDurations.values.min() ?? 0.0
            let maxDuration = dateDurations.values.max() ?? 0.0
            let totalDuration = dateDurations.values.reduce(0.0, +)
            let averageDuration = dateDurations.isEmpty ? 0.0 : totalDuration / Double(dateDurations.count)

            map[title] = TitleStats(minDuration: minDuration, maxDuration: maxDuration, averageDuration: averageDuration, totalDuration: totalDuration)
        }
        return map
    }
    
    var body: some View {
        GeometryReader { geo in
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
                    .disabled(Calendar.current.isDate(firstDayOfWeek, equalTo: getFirstDayOfWeek(for: Date()), toGranularity: .weekOfYear))
                    
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
                
                VStack {
                    HStack(spacing: 0) {
                        Rectangle()
                            .fill(Color("light_gray"))
                            .frame(width: geo.size.width * 0.02, height: 25)

                        Text("제목")
                            .frame(width: geo.size.width * 0.1)

                        Text("최저")
                            .frame(width: geo.size.width * 0.22)
                        
                        Text("최고")
                            .frame(width: geo.size.width * 0.22)
                        
                        Text("평균")
                            .frame(width: geo.size.width * 0.22)

                        Text("총합")
                            .frame(width: geo.size.width * 0.22)
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color("light_gray"))
                    .cornerRadius(5)
                    
                    if wiDs.isEmpty {
                        Spacer()

                        Text("표시할 정보가 없습니다.")
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                        
//                        HStack(spacing: 0) {
//                            Rectangle()
//                                .fill(.red)
//                                .frame(width: geo.size.width * 0.02, height: 25)
//
//                            Text("공부")
//                                .frame(width: geo.size.width * 0.1)
//                                .border(.red)
//
//                            Text("99시간")
//                                .frame(width: geo.size.width * 0.22)
//                                .border(.red)
//
//                            Text("99시간")
//                                .frame(width: geo.size.width * 0.22)
//                                .border(.red)
//
//                            Text("99시간")
//                                .frame(width: geo.size.width * 0.22)
//                                .border(.red)
//
//                            Text("99시간")
//                                .frame(width: geo.size.width * 0.22)
//                                .border(.red)
//                        }
//                        .frame(maxWidth: .infinity)
//                        .background(Color("light_gray"))
//                        .cornerRadius(5)
                    } else {
                        ScrollView {
                            ForEach(titleStats.keys.sorted(), id: \.self) { title in
                                let stats = titleStats[title]!
                                HStack(spacing: 0) {
                                    Rectangle()
                                        .fill(Color(title))
                                        .frame(width: geo.size.width * 0.02, height: 25)

                                    Text(titleDictionary[title] ?? "")
                                        .frame(width: geo.size.width * 0.1)

                                    Text(formatDuration(stats.minDuration, mode: 1))
                                        .frame(width: geo.size.width * 0.22)

                                    Text(formatDuration(stats.maxDuration, mode: 1))
                                        .frame(width: geo.size.width * 0.22)

                                    Text(formatDuration(stats.averageDuration, mode: 1))
                                        .frame(width: geo.size.width * 0.22)

                                    Text(formatDuration(stats.totalDuration, mode: 1))
                                        .frame(width: geo.size.width * 0.22)
                                }
                                .background(Color("light_gray"))
                                .cornerRadius(5)
                            }
                        }
                    }
                    Spacer()
                }
            }
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
        .padding(.horizontal)
    }
}

struct TitleStats {
    let minDuration: TimeInterval
    let maxDuration: TimeInterval
    let averageDuration: TimeInterval
    let totalDuration: TimeInterval
}

struct WiDReadWeekView_Previews: PreviewProvider {
    static var previews: some View {
        WiDReadWeekView()
    }
}
