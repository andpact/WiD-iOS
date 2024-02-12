//
//  PeriodBasedView.swift
//  WiD
//
//  Created by jjkim on 2023/12/01.
//

import SwiftUI

struct WeekWiDView: View {
    // 화면
//    private let screenHeight = UIScreen.main.bounds.height
    
    // WiD
    private let wiDService = WiDService()
    @State private var wiDList: [WiD] = []
//    @State private var filteredWiDListByTitle: [WiD] = []
    
    // 제목
//    @State private var selectedTitle: TitleWithALL = .ALL
//    @State private var expandTitleMenu: Bool = false
    
    // 날짜
    private let calendar = Calendar.current
    private let today: Date = Calendar.current.startOfDay(for: Date()) // 시간을 오전 12:00:00으로 설정함.
    @State private var startDate: Date = Date()
    @State private var finishDate: Date = Date()
//    @State private var expandDatePicker: Bool = false
    
    // 기간
//    @State private var selectedPeriod: Period = Period.WEEK
    
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
    @State private var seletedDictionaryType: DurationDictionary = .TOTAL
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack(spacing: 32) {
                    Button(action: {
//                        expandDatePicker = true
                    }) {
                        getPeriodStringViewOfWeek(firstDayOfWeek: startDate, lastDayOfWeek: finishDate)
                            .titleLarge()
                            .lineLimit(1)
                            .truncationMode(.head)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Button(action: {
                        startDate = calendar.date(byAdding: .day, value: -7, to: startDate) ?? Date()
                        finishDate = calendar.date(byAdding: .day, value: -7, to: finishDate) ?? Date()

                        updateDataFromPeriod()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 24))
                    }

                    Button(action: {
                        startDate = calendar.date(byAdding: .day, value: 7, to: startDate) ?? Date()
                        finishDate = calendar.date(byAdding: .day, value: 7, to: finishDate) ?? Date()
                        
                        updateDataFromPeriod()
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 24))
                    }
                    .disabled(calendar.isDate(startDate, inSameDayAs: getFirstDateOfWeek(for: today)) &&
                              calendar.isDate(finishDate, inSameDayAs: getLastDateOfWeek(for: today)))
                }
                .tint(Color("Black-White"))
                .padding()
                
                VStack(spacing: 0) {
                    if wiDList.isEmpty {
//                        getEmptyView(message: "표시할 데이터가 없습니다.")
                        
                        Text("표시할\n기록이\n없습니다.")
                            .bodyLarge()
                            .lineSpacing(10)
                            .multilineTextAlignment(.center)
                    } else {
                        ScrollView {
                            VStack(spacing: 0) {
                                HStack {
                                    ForEach(0...6, id: \.self) { index in
                                        let textColor = index == 5 ? Color("DeepSkyBlue") : (index == 6 ? Color("OrangeRed") : Color("Black-White"))
                                        
                                        Text(getStringOfDayOfWeekFromMonday(index))
                                            .bodySmall()
                                            .frame(maxWidth: .infinity)
                                            .foregroundColor(textColor)
                                    }
                                }
                                .padding()
                                
                                let daysDifference = calendar.dateComponents([.day], from: startDate, to: finishDate).day ?? 0
                                
                                LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
                                    ForEach(0..<daysDifference + 1, id: \.self) { gridIndex in
                                        let currentDate = calendar.date(byAdding: .day, value: gridIndex, to: startDate) ?? Date()
                                        
                                        let filteredWiDList = wiDList.filter { wiD in
                                            return calendar.isDate(wiD.date, inSameDayAs: currentDate)
                                        }
                                        
                                        PeriodPieChartView(date: currentDate, wiDList: filteredWiDList)
                                    }
                                }
                                .padding()
                                
                                Picker("", selection: $seletedDictionaryType) {
                                    ForEach(DurationDictionary.allCases) { dictionary in
                                        Text(dictionary.koreanValue)
                                            .bodyMedium()
                                    }
                                }
                                .pickerStyle(.segmented)
                                .padding()
                                
                                ForEach(Array(seletedDictionary), id: \.key) { title, duration in
                                    HStack {
                                        Image(systemName: titleImageDictionary[title] ?? "") // (?? "") 반드시 붙혀야 함.
                                            .font(.system(size: 24))
                                            .frame(maxWidth: 15, maxHeight: 15)
                                            .padding()
                                            .background(Color("White-Black"))
                                            .clipShape(Circle())
                                        
                                        Text(titleDictionary[title] ?? "")
                                            .titleLarge()
                                        
                                        Spacer()
                                        
                                        Text(getDurationString(duration, mode: 3))
                                            .titleLarge()
                                            .lineLimit(1)
                                            .truncationMode(.tail)
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color(title))
                                    .cornerRadius(8)
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                
                
                /**
                 컨텐츠
                 */
//                ScrollView {
//                    VStack(spacing: 0) {
                        // 타임라인
//                        if wiDList.isEmpty {
//                            getEmptyView(message: "표시할 타임라인이 없습니다.")
//                        } else {
//                            HStack {
//                                ForEach(0...6, id: \.self) { index in
//                                    let textColor = index == 5 ? Color("DeepSkyBlue") : (index == 6 ? Color("OrangeRed") : Color("Black-White"))
//
//                                    Text(getStringOfDayOfWeekFromMonday(index))
//                                        .bodySmall()
//                                        .frame(maxWidth: .infinity)
//                                        .foregroundColor(textColor)
//                                }
//                            }
//
//                            // Weekday 1 - 일, 2 - 월...
////                                        let weekday = calendar.component(.weekday, from: startDate)
//                            let daysDifference = calendar.dateComponents([.day], from: startDate, to: finishDate).day ?? 0
//
//                            LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
//                                ForEach(0..<daysDifference + 1, id: \.self) { gridIndex in
//                                    let currentDate = calendar.date(byAdding: .day, value: gridIndex, to: startDate) ?? Date()
//
//                                    let filteredWiDList = wiDList.filter { wiD in
//                                        return calendar.isDate(wiD.date, inSameDayAs: currentDate)
//                                    }
//
//                                    PeriodPieChartView(date: currentDate, wiDList: filteredWiDList)
//                                }
//                            }
//                        }
                        
                        // 합계, 평균, 최고 기록
//                        HStack {
//                            Text("\(seletedDictionaryText) 기록")
//                                .titleMedium()
//
//                            Spacer()
//
//                            HStack {
//                                Button(action: {
//                                    seletedDictionary = totalDurationDictionary
//                                    seletedDictionaryText = "합계"
//                                }) {
//                                    Text("합계")
//                                        .bodyMedium()
//                                        .foregroundColor(seletedDictionaryText == "합계" ? Color("Black-White") : Color("DarkGray"))
//                                }
//
//                                Button(action: {
//                                    seletedDictionary = averageDurationDictionary
//                                    seletedDictionaryText = "평균"
//                                }) {
//                                    Text("평균")
//                                        .bodyMedium()
//                                        .foregroundColor(seletedDictionaryText == "평균" ? Color("Black-White") : Color("DarkGray"))
//                                }
//
//                                Button(action: {
//                                    seletedDictionary = minDurationDictionary
//                                    seletedDictionaryText = "최저"
//                                }) {
//                                    Text("최저")
//                                        .bodyMedium()
//                                        .foregroundColor(seletedDictionaryText == "최저" ? Color("Black-White") : Color("DarkGray"))
//                                }
//
//                                Button(action: {
//                                    seletedDictionary = maxDurationDictionary
//                                    seletedDictionaryText = "최고"
//                                }) {
//                                    Text("최고")
//                                        .bodyMedium()
//                                        .foregroundColor(seletedDictionaryText == "최고" ? Color("Black-White") : Color("DarkGray"))
//                                }
//                            }
//                        }
//                        .padding(.horizontal)
                        
//                        if wiDList.isEmpty {
//                            getEmptyView(message: "표시할 \(seletedDictionaryText) 기록이 없습니다.")
//                        } else {
//                            ForEach(Array(seletedDictionary), id: \.key) { title, duration in
//                                HStack {
//                                    Image(systemName: titleImageDictionary[title] ?? "") // (?? "") 반드시 붙혀야 함.
//                                        .font(.system(size: 24))
//                                        .frame(maxWidth: 15, maxHeight: 15)
//                                        .padding()
//                                        .background(Color("White-Black"))
//                                        .clipShape(Circle())
//
//                                    Text(titleDictionary[title] ?? "")
//                                        .titleLarge()
//
//                                    Spacer()
//
//                                    Text(getDurationString(duration, mode: 3))
//                                        .titleLarge()
//                                        .lineLimit(1)
//                                        .truncationMode(.tail)
//                                }
//                                .padding()
//                                .frame(maxWidth: .infinity)
//                                .background(Color(title))
//                                .cornerRadius(8)
//                                .padding(.horizontal)
//                            }
//                        }

                        // 기록률
//                        VStack(spacing: 8) {
//                            Text("기록률")
//                                .titleMedium()
//                                .padding(.horizontal)
//                                .frame(maxWidth: .infinity, alignment: .leading)
//
//                            if wiDList.isEmpty {
//                                getEmptyView(message: "표시할 기록률이 없습니다.")
//                            } else {
//                                VerticalBarChartView(wiDList: wiDList, startDate: startDate, finishDate: finishDate)
//                                    .aspectRatio(1.5 / 1.0, contentMode: .fit) // 가로 1.5, 세로 1 비율
//                                    .padding()
//                                    .background(Color("White-Black"))
//                                    .cornerRadius(8)
//                                    .shadow(color: Color("Black-White"), radius: 1)
//                                    .padding(.horizontal)
//                            }
//                        }
//                        .padding(.vertical)
//                    }
//                }
            }
            
            /**
             대화 상자
             */
//            if expandDatePicker {
//                ZStack {
//                    Color("Black-White")
//                        .opacity(0.3)
//                        .onTapGesture {
//                            expandDatePicker = false
//                        }
//                    
//                    // 날짜 선택
//                    if expandDatePicker {
//                        VStack(spacing: 0) {
//                            ZStack {
//                                Text("주 선택")
//                                    .titleMedium()
//                                
//                                Button(action: {
//                                    expandDatePicker = false
//                                }) {
//                                    Text("확인")
//                                        .bodyMedium()
//                                }
//                                .frame(maxWidth: .infinity, alignment: .trailing)
//                                .tint(Color("Black-White"))
//                            }
//                            .padding()
//                            
//                            Divider()
//                                .background(Color("Black-White"))
//
//                            VStack(spacing: 0) {
//                                ForEach(Period.allCases) { menuPeriod in
//                                    Button(action: {
//                                        // 주 선택하는 기능
//                                        
////                                        selectedPeriod = menuPeriod
//                                        withAnimation {
//                                            expandDatePicker.toggle()
//                                        }
//                                    }) {
////                                            Image(systemName: titleImageDictionary[menuTitle.rawValue] ?? "")
////                                                .font(.system(size: 25))
////                                                .frame(maxWidth: 40, maxHeight: 40)
////
////                                            Spacer()
////                                                .frame(maxWidth: 20)
//                                        
//                                        Text(menuPeriod.koreanValue)
//                                            .labelMedium()
//                                        
//                                        Spacer()
//                                        
////                                        if selectedPeriod == menuPeriod {
////                                            Text("선택됨")
////                                                .bodyMedium()
////                                        }
//                                    }
//                                    .padding()
//                                }
//                            }
//                        }
//                        .background(Color("White-Black"))
//                        .cornerRadius(8)
//                        .padding() // 바깥 패딩
//                        .shadow(color: Color("Black-White"), radius: 1)
//                    }
//                }
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .edgesIgnoringSafeArea(.all)
//            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .tint(Color("Black-White"))
        .background(Color("White-Gray"))
        .navigationBarHidden(true)
        .onAppear {
            self.startDate = getFirstDateOfWeek(for: today)
            self.finishDate = getLastDateOfWeek(for: today)
            
//            print("onAppear - startDate : \(formatDate(startDate, format: "yyyy-MM-dd a HH:mm:ss"))")
//            print("onAppear - finishDate : \(formatDate(finishDate, format: "yyyy-MM-dd a HH:mm:ss"))")
            
            updateDataFromPeriod()
        }
        .onChange(of: seletedDictionaryType) { newDictionaryType in
            // 선택된 딕셔너리 유형에 따라 적절한 딕셔너리 업데이트
            switch newDictionaryType {
            case .TOTAL:
                seletedDictionary = totalDurationDictionary
            case .AVERAGE:
                seletedDictionary = averageDurationDictionary
            case .MIN:
                seletedDictionary = minDurationDictionary
            case .MAX:
                seletedDictionary = maxDurationDictionary
            }
        }
    }
    
    // startDate, finishDate 변경될 때 실행됨.
    func updateDataFromPeriod() {
        wiDList = wiDService.readWiDListBetweenDates(startDate: startDate, finishDate: finishDate)

        totalDurationDictionary = getTotalDurationDictionaryByTitle(wiDList: wiDList)
        averageDurationDictionary = getAverageDurationDictionaryByTitle(wiDList: wiDList)
        maxDurationDictionary = getMaxDurationDictionaryByTitle(wiDList: wiDList)
        minDurationDictionary = getMinDurationDictionaryByTitle(wiDList: wiDList)
        
        // startDate, finishDate를 변경하면 합계 딕셔너리로 초기화함.
        seletedDictionary = totalDurationDictionary
    }
}

struct PeriodBasedView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WeekWiDView()
            
            WeekWiDView()
                .environment(\.colorScheme, .dark)
        }
    }
}
