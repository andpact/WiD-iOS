//
//  WiDReadCalendarView.swift
//  WiD
//
//  Created by jjkim on 2023/10/24.
//

import SwiftUI

struct WiDReadCalendarView: View {
    // 데이터베이스
    private let wiDService = WiDService()
    @State private var wiDList: [WiD] = []
    
    // 날짜
    private let calendar = Calendar.current
    private let today: Date = Date()
    private let totalDays = 365
    @State private var uniqueYears: [Year] = []
    @State private var selectedYear: Year = Year(id: "지난 1년")
    @State private var startDate: Date = Calendar.current.date(byAdding: .day, value: -364, to: Date()) ?? Date() // selectedYear의 시작 날짜
    @State private var finishDate: Date = Date() // selectedYear의 종료 날짜
    @State private var selectedDate: Date = Date()
    
    // 제목
    @State private var selectedTitle: TitleWithALL = .ALL
    
    var body: some View {
        // 전체 화면
        VStack {
            // 기간 및 제목 선택
            HStack {
                if 1 < uniqueYears.count {
                    Picker("", selection: $selectedYear.id) {
                        ForEach(Array(uniqueYears)) { year in
                            Text(year.id)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Spacer()

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
            
            // 달력 및 기록
            VStack(spacing: 32) {
                // 달력
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .bottom) {
                        Text("🗓️ 달력")
                            .font(.custom("BlackHanSans-Regular", size: 20))
                        
                        Spacer()
                        
                        if selectedTitle.rawValue == "ALL" {
                            Text("달력을 클릭하여 조회")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        } else {
                            HStack(alignment: .center) {
                                Text("0시간")
                                    .font(.system(size: 14))
                                
                                ForEach([0.2, 0.4, 0.6, 0.8, 1.0], id: \.self) { opacity in
                                    ExampleOpacityChartView(title: selectedTitle.rawValue, opacity: opacity)
                                }
                                .padding(.horizontal, -2)
                                
                                Text("10시간")
                                    .font(.system(size: 14))
                            }
                        }
                    }
                    
                    VStack(spacing: 0) {
                        HStack {
                            Text("날짜")
                                .frame(maxWidth: .infinity)
                            
                            ForEach(0...6, id: \.self) { index in
                                let textColor = index == 0 ? Color.red : (index == 6 ? Color.blue : Color.black)
                                
                                Text(formatWeekdayLetter(index))
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(textColor)
                            }
                        }
                        .padding(.vertical, 8)
                        
                        ScrollViewReader { sp in
                            ScrollView {
                                LazyVGrid(columns: Array(repeating: GridItem(), count: 8)) {
                                    let weekday = calendar.component(.weekday, from: startDate)
                                    
                                    // startDate가 일요일이 아니면 빈 아이템을 넣음.
                                    if weekday != 1 {
                                        ForEach(0..<weekday, id: \.self) { gridIndex in
                                            Text("")
                                        }
                                        
                                        ForEach(0..<8 - weekday, id: \.self) { gridIndex in
                                            let currentDate = calendar.date(byAdding: .day, value: gridIndex, to: startDate) ?? Date()
                                            
                                            if selectedTitle.rawValue == "ALL" {
                                                let filteredWiDList = wiDList.filter { wiD in
                                                    return calendar.isDate(wiD.date, inSameDayAs: currentDate)
                                                }
                                                
                                                CalendarPieChartView(date: currentDate, wiDList: filteredWiDList)
                                                    .onTapGesture {
                                                        selectedDate = currentDate
                                                    }
                                                    .border(selectedDate == currentDate ? Color.blue : Color.clear, width: 1)
                                            } else {
                                                let filteredWiDList = wiDList.filter { wiD in
                                                    return calendar.isDate(wiD.date, inSameDayAs: currentDate) && wiD.title == selectedTitle.rawValue
                                                }
                                                
                                                OpacityChartView(date: currentDate, wiDList: filteredWiDList)
                                                    .onTapGesture {
                                                        selectedDate = currentDate
                                                    }
                                                    .border(selectedDate == currentDate ? Color.blue : Color.clear, width: 1)
                                            }
                                        }
                                    }
                                    
                                    var startIndex: Int { if weekday != 1 { return 8 - weekday } else { return 0 }}
                                    
                                    ForEach(startIndex..<totalDays, id: \.self) { gridIndex in
                                        let currentDate = calendar.date(byAdding: .day, value: gridIndex, to: startDate) ?? Date()
                                        let dateWeekAgo = calendar.date(byAdding: .day, value: -7, to: currentDate) ?? Date()
                                        
                                        // 각 View가 Column 하나씩을 차지하므로, gridIndex % 7 == 0 일 때, Column 두 개를 차지하지만, gridIndex는 1 증가
                                        if gridIndex % 7 == startIndex {
                                            let previousMonth = calendar.component(.month, from: dateWeekAgo)
                                            let currentMonth = calendar.component(.month, from: currentDate)
                                            
                                            // 매달 첫 일요일에 해당하는 날짜 앞에 월 표시를 함.
                                            if previousMonth != currentMonth {
                                                Text(formatDate(currentDate, format: "M월"))
                                                    .font(.system(size: 14))
                                            } else {
                                                Text("")
                                            }
                                            
                                            if selectedTitle.rawValue == "ALL" {
                                                // 제목 상관없이 currentDate와 동일한 날짜의 WiD를 다 가져옴.
                                                let filteredWiDList = wiDList.filter { wiD in
                                                    return calendar.isDate(wiD.date, inSameDayAs: currentDate)
                                                }
                                                
                                                CalendarPieChartView(date: currentDate, wiDList: filteredWiDList)
                                                    .onTapGesture {
                                                        selectedDate = currentDate
                                                    }
                                                    .border(selectedDate == currentDate ? Color.blue : Color.clear, width: 1)
                                            } else {
                                                // currentDate와 동일한 날짜뿐만 아니라 제목도 selectTitle와 같은 WiD를 가져옴.
                                                let filteredWiDList = wiDList.filter { wiD in
                                                    return calendar.isDate(wiD.date, inSameDayAs: currentDate) && wiD.title == selectedTitle.rawValue
                                                }
                                                
                                                OpacityChartView(date: currentDate, wiDList: filteredWiDList)
                                                    .onTapGesture {
                                                        selectedDate = currentDate
                                                    }
                                                    .border(selectedDate == currentDate ? Color.blue : Color.clear, width: 1)
                                            }
                                        } else {
                                            if selectedTitle.rawValue == "ALL" {
                                                let filteredWiDList = wiDList.filter { wiD in
                                                    return calendar.isDate(wiD.date, inSameDayAs: currentDate)
                                                }
                                                
                                                CalendarPieChartView(date: currentDate, wiDList: filteredWiDList)
                                                    .onTapGesture {
                                                        selectedDate = currentDate
                                                    }
                                                    .border(calendar.isDate(selectedDate, inSameDayAs: currentDate) ? Color.blue : Color.clear, width: 1)
                                            } else {
                                                let filteredWiDList = wiDList.filter { wiD in
                                                    return calendar.isDate(wiD.date, inSameDayAs: currentDate) && wiD.title == selectedTitle.rawValue
                                                }
                                                
                                                OpacityChartView(date: currentDate, wiDList: filteredWiDList)
                                                    .onTapGesture {
                                                        selectedDate = currentDate
                                                    }
                                                    .border(calendar.isDate(selectedDate, inSameDayAs: currentDate) ? Color.blue : Color.clear, width: 1)
                                            }
                                        }
                                    }
                                }
                            }
                            .onAppear {
                                // 최초 스크롤을 가장 아래로 이동
                                sp.scrollTo(totalDays - 1, anchor: .bottom)
                            }
                        }
                    }
                    .padding(1)
                    .background(.white)
                    .cornerRadius(5)
                    .shadow(radius: 5)
                }
                .padding(.horizontal)
                
                // 기록
                ScrollView {
                    // 스크롤 뷰 안에 자동으로 수직 수택(spacing: 8)이 생성되는 듯하고, 수직 스택을 명시적으로 생성하면 자동 생성된 수직 스택이 사라지는 듯.
                    if selectedTitle.rawValue == "ALL" {
                        TotalDictionaryView(selectedDate: selectedDate, wiDList: wiDList)
                    } else {
                        TitleDictionaryView(selectedDate: selectedDate, startDate: startDate, finishDate: finishDate, selectedTitle: selectedTitle, wiDList: wiDList)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .onAppear {
            print(".onAppear 호출됨")
            uniqueYears = wiDService.getUniqueYears()
            
            wiDList = wiDService.selectWiDsBetweenDates(startDate: startDate, finishDate: finishDate)
        }
        .onChange(of: selectedYear.id) { newYear in
            print(".onChange(of: selectedYear.id) 호출됨")
            if newYear == "지난 1년" {
                withAnimation {
                    startDate = calendar.date(byAdding: .day, value: -364, to: Date()) ?? Date()
                    finishDate = Date()
                }
            } else {
                let yearFormatter = DateFormatter()
                yearFormatter.dateFormat = "yyyy"
                let selectedYearDate = yearFormatter.date(from: newYear)
                let components = calendar.dateComponents([.year], from: selectedYearDate ?? Date())

                let startComponents = DateComponents(year: components.year, month: 1, day: 1)
                let endComponents = DateComponents(year: components.year, month: 12, day: 31)
                
                withAnimation {
                    startDate = calendar.date(from: startComponents) ?? Date()
                    finishDate = calendar.date(from: endComponents) ?? Date()
                }
            }
        }
    }
}

struct WiDReadCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        WiDReadCalendarView()
    }
}
