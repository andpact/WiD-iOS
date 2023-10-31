//
//  WiDReadCalendarView.swift
//  WiD
//
//  Created by jjkim on 2023/10/24.
//

import SwiftUI

struct WiDReadCalendarView: View {
    private let calendar = Calendar.current
    private let today: Date = Date()
    private let wiDService = WiDService()
    @State private var wiDList: [WiD] = []
    
    @State private var uniqueYears: [Year] = []
    @State private var selectedYear: Year = Year(id: "지난 1년")
    @State private var selectedDate: Date = Date()
    @State private var firstDayOfWeek: Date = Date()
    @State private var lastDayOfWeek: Date = Date()
    @State private var selectedTitle: Title2 = .ALL
    
    @State private var startDate: Date = Calendar.current.date(byAdding: .day, value: -364, to: Date()) ?? Date()
    @State private var finishDate: Date = Date()
        
    @State private var dailyTitleDurationDictionary: [String: TimeInterval] = [:]
    @State private var weeklyTitleDurationDictionary: [String: TimeInterval] = [:]
    @State private var monthlyTitleDurationDictionary: [String: TimeInterval] = [:]
    
    var body: some View {
        VStack(spacing: 0) {
//            HStack {
//                Text(formatDate(startDate, format: "yyyy년 M월 d일 E"))
//
//                Text("~")
//
//                Text(formatDate(finishDate, format: "yyyy년 M월 d일 E"))
//
//                Text(titleDictionary[selectedTitle.rawValue]!)
//            }
            
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

                Picker("", selection: $selectedTitle) {
                    ForEach(Array(Title2.allCases), id: \.self) { title in
                        Text(titleDictionary[title.rawValue]!)
                    }
                }
            }
            .padding(.horizontal)

            Divider()
                .background(Color.black)
            
            VStack(spacing: 0) {
                Text("달력")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
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
                    
                    Divider()
                        .background(Color.black)
                    
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
                            let daysDifference = calendar.dateComponents([.day], from: startDate, to: finishDate).day! + 1
                            
                            ForEach(startIndex..<daysDifference, id: \.self) { gridIndex in
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
                }
                .padding(1)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(RoundedRectangle(cornerRadius: 5)
                    .stroke(.black, lineWidth: 1)
                )
                .background(.white)
                .cornerRadius(5)

                
                ZStack {
                    HStack {
                        Text("달력을 클릭하여 조회")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        if selectedTitle.rawValue != "ALL" {
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

                    Image(systemName: "equal")
                }
                
                ScrollView {
//                    HStack {
//                        Text("DAY")
//                            .bold()
//
//                        Text(calendar.isDate(selectedDate, inSameDayAs: today) ? "오늘" : formatDate(selectedDate, format: "yyyy년 M월 d일"))
//                            .font(.system(size: 14))
//                            .foregroundColor(.gray)
//                    }
//                    .frame(maxWidth: .infinity, alignment: .leading)
//
//                    VStack(spacing: 0) {
//                        if dailyTitleDurationDictionary.isEmpty {
//                            Text("표시할 데이터가 없습니다.")
//                                .foregroundColor(.gray)
//                        } else {
//                            ForEach(Array(dailyTitleDurationDictionary), id: \.key) { title, duration in
//                                HStack {
////                                    Rectangle()
////                                        .fill(Color(title))
////                                        .frame(width: 5, height: 10)
//
//                                    Text(titleDictionary[title] ?? "")
//
//                                    Spacer()
//
//                                    Text((formatDuration(duration, mode: 2)))
//                                }
//                            }
//                        }
//                    }
//                    .frame(maxWidth: .infinity)
//                    .background(RoundedRectangle(cornerRadius: 5)
//                        .stroke(.black, lineWidth: 1)
//                    )
//                    .background(.white)
//                    .cornerRadius(5)
//
//                    HStack {
//                        Text("WEEK")
//                            .bold()
//
//                        Text(calendar.isDate(firstDayOfWeek, inSameDayAs: today) ? "오늘" : formatDate(firstDayOfWeek, format: "yyyy년 M월 d일"))
//                            .font(.system(size: 14))
//                            .foregroundColor(.gray)
//
//                        Text("~")
//                            .foregroundColor(.gray)
//
//                        if calendar.isDate(lastDayOfWeek, inSameDayAs: today) {
//                            Text("오늘")
//                                .font(.system(size: 14))
//                                .foregroundColor(.gray)
//                        } else {
//                            if calendar.isDate(firstDayOfWeek, equalTo: lastDayOfWeek, toGranularity: .month) {
//                                Text(formatDate(lastDayOfWeek, format: "d일"))
//                                    .font(.system(size: 14))
//                                    .foregroundColor(.gray)
//                            } else {
//                                Text(formatDate(lastDayOfWeek, format: "M월 d일"))
//                                    .font(.system(size: 14))
//                                    .foregroundColor(.gray)
//                            }
//                        }
//                    }
//                    .frame(maxWidth: .infinity, alignment: .leading)
//
//                    VStack(spacing: 0) {
//                        if weeklyTitleDurationDictionary.isEmpty {
//                            Text("표시할 데이터가 없습니다.")
//                                .foregroundColor(.gray)
//                        } else {
//                            ForEach(Array(weeklyTitleDurationDictionary), id: \.key) { title, duration in
//                                HStack {
////                                    Rectangle()
////                                        .fill(Color(title))
////                                        .frame(width: 5, height: 10)
//
//                                    Text(titleDictionary[title] ?? "")
//
//                                    Spacer()
//
//                                    Text((formatDuration(duration, mode: 2)))
//                                }
//                            }
//                        }
//                    }
//                    .frame(maxWidth: .infinity)
//                    .background(RoundedRectangle(cornerRadius: 5)
//                        .stroke(.black, lineWidth: 1)
//                    )
//                    .background(.white)
//                    .cornerRadius(5)
//
//                    HStack {
//                        Text("MONTH")
//                            .bold()
//
//                        Text(formatDate(selectedDate, format: "yyyy년 M월"))
//                            .font(.system(size: 14))
//                            .foregroundColor(.gray)
//                    }
//                    .frame(maxWidth: .infinity, alignment: .leading)
//
//                    VStack(spacing: 0) {
//                        if monthlyTitleDurationDictionary.isEmpty {
//                            Text("표시할 데이터가 없습니다.")
//                                .foregroundColor(.gray)
//                        } else {
//                            ForEach(Array(monthlyTitleDurationDictionary), id: \.key) { title, duration in
//                                HStack {
////                                    Rectangle()
////                                        .fill(Color(title))
////                                        .frame(width: 5, height: 10)
//
//                                    Text(titleDictionary[title] ?? "")
//
//                                    Spacer()
//
//                                    Text((formatDuration(duration, mode: 2)))
//                                }
//                            }
//                        }
//                    }
//                    .frame(maxWidth: .infinity)
//                    .background(RoundedRectangle(cornerRadius: 5)
//                        .stroke(.black, lineWidth: 1)
//                    )
//                    .background(.white)
//                    .cornerRadius(5)
                    
                    Text("날짜 및 기간별 기록")
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        VStack {
                            Text("Day")
                            
                            Text("10시간")
                            
                            Text("10일")
                        }
                        .frame(maxWidth: .infinity)
                        
                        VStack {
                            Text("Week")
                            
                            Text("10시간")
                            
                            Text("10일 ~ 16일")
                        }
                        .frame(maxWidth: .infinity)
                        
                        VStack {
                            Text("Month")
                            
                            Text("10시간")
                            
                            Text("10월")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 5)
                        .stroke(.black, lineWidth: 1)
                    )
                    .background(.white)
                    .cornerRadius(5)
                    
                    Text("연속 기록")
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        VStack {
                            Text("최장 기간")
                            
                            Text("10일")
                            
                            Text("10월 10일 ~ 16일")
                        }
                        .frame(maxWidth: .infinity)
                        
                        VStack {
                            Text("현재 진행 중")
                            
                            Text("10일")
                            
                            Text("10월 10일 ~ 16일")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 5)
                        .stroke(.black, lineWidth: 1)
                    )
                    .background(.white)
                    .cornerRadius(5)
                    
                    Text("종합 기록")
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        VStack {
                            Text("총")
                            
                            Text("10일")
                            
                            Text("10월 10일 ~ 16일")
                        }
                        .frame(maxWidth: .infinity)
                        
                        VStack {
                            Text("최고")
                            
                            Text("10일")
                            
                            Text("10월 10일 ~ 16일")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 5)
                        .stroke(.black, lineWidth: 1)
                    )
                    .background(.white)
                    .cornerRadius(5)

                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal)
        }
        .onAppear {
            print(".onAppear 호출됨")
            uniqueYears = wiDService.getUniqueYears()
            
            wiDList = wiDService.selectWiDsBetweenDates(startDate: startDate, finishDate: finishDate)
            
            let weekday = calendar.component(.weekday, from: selectedDate)
            if weekday == 1 {
                firstDayOfWeek = calendar.date(byAdding: .day, value: -6, to: selectedDate)!
                lastDayOfWeek = selectedDate
            } else {
                firstDayOfWeek = calendar.date(byAdding: .day, value: 2 - weekday, to: selectedDate)!
                lastDayOfWeek = calendar.date(byAdding: .day, value: 8 - weekday, to: selectedDate)!
            }
            
            dailyTitleDurationDictionary = wiDService.getDailyTitleDurationDictionary(forDate: selectedDate)
            weeklyTitleDurationDictionary = wiDService.getWeeklyTitleDurationDictionary(forDate: selectedDate)
            monthlyTitleDurationDictionary = wiDService.getMonthlyTitleDurationDictionary(forDate: selectedDate)
        }
        .onChange(of: selectedDate) { newDate in
            print(".onChange(of: selectedDate) 호출됨")
            let weekday = calendar.component(.weekday, from: newDate)
            if weekday == 1 {
                firstDayOfWeek = calendar.date(byAdding: .day, value: -6, to: newDate)!
                lastDayOfWeek = newDate
            } else {
                firstDayOfWeek = calendar.date(byAdding: .day, value: 2 - weekday, to: newDate)!
                lastDayOfWeek = calendar.date(byAdding: .day, value: 8 - weekday, to: newDate)!
            }
            
            dailyTitleDurationDictionary = wiDService.getDailyTitleDurationDictionary(forDate: newDate)
            weeklyTitleDurationDictionary = wiDService.getWeeklyTitleDurationDictionary(forDate: newDate)
            monthlyTitleDurationDictionary = wiDService.getMonthlyTitleDurationDictionary(forDate: newDate)
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
