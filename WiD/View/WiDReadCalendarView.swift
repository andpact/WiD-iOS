//
//  WiDReadCalendarView.swift
//  WiD
//
//  Created by jjkim on 2023/10/24.
//

import SwiftUI

struct WiDReadCalendarView: View {
    private let calendar = Calendar.current
    private let wiDService = WiDService()
    @State private var wiDList: [WiD] = []
    
    @State private var uniqueYears: [Year] = []
    @State private var selectedYear = Year(id: "지난 1년")
    @State private var selectedDate = Date()
    @State private var firstDayOfWeek: Date = Date()
    @State private var lastDayOfWeek: Date = Date()
    @State private var selectedTitle: Title2 = .ALL
    
    @State private var startDate = Calendar.current.date(byAdding: .day, value: -364, to: Date()) ?? Date()
    @State private var finishDate = Date()
    
    @State private var dailyTitleDurationDictionary: [String: TimeInterval] = [:]
    @State private var weeklyTitleDurationDictionary: [String: TimeInterval] = [:]
    @State private var monthlyTitleDurationDictionary: [String: TimeInterval] = [:]
    
    var body: some View {
        VStack(spacing: 0) {
//            HStack {
//                Text(formatDate(startDate, format: "yyyy년 M월 d일"))
//
//                Text("~")
//
//                Text(formatDate(finishDate, format: "yyyy년 M월 d일"))
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
//                        Text("날짜")
//                            .frame(maxWidth: .infinity)
                        
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
                        LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
                            var daysDifference = calendar.dateComponents([.day], from: startDate, to: finishDate).day! + 1

                            ForEach(0..<daysDifference, id: \.self) { gridIndex in
                                let currentDate = calendar.date(byAdding: .day, value: gridIndex, to: startDate) ?? Date()

//                                if gridIndex % 8 == 0 {
//                                    Text(formatDate(currentDate, format: "M월"))
//                                        .font(.system(size: 14))
//                                } else {
                                    let filteredWiDList = wiDList.filter { wiD in
                                        return calendar.isDate(wiD.date, inSameDayAs: currentDate)
                                    }

                                    TmpPieChartView(date: currentDate, wiDList: filteredWiDList)
                                        .onTapGesture {
                                            selectedDate = currentDate
                                        }
                                        .border(selectedDate == currentDate ? Color.blue : Color.clear, width: 1)
//                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray, lineWidth: 1)
                    .background(.white)
                )
                
                ZStack {
                    HStack {
                        Text("달력을 클릭하여 조회")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Text("0시간 ~ 10시간")
                            .font(.system(size: 14))
                    }

                    Image(systemName: "equal")
                }
                
                ScrollView {
                    HStack {
                        Text("DAY")
                            .bold()
                        
                        Text(formatDate(selectedDate, format: "yyyy년 M월 d일"))
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(spacing: 0) {
                        if dailyTitleDurationDictionary.isEmpty {
                            Text("표시할 데이터가 없습니다.")
                                .foregroundColor(.gray)
                        } else {
                            ForEach(Array(dailyTitleDurationDictionary), id: \.key) { title, duration in
                                HStack {
                                    Rectangle()
                                        .fill(Color(title))
                                        .frame(width: 5)
                                    
                                    Text(titleDictionary[title] ?? "")
                                    
                                    Spacer()
                                    
                                    Text((formatDuration(duration, mode: 2)))
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1)
                        .background(.white)
                    )
                    
                    HStack {
                        Text("WEEK")
                            .bold()
                        
                        Text(formatDate(firstDayOfWeek, format: "yyyy년 M월 d일"))
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        
                        Text("~")
                            .foregroundColor(.gray)
                        
                        if Calendar.current.isDate(firstDayOfWeek, equalTo: lastDayOfWeek, toGranularity: .month) {
                            Text(formatDate(lastDayOfWeek, format: "d일"))
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        } else {
                            Text(formatDate(lastDayOfWeek, format: "M월 d일"))
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(spacing: 0) {
                        if weeklyTitleDurationDictionary.isEmpty {
                            Text("표시할 데이터가 없습니다.")
                                .foregroundColor(.gray)
                        } else {
                            ForEach(Array(weeklyTitleDurationDictionary), id: \.key) { title, duration in
                                HStack {
                                    Rectangle()
                                        .fill(Color(title))
                                        .frame(width: 5)
                                    
                                    Text(titleDictionary[title] ?? "")
                                    
                                    Spacer()
                                    
                                    Text((formatDuration(duration, mode: 2)))
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1)
                        .background(.white)
                    )
                    
                    HStack {
                        Text("MONTH")
                            .bold()
                        
                        Text(formatDate(selectedDate, format: "yyyy년 M월"))
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(spacing: 0) {
                        if monthlyTitleDurationDictionary.isEmpty {
                            Text("표시할 데이터가 없습니다.")
                                .foregroundColor(.gray)
                        } else {
                            ForEach(Array(monthlyTitleDurationDictionary), id: \.key) { title, duration in
                                HStack {
                                    Rectangle()
                                        .fill(Color(title))
                                        .frame(width: 5)
                                    
                                    Text(titleDictionary[title] ?? "")
                                    
                                    Spacer()
                                    
                                    Text((formatDuration(duration, mode: 2)))
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1)
                        .background(.white)
                    )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal)
        }
        .onAppear {
            print(".onAppear 호출됨")
            uniqueYears = wiDService.getUniqueYears()
            
            wiDList = wiDService.selectWiDsBetweenDates(startDate: startDate, finishDate: finishDate)
            
            let weekday = calendar.component(.weekday, from: selectedDate)
            firstDayOfWeek = calendar.date(byAdding: .day, value: 2 - weekday, to: selectedDate)!
            lastDayOfWeek = calendar.date(byAdding: .day, value: 8 - weekday, to: selectedDate)!
            
            dailyTitleDurationDictionary = wiDService.getDailyTitleDurationDictionary(forDate: selectedDate)
            weeklyTitleDurationDictionary = wiDService.getWeeklyTitleDurationDictionary(forDate: selectedDate)
            monthlyTitleDurationDictionary = wiDService.getMonthlyTitleDurationDictionary(forDate: selectedDate)
        }
        .onChange(of: selectedDate) { newDate in
            print(".onChange(of: selectedDate) 호출됨")
            let weekday = calendar.component(.weekday, from: newDate)
            firstDayOfWeek = calendar.date(byAdding: .day, value: 2 - weekday, to: newDate)!
            lastDayOfWeek = calendar.date(byAdding: .day, value: 8 - weekday, to: newDate)!
            
            dailyTitleDurationDictionary = wiDService.getDailyTitleDurationDictionary(forDate: newDate)
            weeklyTitleDurationDictionary = wiDService.getWeeklyTitleDurationDictionary(forDate: newDate)
            monthlyTitleDurationDictionary = wiDService.getMonthlyTitleDurationDictionary(forDate: newDate)
        }
        .onChange(of: selectedYear.id) { newYear in
            if newYear == "지난 1년" {
                startDate = calendar.date(byAdding: .day, value: -364, to: Date()) ?? Date()
                finishDate = Date()
            } else {
                let yearFormatter = DateFormatter()
                yearFormatter.dateFormat = "yyyy"
                
                if let selectedYearDate = yearFormatter.date(from: newYear) {
                    let components = calendar.dateComponents([.year], from: selectedYearDate)
                    if let year = components.year {
                        let startComponents = DateComponents(year: year, month: 1, day: 1)
                        let endComponents = DateComponents(year: year, month: 12, day: 31)
                        
                        startDate = calendar.date(from: startComponents) ?? Date()
                        finishDate = calendar.date(from: endComponents) ?? Date()
                    }
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
