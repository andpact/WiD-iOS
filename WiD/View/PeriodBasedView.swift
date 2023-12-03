//
//  PeriodBasedView.swift
//  WiD
//
//  Created by jjkim on 2023/12/01.
//

import SwiftUI

struct PeriodBasedView: View {
    // WiD
    private let wiDService = WiDService()
    @State private var wiDList: [WiD] = []
    @State private var filteredWiDListByTitle: [WiD] = []
    
    // 제목
    @State private var selectedTitle: TitleWithALL = .ALL
    
    // 날짜
    private let calendar = Calendar.current
    private let today: Date = Date()
    @State private var startDate: Date = Date()
    @State private var finishDate: Date = Date()
    
    // 기간
    @State private var selectedPeriod: Period = Period.WEEK
    
    // 합계
    @State private var totalDurationDictionary: [String: TimeInterval] = [:]
    
    // 평균
    @State private var averageDurationDictionary: [String: TimeInterval] = [:]
    
    // 최고
    @State private var maxDurationDictionary: [String: TimeInterval] = [:]
    
    // 딕셔너리
    @State private var seletedDictionary: [String: TimeInterval] = [:]
    @State private var seletedDictionaryText: String = ""
    
    var body: some View {
        // 전체 화면
        VStack {
            // 상단 바
            HStack {
                Picker("", selection: $selectedPeriod) {
                    ForEach(Array(Period.allCases)) { period in
                        Text(period.koreanValue)
                    }
                }
                .pickerStyle(.segmented)
                
                Circle()
                    .fill(Color(selectedTitle.rawValue))
                    .frame(width: 10)
                
                Picker("", selection: $selectedTitle) {
                    ForEach(Array(TitleWithALL.allCases), id: \.self) { title in
                        Text(title.koreanValue)
                    }
                }
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            
            Divider()
            
            // 컨텐츠
            ScrollView {
                VStack(spacing: 32) {
                    if selectedTitle == TitleWithALL.ALL { // 제목이 "전체" 일 때
                        VStack(alignment: .leading, spacing: 8) {
                            Text("시간 그래프")
                                .font(.custom("BlackHanSans-Regular", size: 20))
                            
                            if wiDList.isEmpty {
                                HStack {
                                    Image(systemName: "ellipsis.bubble")
                                        .foregroundColor(.gray)

                                    Text("표시할 그래프가 없습니다.")
                                        .foregroundColor(.gray)

                                }
                                .padding()
                                .padding(.vertical, 32)
                                .frame(maxWidth: .infinity)
                                .background(.white)
                                .cornerRadius(8)
                                .shadow(radius: 1)
                            } else {
                                VStack(spacing: 0) {
                                    HStack {
                                        if selectedPeriod == Period.WEEK {
                                            ForEach(0...6, id: \.self) { index in
                                                let textColor = index == 5 ? Color.blue : (index == 6 ? Color.red : Color.black)
                                                
                                                Text(formatWeekdayLetterFromMonday(index))
                                                    .frame(maxWidth: .infinity)
                                                    .foregroundColor(textColor)
                                            }
                                        } else if selectedPeriod == Period.MONTH {
                                            ForEach(0...6, id: \.self) { index in
                                                let textColor = index == 0 ? Color.red : (index == 6 ? Color.blue : Color.black)
                                                
                                                Text(formatWeekdayLetterFromSunday(index))
                                                    .frame(maxWidth: .infinity)
                                                    .foregroundColor(textColor)
                                            }
                                        }
                                    }
                                    .padding(.vertical, 8)
                                    
                                    let weekday = calendar.component(.weekday, from: startDate)
                                    
                                    let timeInterval = finishDate.timeIntervalSince(startDate)
                                    let daysDifference = Int(timeInterval / (24 * 60 * 60))
                                    
                                    LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
                                        if selectedPeriod == Period.MONTH && weekday != 1 {
                                            // "id: \.self" 넣어야 정상작동한다.
                                            ForEach(0..<weekday - 1, id: \.self) { index in
                                                Text("\(index)")
                                            }
                                        }
                                        
                                        ForEach(0..<daysDifference + 1, id: \.self) { gridIndex in
                                            let currentDate = calendar.date(byAdding: .day, value: gridIndex, to: startDate) ?? Date()
                                            
                                            let filteredWiDList = wiDList.filter { wiD in
                                                return calendar.isDate(wiD.date, inSameDayAs: currentDate)
                                            }
                                            
                                            CalendarPieChartView(date: currentDate, wiDList: filteredWiDList)
                                        }
                                    }
                                }
                                .background(.white)
                                .cornerRadius(8)
                                .shadow(radius: 1)
                            }
                        }
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("\(seletedDictionaryText) 기록")
                                    .font(.custom("BlackHanSans-Regular", size: 20))
                                
                                Spacer()
                                
                                HStack {
                                    Button(action: {
                                        seletedDictionary = totalDurationDictionary
                                        seletedDictionaryText = "합계"
                                    }) {
                                        Text("합계")
                                            .foregroundColor(seletedDictionaryText == "합계" ? .black : .gray)
                                    }
                                    
                                    Button(action: {
                                        seletedDictionary = averageDurationDictionary
                                        seletedDictionaryText = "평균"
                                    }) {
                                        Text("평균")
                                            .foregroundColor(seletedDictionaryText == "평균" ? .black : .gray)
                                    }
                                    
                                    Button(action: {
                                        seletedDictionary = maxDurationDictionary
                                        seletedDictionaryText = "최고"
                                    }) {
                                        Text("최고")
                                            .foregroundColor(seletedDictionaryText == "최고" ? .black : .gray)
                                    }
                                }
                            }
                            
                            if wiDList.isEmpty {
                                HStack {
                                    Image(systemName: "ellipsis.bubble")
                                        .foregroundColor(.gray)
                                    
                                    Text("표시할 \(seletedDictionaryText) 기록이 없습니다.")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .padding(.vertical, 32)
                                .frame(maxWidth: .infinity)
                                .background(.white)
                                .cornerRadius(8)
                                .shadow(radius: 1)
                            } else {
                                VStack(spacing: 8) {
                                    ForEach(Array(seletedDictionary), id: \.key) { title, duration in
                                        HStack {
                                            HStack {
                                                Image(systemName: "character.textbox.ko")
                                                    .frame(width: 20)
                                                
                                                Text(titleDictionary[title] ?? "")
                                                    .bold()
                                                
                                                Circle()
                                                    .fill(Color(title))
                                                    .frame(width: 10)
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                            HStack {
                                                Image(systemName: "hourglass")
                                                    .frame(width: 20)
                                                
                                                Text(formatDuration(duration, mode: 2))
                                                    .bold()
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                    }
                                }
                                .padding()
                                .background(.white)
                                .cornerRadius(8)
                                .shadow(radius: 1)
                            }
                        }
                        .padding(.horizontal)
                    } else { // 제목이 "전체"가 아닐 떄
                        VStack(alignment: .leading, spacing: 8) {
                            Text("시간 그래프")
                                .font(.custom("BlackHanSans-Regular", size: 20))
                            
                            if wiDList.isEmpty {
                                HStack {
                                    Image(systemName: "ellipsis.bubble")
                                        .foregroundColor(.gray)

                                    Text("표시할 그래프가 없습니다.")
                                        .foregroundColor(.gray)

                                }
                                .padding()
                                .padding(.vertical, 32)
                                .frame(maxWidth: .infinity)
                                .background(.white)
                                .cornerRadius(8)
                                .shadow(radius: 1)
                            } else {
                                Text("LineChart Here")
                            }
                        }
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("시간 기록")
                                .font(.custom("BlackHanSans-Regular", size: 20))
                            
                            if wiDList.isEmpty {
                                HStack {
                                    Image(systemName: "ellipsis.bubble")
                                        .foregroundColor(.gray)
                                    
                                    Text("표시할 기록이 없습니다.")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .padding(.vertical, 32)
                                .frame(maxWidth: .infinity)
                                .background(.white)
                                .cornerRadius(8)
                                .shadow(radius: 1)
                            } else {
                                VStack(spacing: 8) {
                                    HStack {
                                        HStack {
                                            Image(systemName: "character.textbox.ko")
                                                .frame(width: 20)
                                            
                                            Text("합계")
                                                .bold()
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        HStack {
                                            Image(systemName: "hourglass")
                                                .frame(width: 20)
                                            
                                            Text(formatDuration(totalDurationDictionary[selectedTitle.rawValue] ?? 0, mode: 2))
                                                .bold()
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    
                                    HStack {
                                        HStack {
                                            Image(systemName: "character.textbox.ko")
                                                .frame(width: 20)
                                            
                                            Text("평균")
                                                .bold()
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        HStack {
                                            Image(systemName: "hourglass")
                                                .frame(width: 20)
                                            
                                            Text(formatDuration(averageDurationDictionary[selectedTitle.rawValue] ?? 0, mode: 2))
                                                .bold()
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    
                                    HStack {
                                        HStack {
                                            Image(systemName: "character.textbox.ko")
                                                .frame(width: 20)
                                            
                                            Text("최고")
                                                .bold()
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        HStack {
                                            Image(systemName: "hourglass")
                                                .frame(width: 20)
                                            
                                            Text(formatDuration(maxDurationDictionary[selectedTitle.rawValue] ?? 0, mode: 2))
                                                .bold()
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                                .padding()
                                .background(.white)
                                .cornerRadius(8)
                                .shadow(radius: 1)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            
            Divider()
            
            // 하단 바
            HStack {
                if selectedPeriod == Period.WEEK {
                    getWeekString(firstDayOfWeek: startDate, lastDayOfWeek: finishDate)
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else if selectedPeriod == Period.MONTH {
                    getMonthString(date: startDate)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Button(action: {
                    if (selectedPeriod == Period.WEEK) {
                        startDate = getFirstDayOfWeek(for: today)
                        finishDate = getLastDayOfWeek(for: today)
                    } else if (selectedPeriod == Period.MONTH) {
                        startDate = getFirstDayOfMonth(for: today)
                        finishDate = getLastDayOfMonth(for: today)
                    }

                    updateWiDData()
                }) {
                    Image(systemName: "arrow.clockwise")
                }
                .padding(.horizontal, 8)
                
                Button(action: {
                    if (selectedPeriod == Period.WEEK) {
                        startDate = calendar.date(byAdding: .day, value: -7, to: startDate) ?? Date()
                        finishDate = calendar.date(byAdding: .day, value: -7, to: finishDate) ?? Date()
                    } else if (selectedPeriod == Period.MONTH) {
                        startDate = getFirstDayOfMonth(for: calendar.date(byAdding: .day, value: -15, to: startDate) ?? Date())
                        finishDate = getLastDayOfMonth(for: calendar.date(byAdding: .day, value: -45, to: finishDate) ?? Date())
                    }
                    
                    updateWiDData()
                }) {
                    Image(systemName: "chevron.left")
                }
                .padding(.horizontal, 8)
                
                Button(action: {
                    if (selectedPeriod == Period.WEEK) {
                        startDate = calendar.date(byAdding: .day, value: 7, to: startDate) ?? Date()
                        finishDate = calendar.date(byAdding: .day, value: 7, to: finishDate) ?? Date()
                    } else if (selectedPeriod == Period.MONTH) {
                        startDate = getFirstDayOfMonth(for: calendar.date(byAdding: .day, value: 45, to: startDate) ?? Date())
                        finishDate = getLastDayOfMonth(for: calendar.date(byAdding: .day, value: 15, to: finishDate) ?? Date())
                    }

                    updateWiDData()
                }) {
                    Image(systemName: "chevron.right")
                }
                .padding(.horizontal, 8)
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            self.startDate = getFirstDayOfWeek(for: today)
            self.finishDate = getLastDayOfWeek(for: today)
            
            updateWiDData()
            
            self.filteredWiDListByTitle = wiDList.filter { wiD in
                return wiD.title == selectedTitle.rawValue
            }
        }
        .onChange(of: selectedTitle) { newTitle in
            filteredWiDListByTitle = wiDList.filter { wiD in
                return wiD.title == newTitle.rawValue
            }
        }
        .onChange(of: selectedPeriod) { newPeriod in
            if (newPeriod == Period.WEEK) {
                startDate = getFirstDayOfWeek(for: today)
                finishDate = getLastDayOfWeek(for: today)
            } else if (newPeriod == Period.MONTH) {
                startDate = getFirstDayOfMonth(for: today)
                finishDate = getLastDayOfMonth(for: today)
            }

            updateWiDData()
        }
    }
    
    // startDate, finishDate 변경될 때 실행됨.
    func updateWiDData() {
        wiDList = wiDService.selectWiDsBetweenDates(startDate: startDate, finishDate: finishDate)

        totalDurationDictionary = getTotalDurationDictionaryByTitle(wiDList: wiDList)
        averageDurationDictionary = getAverageDurationDictionaryByTitle(wiDList: wiDList)
        maxDurationDictionary = getMaxDurationDictionaryByTitle(wiDList: wiDList)
        
        seletedDictionary = totalDurationDictionary
        seletedDictionaryText = "합계"
    }
}

struct PeriodBasedView_Previews: PreviewProvider {
    static var previews: some View {
        PeriodBasedView()
    }
}
