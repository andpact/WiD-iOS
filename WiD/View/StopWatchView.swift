//
//  WiDCreateView.swift
//  WiD
//
//  Created by jjkim on 2023/07/06.
//

import SwiftUI

/**
 제목, 날짜, 시작 시간은 스톱 워치 클래스에서 관리
 종료 시간, 소요 시간, WiD 생성 및 저장은 스톱 워치 뷰에서 관리
 */
struct StopWatchView: View {
    // 화면
    @Environment(\.presentationMode) var presentationMode
    @State private var stopWatchTopBottomBarVisible: Bool = true
    
    // WiD
    private let wiDService = WiDService()
    
    // 제목
    @State private var expandTitleMenu: Bool = false
    
    // 스톱 워치
    @EnvironmentObject var stopwatch: Stopwatch
    
    var body: some View {
        ZStack {
            /**
             상단 바
             */
            if stopWatchTopBottomBarVisible {
                ZStack {
                    ZStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "arrow.backward")
                                .imageScale(.large)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        Text("스톱워치")
                            .titleLarge()
                    }
                    .frame(maxWidth: .infinity, maxHeight: 44)
                    .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            
            /**
             컨텐츠
             */
            formatStopWatchTime(stopwatch.elapsedTime)
                .font(.custom("ChivoMono-BlackItalic", size: 120))
            
            /**
             하단 바
             */
            if stopWatchTopBottomBarVisible {
                VStack {
                    if expandTitleMenu {
                        Text(stopwatch.stopwatchStarted ? "선택한 제목이 이어서 사용됩니다." : "사용할 제목을 선택해 주세요.")
                            .bodyMedium()
                        
                        LazyVGrid(columns: Array(repeating: GridItem(), count: 5)) {
                            ForEach(Title.allCases) { menuTitle in
                                Button(action: {
                                    if stopwatch.stopwatchStarted && stopwatch.title != menuTitle { // 이어서 기록
                                        restartStopWatch()
                                    }
                                    stopwatch.title = menuTitle
                                    withAnimation {
                                        expandTitleMenu.toggle()
                                    }
                                }) {
                                    Text(menuTitle.koreanValue)
                                        .bodyMedium()
                                        .frame(maxWidth: .infinity)
                                        .padding(8)
                                        .background(stopwatch.title == menuTitle ? Color("Black-White") : Color("White-Black"))
                                        .foregroundColor(stopwatch.title == menuTitle ? Color("White-Black") : Color("Black-White"))
                                        .clipShape(Capsule())
                                }
                            }
                        }
                        
                        Divider()
                            .background(Color("LightGray"))
                    }

                    HStack {
                        Button(action: {
                            withAnimation {
                                expandTitleMenu.toggle()
                            }
                        }) {
                            Rectangle()
                                .frame(maxWidth: 5, maxHeight: 20)
                                .foregroundColor(Color(stopwatch.title.rawValue))
                            
                            Text(stopwatch.title.koreanValue)
                                .bodyMedium()
                            
                            if !stopwatch.stopwatchPaused {
                                Image(systemName: "chevron.up.chevron.down")
                                    .imageScale(.small)
                            }
                        }
                        .disabled(stopwatch.stopwatchPaused)
                        
                        Spacer()
                        
                        if stopwatch.stopwatchPaused {
                            Button(action: {
                                stopwatch.resetStopwatchPlayer()
                            }) {
                                Image(systemName: "arrow.clockwise")
                                    .imageScale(.large)
                            }
                            .frame(maxWidth: 25, maxHeight: 25)
                            .padding()
                            .background(Color("DeepSkyBlue"))
                            .foregroundColor(Color("White"))
                            .clipShape(Circle())
                        }
                        
                        Button(action: {
                            if stopwatch.stopwatchStarted {
                                pauseStopWatch()
                            } else {
                                startStopWatch()
                            }
                        }) {
                            Image(systemName: stopwatch.stopwatchStarted ? "pause.fill" : "play.fill")
                                .imageScale(.large)
                        }
                        .frame(maxWidth: 25, maxHeight: 25)
                        .padding()
                        .background(stopwatch.stopwatchStarted ? Color("OrangeRed") : (stopwatch.stopwatchPaused ? Color("LimeGreen") : Color("Black-White")))
                        .foregroundColor(stopwatch.stopwatchReset ? Color("White-Black") : Color("White"))
                        .clipShape(Circle())
                    }
                }
                .padding()
                .background(Color("LightGray-Gray"))
                .cornerRadius(8)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
        }
        .navigationBarHidden(true)
        .tint(Color("Black-White"))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("White-Black"))
        .onTapGesture {
            if stopwatch.stopwatchStarted {
                withAnimation {
                    stopWatchTopBottomBarVisible.toggle()
                }
            }
        }
    }
    
    private func startStopWatch() {
        stopwatch.startStopwatchPlayer()
    }
    
    private func restartStopWatch() {
        stopwatch.restartStopwatchPlayer()
        
        let now = Date()
        
        let title = stopwatch.title.rawValue
        
        let start = stopwatch.start
        let finish = now
        let duration = finish.timeIntervalSince(start)

        let calendar = Calendar.current
        let startComponents = calendar.dateComponents([.year, .month, .day], from: start)
        let finishComponents = calendar.dateComponents([.year, .month, .day], from: finish)

//        if let startDate = calendar.date(from: startComponents), let finishDate = calendar.date(from: finishComponents) {
//            // Check if the duration spans across multiple days
//            if calendar.isDate(startDate, inSameDayAs: finishDate) {
//                // WiD duration is within the same day
//                let wiD = WiD(
//                    id: 0,
//                    date: startDate,
//                    title: title,
//                    start: start,
//                    finish: finish,
//                    duration: duration
//                )
//                wiDService.insertWiD(wid: wiD)
//            } else {
//                // WiD duration spans across multiple days
//                let midnightEndDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startDate)!
//                let firstDayWiD = WiD(
//                    id: 0,
//                    date: startDate,
//                    title: title,
//                    start: start,
//                    finish: midnightEndDate,
//                    duration: midnightEndDate.timeIntervalSince(start)
//                )
//                wiDService.insertWiD(wid: firstDayWiD)
//
//                let nextDayStartDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
//                let midnightEndDateNextDay = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: nextDayStartDate)!
//                let secondDayWiD = WiD(
//                    id: 0,
//                    date: nextDayStartDate,
//                    title: title,
//                    start: midnightEndDateNextDay,
//                    finish: finish,
//                    duration: finish.timeIntervalSince(midnightEndDateNextDay)
//                )
//                wiDService.insertWiD(wid: secondDayWiD)
//            }
//        }
        
        stopwatch.date = now
        stopwatch.start = now
    }

    private func pauseStopWatch() {
        stopwatch.pauseStopwatchPlayer()
        
        let title = stopwatch.title.rawValue
        
        let start = stopwatch.start
        let finish = Date()
        let duration = finish.timeIntervalSince(start)

        let calendar = Calendar.current
        let startComponents = calendar.dateComponents([.year, .month, .day], from: start)
        let finishComponents = calendar.dateComponents([.year, .month, .day], from: finish)

//        if let startDate = calendar.date(from: startComponents),
//           let finishDate = calendar.date(from: finishComponents) {
//
//            // Check if the duration spans across multiple days
//            if calendar.isDate(startDate, inSameDayAs: finishDate) {
//                // WiD duration is within the same day
//                let wiD = WiD(
//                    id: 0,
//                    date: startDate,
//                    title: title,
//                    start: start,
//                    finish: finish,
//                    duration: duration
//                )
//                wiDService.insertWiD(wid: wiD)
//            } else {
//                // WiD duration spans across multiple days
//                let midnightEndDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startDate)!
//                let firstDayWiD = WiD(
//                    id: 0,
//                    date: startDate,
//                    title: title,
//                    start: start,
//                    finish: midnightEndDate,
//                    duration: midnightEndDate.timeIntervalSince(start)
//                )
//                wiDService.insertWiD(wid: firstDayWiD)
//
//                let nextDayStartDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
//                let midnightEndDateNextDay = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: nextDayStartDate)!
//                let secondDayWiD = WiD(
//                    id: 0,
//                    date: nextDayStartDate,
//                    title: title,
//                    start: midnightEndDateNextDay,
//                    finish: finish,
//                    duration: finish.timeIntervalSince(midnightEndDateNextDay)
//                )
//                wiDService.insertWiD(wid: secondDayWiD)
//            }
//        }
    }
}

struct StopWatchView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StopWatchView()
                .environmentObject(Stopwatch())
                .environment(\.colorScheme, .light)
            
            StopWatchView()
                .environmentObject(Stopwatch())
                .environment(\.colorScheme, .dark)
        }
    }
}
