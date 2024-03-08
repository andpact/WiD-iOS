//
//  HomeView.swift
//  WiD
//
//  Created by jjkim on 2023/12/02.
//

import SwiftUI

struct HomeView: View {
    // 화면
//    private let screenHeight = UIScreen.main.bounds.height
    
    // 날짜
    private let calendar = Calendar.current
//    @State private var remainingSeconds: Int = 0
//    @State private var remainingPercentage: Float = 0
//    private let totalSecondsInADay: Int = 24 * 60 * 60
    private let today: Date = Calendar.current.startOfDay(for: Date()) // 시간을 오전 12:00:00으로 설정함.
    @State private var startDate: Date = Date()
    @State private var finishDate: Date = Date()
    
    // WiD
    private let wiDService = WiDService()
    @State private var wiDExistenceList: [Date: Bool] = [:]
//    private let totalWiDCounts: Int
    
    // 다이어리
    private let diaryService = DiaryService()
    @State private var diaryExistenceList: [Date: Bool] = [:]
//    private let totalDiaryCounts: Int
    
//    init() {
//        self.totalWiDCounts = wiDService.readTotalWiDCount()
//        self.totalDiaryCounts = diaryService.readTotalDiaryCount()
//    }
    
    // 도구
//    @EnvironmentObject var stopwatchViewModel: StopwatchViewModel
//    @EnvironmentObject var timerViewModel: TimerViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // 상단 바
            HStack {
                Text("홈")
                    .titleLarge()
                
                Spacer()
                
                NavigationLink(destination: SettingView()) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 24))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 44)
            .padding(.horizontal)
            
            ScrollView {
                VStack(spacing: 0) {
                    // 상단 탭
                    HStack {
        //                Button(action: {
        //                        expandDatePicker = true
        //                }) {
                            getPeriodStringViewOfMonth(date: startDate)
                                .titleLarge()
                                .lineLimit(1)
                                .truncationMode(.head)
        //                }
                        
                        Spacer()
                        
                        Circle()
                            .fill(Color("OrangeRed")) // .fill이 먼저 와야 함.
                            .frame(maxWidth: 10, maxHeight: 10)

                        Text("WiD")
                            .bodyMedium()
                        
                        Circle()
                            .fill(Color("DeepSkyBlue"))
                            .frame(maxWidth: 10, maxHeight: 10)
                        
                        Text("다이어리")
                            .bodyMedium()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    VStack(spacing: 16) {
                        HStack {
                            ForEach(0...6, id: \.self) { index in
                                let textColor = index == 0 ? Color("OrangeRed") : (index == 6 ? Color("DeepSkyBlue") : Color("Black-White"))
                                
                                Text(getStringOfDayOfWeekFromSunday(index))
                                    .bodyMedium()
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(textColor)
                            }
                        }
                        
                        Divider()
                            .background(Color("Black-White"))
                        
                        // Weekday 1 - 일, 2 - 월...
                        let weekday = calendar.component(.weekday, from: startDate)
                        
                        let daysDifference = calendar.dateComponents([.day], from: startDate, to: finishDate).day ?? 0
                        
                        LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
                            ForEach(0..<(daysDifference + 1) + (weekday - 1), id: \.self) { gridIndex in
                                if gridIndex < weekday - 1 {
                                    Text("")
                                } else {
                                    let currentDate = calendar.date(byAdding: .day, value: gridIndex - (weekday - 1), to: startDate) ?? Date()
                                    
                                    VStack(spacing: 8) {
                                        Text("\(calendar.component(.day, from: currentDate))")
                                            .bodyMedium()
                                        
                                        HStack(spacing: 4) {
        //                                    if wiDExistenceList[currentDate] ?? false {
                                                Circle()
                                                    .fill(wiDExistenceList[currentDate] ?? false ? Color("OrangeRed") : Color("White-Black")) // .fill이 먼저 작성해야 함.
                                                    .frame(maxWidth: 10, maxHeight: 10)
        //                                    }

        //                                    if diaryExistenceList[currentDate] ?? false {
                                                Circle()
                                                    .fill(diaryExistenceList[currentDate] ?? false ? Color("DeepSkyBlue") : Color("White-Black"))
                                                    .frame(maxWidth: 10, maxHeight: 10)
        //                                    }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color("Black-White"), lineWidth: 0.5)
                    )
                    .background(Color("White-Black"))
                    .padding(.horizontal)
                    .gesture(
                        DragGesture()
                            .onEnded { value in
                                if 100 < value.translation.width { // 전 달
                                    startDate = getFirstDateOfMonth(for: calendar.date(byAdding: .day, value: -15, to: startDate) ?? Date())
                                    finishDate = getLastDateOfMonth(for: calendar.date(byAdding: .day, value: -45, to: finishDate) ?? Date())
                                }
                                
                                if value.translation.width < -100 && !(calendar.isDate(startDate, inSameDayAs: getFirstDateOfMonth(for: today)) &&
                                                                       calendar.isDate(finishDate, inSameDayAs: getLastDateOfMonth(for: today))){ // 다음 달
                                    startDate = getFirstDateOfMonth(for: calendar.date(byAdding: .day, value: 45, to: startDate) ?? Date())
                                    finishDate = getLastDateOfMonth(for: calendar.date(byAdding: .day, value: 15, to: finishDate) ?? Date())
                                }
                            }
                    )
                }
            }
        }
//        .padding(.top, screenHeight / 4)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color("White-Black"))
        .tint(Color("Black-White"))
        .onAppear {
            self.startDate = getFirstDateOfMonth(for: today)
            self.finishDate = getLastDateOfMonth(for: today)
            
            self.wiDExistenceList = wiDService.checkWiDExistence(startDate: startDate, finishDate: finishDate)
            self.diaryExistenceList = diaryService.checkDiaryExistence(startDate: startDate, finishDate: finishDate)
            
//            print("onAppear - startDate : \(formatDate(startDate, format: "yyyy-MM-dd a HH:mm:ss"))")
//            print("onAppear - finishDate : \(formatDate(finishDate, format: "yyyy-MM-dd a HH:mm:ss"))")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeView()
                .environmentObject(StopwatchViewModel())
                .environmentObject(TimerViewModel())
                .environment(\.colorScheme, .light)
            
            HomeView()
                .environmentObject(StopwatchViewModel())
                .environmentObject(TimerViewModel())
                .environment(\.colorScheme, .dark)
        }
    }
}

//struct SlideInAndOutAnimation: ViewModifier {
//    enum Direction {
//        case topToBottom
//        case bottomToTop
//    }
//
//    var direction: Direction
//    var duration: Double = 0.5
//
//    func body(content: Content) -> some View {
//        content
//            .transition(
//                .move(edge: direction == .topToBottom ? .top : .bottom)
//                    .combined(with: .opacity)
//            )
//            .animation(.easeInOut(duration: duration))
//    }
//}
//
//extension View {
//    func slideInAndOutAnimation(direction: SlideInAndOutAnimation.Direction, duration: Double = 0.5) -> some View {
//        self.modifier(SlideInAndOutAnimation(direction: direction, duration: duration))
//    }
//}
