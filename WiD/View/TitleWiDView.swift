//
//  TitleWiDView.swift
//  WiD
//
//  Created by jjkim on 2024/02/06.
//

import SwiftUI

struct TitleWiDView: View {
    // 뷰 모델
    @EnvironmentObject var titleWiDViewModel: TitleWiDViewModel
    
    // 화면
    private let screenHeight = UIScreen.main.bounds.height
    
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
                        if titleWiDViewModel.selectedPeriod == Period.WEEK {
                            getPeriodStringViewOfWeek(firstDayOfWeek: titleWiDViewModel.startDate, lastDayOfWeek: titleWiDViewModel.finishDate)
                                .titleLarge()
                                .lineLimit(1)
                                .truncationMode(.head)
                        } else if titleWiDViewModel.selectedPeriod == Period.MONTH {
                            getPeriodStringViewOfMonth(date: titleWiDViewModel.startDate)
                                .titleLarge()
                                .lineLimit(1)
                                .truncationMode(.head)
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        if titleWiDViewModel.selectedPeriod == Period.WEEK {
                            let newStartDate = calendar.date(byAdding: .day, value: -7, to: titleWiDViewModel.startDate) ?? Date()
                            let newFinishDate = calendar.date(byAdding: .day, value: -7, to: titleWiDViewModel.finishDate) ?? Date()
                            
                            titleWiDViewModel.setDates(startDate: newStartDate, finishDate: newFinishDate)
                        } else {
                            let newStartDate = getFirstDateOfMonth(for: calendar.date(byAdding: .day, value: -15, to: titleWiDViewModel.startDate) ?? Date())
                            let newFinishDate = getLastDateOfMonth(for: calendar.date(byAdding: .day, value: -45, to: titleWiDViewModel.finishDate) ?? Date())
                            
                            titleWiDViewModel.setDates(startDate: newStartDate, finishDate: newFinishDate)
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 24))
                            .frame(width: 24, height: 24)
                    }

                    Button(action: {
                        if titleWiDViewModel.selectedPeriod == Period.WEEK {
                            let newStartDate = calendar.date(byAdding: .day, value: 7, to: titleWiDViewModel.startDate) ?? Date()
                            let newFinishDate = calendar.date(byAdding: .day, value: 7, to: titleWiDViewModel.finishDate) ?? Date()
                            
                            titleWiDViewModel.setDates(startDate: newStartDate, finishDate: newFinishDate)
                        } else {
                            let newStartDate = getFirstDateOfMonth(for: calendar.date(byAdding: .day, value: 45, to: titleWiDViewModel.startDate) ?? Date())
                            let newFinishDate = getLastDateOfMonth(for: calendar.date(byAdding: .day, value: 15, to: titleWiDViewModel.finishDate) ?? Date())
                            
                            titleWiDViewModel.setDates(startDate: newStartDate, finishDate: newFinishDate)
                        }
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 24))
                            .frame(width: 24, height: 24)
                    }
                    .disabled(titleWiDViewModel.selectedPeriod == Period.WEEK &&
                              calendar.isDate(titleWiDViewModel.startDate, inSameDayAs: getFirstDateOfWeek(for: today)) &&
                              calendar.isDate(titleWiDViewModel.finishDate, inSameDayAs: getLastDateOfWeek(for: today)) ||

                              titleWiDViewModel.selectedPeriod == Period.MONTH &&
                              calendar.isDate(titleWiDViewModel.startDate, inSameDayAs: getFirstDateOfMonth(for: today)) &&
                              calendar.isDate(titleWiDViewModel.finishDate, inSameDayAs: getLastDateOfMonth(for: today)))
                }
                .frame(maxHeight: 44)
                .padding(.horizontal)
                
                if titleWiDViewModel.filteredWiDListByTitle.isEmpty {
                    VStack {
                        Text("표시할 기록이 없습니다.")
                            .bodyLarge()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        VStack(spacing: 8) {
                            LineGraphView(
                                title: titleWiDViewModel.selectedTitle.rawValue,
                                wiDList: titleWiDViewModel.filteredWiDListByTitle,
                                startDate: titleWiDViewModel.startDate,
                                finishDate: titleWiDViewModel.finishDate
                            )
                            .aspectRatio(1.0 / 1.0, contentMode: .fit) // 가로 1, 세로 1 비율
                            .padding(.horizontal)
                            
                            ZStack {
                                VStack(spacing :16) {
                                    HStack(spacing : 0) {
                                        VStack(spacing :0) {
                                            Text("합계")
                                                .bodyMedium()
                                            
                                            Text(getDurationString(titleWiDViewModel.totalDurationDictionary[titleWiDViewModel.selectedTitle.rawValue] ?? 0, mode: 3))
                                                .titleLarge()
                                                .lineLimit(1)
                                        }
                                        .frame(maxWidth: .infinity)
                                        
                                        Rectangle()
                                            .frame(maxWidth: 0.5, maxHeight: 48)
                                            .padding(.bottom, 20)
                                            .foregroundColor(Color("Black-White"))
                                        
                                        VStack(spacing :0) {
                                            Text("평균")
                                                .bodyMedium()
                                        
                                            Text(getDurationString(titleWiDViewModel.averageDurationDictionary[titleWiDViewModel.selectedTitle.rawValue] ?? 0, mode: 3))
                                                .titleLarge()
                                                .lineLimit(1)
                                        }
                                        .frame(maxWidth: .infinity)
                                    }
                                    
                                    HStack(spacing: 80) {
                                        Rectangle()
                                            .frame(maxHeight: 0.5)
                                            .foregroundColor(Color("Black-White"))
                                        
                                        Rectangle()
                                            .frame(maxHeight: 0.5)
                                            .foregroundColor(Color("Black-White"))
                                    }
                                    
                                    HStack(spacing :0) {
                                        VStack(spacing :0) {
                                            Text("최저")
                                                .bodyMedium()
                                        
                                            Text(getDurationString(titleWiDViewModel.minDurationDictionary[titleWiDViewModel.selectedTitle.rawValue] ?? 0, mode: 3))
                                                .titleLarge()
                                                .lineLimit(1)
                                        }
                                        .frame(maxWidth: .infinity)
                                         
                                        Rectangle()
                                            .frame(maxWidth: 0.5, maxHeight: 48)
                                            .padding(.top, 20)
                                            .foregroundColor(Color("Black-White"))
                                        
                                        VStack(spacing :0) {
                                            Text("최고")
                                                .bodyMedium()
                                        
                                            Text(getDurationString(titleWiDViewModel.maxDurationDictionary[titleWiDViewModel.selectedTitle.rawValue] ?? 0, mode: 3))
                                                .titleLarge()
                                                .lineLimit(1)
                                        }
                                        .frame(maxWidth: .infinity)
                                    }
                                }
                                
                                Text(titleWiDViewModel.selectedTitle.koreanValue)
                                    .bodyLarge()
                                    .padding(16)
                                    .background(Color(titleWiDViewModel.selectedTitle.rawValue))
                                    .clipShape(Circle())
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color("Black-White"), lineWidth: 0.5)
                            )
                            .padding()
                        }
                    }
                }
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
                                if titleWiDViewModel.selectedPeriod == .WEEK {
                                    Button(action: {
                                        let firstDayOfWeek = calendar.date(byAdding: .weekOfYear, value: index, to: getFirstDateOfWeek(for: today))!
                                        let lastDayOfWeek = calendar.date(byAdding: .weekOfYear, value: index, to: getLastDateOfWeek(for: today))!
                                        
                                        titleWiDViewModel.setDates(startDate: firstDayOfWeek, finishDate: lastDayOfWeek)
                                        
                                        expandDatePicker = false
                                    }) {
                                        HStack(spacing: 0) {
                                            let firstDayOfWeek = calendar.date(byAdding: .weekOfYear, value: index, to: getFirstDateOfWeek(for: today))!
                                            let lastDayOfWeek = calendar.date(byAdding: .weekOfYear, value: index, to: getLastDateOfWeek(for: today))!
                                            
                                            getPeriodStringViewOfWeek(firstDayOfWeek: firstDayOfWeek, lastDayOfWeek: lastDayOfWeek)
                                                .bodyMedium()
                                            
                                            Spacer()
                                            
                                            if firstDayOfWeek == titleWiDViewModel.startDate && lastDayOfWeek == titleWiDViewModel.finishDate {
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
                                } else if titleWiDViewModel.selectedPeriod == .MONTH {
                                    Button(action: {
                                        let firstDayOfMonth = calendar.date(byAdding: .month, value: index, to: getFirstDateOfMonth(for: today))!
                                        let lastDayOfMonth = calendar.date(byAdding: .month, value: index, to: getLastDateOfMonth(for: today))!
                                         
                                        titleWiDViewModel.setDates(startDate: firstDayOfMonth, finishDate: lastDayOfMonth)
                                         
                                        expandDatePicker = false
                                    }) {
                                        HStack(spacing: 0) {
                                            let firstDayOfMonth = calendar.date(byAdding: .month, value: index, to: getFirstDateOfMonth(for: today))!
                                            let lastDayOfMonth = calendar.date(byAdding: .month, value: index, to: getLastDateOfMonth(for: today))!
                                            
                                            getPeriodStringViewOfMonth(date: firstDayOfMonth)
                                                .bodyMedium()
                                            
                                            Spacer()
                                            
                                            if firstDayOfMonth == titleWiDViewModel.startDate && lastDayOfMonth == titleWiDViewModel.finishDate {
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
        .navigationBarHidden(true)
        .tint(Color("Black-White"))
        .background(Color("White-Black"))
        .onAppear {
            print("TitleWiDView appeared")
            
            titleWiDViewModel.setDates(startDate: titleWiDViewModel.startDate, finishDate: titleWiDViewModel.finishDate)
        }
        .onDisappear {
            print("TitleWiDView disappeared")
        }
    }
}

struct TitleWiDView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TitleWiDView()
                .environment(\.colorScheme, .light)
                .environmentObject(TitleWiDViewModel()) // 이 뷰에 선언된 환경변수를 꼭 넣어줘야함.
            
            TitleWiDView()
                .environment(\.colorScheme, .dark)
                .environmentObject(TitleWiDViewModel())
        }
    }
}
