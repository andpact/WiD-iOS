//
//  PeriodBasedView.swift
//  WiD
//
//  Created by jjkim on 2023/12/01.
//

import SwiftUI

struct PeriodBasedView: View {
    // 화면
    @Environment(\.presentationMode) var presentationMode
    
    // WiD
    private let wiDService = WiDService()
    @State private var wiDList: [WiD] = []
    @State private var filteredWiDListByTitle: [WiD] = []
    
    // 제목
    @State private var selectedTitle: TitleWithALL = .ALL
    @State private var expandTitleMenu: Bool = false
    
    // 날짜
    private let calendar = Calendar.current
    private let today: Date = Calendar.current.startOfDay(for: Date()) // 시간을 오전 12:00:00으로 설정함.
    @State private var startDate: Date = Date()
    @State private var finishDate: Date = Date()
    @State private var expandDatePicker: Bool = false
    
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
        VStack(spacing: 0) {
            /**
             상단 바
             */
            ZStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.backward")
                        .imageScale(.large)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.blue)

                Text("기간 별 조회")
                    .titleLarge()
                
                Text("\(selectedTitle.koreanValue) • \(selectedPeriod.koreanValue)")
                    .bodySmall()
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding()
            
            Divider()
            
            /**
             컨텐츠
             */
            ScrollView {
                VStack(spacing: 16) {
                    if selectedTitle == TitleWithALL.ALL { // 제목이 "전체" 일 때
                        // 타임라인
                        VStack(spacing: 0) {
                            if selectedPeriod == Period.WEEK {
                                getWeekString(firstDayOfWeek: startDate, lastDayOfWeek: finishDate)
                                    .titleMedium()
                                    .padding(.horizontal)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            } else if selectedPeriod == Period.MONTH {
                                getMonthString(date: startDate)
                                    .titleMedium()
                                    .padding(.horizontal)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            if wiDList.isEmpty {
                                getEmptyView(message: "표시할 타임라인이 없습니다.")
                            } else {
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
                                .padding()
                                
                                // Weekday 1 - 일, 2 - 월...
                                let weekday = calendar.component(.weekday, from: startDate)
                                let daysDifference = calendar.dateComponents([.day], from: startDate, to: finishDate).day ?? 0
                                
                                if selectedPeriod == Period.WEEK {
                                    LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
                                        ForEach(0..<daysDifference + 1, id: \.self) { gridIndex in
                                            let currentDate = calendar.date(byAdding: .day, value: gridIndex, to: startDate) ?? Date()

                                            let filteredWiDList = wiDList.filter { wiD in
                                                return calendar.isDate(wiD.date, inSameDayAs: currentDate)
                                            }

                                            CalendarPieChartView(date: currentDate, wiDList: filteredWiDList)
                                        }
                                    }
                                    .padding(.horizontal)
                                } else if selectedPeriod == Period.MONTH {
                                    LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
                                        ForEach(0..<(daysDifference + 1) + (weekday - 1), id: \.self) { gridIndex in
                                            if gridIndex < weekday - 1 {
                                                Text("")
                                            } else {
                                                let currentDate = calendar.date(byAdding: .day, value: gridIndex - (weekday - 1), to: startDate) ?? Date()

                                                let filteredWiDList = wiDList.filter { wiD in
                                                    return calendar.isDate(wiD.date, inSameDayAs: currentDate)
                                                }

                                                CalendarPieChartView(date: currentDate, wiDList: filteredWiDList)
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        .padding(.vertical)
                        .background(.white)
                        
                        // 합계, 평균, 최고 기록
                        VStack(spacing: 0) {
                            HStack {
                                Text("\(seletedDictionaryText) 기록")
                                    .titleMedium()
                                
                                Spacer()
                                
                                HStack {
                                    Button(action: {
                                        seletedDictionary = totalDurationDictionary
                                        seletedDictionaryText = "합계"
                                    }) {
                                        Text("합계")
                                            .bodySmall()
                                            .foregroundColor(seletedDictionaryText == "합계" ? .black : .gray)
                                    }
                                    
                                    Button(action: {
                                        seletedDictionary = averageDurationDictionary
                                        seletedDictionaryText = "평균"
                                    }) {
                                        Text("평균")
                                            .bodySmall()
                                            .foregroundColor(seletedDictionaryText == "평균" ? .black : .gray)
                                    }
                                    
                                    Button(action: {
                                        seletedDictionary = maxDurationDictionary
                                        seletedDictionaryText = "최고"
                                    }) {
                                        Text("최고")
                                            .bodySmall()
                                            .foregroundColor(seletedDictionaryText == "최고" ? .black : .gray)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            
                            if wiDList.isEmpty {
                                getEmptyView(message: "표시할 \(seletedDictionaryText) 기록이 없습니다.")
                            } else {
                                ForEach(Array(seletedDictionary.enumerated()), id: \.element.key) {  item in
                                    let (index, (title, duration)) = item
                                    
                                    HStack {
                                        Text(titleDictionary[title] ?? "")
                                            .font(.custom("PyeongChangPeace-Bold", size: 20))
                                        
                                        Spacer()
                                    
                                        Text(formatDuration(duration, mode: 3))
                                            .font(.custom("PyeongChangPeace-Bold", size: 20))
                                    }
                                    .padding()
                                    
                                    if index != seletedDictionary.count - 1 {
                                        Divider()
                                            .padding(.horizontal)
                                    }
                                }
                            }
                        }
                        .padding(.vertical)
                        .background(.white)
                        
                        // 기록률
                        VStack(spacing: 0) {
                            Text("기록률")
                                .titleMedium()
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            if wiDList.isEmpty {
                                getEmptyView(message: "표시할 기록률이 없습니다.")
                            } else {
                                VerticalBarChartView(wiDList: wiDList, startDate: startDate, finishDate: finishDate)
                                    .padding()
                                    .aspectRatio(1.5 / 1.0, contentMode: .fit) // 가로 1.5, 세로 1 비율
                            }
                        }
                        .padding(.vertical)
                        .background(.white)
                    } else { // 제목이 "전체"가 아닐 떄
                        // 그래프
                        VStack(spacing: 0) {
                            if selectedPeriod == Period.WEEK {
                                getWeekString(firstDayOfWeek: startDate, lastDayOfWeek: finishDate)
                                    .titleMedium()
                                    .padding(.horizontal)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            } else if selectedPeriod == Period.MONTH {
                                getMonthString(date: startDate)
                                    .titleMedium()
                                    .padding(.horizontal)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            if filteredWiDListByTitle.isEmpty {
                                getEmptyView(message: "표시할 그래프가 없습니다.")
                            } else {
                                LineGraphView(title: selectedTitle.rawValue, wiDList: filteredWiDListByTitle, startDate: startDate, finishDate: finishDate)
                                    .padding()
                                    .aspectRatio(1.5 / 1.0, contentMode: .fit) // 가로 1.5, 세로 1 비율
                            }
                        }
                        .padding(.vertical)
                        .background(.white)
                        
                        // 시간 기록
                        VStack(spacing: 0) {
                            Text("시간 기록")
                                .titleMedium()
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            if filteredWiDListByTitle.isEmpty {
                                getEmptyView(message: "표시할 기록이 없습니다.")
                            } else {
                                HStack {
                                    Text("합계")
                                        .font(.custom("PyeongChangPeace-Bold", size: 20))
                                    
                                    Spacer()
                                
                                    Text(formatDuration(totalDurationDictionary[selectedTitle.rawValue] ?? 0, mode: 3))
                                        .font(.custom("PyeongChangPeace-Bold", size: 20))
                                }
                                .padding()
                                
                                Divider()
                                    .padding(.horizontal)
                                
                                HStack {
                                    Text("평균")
                                        .font(.custom("PyeongChangPeace-Bold", size: 20))
                                    
                                    Spacer()
                                
                                    Text(formatDuration(averageDurationDictionary[selectedTitle.rawValue] ?? 0, mode: 3))
                                        .font(.custom("PyeongChangPeace-Bold", size: 20))
                                }
                                .padding()
                                
                                Divider()
                                    .padding(.horizontal)
                                
                                HStack {
                                    Text("최고")
                                        .font(.custom("PyeongChangPeace-Bold", size: 20))
                                    
                                    Spacer()
                                
                                    Text(formatDuration(maxDurationDictionary[selectedTitle.rawValue] ?? 0, mode: 3))
                                        .font(.custom("PyeongChangPeace-Bold", size: 20))
                                }
                                .padding()
                            }
                        }
                        .padding(.vertical)
                        .background(.white)
                    }
                }
            }
            .background(Color("ghost_white"))
            
            Divider()
            
            /**
             하단 바
             */
            VStack(spacing: 8) {
                if expandDatePicker {
                    Text("조회할 기간을 선택해 주세요.")
                        .titleMedium()

                    LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
                        ForEach(Period.allCases) { menuPeriod in
                            Button(action: {
                                selectedPeriod = menuPeriod
                                withAnimation {
                                    expandDatePicker.toggle()
                                }
                            }) {
                                Text(menuPeriod.koreanValue)
                                    .bodyMedium()
                                    .frame(maxWidth: .infinity)
                                    .padding(8)
                                    .background(selectedPeriod == menuPeriod ? .black : Color("light_gray"))
                                    .foregroundColor(selectedPeriod == menuPeriod ? .white : .black)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                
                if expandTitleMenu {
                    Text("조회할 제목을 선택해 주세요.")
                        .titleMedium()
                    
                    Button(action: {
                        selectedTitle = TitleWithALL.ALL
                        withAnimation {
                            expandTitleMenu.toggle()
                        }
                    }) {
                        Text(TitleWithALL.ALL.koreanValue)
                            .bodyMedium()
                            .frame(maxWidth: .infinity)
                            .padding(8)
                            .background(selectedTitle == TitleWithALL.ALL ? .black : Color("light_gray"))
                            .foregroundColor(selectedTitle == TitleWithALL.ALL ? .white : .black)
                            .cornerRadius(8)
                    }
                    
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 5)) {
                        ForEach(TitleWithALL.allCases.filter { $0 != .ALL }) { menuTitle in
                            Button(action: {
                                selectedTitle = menuTitle
                                withAnimation {
                                    expandTitleMenu.toggle()
                                }
                            }) {
                                Text(menuTitle.koreanValue)
                                    .bodyMedium()
                                    .frame(maxWidth: .infinity)
                                    .padding(8)
                                    .background(selectedTitle == menuTitle ? .black : Color("light_gray"))
                                    .foregroundColor(selectedTitle == menuTitle ? .white : .black)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                
                HStack(spacing: 32) {
                    Button(action: {
                        withAnimation {
                            if expandTitleMenu {
                                expandTitleMenu = false
                            }
                            expandDatePicker.toggle()
                        }
                    }) {
                        Image(systemName: "calendar")
                            .imageScale(.large)
                    }
                    
                    Button(action: {
                        withAnimation {
                            if expandDatePicker {
                                expandDatePicker = false
                            }
                            expandTitleMenu.toggle()
                        }
                    }) {
                        Image(systemName: "textformat")
                            .imageScale(.large)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        if selectedPeriod == Period.WEEK {
                            startDate = getFirstDayOfWeek(for: today)
                            finishDate = getLastDayOfWeek(for: today)
                        } else if selectedPeriod == Period.MONTH {
                            startDate = getFirstDayOfMonth(for: today)
                            finishDate = getLastDayOfMonth(for: today)
                        }

                        updateDataFromPeriod()
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .imageScale(.large)
                    }
                    .disabled(
                        selectedPeriod == Period.WEEK &&
                        calendar.isDate(startDate, inSameDayAs: getFirstDayOfWeek(for: today)) &&
                        calendar.isDate(finishDate, inSameDayAs: getLastDayOfWeek(for: today)) ||
                        
                        selectedPeriod == Period.MONTH &&
                        calendar.isDate(startDate, inSameDayAs: getFirstDayOfMonth(for: today)) &&
                        calendar.isDate(finishDate, inSameDayAs: getLastDayOfMonth(for: today))
                    )
                    
                    Button(action: {
                        if selectedPeriod == Period.WEEK {
                            startDate = calendar.date(byAdding: .day, value: -7, to: startDate) ?? Date()
                            finishDate = calendar.date(byAdding: .day, value: -7, to: finishDate) ?? Date()
                        } else if selectedPeriod == Period.MONTH {
                            startDate = getFirstDayOfMonth(for: calendar.date(byAdding: .day, value: -15, to: startDate) ?? Date())
                            finishDate = getLastDayOfMonth(for: calendar.date(byAdding: .day, value: -45, to: finishDate) ?? Date())
                        }
                        
                        updateDataFromPeriod()
                    }) {
                        Image(systemName: "chevron.backward")
                            .imageScale(.large)
                    }
                    
                    Button(action: {
                        if selectedPeriod == Period.WEEK {
                            startDate = calendar.date(byAdding: .day, value: 7, to: startDate) ?? Date()
                            finishDate = calendar.date(byAdding: .day, value: 7, to: finishDate) ?? Date()
                        } else if selectedPeriod == Period.MONTH {
                            startDate = getFirstDayOfMonth(for: calendar.date(byAdding: .day, value: 45, to: startDate) ?? Date())
                            finishDate = getLastDayOfMonth(for: calendar.date(byAdding: .day, value: 15, to: finishDate) ?? Date())
                        }

                        updateDataFromPeriod()
                    }) {
                        Image(systemName: "chevron.forward")
                            .imageScale(.large)
                    }
                    .disabled(
                        selectedPeriod == Period.WEEK &&
                        calendar.isDate(startDate, inSameDayAs: getFirstDayOfWeek(for: today)) &&
                        calendar.isDate(finishDate, inSameDayAs: getLastDayOfWeek(for: today)) ||
                        
                        selectedPeriod == Period.MONTH &&
                        calendar.isDate(startDate, inSameDayAs: getFirstDayOfMonth(for: today)) &&
                        calendar.isDate(finishDate, inSameDayAs: getLastDayOfMonth(for: today))
                    )
                }
            }
            .padding()
            .background(.white)
        }
        .tint(.black)
        .navigationBarHidden(true)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            self.startDate = getFirstDayOfWeek(for: today)
            self.finishDate = getLastDayOfWeek(for: today)
            
//            print("onAppear - startDate : \(formatDate(startDate, format: "yyyy-MM-dd a HH:mm:ss"))")
//            print("onAppear - finishDate : \(formatDate(finishDate, format: "yyyy-MM-dd a HH:mm:ss"))")
            
            updateDataFromPeriod()
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

            updateDataFromPeriod()
        }
    }
    
    // startDate, finishDate 변경될 때 실행됨.
    func updateDataFromPeriod() {
        wiDList = wiDService.selectWiDsBetweenDates(startDate: startDate, finishDate: finishDate)
        
        filteredWiDListByTitle = wiDList.filter { wiD in
            return wiD.title == selectedTitle.rawValue
        }

        totalDurationDictionary = getTotalDurationDictionaryByTitle(wiDList: wiDList)
        averageDurationDictionary = getAverageDurationDictionaryByTitle(wiDList: wiDList)
        maxDurationDictionary = getMaxDurationDictionaryByTitle(wiDList: wiDList)
        
        // startDate, finishDate를 변경하면 합계 딕셔너리로 초기화함.
        seletedDictionary = totalDurationDictionary
        seletedDictionaryText = "합계"
    }
}

struct PeriodBasedView_Previews: PreviewProvider {
    static var previews: some View {
        PeriodBasedView()
    }
}
