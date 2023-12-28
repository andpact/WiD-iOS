//
//  WiDCreateView.swift
//  WiD
//
//  Created by jjkim on 2023/07/06.
//

import SwiftUI

struct StopWatchView: View {
    // 화면
    @Environment(\.presentationMode) var presentationMode
    @State private var stopWatchTopBottomBarVisible: Bool = true
    
    // WiD
    private let wiDService = WiDService()
    
    // 날짜
    @State private var date: Date = Date()
    
    // 제목
    @State private var title: Title = .STUDY
    @State private var expandTitleMenu: Bool = false
    
    // 시작 시간
    @State private var start: Date = Date()
    
    // 종료 시간
    @State private var finish: Date = Date()
    
    // 소요 시간
    @State private var duration: TimeInterval = 0
    
    // 스톱 워치
    @State private var timer: Timer?
    @State private var stopWatchStarted: Bool = false
    @State private var stopWatchPaused: Bool = false
    @State private var stopWatchReset: Bool = true
    @State private var elapsedTime = 0
    private let timerInterval = 1
    
    var body: some View {
        NavigationView {
            ZStack {
                if stopWatchTopBottomBarVisible {
                    /**
                     상단 바
                     */
                    ZStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                            
                            if stopWatchStarted {
                                pauseStopWatch()
                            }
                        }) {
                            Image(systemName: "chevron.backward")
                            
                            Text("뒤로 가기")
                                .bodyMedium()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.blue)

                        Text("스톱워치")
                            .titleLarge()
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                }
                
                /**
                 컨텐츠
                 */
                formatStopWatchTime(elapsedTime)
                
                /**
                 하단 바
                 */
                if stopWatchTopBottomBarVisible {
                    VStack {
                        if expandTitleMenu {
                            Text(stopWatchStarted ? "선택한 제목이 이어서 사용됩니다." : "사용할 제목을 선택해 주세요.")
                                .titleMedium()
                            
                            LazyVGrid(columns: Array(repeating: GridItem(), count: 5)) {
                                ForEach(Title.allCases) { menuTitle in
                                    Button(action: {
                                        if stopWatchStarted && title != menuTitle { // 이어서 기록
                                            restartStopWatch()
                                        }
                                        title = menuTitle
                                        withAnimation {
                                            expandTitleMenu.toggle()
                                        }
                                    }) {
                                        Text(menuTitle.koreanValue)
                                            .bodyMedium()
                                            .frame(maxWidth: .infinity)
                                            .padding(8)
                                            .background(title == menuTitle ? .black : .white)
                                            .foregroundColor(title == menuTitle ? .white : .black)
                                            .cornerRadius(8)
                                    }
                                }
                            }
                            
                            Divider()
                        }

                        HStack {
                            Button(action: {
                                withAnimation {
                                    expandTitleMenu.toggle()
                                }
                            }) {
                                Rectangle()
                                    .frame(maxWidth: 5, maxHeight: 20)
                                    .foregroundColor(Color(title.rawValue))
                                
                                Text(title.koreanValue)
                                    .bodyMedium()
                                
                                Image(systemName: "chevron.up.chevron.down")
                                    .imageScale(.small)
                            }
                            
                            Spacer()
                            
                            if stopWatchPaused {
                                Button(action: {
                                    resetStopWatch()
                                }) {
                                    Image(systemName: "arrow.clockwise")
                                        .imageScale(.large)
                                }
                                .frame(maxWidth: 25, maxHeight: 25)
                                .padding()
                                .background(.blue)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                            }
                            
                            Button(action: {
                                if stopWatchStarted {
                                    pauseStopWatch()
                                } else {
                                    startStopWatch()
                                }
                            }) {
                                Image(systemName: stopWatchStarted ? "pause.fill" : "play.fill")
                                    .imageScale(.large)
                            }
                            .frame(maxWidth: 25, maxHeight: 25)
                            .padding()
                            .background(stopWatchStarted ? .red : (stopWatchPaused ? .green : .blue))
                            .foregroundColor(.white)
                            .clipShape(Circle())
                        }
                    }
                    .padding()
                    .background(Color("light_gray"))
                    .cornerRadius(8)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                }
            }
            .tint(.black)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.white)
            .onTapGesture {
                if stopWatchStarted {
                    withAnimation {
                        stopWatchTopBottomBarVisible.toggle()
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private func startStopWatch() {
        stopWatchStarted = true
        stopWatchPaused = false
        stopWatchReset = false
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(timerInterval), repeats: true) { timer in
            if elapsedTime < 12 * 60 * 60 {
                elapsedTime += timerInterval
            } else {
                pauseStopWatch()
                resetStopWatch()
            }
        }
        
        date = Date()
        start = Date()
    }
    
    private func restartStopWatch() {
        let now = Date()
        
        // pauseStopWatch()
        timer?.invalidate()
        timer = nil
        
        finish = now
        duration = finish.timeIntervalSince(start)

        let calendar = Calendar.current
        let startComponents = calendar.dateComponents([.year, .month, .day], from: start)
        let finishComponents = calendar.dateComponents([.year, .month, .day], from: finish)

        if let startDate = calendar.date(from: startComponents),
           let finishDate = calendar.date(from: finishComponents) {

            // Check if the duration spans across multiple days
            if calendar.isDate(startDate, inSameDayAs: finishDate) {
                // WiD duration is within the same day
                let wiD = WiD(id: 0, date: startDate, title: title.rawValue, start: start, finish: finish, duration: duration)
                wiDService.insertWiD(wid: wiD)
            } else {
                // WiD duration spans across multiple days
                let midnightEndDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startDate)!
                let firstDayWiD = WiD(id: 0, date: startDate, title: title.rawValue, start: start, finish: midnightEndDate, duration: midnightEndDate.timeIntervalSince(start))
                wiDService.insertWiD(wid: firstDayWiD)

                let nextDayStartDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
                let midnightEndDateNextDay = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: nextDayStartDate)!
                let secondDayWiD = WiD(id: 0, date: nextDayStartDate, title: title.rawValue, start: midnightEndDateNextDay, finish: finish, duration: finish.timeIntervalSince(midnightEndDateNextDay))
                wiDService.insertWiD(wid: secondDayWiD)
            }
        }
        
        elapsedTime = 0
        
        // startStopWatch()
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(timerInterval), repeats: true) { timer in
            if elapsedTime < 12 * 60 * 60 {
                elapsedTime += timerInterval
            } else { // 12시간 초과 시 스탑 워치 정지 및 리셋
                pauseStopWatch()
                resetStopWatch()
            }
        }
        
        date = Date()
        start = now
    }

    private func pauseStopWatch() {
        stopWatchStarted = false
        stopWatchPaused = true
        
        timer?.invalidate()
        timer = nil
        
        finish = Date()
        duration = finish.timeIntervalSince(start)

        let calendar = Calendar.current
        let startComponents = calendar.dateComponents([.year, .month, .day], from: start)
        let finishComponents = calendar.dateComponents([.year, .month, .day], from: finish)

        if let startDate = calendar.date(from: startComponents),
           let finishDate = calendar.date(from: finishComponents) {

            // Check if the duration spans across multiple days
            if calendar.isDate(startDate, inSameDayAs: finishDate) {
                // WiD duration is within the same day
                let wiD = WiD(id: 0, date: startDate, title: title.rawValue, start: start, finish: finish, duration: duration)
                wiDService.insertWiD(wid: wiD)
            } else {
                // WiD duration spans across multiple days
                let midnightEndDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startDate)!
                let firstDayWiD = WiD(id: 0, date: startDate, title: title.rawValue, start: start, finish: midnightEndDate, duration: midnightEndDate.timeIntervalSince(start))
                wiDService.insertWiD(wid: firstDayWiD)

                let nextDayStartDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
                let midnightEndDateNextDay = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: nextDayStartDate)!
                let secondDayWiD = WiD(id: 0, date: nextDayStartDate, title: title.rawValue, start: midnightEndDateNextDay, finish: finish, duration: finish.timeIntervalSince(midnightEndDateNextDay))
                wiDService.insertWiD(wid: secondDayWiD)
            }
        }
    }

    private func resetStopWatch() {
        stopWatchPaused = false
        stopWatchReset = true
        elapsedTime = 0
    }
}

struct StopWatchView_Previews: PreviewProvider {
    static var previews: some View {
        return StopWatchView()
    }
}
