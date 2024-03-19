//
//  MonthWiDView.swift
//  WiD
//
//  Created by jjkim on 2024/02/07.
//

import SwiftUI

struct MonthWiDView: View {
    // 뷰 모델
    @EnvironmentObject var monthWiDViewModel: MonthWiDViewModel
    
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
                        getPeriodStringViewOfMonth(date: monthWiDViewModel.startDate)
                            .titleLarge()
                            .lineLimit(1)
                            .truncationMode(.head)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        let newStartDate = getFirstDateOfMonth(for: calendar.date(byAdding: .day, value: -15, to: monthWiDViewModel.startDate) ?? Date())
                        let newFinishDate = getLastDateOfMonth(for: calendar.date(byAdding: .day, value: -45, to: monthWiDViewModel.finishDate) ?? Date())
                        
                        monthWiDViewModel.setDates(startDate: newStartDate, finishDate: newFinishDate)
//                        updateDataFromPeriod()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 24))
                            .frame(width: 24, height: 24)
                    }

                    Button(action: {
                        let newStartDate = getFirstDateOfMonth(for: calendar.date(byAdding: .day, value: 45, to: monthWiDViewModel.startDate) ?? Date())
                        let newFinishDate = getLastDateOfMonth(for: calendar.date(byAdding: .day, value: 15, to: monthWiDViewModel.finishDate) ?? Date())
                        
                        monthWiDViewModel.setDates(startDate: newStartDate, finishDate: newFinishDate)
//                        updateDataFromPeriod()
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 24))
                            .frame(width: 24, height: 24)
                    }
                    .disabled(calendar.isDate(monthWiDViewModel.startDate, inSameDayAs: getFirstDateOfMonth(for: today)) &&
                              calendar.isDate(monthWiDViewModel.finishDate, inSameDayAs: getLastDateOfMonth(for: today)))
                }
                .frame(maxHeight: 44)
                .padding(.horizontal)
                
                VStack(spacing: 0) {
                    if monthWiDViewModel.wiDList.isEmpty {
                        Text("표시할 기록이 없습니다.")
                            .bodyLarge()
                    } else {
                        ScrollView {
                            VStack(spacing: 8) {
                                HStack {
                                    ForEach(0...6, id: \.self) { index in
                                        let textColor = index == 0 ? Color("OrangeRed") : (index == 6 ? Color("DeepSkyBlue") : Color("Black-White"))
                                        
                                        Text(getStringOfDayOfWeekFromSunday(index))
                                            .bodySmall()
                                            .frame(maxWidth: .infinity)
                                            .foregroundColor(textColor)
                                    }
                                }
                                .padding(.horizontal)
                                
                                // Weekday 1 - 일, 2 - 월...
                                let weekday = calendar.component(.weekday, from: monthWiDViewModel.startDate)
                                let daysDifference = calendar.dateComponents([.day], from: monthWiDViewModel.startDate, to: monthWiDViewModel.finishDate).day ?? 0
                                
                                LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
                                    ForEach(0..<(daysDifference + 1) + (weekday - 1), id: \.self) { gridIndex in
                                        if gridIndex < weekday - 1 {
                                            Text("")
                                        } else {
                                            let currentDate = calendar.date(byAdding: .day, value: gridIndex - (weekday - 1), to: monthWiDViewModel.startDate) ?? Date()

                                            let filteredWiDList = monthWiDViewModel.wiDList.filter { wiD in
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
                                }
                                .padding(.horizontal)
                                
                                Picker("", selection: $monthWiDViewModel.seletedDictionaryType) {
                                    ForEach(DurationDictionary.allCases) { dictionary in
                                        Text(dictionary.koreanValue)
                                            .bodyMedium()
                                    }
                                }
                                .pickerStyle(.segmented)
                                .padding(.horizontal)
                                .onChange(of: monthWiDViewModel.seletedDictionaryType) { newDictionaryType in
                                    monthWiDViewModel.setDictionaryType(newDictionaryType: newDictionaryType)
                                }
                                
                                ForEach(Array(monthWiDViewModel.seletedDictionary), id: \.key) { title, duration in
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
                                    let firstDayOfMonth = calendar.date(byAdding: .month, value: index, to: getFirstDateOfMonth(for: today))!
                                    let lastDayOfMonth = calendar.date(byAdding: .month, value: index, to: getLastDateOfMonth(for: today))!
                                     
                                    monthWiDViewModel.setDates(startDate: firstDayOfMonth, finishDate: lastDayOfMonth)
                                     
                                    expandDatePicker = false
                                }) {
                                    HStack(spacing: 0) {
                                        let firstDayOfMonth = calendar.date(byAdding: .month, value: index, to: getFirstDateOfMonth(for: today))!
                                        let lastDayOfMonth = calendar.date(byAdding: .month, value: index, to: getLastDateOfMonth(for: today))!
                                        
                                        getPeriodStringViewOfMonth(date: firstDayOfMonth)
                                            .bodyMedium()
                                        
                                        Spacer()
                                        
                                        if firstDayOfMonth == monthWiDViewModel.startDate && lastDayOfMonth == monthWiDViewModel.finishDate {
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
            print("MonthWiDView appeared")
//            print("onAppear - startDate : \(formatDate(startDate, format: "yyyy-MM-dd a HH:mm:ss"))")
//            print("onAppear - finishDate : \(formatDate(finishDate, format: "yyyy-MM-dd a HH:mm:ss"))")
            
            monthWiDViewModel.setDates(startDate: monthWiDViewModel.startDate, finishDate: monthWiDViewModel.finishDate)
        }
        .onDisappear {
            print("MonthWiDView disappeared")
        }
    }
}

struct MonthWiDView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MonthWiDView()
                .environment(\.colorScheme, .light)
                .environmentObject(MonthWiDViewModel())
            
            MonthWiDView()
                .environment(\.colorScheme, .dark)
                .environmentObject(MonthWiDViewModel())
        }
    }
}
