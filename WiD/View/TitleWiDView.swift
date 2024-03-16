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
    
    // WiD
//    private let wiDService = WiDService()
//    @State private var wiDList: [WiD] = []
//    @State private var filteredWiDListByTitle: [WiD] = []
    
    // 제목
//    @State private var selectedTitle: Title = .STUDY
//    @State private var expandTitleMenu: Bool = false
    
    // 기간
//    @State private var selectedPeriod: Period = Period.WEEK
    
    // 날짜
    private let calendar = Calendar.current
    private let today: Date = Calendar.current.startOfDay(for: Date()) // 시간을 오전 12:00:00으로 설정함.
//    @State private var startDate: Date = Date()
//    @State private var finishDate: Date = Date()
    @State private var expandDatePicker: Bool = false
    
    // 합계
//    @State private var totalDurationDictionary: [String: TimeInterval] = [:]
//
//    // 평균
//    @State private var averageDurationDictionary: [String: TimeInterval] = [:]
//
//    // 최저
//    @State private var minDurationDictionary: [String: TimeInterval] = [:]
//
//    // 최고
//    @State private var maxDurationDictionary: [String: TimeInterval] = [:]
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack(spacing: 16) {
                    Button(action: {
                        expandDatePicker = true
                    }) {
                        if titleWiDViewModel.selectedPeriod == Period.WEEK {
                            getPeriodStringViewOfWeek(firstDayOfWeek: titleWiDViewModel.startDate, lastDayOfWeek: titleWiDViewModel.finishDate)
                                .titleLarge()
                                .lineLimit(1)
                                .truncationMode(.head)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        } else if titleWiDViewModel.selectedPeriod == Period.MONTH {
                            getPeriodStringViewOfMonth(date: titleWiDViewModel.startDate)
                                .titleLarge()
                                .lineLimit(1)
                                .truncationMode(.head)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    
//                    Button(action: {
//                        expandTitleMenu = true
//                    }) {
//                        Image(systemName: titleImageDictionary[titleWiDViewModel.selectedTitle.rawValue] ?? "")
//                            .font(.system(size: 20))
//                            .frame(width: 20, height: 20)
//                    }
//                    .padding(8)
//                    .background(Color("AppIndigo-AppYellow"))
//                    .foregroundColor(Color("White-Black"))
//                    .cornerRadius(8)
                    
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
                        
//                        updateDataFromPeriod()
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
                        
//                        updateDataFromPeriod()
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
                        Text("표시할\n기록이\n없습니다.")
                            .bodyLarge()
                            .lineSpacing(10)
                            .multilineTextAlignment(.center)
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
                            
//                            VStack(spacing: 0) {
//                                HStack {
//                                    Spacer()
//
//                                    Text(selectedTitle.koreanValue)
//                                        .bodyMedium()
//                                        .padding(8)
//                                        .background(Color(selectedTitle.rawValue))
//                                        .cornerRadius(radius: 8, corners: [.topLeft, .topRight])
//
//                                    Spacer()
//                                }
//                                .padding(.horizontal)
//
//                                HStack {
//                                    Text("합계")
//                                        .bodyLarge()
//
//                                    Spacer()
//
//                                    Text(getDurationString(totalDurationDictionary[selectedTitle.rawValue] ?? 0, mode: 3))
//                                        .titleLarge()
//                                }
//                                .padding()
//    //                            .background(Color("White-Black"))
//    //                            .cornerRadius(8)
//    //                            .shadow(color: Color("Black-White"), radius: 1)
//                                .padding(.horizontal)
//
//                                HStack {
//                                    Text("평균")
//                                        .bodyLarge()
//
//                                    Spacer()
//
//                                    Text(getDurationString(averageDurationDictionary[selectedTitle.rawValue] ?? 0, mode: 3))
//                                        .titleLarge()
//                                }
//                                .padding()
//    //                            .background(Color("White-Black"))
//    //                            .cornerRadius(8)
//    //                            .shadow(color: Color("Black-White"), radius: 1)
//                                .padding(.horizontal)
//
//                                HStack {
//                                    Text("최저")
//                                        .bodyLarge()
//
//                                    Spacer()
//
//                                    Text(getDurationString(minDurationDictionary[selectedTitle.rawValue] ?? 0, mode: 3))
//                                        .titleLarge()
//                                }
//                                .padding()
//    //                            .background(Color("White-Black"))
//    //                            .cornerRadius(8)
//    //                            .shadow(color: Color("Black-White"), radius: 1)
//                                .padding(.horizontal)
//
//                                HStack {
//                                    Text("최고")
//                                        .bodyLarge()
//
//                                    Spacer()
//
//                                    Text(getDurationString(maxDurationDictionary[selectedTitle.rawValue] ?? 0, mode: 3))
//                                        .titleLarge()
//                                }
//                                .padding()
//    //                            .background(Color("White-Black"))
//    //                            .cornerRadius(8)
//    //                            .shadow(color: Color("Black-White"), radius: 1)
//                                .padding(.horizontal)
//                            }
                        }
                    }
//                }
//                ScrollView {
//                    VStack(spacing: 16) {
//                        // 그래프
//                        if filteredWiDListByTitle.isEmpty {
////                            getEmptyView(message: "표시할 그래프가 없습니다.")
//
//                        } else {
//
//                        }
//
////                        // 시간 기록
////                        if filteredWiDListByTitle.isEmpty {
//////                            getEmptyView(message: "표시할 기록이 없습니다.")
////
////                            Text("표시할\n기록이\n없습니다.")
////                                .bodyLarge()
////                                .lineSpacing(10)
////                                .multilineTextAlignment(.center)
////                        } else {
////                            HStack {
////                                Text("합계")
////                                    .bodyLarge()
////
////                                Spacer()
////
////                                Text(getDurationString(totalDurationDictionary[selectedTitle.rawValue] ?? 0, mode: 3))
////                                    .titleLarge()
////                            }
////                            .padding()
////                            .background(Color("White-Black"))
////                            .cornerRadius(8)
////                            .shadow(color: Color("Black-White"), radius: 1)
////                            .padding(.horizontal)
////
////                            HStack {
////                                Text("평균")
////                                    .bodyLarge()
////
////                                Spacer()
////
////                                Text(getDurationString(averageDurationDictionary[selectedTitle.rawValue] ?? 0, mode: 3))
////                                    .titleLarge()
////                            }
////                            .padding()
////                            .background(Color("White-Black"))
////                            .cornerRadius(8)
////                            .shadow(color: Color("Black-White"), radius: 1)
////                            .padding(.horizontal)
////
////                            HStack {
////                                Text("최저")
////                                    .bodyLarge()
////
////                                Spacer()
////
////                                Text(getDurationString(minDurationDictionary[selectedTitle.rawValue] ?? 0, mode: 3))
////                                    .titleLarge()
////                            }
////                            .padding()
////                            .background(Color("White-Black"))
////                            .cornerRadius(8)
////                            .shadow(color: Color("Black-White"), radius: 1)
////                            .padding(.horizontal)
////
////                            HStack {
////                                Text("최고")
////                                    .bodyLarge()
////
////                                Spacer()
////
////                                Text(getDurationString(maxDurationDictionary[selectedTitle.rawValue] ?? 0, mode: 3))
////                                    .titleLarge()
////                            }
////                            .padding()
////                            .background(Color("White-Black"))
////                            .cornerRadius(8)
////                            .shadow(color: Color("Black-White"), radius: 1)
////                            .padding(.horizontal)
////                        }
//                    }
                }
            }
            
            if expandDatePicker {
                ZStack {
                    Color("Black-White")
                        .opacity(0.3)
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
                    .background(Color("White-Black"))
                    .cornerRadius(8)
                    .padding() // 바깥 패딩
//                        .shadow(color: Color("Black-White"), radius: 1)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarHidden(true)
        .tint(Color("Black-White"))
        .background(Color("White-Black"))
//        .onAppear {
//            self.startDate = getFirstDateOfWeek(for: today)
//            self.finishDate = getLastDateOfWeek(for: today)
//
//            updateDataFromPeriod()
//        }
//        .onChange(of: selectedTitle) { newTitle in
//            filteredWiDListByTitle = wiDList.filter { wiD in
//                return wiD.title == newTitle.rawValue
//            }
//        }
//        .onChange(of: selectedPeriod) { newPeriod in
//            if (newPeriod == Period.WEEK) {
//                startDate = getFirstDateOfWeek(for: today)
//                finishDate = getLastDateOfWeek(for: today)
//            } else if (newPeriod == Period.MONTH) {
//                startDate = getFirstDateOfMonth(for: today)
//                finishDate = getLastDateOfMonth(for: today)
//            }
//
//            updateDataFromPeriod()
//        }
//        .gesture(
//            DragGesture()
//                .onEnded { value in
//                    // 오른쪽 스와이프
//                    if value.translation.width > 100 {
//                        if selectedPeriod == Period.WEEK {
//                            startDate = calendar.date(byAdding: .day, value: -7, to: startDate) ?? Date()
//                            finishDate = calendar.date(byAdding: .day, value: -7, to: finishDate) ?? Date()
//                        } else {
//                            startDate = getFirstDateOfMonth(for: calendar.date(byAdding: .day, value: -15, to: startDate) ?? Date())
//                            finishDate = getLastDateOfMonth(for: calendar.date(byAdding: .day, value: -45, to: finishDate) ?? Date())
//                        }
//
//                        updateDataFromPeriod()
//                    }
//
//                    // 왼쪽 스와이프
//                    if value.translation.width < -100 &&
//                        !(selectedPeriod == Period.WEEK &&
//                            calendar.isDate(startDate, inSameDayAs: getFirstDateOfWeek(for: today)) &&
//                            calendar.isDate(finishDate, inSameDayAs: getLastDateOfWeek(for: today)) ||
//
//                            selectedPeriod == Period.MONTH &&
//                            calendar.isDate(startDate, inSameDayAs: getFirstDateOfMonth(for: today)) &&
//                            calendar.isDate(finishDate, inSameDayAs: getLastDateOfMonth(for: today)))
//                    {
//                        if selectedPeriod == Period.WEEK {
//                            startDate = calendar.date(byAdding: .day, value: 7, to: startDate) ?? Date()
//                            finishDate = calendar.date(byAdding: .day, value: 7, to: finishDate) ?? Date()
//                        } else {
//                            startDate = getFirstDateOfMonth(for: calendar.date(byAdding: .day, value: 45, to: startDate) ?? Date())
//                            finishDate = getLastDateOfMonth(for: calendar.date(byAdding: .day, value: 15, to: finishDate) ?? Date())
//                        }
//
//                        updateDataFromPeriod()
//                    }
//                }
//        )
    }
    
    // startDate, finishDate 변경될 때 실행됨.
//    func updateDataFromPeriod() {
//        wiDList = wiDService.readWiDListBetweenDates(startDate: startDate, finishDate: finishDate)
//
////        filteredWiDListByTitle = wiDList.filter { wiD in
////            return wiD.title == selectedTitle.rawValue
////        }
//
//        totalDurationDictionary = getTotalDurationDictionaryByTitle(wiDList: wiDList)
//        averageDurationDictionary = getAverageDurationDictionaryByTitle(wiDList: wiDList)
//        maxDurationDictionary = getMaxDurationDictionaryByTitle(wiDList: wiDList)
//        minDurationDictionary = getMinDurationDictionaryByTitle(wiDList: wiDList)
//
//        // startDate, finishDate를 변경하면 합계 딕셔너리로 초기화함.
////        seletedDictionary = totalDurationDictionary
////        seletedDictionaryText = "합계"
//    }
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
