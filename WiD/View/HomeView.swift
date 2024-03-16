//
//  HomeView.swift
//  WiD
//
//  Created by jjkim on 2023/12/02.
//

import SwiftUI

struct HomeView: View {
    // 뷰 모델
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    // 화면
//    private let screenHeight = UIScreen.main.bounds.height
    
    // 날짜
//    private let calendar = Calendar.current
//    @State private var remainingSeconds: Int = 0
//    @State private var remainingPercentage: Float = 0
//    private let totalSecondsInADay: Int = 24 * 60 * 60
//    private let today: Date = Calendar.current.startOfDay(for: Date()) // 시간을 오전 12:00:00으로 설정함.
//    @State private var startDate: Date = Date()
//    @State private var finishDate: Date = Date()
    
    // WiD
//    private let wiDService = WiDService()
//    @State private var wiDExistenceList: [Date: Bool] = [:]
//    private let totalWiDCounts: Int
    
    // 다이어리
//    private let diaryService = DiaryService()
//    @State private var diaryExistenceList: [Date: Bool] = [:]
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
                
//                NavigationLink(destination: SettingView()) {
//                    Image(systemName: "gearshape.fill")
//                        .font(.system(size: 24))
//                }
            }
            .frame(maxWidth: .infinity, maxHeight: 44)
            .padding(.horizontal)
            
            // 가장 최근의 WiD와 다이어리가 없을 떄(초기 화면)
            if homeViewModel.wiD.id == -1 && homeViewModel.diary.id == -1 {
                VStack(spacing: 16) {
                    Text("WiD - What I Did")
                        .font(.system(size: 40, weight: .bold))

                    Text("WiD로 행동을 기록하고,\n다이어리로 생각을 기록하세요.\n기록된 모든 순간을 통해\n본인의 여정을 파악하세요.")
                        .font(.system(size: 25, weight: .bold))
                        .multilineTextAlignment(.center)
                        .lineSpacing(10)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    VStack(spacing: 10) {
                        
                        VStack(spacing: 0) {
                            Text("최근 활동")
                                .titleLarge()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                            
                            VStack(spacing: 0) {
                                // 날짜
                                HStack(spacing: 0) {
                                    Image(systemName: "calendar")
                                        .font(.system(size: 24))
                                        .frame(width: 30, height: 30)
                                        .padding()
                                    
                                    Divider()
                                        .background(Color("Black-White"))
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("날짜")
                                            .labelMedium()
                                        
                                        getDateStringView(date: homeViewModel.wiD.date)
                                            .bodyMedium()
                                    }
                                    .padding(.horizontal)
                                    
                                    Spacer()
                                }
                                .background(Color("White-Black"))
                                
                                Divider()
                                    .background(Color("Black-White"))
                                
                                // 제목
                                HStack(spacing: 0) {
                                    Image(systemName: titleImageDictionary[homeViewModel.wiD.title] ?? "")
//                                    Image(systemName: "character.ko")
                                        .font(.system(size: 24))
                                        .frame(width: 30, height: 30)
                                        .padding()
                                    
                                    Divider()
                                        .background(Color("Black-White"))
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("제목")
                                            .labelMedium()
                                        
    //                                    Text(homeViewModel.wiD.title)
                                        Text(titleDictionary[homeViewModel.wiD.title] ?? "공부")
                                            .bodyMedium()
                                    }
                                    .padding(.horizontal)
                                    
                                    Spacer()
                                    
    //                                Image(systemName: expandTitleMenu ? "chevron.up" : "chevron.down")
    //                                    .padding(.horizontal)
    //                                    .font(.system(size: 16))
                                }
                                .background(Color("White-Black"))
    //                            .onTapGesture {
    //                                withAnimation {
    //                                    expandTitleMenu.toggle()
    //                                }
    //                            }
                                
                                Divider()
                                    .background(Color("Black-White"))
                                
                                // 시작 시간 선택
                                HStack(spacing: 0) {
                                    Image(systemName: "clock")
                                        .font(.system(size: 24))
                                        .frame(width: 30, height: 30)
                                        .padding()

                                    Divider()
                                        .background(Color("Black-White"))
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("시작")
                                            .labelMedium()
                                        
                                        Text(getTimeString(homeViewModel.wiD.start))
                                            .bodyMedium()
                                    }
                                    .padding(.horizontal)
                                    
                                    Spacer()
                                    
    //                                Image(systemName: expandStartPicker ? "chevron.up" : "chevron.down")
    //                                    .padding(.horizontal)
    //                                    .font(.system(size: 16))
                                }
                                .background(Color("White-Black"))
    //                            .onTapGesture {
    //                                withAnimation {
    //                                    expandStartPicker.toggle()
    //                                }
    //                            }
                                
                                Divider()
                                    .background(Color("Black-White"))
                                
                                // 종료 시간 선택
                                HStack(spacing: 0) {
                                    Image(systemName: "clock.badge.checkmark")
                                        .font(.system(size: 24))
                                        .frame(width: 30, height: 30)
                                        .padding()
                                    
                                    Divider()
                                        .background(Color("Black-White"))
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("종료")
                                            .labelMedium()
                                        
                                        Text(getTimeString(homeViewModel.wiD.finish))
                                            .bodyMedium()
                                    }
                                    .padding(.horizontal)
                                    
                                    Spacer()
                                    
    //                                Image(systemName: expandFinishPicker ? "chevron.up" : "chevron.down")
    //                                    .padding(.horizontal)
    //                                    .font(.system(size: 16))
                                }
                                .background(Color("White-Black"))
    //                            .onTapGesture {
    //                                withAnimation {
    //                                    expandFinishPicker.toggle()
    //                                }
    //                            }
                                
                                Divider()
                                    .background(Color("Black-White"))
                                
                                // 소요 시간
                                HStack(spacing: 0) {
                                    Image(systemName: "hourglass")
                                        .font(.system(size: 24))
                                        .frame(width: 30, height: 30)
                                        .padding()
                                    
                                    Divider()
                                        .background(Color("Black-White"))
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("소요")
                                            .labelMedium()

                                        Text(getDurationString(homeViewModel.wiD.duration, mode: 3))
                                            .bodyMedium()
                                    }
                                    .padding(.horizontal)
                                    
                                    Spacer()
                                }
                                .background(Color("White-Black"))
                            }
                            .fixedSize(horizontal: false, vertical: true)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color("Black-White"), lineWidth: 0.5)
                            )
                            .padding(.horizontal)
                        }
                        
                        VStack(spacing: 0) {
                            Text("최근 다이어리")
                                .titleLarge()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                            
                            VStack(alignment: .leading, spacing: 16) {
                                HStack(spacing: 0) {
                                    getDateStringViewWith3Lines(date: homeViewModel.diary.date)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .font(.system(size: 22, weight: .bold))

                                    ZStack {
                                        let wiDList = homeViewModel.wiDList

                                        if wiDList.isEmpty {
                                            getEmptyViewWithMultipleLines(message: "표시할\n타임라인이\n없습니다.")
                                        } else {
                                            DiaryPieChartView(wiDList: wiDList)
                                        }
                                    }
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                }
                                .aspectRatio(2.5 / 1, contentMode: .fit)

    //                            Text(randomDiaryViewModel.diaryList[date]?.title ?? "")
                                Text(homeViewModel.diary.title)
                                    .bodyMedium()

    //                            Text(randomDiaryViewModel.diaryList[date]?.content ?? "")
                                Text(homeViewModel.diary.content)
                                    .bodyMedium()
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color("Black-White"), lineWidth: 0.5)
                            )
                            .padding(.horizontal)
                        }
                    }
                }
            }

//            ScrollView {
//                VStack(spacing: 0) {
//                    // 상단 탭
//                    HStack {
//        //                Button(action: {
//        //                        expandDatePicker = true
//        //                }) {
//                            getPeriodStringViewOfMonth(date: startDate)
//                                .titleLarge()
//                                .lineLimit(1)
//                                .truncationMode(.head)
//        //                }
//
//                        Spacer()
//
//                        Circle()
//                            .fill(Color("OrangeRed")) // .fill이 먼저 와야 함.
//                            .frame(maxWidth: 10, maxHeight: 10)
//
//                        Text("WiD")
//                            .bodyMedium()
//
//                        Circle()
//                            .fill(Color("DeepSkyBlue"))
//                            .frame(maxWidth: 10, maxHeight: 10)
//
//                        Text("다이어리")
//                            .bodyMedium()
//                    }
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding(.horizontal)
//
//                    VStack(spacing: 16) {
//                        HStack {
//                            ForEach(0...6, id: \.self) { index in
//                                let textColor = index == 0 ? Color("OrangeRed") : (index == 6 ? Color("DeepSkyBlue") : Color("Black-White"))
//
//                                Text(getStringOfDayOfWeekFromSunday(index))
//                                    .bodyMedium()
//                                    .frame(maxWidth: .infinity)
//                                    .foregroundColor(textColor)
//                            }
//                        }
//
//                        Divider()
//                            .background(Color("Black-White"))
//
//                        // Weekday 1 - 일, 2 - 월...
//                        let weekday = calendar.component(.weekday, from: startDate)
//
//                        let daysDifference = calendar.dateComponents([.day], from: startDate, to: finishDate).day ?? 0
//
//                        LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
//                            ForEach(0..<(daysDifference + 1) + (weekday - 1), id: \.self) { gridIndex in
//                                if gridIndex < weekday - 1 {
//                                    Text("")
//                                } else {
//                                    let currentDate = calendar.date(byAdding: .day, value: gridIndex - (weekday - 1), to: startDate) ?? Date()
//
//                                    VStack(spacing: 8) {
//                                        Text("\(calendar.component(.day, from: currentDate))")
//                                            .bodyMedium()
//
//                                        HStack(spacing: 4) {
//        //                                    if wiDExistenceList[currentDate] ?? false {
//                                                Circle()
//                                                    .fill(wiDExistenceList[currentDate] ?? false ? Color("OrangeRed") : Color("White-Black")) // .fill이 먼저 작성해야 함.
//                                                    .frame(maxWidth: 10, maxHeight: 10)
//        //                                    }
//
//        //                                    if diaryExistenceList[currentDate] ?? false {
//                                                Circle()
//                                                    .fill(diaryExistenceList[currentDate] ?? false ? Color("DeepSkyBlue") : Color("White-Black"))
//                                                    .frame(maxWidth: 10, maxHeight: 10)
//        //                                    }
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//                    .padding(.vertical)
//                    .frame(maxWidth: .infinity)
//                    .background(
//                        RoundedRectangle(cornerRadius: 8)
//                            .stroke(Color("Black-White"), lineWidth: 0.5)
//                    )
//                    .background(Color("White-Black"))
//                    .padding(.horizontal)
//                    .gesture(
//                        DragGesture()
//                            .onEnded { value in
//                                if 100 < value.translation.width { // 전 달
//                                    startDate = getFirstDateOfMonth(for: calendar.date(byAdding: .day, value: -15, to: startDate) ?? Date())
//                                    finishDate = getLastDateOfMonth(for: calendar.date(byAdding: .day, value: -45, to: finishDate) ?? Date())
//                                }
//
//                                if value.translation.width < -100 && !(calendar.isDate(startDate, inSameDayAs: getFirstDateOfMonth(for: today)) &&
//                                                                       calendar.isDate(finishDate, inSameDayAs: getLastDateOfMonth(for: today))){ // 다음 달
//                                    startDate = getFirstDateOfMonth(for: calendar.date(byAdding: .day, value: 45, to: startDate) ?? Date())
//                                    finishDate = getLastDateOfMonth(for: calendar.date(byAdding: .day, value: 15, to: finishDate) ?? Date())
//                                }
//                            }
//                    )
//                }
//            }
        }
//        .padding(.top, screenHeight / 4)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color("White-Black"))
        .tint(Color("Black-White"))
        .onAppear {
//            self.startDate = getFirstDateOfMonth(for: today)
//            self.finishDate = getLastDateOfMonth(for: today)
            
//            self.wiDExistenceList = wiDService.checkWiDExistence(startDate: startDate, finishDate: finishDate)
//            self.diaryExistenceList = diaryService.checkDiaryExistence(startDate: startDate, finishDate: finishDate)
            
//            print("onAppear - startDate : \(formatDate(startDate, format: "yyyy-MM-dd a HH:mm:ss"))")
//            print("onAppear - finishDate : \(formatDate(finishDate, format: "yyyy-MM-dd a HH:mm:ss"))")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeView()
                .environmentObject(HomeViewModel())
                .environmentObject(StopwatchViewModel())
                .environmentObject(TimerViewModel())
                .environment(\.colorScheme, .light)
            
            HomeView()
                .environmentObject(HomeViewModel())
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
