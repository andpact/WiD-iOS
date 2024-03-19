//
//  PeriodBasedView.swift
//  WiD
//
//  Created by jjkim on 2023/12/01.
//

import SwiftUI

struct WeekWiDView: View {
    // 뷰 모델
    @EnvironmentObject var weekWiDViewModel: WeekWiDViewModel
    
    // 날짜
    private let calendar = Calendar.current
    private let today: Date = Calendar.current.startOfDay(for: Date()) // 시간을 오전 12:00:00으로 설정함.
    @State private var expandDatePicker: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack(spacing: 24) {
                    Button(action: {
                        expandDatePicker = true
                    }) {
                        getPeriodStringViewOfWeek(firstDayOfWeek: weekWiDViewModel.startDate, lastDayOfWeek: weekWiDViewModel.finishDate)
                            .titleLarge()
                            .lineLimit(1)
                            .truncationMode(.head)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        let newStartDate = calendar.date(byAdding: .day, value: -7, to: weekWiDViewModel.startDate) ?? Date()
                        let newFinishDate = calendar.date(byAdding: .day, value: -7, to: weekWiDViewModel.finishDate) ?? Date()

                        weekWiDViewModel.setDates(startDate: newStartDate, finishDate: newFinishDate)
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 24))
                            .frame(width: 24, height: 24)
                    }

                    Button(action: {
                        let newStartDate = calendar.date(byAdding: .day, value: 7, to: weekWiDViewModel.startDate) ?? Date()
                        let newFinishDate = calendar.date(byAdding: .day, value: 7, to: weekWiDViewModel.finishDate) ?? Date()
                        
                        weekWiDViewModel.setDates(startDate: newStartDate, finishDate: newFinishDate)
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 24))
                            .frame(width: 24, height: 24)
                    }
                    .disabled(calendar.isDate(weekWiDViewModel.startDate, inSameDayAs: getFirstDateOfWeek(for: today)) &&
                              calendar.isDate(weekWiDViewModel.finishDate, inSameDayAs: getLastDateOfWeek(for: today)))
                }
                .frame(maxHeight: 44)
                .padding(.horizontal)
                
                VStack(spacing: 0) {
                    if weekWiDViewModel.wiDList.isEmpty {
                        Text("표시할 기록이 없습니다.")
                            .bodyLarge()
                    } else {
                        ScrollView {
                            VStack(spacing: 8) {
                                HStack {
                                    ForEach(0...6, id: \.self) { index in
                                        let textColor = index == 5 ? Color("DeepSkyBlue") : (index == 6 ? Color("OrangeRed") : Color("Black-White"))
                                        
                                        Text(getStringOfDayOfWeekFromMonday(index))
                                            .bodySmall()
                                            .frame(maxWidth: .infinity)
                                            .foregroundColor(textColor)
                                    }
                                }
                                .padding(.horizontal)
                                
                                let daysDifference = calendar.dateComponents([.day], from: weekWiDViewModel.startDate, to: weekWiDViewModel.finishDate).day ?? 0
                                
                                LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
                                    ForEach(0..<daysDifference + 1, id: \.self) { gridIndex in
                                        let currentDate = calendar.date(byAdding: .day, value: gridIndex, to: weekWiDViewModel.startDate) ?? Date()
                                        
                                        let filteredWiDList = weekWiDViewModel.wiDList.filter { wiD in
                                            return calendar.isDate(wiD.date, inSameDayAs: currentDate)
                                        }
                                        
                                        var totalDurationPercentage: Int {
                                            let totalMinutesInDay = 60 * 24
                                            var totalDurationMinutes: Int = 0

                                            for wid in filteredWiDList {
                                                totalDurationMinutes += Int(wid.duration / 60) // Convert duration to minutes
                                            }

                                            return Int(Double(totalDurationMinutes) / Double(totalMinutesInDay) * 100)
                                        }
                                        
                                        VStack(spacing: 0) {
                                            PeriodPieChartView(date: currentDate, wiDList: filteredWiDList)
                                            
                                            Text("\(totalDurationPercentage)%")
                                        }
                                    }
                                }
                                .padding(.horizontal)
                                
                                Picker("", selection: $weekWiDViewModel.seletedDictionaryType) {
                                    ForEach(DurationDictionary.allCases) { dictionary in
                                        Text(dictionary.koreanValue)
                                            .bodyMedium()
                                    }
                                }
                                .pickerStyle(.segmented)
                                .padding(.horizontal)
                                .onChange(of: weekWiDViewModel.seletedDictionaryType) { newDictionaryType in
                                    weekWiDViewModel.setDictionaryType(newDictionaryType: newDictionaryType)
                                }
                                
                                ForEach(Array(weekWiDViewModel.seletedDictionary), id: \.key) { title, duration in
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
            }
            
            /**
             대화 상자
             */
            if expandDatePicker {
                ZStack {
                    Color("Transparent")
                        .contentShape(Rectangle())
                        .onTapGesture {
                            expandDatePicker = false
                        }
                    
                    // 날짜 선택
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(-4..<1, id: \.self) { index in
                                Button(action: {
                                    let firstDayOfWeek = calendar.date(byAdding: .weekOfYear, value: index, to: getFirstDateOfWeek(for: today))!
                                    let lastDayOfWeek = calendar.date(byAdding: .weekOfYear, value: index, to: getLastDateOfWeek(for: today))!
                                    
                                    weekWiDViewModel.setDates(startDate: firstDayOfWeek, finishDate: lastDayOfWeek)
                                    
                                    expandDatePicker = false
                                }) {
                                    HStack(spacing: 0) {
                                        let firstDayOfWeek = calendar.date(byAdding: .weekOfYear, value: index, to: getFirstDateOfWeek(for: today))!
                                        let lastDayOfWeek = calendar.date(byAdding: .weekOfYear, value: index, to: getLastDateOfWeek(for: today))!
                                        
                                        getPeriodStringViewOfWeek(firstDayOfWeek: firstDayOfWeek, lastDayOfWeek: lastDayOfWeek)
                                            .bodyMedium()
                                        
                                        Spacer()
                                        
                                        if firstDayOfWeek == weekWiDViewModel.startDate && lastDayOfWeek == weekWiDViewModel.finishDate {
                                             Image(systemName: "checkmark.circle.fill")
                                                    .font(.system(size: 20))
                                                    .frame(width: 20, height: 20)
                                        } else {
                                            Image(systemName: "circle")
                                                   .font(.system(size: 20))
                                                   .frame(width: 20, height: 20)
                                        }
                                    }
                                }
                                .padding()
                            }
                        }
                        .padding()
                    }
                    .frame(maxHeight: 300)
                    .background(Color("LightGray-Gray"))
                    .cornerRadius(8)
                    .padding() // 바깥 패딩
                    .shadow(color: Color("Black-White"), radius: 1)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .tint(Color("Black-White"))
        .background(Color("White-Black"))
        .navigationBarHidden(true)
        .onAppear {
            print("WeekWiDView appeared")
//            self.startDate = getFirstDateOfWeek(for: today)
//            self.finishDate = getLastDateOfWeek(for: today)
//
////            print("onAppear - startDate : \(formatDate(startDate, format: "yyyy-MM-dd a HH:mm:ss"))")
////            print("onAppear - finishDate : \(formatDate(finishDate, format: "yyyy-MM-dd a HH:mm:ss"))")
//
//            updateDataFromPeriod()
            
            weekWiDViewModel.setDates(startDate: weekWiDViewModel.startDate, finishDate: weekWiDViewModel.finishDate)
        }
        .onDisappear {
            print("WeekWiDView disappeared")
        }
//        .onChange(of: seletedDictionaryType) { newDictionaryType in
//            // 선택된 딕셔너리 유형에 따라 적절한 딕셔너리 업데이트
//            switch newDictionaryType {
//            case .TOTAL:
//                seletedDictionary = totalDurationDictionary
//            case .AVERAGE:
//                seletedDictionary = averageDurationDictionary
//            case .MIN:
//                seletedDictionary = minDurationDictionary
//            case .MAX:
//                seletedDictionary = maxDurationDictionary
//            }
//        }
    }
    
    // startDate, finishDate 변경될 때 실행됨.
//    func updateDataFromPeriod() {
//        wiDList = wiDService.readWiDListBetweenDates(startDate: startDate, finishDate: finishDate)
//
//        totalDurationDictionary = getTotalDurationDictionaryByTitle(wiDList: wiDList)
//        averageDurationDictionary = getAverageDurationDictionaryByTitle(wiDList: wiDList)
//        maxDurationDictionary = getMaxDurationDictionaryByTitle(wiDList: wiDList)
//        minDurationDictionary = getMinDurationDictionaryByTitle(wiDList: wiDList)
//
//        // startDate, finishDate를 변경하면 합계 딕셔너리로 초기화함.
//        seletedDictionary = totalDurationDictionary
//    }
}

struct PeriodBasedView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WeekWiDView()
                .environment(\.colorScheme, .light)
                .environmentObject(WeekWiDViewModel())
            
            WeekWiDView()
                .environment(\.colorScheme, .dark)
                .environmentObject(WeekWiDViewModel())
        }
    }
}
