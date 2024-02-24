//
//  TitleWiDView.swift
//  WiD
//
//  Created by jjkim on 2024/02/06.
//

import SwiftUI

struct TitleWiDView: View {
    // 화면
    private let screenHeight = UIScreen.main.bounds.height
    
    // WiD
    private let wiDService = WiDService()
    @State private var wiDList: [WiD] = []
    @State private var filteredWiDListByTitle: [WiD] = []
    
    // 제목
    @State private var selectedTitle: Title = .STUDY
    @State private var expandTitleMenu: Bool = false
    
    // 기간
    @State private var selectedPeriod: Period = Period.WEEK
    
    // 날짜
    private let calendar = Calendar.current
    private let today: Date = Calendar.current.startOfDay(for: Date()) // 시간을 오전 12:00:00으로 설정함.
    @State private var startDate: Date = Date()
    @State private var finishDate: Date = Date()
    @State private var expandDatePicker: Bool = false
    
    // 합계
    @State private var totalDurationDictionary: [String: TimeInterval] = [:]
    
    // 평균
    @State private var averageDurationDictionary: [String: TimeInterval] = [:]
    
    // 최저
    @State private var minDurationDictionary: [String: TimeInterval] = [:]
    
    // 최고
    @State private var maxDurationDictionary: [String: TimeInterval] = [:]
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack(spacing: 16) {
                    Button(action: {
//                        expandDatePicker = true
                    }) {
                        if selectedPeriod == Period.WEEK {
                            getPeriodStringViewOfWeek(firstDayOfWeek: startDate, lastDayOfWeek: finishDate)
                                .titleLarge()
                                .lineLimit(1)
                                .truncationMode(.head)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        } else if selectedPeriod == Period.MONTH {
                            getPeriodStringViewOfMonth(date: startDate)
                                .titleLarge()
                                .lineLimit(1)
                                .truncationMode(.head)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    
                    Button(action: {
                        expandTitleMenu = true
                    }) {
                        Image(systemName: titleImageDictionary[selectedTitle.rawValue] ?? "")
                            .font(.system(size: 20))
                            .frame(width: 20, height: 20)
                    }
                    .padding(8)
                    .background(Color("AppIndigo-AppYellow"))
                    .foregroundColor(Color("White-Black"))
                    .cornerRadius(8)
                    
                    Button(action: {
                        if selectedPeriod == Period.WEEK {
                            startDate = calendar.date(byAdding: .day, value: -7, to: startDate) ?? Date()
                            finishDate = calendar.date(byAdding: .day, value: -7, to: finishDate) ?? Date()
                        } else {
                            startDate = getFirstDateOfMonth(for: calendar.date(byAdding: .day, value: -15, to: startDate) ?? Date())
                            finishDate = getLastDateOfMonth(for: calendar.date(byAdding: .day, value: -45, to: finishDate) ?? Date())
                        }
                        
                        updateDataFromPeriod()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 24))
                            .frame(width: 24, height: 24)
                    }

                    Button(action: {
                        if selectedPeriod == Period.WEEK {
                            startDate = calendar.date(byAdding: .day, value: 7, to: startDate) ?? Date()
                            finishDate = calendar.date(byAdding: .day, value: 7, to: finishDate) ?? Date()
                        } else {
                            startDate = getFirstDateOfMonth(for: calendar.date(byAdding: .day, value: 45, to: startDate) ?? Date())
                            finishDate = getLastDateOfMonth(for: calendar.date(byAdding: .day, value: 15, to: finishDate) ?? Date())
                        }
                        
                        updateDataFromPeriod()
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 24))
                            .frame(width: 24, height: 24)
                    }
                    .disabled(selectedPeriod == Period.WEEK &&
                              calendar.isDate(startDate, inSameDayAs: getFirstDateOfWeek(for: today)) &&
                              calendar.isDate(finishDate, inSameDayAs: getLastDateOfWeek(for: today)) ||

                              selectedPeriod == Period.MONTH &&
                              calendar.isDate(startDate, inSameDayAs: getFirstDateOfMonth(for: today)) &&
                              calendar.isDate(finishDate, inSameDayAs: getLastDateOfMonth(for: today)))
                }
                .frame(maxHeight: 44)
                .tint(Color("Black-White"))
                .padding()
                
                if filteredWiDListByTitle.isEmpty {
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
                            LineGraphView(title: selectedTitle.rawValue, wiDList: filteredWiDListByTitle, startDate: startDate, finishDate: finishDate)
                                .aspectRatio(1.0 / 1.0, contentMode: .fit) // 가로 1, 세로 1 비율
                                .padding(.horizontal)
                            
                            ZStack {
                                VStack(spacing :16) {
                                    HStack(spacing : 0) {
                                        VStack(spacing :0) {
                                            Text("합계")
                                                .bodyMedium()
                                            
                                            Text(getDurationString(totalDurationDictionary[selectedTitle.rawValue] ?? 0, mode: 3))
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
                                        
                                            Text(getDurationString(averageDurationDictionary[selectedTitle.rawValue] ?? 0, mode: 3))
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
                                        
                                            Text(getDurationString(minDurationDictionary[selectedTitle.rawValue] ?? 0, mode: 3))
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
                                        
                                            Text(getDurationString(maxDurationDictionary[selectedTitle.rawValue] ?? 0, mode: 3))
                                                .titleLarge()
                                                .lineLimit(1)
                                        }
                                        .frame(maxWidth: .infinity)
                                    }
                                }
                                
                                Text(selectedTitle.koreanValue)
                                    .bodyLarge()
                                    .padding(16)
                                    .background(Color(selectedTitle.rawValue))
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
                                        // 주 선택하는 기능

                                        selectedPeriod = menuPeriod
                                        withAnimation {
                                            expandDatePicker.toggle()
                                        }
                                    }) {
//                                        Image(systemName: titleImageDictionary[menuPeriod.rawValue] ?? "")
//                                            .font(.system(size: 25))
//                                            .frame(maxWidth: 40, maxHeight: 40)
//
//                                        Spacer()
//                                            .frame(maxWidth: 20)

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
                                    ForEach(Title.allCases) { menuTitle in
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
        .navigationBarHidden(true)
        .tint(Color("Black-White"))
//        .background(Color("White-Gray"))
        .onAppear {
            self.startDate = getFirstDateOfWeek(for: today)
            self.finishDate = getLastDateOfWeek(for: today)
            
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
//        seletedDictionary = totalDurationDictionary
//        seletedDictionaryText = "합계"
    }
}

struct TitleWiDView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TitleWiDView()
                .environment(\.colorScheme, .light)
            
            TitleWiDView()
                .environment(\.colorScheme, .dark)
        }
    }
}
