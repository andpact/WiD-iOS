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
    private let screenHeight = UIScreen.main.bounds.height
    
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
    
    // 최저
    @State private var minDurationDictionary: [String: TimeInterval] = [:]
    
    // 최고
    @State private var maxDurationDictionary: [String: TimeInterval] = [:]
    
    // 딕셔너리
    @State private var seletedDictionary: [String: TimeInterval] = [:]
    @State private var seletedDictionaryText: String = ""
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                /**
                 상단 바
                 */
                ZStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.backward")
                            .font(.system(size: 24))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Text("기간 조회")
                        .titleLarge()
                    
                    Text("\(selectedTitle.koreanValue) • \(selectedPeriod.koreanValue)")
                        .bodyMedium()
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity, maxHeight: 44)
                
                Divider()
                    .background(Color("Black-White"))
                
                /**
                 컨텐츠
                 */
                ScrollView {
                    VStack(spacing: 0) {
                        if selectedTitle == TitleWithALL.ALL { // 제목이 "전체" 일 때
                            // 타임라인
                            VStack(spacing: 8) {
                                if selectedPeriod == Period.WEEK {
                                    getPeriodStringViewOfWeek(firstDayOfWeek: startDate, lastDayOfWeek: finishDate)
                                        .titleMedium()
                                        .padding(.horizontal)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                } else if selectedPeriod == Period.MONTH {
                                    getPeriodStringViewOfMonth(date: startDate)
                                        .titleMedium()
                                        .padding(.horizontal)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                
                                if wiDList.isEmpty {
                                    getEmptyView(message: "표시할 타임라인이 없습니다.")
                                } else {
                                    VStack(spacing: 0) {
                                        HStack {
                                            if selectedPeriod == Period.WEEK {
                                                ForEach(0...6, id: \.self) { index in
                                                    let textColor = index == 5 ? Color("DeepSkyBlue") : (index == 6 ? Color("OrangeRed") : Color("Black-White"))
                                                    
                                                    Text(getStringOfDayOfWeekFromMonday(index))
                                                        .bodySmall()
                                                        .frame(maxWidth: .infinity)
                                                        .foregroundColor(textColor)
                                                }
                                            } else if selectedPeriod == Period.MONTH {
                                                ForEach(0...6, id: \.self) { index in
                                                    let textColor = index == 0 ? Color("OrangeRed") : (index == 6 ? Color("DeepSkyBlue") : Color("Black-White"))
                                                    
                                                    Text(getStringOfDayOfWeekFromSunday(index))
                                                        .bodySmall()
                                                        .frame(maxWidth: .infinity)
                                                        .foregroundColor(textColor)
                                                }
                                            }
                                        }
                                        .padding(4)
                                        
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

                                                    PeriodPieChartView(date: currentDate, wiDList: filteredWiDList)
                                                }
                                            }
                                            .padding(4)
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

                                                        PeriodPieChartView(date: currentDate, wiDList: filteredWiDList)
                                                    }
                                                }
                                            }
                                            .padding(4)
                                        }
                                    }
                                    .background(Color("White-Black"))
                                    .cornerRadius(8)
                                    .shadow(color: Color("Black-White"), radius: 1)
                                    .padding(.horizontal)
                                }
                            }
                            .padding(.vertical)
                            
                            Rectangle()
                                .frame(maxWidth: .infinity, maxHeight: 8)
                                .foregroundColor(Color("LightGray-Gray"))
                            
                            // 합계, 평균, 최고 기록
                            VStack(spacing: 8) {
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
                                                .bodyMedium()
                                                .foregroundColor(seletedDictionaryText == "합계" ? Color("Black-White") : Color("DarkGray"))
                                        }
                                        
                                        Button(action: {
                                            seletedDictionary = averageDurationDictionary
                                            seletedDictionaryText = "평균"
                                        }) {
                                            Text("평균")
                                                .bodyMedium()
                                                .foregroundColor(seletedDictionaryText == "평균" ? Color("Black-White") : Color("DarkGray"))
                                        }
                                        
                                        Button(action: {
                                            seletedDictionary = minDurationDictionary
                                            seletedDictionaryText = "최저"
                                        }) {
                                            Text("최저")
                                                .bodyMedium()
                                                .foregroundColor(seletedDictionaryText == "최저" ? Color("Black-White") : Color("DarkGray"))
                                        }
                                        
                                        Button(action: {
                                            seletedDictionary = maxDurationDictionary
                                            seletedDictionaryText = "최고"
                                        }) {
                                            Text("최고")
                                                .bodyMedium()
                                                .foregroundColor(seletedDictionaryText == "최고" ? Color("Black-White") : Color("DarkGray"))
                                        }
                                    }
                                }
                                .padding(.horizontal)
                                
                                if wiDList.isEmpty {
                                    getEmptyView(message: "표시할 \(seletedDictionaryText) 기록이 없습니다.")
                                } else {
                                    LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
                                        ForEach(Array(seletedDictionary), id: \.key) { title, duration in
                                            VStack(spacing: 16) {
                                                HStack {
                                                    Image(systemName: titleImageDictionary[title] ?? "") // (?? "") 반드시 붙혀야 함.
                                                        .font(.system(size: 16))
                                                        .frame(maxWidth: 15, maxHeight: 15)
                                                        .padding(8)
                                                        .background(Color(title).overlay(.white.opacity(0.9)))
                                                        .foregroundColor(Color(title))
                                                        .clipShape(Circle())
                                                    
                                                    Text(titleDictionary[title] ?? "")
                                                        .font(.system(size: 24, weight: .bold))
                                                }
                                                .frame(maxWidth: .infinity)
                                                
                                                Text(getDurationString(duration, mode: 3))
                                                    .bodyMedium()
                                                    .frame(maxWidth: .infinity)
                                            }
                                            .padding(.vertical)
                                            .frame(maxWidth: .infinity)
                                            .background(Color("White-Black"))
                                            .cornerRadius(8)
                                            .shadow(color: Color("Black-White"), radius: 1)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            .padding(.vertical)
                            
                            Rectangle()
                                .frame(maxWidth: .infinity, maxHeight: 8)
                                .foregroundColor(Color("LightGray-Gray"))
                            
                            // 기록률
                            VStack(spacing: 8) {
                                Text("기록률")
                                    .titleMedium()
                                    .padding(.horizontal)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                if wiDList.isEmpty {
                                    getEmptyView(message: "표시할 기록률이 없습니다.")
                                } else {
                                    VerticalBarChartView(wiDList: wiDList, startDate: startDate, finishDate: finishDate)
                                        .aspectRatio(1.5 / 1.0, contentMode: .fit) // 가로 1.5, 세로 1 비율
                                        .padding()
                                        .background(Color("White-Black"))
                                        .cornerRadius(8)
                                        .shadow(color: Color("Black-White"), radius: 1)
                                        .padding(.horizontal)
                                }
                            }
                            .padding(.vertical)
                        } else { // 제목이 "전체"가 아닐 떄
                            // 그래프
                            VStack(spacing: 8) {
                                if selectedPeriod == Period.WEEK {
                                    getPeriodStringViewOfWeek(firstDayOfWeek: startDate, lastDayOfWeek: finishDate)
                                        .titleMedium()
                                        .padding(.horizontal)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                } else if selectedPeriod == Period.MONTH {
                                    getPeriodStringViewOfMonth(date: startDate)
                                        .titleMedium()
                                        .padding(.horizontal)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                
                                if filteredWiDListByTitle.isEmpty {
                                    getEmptyView(message: "표시할 그래프가 없습니다.")
                                } else {
                                    LineGraphView(title: selectedTitle.rawValue, wiDList: filteredWiDListByTitle, startDate: startDate, finishDate: finishDate)
                                        .aspectRatio(1.5 / 1.0, contentMode: .fit) // 가로 1.5, 세로 1 비율
                                        .padding()
                                        .background(Color("White-Black"))
                                        .cornerRadius(8)
                                        .shadow(color: Color("Black-White"), radius: 1)
                                        .padding(.horizontal)
                                }
                            }
                            .padding(.vertical)
                            
                            Rectangle()
                                .frame(maxWidth: .infinity, maxHeight: 8)
                                .foregroundColor(Color("LightGray-Gray"))
                            
                            // 시간 기록
                            VStack(spacing: 8) {
                                Text("시간 기록")
                                    .titleMedium()
                                    .padding(.horizontal)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                if filteredWiDListByTitle.isEmpty {
                                    getEmptyView(message: "표시할 기록이 없습니다.")
                                } else {
                                    HStack {
                                        Text("합계")
                                            .bodyLarge()
                                        
                                        Spacer()
                                    
                                        Text(getDurationString(totalDurationDictionary[selectedTitle.rawValue] ?? 0, mode: 3))
                                            .titleLarge()
                                    }
                                    .padding()
                                    .background(Color("White-Black"))
                                    .cornerRadius(8)
                                    .shadow(color: Color("Black-White"), radius: 1)
                                    .padding(.horizontal)
                                    
                                    HStack {
                                        Text("평균")
                                            .bodyLarge()
                                        
                                        Spacer()
                                    
                                        Text(getDurationString(averageDurationDictionary[selectedTitle.rawValue] ?? 0, mode: 3))
                                            .titleLarge()
                                    }
                                    .padding()
                                    .background(Color("White-Black"))
                                    .cornerRadius(8)
                                    .shadow(color: Color("Black-White"), radius: 1)
                                    .padding(.horizontal)
                                    
                                    HStack {
                                        Text("최저")
                                            .bodyLarge()
                                        
                                        Spacer()
                                    
                                        Text(getDurationString(minDurationDictionary[selectedTitle.rawValue] ?? 0, mode: 3))
                                            .titleLarge()
                                    }
                                    .padding()
                                    .background(Color("White-Black"))
                                    .cornerRadius(8)
                                    .shadow(color: Color("Black-White"), radius: 1)
                                    .padding(.horizontal)
                                    
                                    HStack {
                                        Text("최고")
                                            .bodyLarge()
                                        
                                        Spacer()
                                    
                                        Text(getDurationString(maxDurationDictionary[selectedTitle.rawValue] ?? 0, mode: 3))
                                            .titleLarge()
                                    }
                                    .padding()
                                    .background(Color("White-Black"))
                                    .cornerRadius(8)
                                    .shadow(color: Color("Black-White"), radius: 1)
                                    .padding(.horizontal)
                                }
                            }
                            .padding(.vertical)
                        }
                    }
                }
                
                Divider()
                    .background(Color("Black-White"))
                
                /**
                 하단 바
                 */
                HStack(spacing: 0) {
                    Button(action: {
                        withAnimation {
                            if expandTitleMenu {
                                expandTitleMenu = false
                            }
                            expandDatePicker.toggle()
                        }
                    }) {
                        Image(systemName: "calendar")
                            .font(.system(size: 24))
                            .frame(width: 30, height: 30)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Button(action: {
                        withAnimation {
                            if expandDatePicker {
                                expandDatePicker = false
                            }
                            expandTitleMenu.toggle()
                        }
                    }) {
                        Image(systemName: titleImageDictionary[selectedTitle.rawValue] ?? "")
                            .font(.system(size: 24))
                            .frame(width: 30, height: 30)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Button(action: {
                        if selectedPeriod == Period.WEEK {
                            startDate = getFirstDateOfWeek(for: today)
                            finishDate = getLastDateOfWeek(for: today)
                        } else if selectedPeriod == Period.MONTH {
                            startDate = getFirstDateOfMonth(for: today)
                            finishDate = getLastDateOfMonth(for: today)
                        }

                        updateDataFromPeriod()
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 24))
                            .frame(width: 30, height: 30)
                    }
                    .frame(maxWidth: .infinity)
                    .disabled(
                        selectedPeriod == Period.WEEK &&
                        calendar.isDate(startDate, inSameDayAs: getFirstDateOfWeek(for: today)) &&
                        calendar.isDate(finishDate, inSameDayAs: getLastDateOfWeek(for: today)) ||
                        
                        selectedPeriod == Period.MONTH &&
                        calendar.isDate(startDate, inSameDayAs: getFirstDateOfMonth(for: today)) &&
                        calendar.isDate(finishDate, inSameDayAs: getLastDateOfMonth(for: today))
                    )
                    
                    Button(action: {
                        if selectedPeriod == Period.WEEK {
                            startDate = calendar.date(byAdding: .day, value: -7, to: startDate) ?? Date()
                            finishDate = calendar.date(byAdding: .day, value: -7, to: finishDate) ?? Date()
                        } else if selectedPeriod == Period.MONTH {
                            startDate = getFirstDateOfMonth(for: calendar.date(byAdding: .day, value: -15, to: startDate) ?? Date())
                            finishDate = getLastDateOfMonth(for: calendar.date(byAdding: .day, value: -45, to: finishDate) ?? Date())
                        }
                        
                        updateDataFromPeriod()
                    }) {
                        Image(systemName: "chevron.backward")
                            .font(.system(size: 24))
                            .frame(width: 30, height: 30)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Button(action: {
                        if selectedPeriod == Period.WEEK {
                            startDate = calendar.date(byAdding: .day, value: 7, to: startDate) ?? Date()
                            finishDate = calendar.date(byAdding: .day, value: 7, to: finishDate) ?? Date()
                        } else if selectedPeriod == Period.MONTH {
                            startDate = getFirstDateOfMonth(for: calendar.date(byAdding: .day, value: 45, to: startDate) ?? Date())
                            finishDate = getLastDateOfMonth(for: calendar.date(byAdding: .day, value: 15, to: finishDate) ?? Date())
                        }

                        updateDataFromPeriod()
                    }) {
                        Image(systemName: "chevron.forward")
                            .font(.system(size: 24))
                            .frame(width: 30, height: 30)
                    }
                    .frame(maxWidth: .infinity)
                    .disabled(
                        selectedPeriod == Period.WEEK &&
                        calendar.isDate(startDate, inSameDayAs: getFirstDateOfWeek(for: today)) &&
                        calendar.isDate(finishDate, inSameDayAs: getLastDateOfWeek(for: today)) ||
                        
                        selectedPeriod == Period.MONTH &&
                        calendar.isDate(startDate, inSameDayAs: getFirstDateOfMonth(for: today)) &&
                        calendar.isDate(finishDate, inSameDayAs: getLastDateOfMonth(for: today))
                    )
                }
                .padding()
            }
            
            /**
             대화 상자
             */
            if expandDatePicker || expandTitleMenu {
                ZStack {
                    Color("Black-White")
                        .opacity(0.3)
                        .onTapGesture {
                            expandDatePicker = false
                            expandTitleMenu = false
                        }
                    
                    // 날짜 선택
                    if expandDatePicker {
                        VStack(spacing: 0) {
                            ZStack {
                                Text("기간 선택")
                                    .titleMedium()
                                
                                Button(action: {
                                    expandDatePicker = false
                                }) {
                                    Text("확인")
                                        .bodyMedium()
                                }
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .tint(Color("Black-White"))
                            }
                            .padding()
                            
                            Divider()
                                .background(Color("Black-White"))

                            VStack(spacing: 0) {
                                ForEach(Period.allCases) { menuPeriod in
                                    Button(action: {
                                        selectedPeriod = menuPeriod
                                        withAnimation {
                                            expandDatePicker.toggle()
                                        }
                                    }) {
//                                            Image(systemName: titleImageDictionary[menuTitle.rawValue] ?? "")
//                                                .font(.system(size: 25))
//                                                .frame(maxWidth: 40, maxHeight: 40)
//
//                                            Spacer()
//                                                .frame(maxWidth: 20)
                                        
                                        Text(menuPeriod.koreanValue)
                                            .labelMedium()
                                        
                                        Spacer()
                                        
                                        if selectedPeriod == menuPeriod {
                                            Text("선택됨")
                                                .bodyMedium()
                                        }
                                    }
                                    .padding()
                                }
                            }
                        }
                        .background(Color("White-Black"))
                        .cornerRadius(8)
                        .padding() // 바깥 패딩
                        .shadow(color: Color("Black-White"), radius: 1)
                    }
                    
                    if expandTitleMenu {
                        VStack(spacing: 0) {
                            ZStack {
                                Text("제목 선택")
                                    .titleLarge()
                                
                                Button(action: {
                                    expandTitleMenu = false
                                }) {
                                    Text("확인")
                                        .bodyMedium()
                                }
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                            .padding()
                            
                            Divider()
                                .background(Color("Black-White"))
                            
                            ScrollView {
                                VStack(spacing: 0) {
                                    ForEach(TitleWithALL.allCases) { menuTitle in
                                        Button(action: {
                                            selectedTitle = menuTitle
                                            withAnimation {
                                                expandTitleMenu.toggle()
                                            }
                                        }) {
                                            Image(systemName: titleImageDictionary[menuTitle.rawValue] ?? "")
                                                .font(.system(size: 24))
                                                .frame(maxWidth: 40, maxHeight: 40)
                                            
                                            Spacer()
                                                .frame(maxWidth: 20)
                                            
                                            Text(menuTitle.koreanValue)
                                                .labelMedium()
                                            
                                            Spacer()
                                            
                                            if selectedTitle == menuTitle {
                                                Text("선택됨")
                                                    .bodyMedium()
                                            }
                                        }
                                        .padding()
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: screenHeight / 2)
                        .background(Color("White-Black"))
                        .cornerRadius(8)
                        .padding()
                        .shadow(color: Color("Black-White"), radius: 1)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .tint(Color("Black-White"))
        .navigationBarHidden(true)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            self.startDate = getFirstDateOfWeek(for: today)
            self.finishDate = getLastDateOfWeek(for: today)
            
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
                startDate = getFirstDateOfWeek(for: today)
                finishDate = getLastDateOfWeek(for: today)
            } else if (newPeriod == Period.MONTH) {
                startDate = getFirstDateOfMonth(for: today)
                finishDate = getLastDateOfMonth(for: today)
            }

            updateDataFromPeriod()
        }
    }
    
    // startDate, finishDate 변경될 때 실행됨.
    func updateDataFromPeriod() {
        wiDList = wiDService.readWiDListBetweenDates(startDate: startDate, finishDate: finishDate)
        
        filteredWiDListByTitle = wiDList.filter { wiD in
            return wiD.title == selectedTitle.rawValue
        }

        totalDurationDictionary = getTotalDurationDictionaryByTitle(wiDList: wiDList)
        averageDurationDictionary = getAverageDurationDictionaryByTitle(wiDList: wiDList)
        maxDurationDictionary = getMaxDurationDictionaryByTitle(wiDList: wiDList)
        minDurationDictionary = getMinDurationDictionaryByTitle(wiDList: wiDList)
        
        // startDate, finishDate를 변경하면 합계 딕셔너리로 초기화함.
        seletedDictionary = totalDurationDictionary
        seletedDictionaryText = "합계"
    }
}

struct PeriodBasedView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PeriodBasedView()
            
            PeriodBasedView()
                .environment(\.colorScheme, .dark)
        }
    }
}
