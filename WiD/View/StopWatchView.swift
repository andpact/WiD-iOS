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
struct StopwatchView: View {
    // 화면
    @Environment(\.presentationMode) var presentationMode
    @State private var stopwatchTopBottomBarVisible: Bool = true
    
    // WiD
    private let wiDService = WiDService()
    
    // 날짜
    private let calendar = Calendar.current
    
    // 제목
    @State private var expandTitleMenu: Bool = false
    
    // 스톱 워치
    @EnvironmentObject var stopwatchPlayer: StopwatchPlayer
    
    var body: some View {
        ZStack {
            /**
             상단 바
             */
            if stopwatchTopBottomBarVisible {
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
            formatTimeVertically(stopwatchPlayer.elapsedTime)
            
            /**
             하단 바
             */
            if stopwatchTopBottomBarVisible {
                VStack(spacing: 32) {
                    if stopwatchPlayer.paused {
                        Button(action: {
                            resetStopwatchPlayer()
                        }) {
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 30))
                        }
                    }
                    
                    HStack(spacing: 32) {
                        Button(action: {
                            withAnimation {
                                expandTitleMenu.toggle()
                            }
                        }) {
                            Image(systemName: titleImageDictionary[stopwatchPlayer.title.rawValue] ?? "")
                                .font(.system(size: 30))
                        }
                        .frame(maxWidth: 40, maxHeight: 40)
                        .disabled(!stopwatchPlayer.reset)
                        
                        Button(action: {
                            if stopwatchPlayer.started {
                                pauseStopwatchPlayer()
                            } else {
                                startStopwatchPlayer()
                            }
                        }) {
                            Image(systemName: stopwatchPlayer.started ? "pause.fill" : "play.fill")
                                .font(.system(size: 30))
                        }
                        .frame(maxWidth: 40, maxHeight: 40)
                        .padding()
                        .background(stopwatchPlayer.started ? Color("OrangeRed") : (stopwatchPlayer.paused ? Color("LimeGreen") : Color("Black-White")))
                        .foregroundColor(stopwatchPlayer.reset ? Color("White-Black") : Color("White"))
                        .clipShape(Circle())
                        
                        Button(action: {
                            withAnimation {
                                expandTitleMenu.toggle()
                            }
                        }) {
                            Image(systemName: "chevron.forward.2")
                                .font(.system(size: 30))
                        }
                        .frame(maxWidth: 40, maxHeight: 40)
                        .disabled(!stopwatchPlayer.started)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding()
            }
            
            if expandTitleMenu {
                ZStack(alignment: .bottom) {
                    Color("Black").opacity(0.5)
                        .onTapGesture {
                            expandTitleMenu = false
                        }
                    
                    VStack(spacing: 0) {
                        ZStack {
                            Text(stopwatchPlayer.started ? "이어서 사용할 제목 선택" : "제목 선택")
                                .titleLarge()
                            
                            Button(action: {
                                expandTitleMenu = false
                            }) {
                                Image(systemName: "xmark")
                                    .imageScale(.large)
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .padding()
                        
                        Divider()
                        
                        ScrollView {
                            VStack(spacing: 0) {
                                ForEach(Title.allCases) { menuTitle in
                                    Button(action: {
                                        if stopwatchPlayer.started && stopwatchPlayer.title != menuTitle { // 이어서 기록
                                            restartStopwatchPlayer()
                                        }
                                        
                                        stopwatchPlayer.title = menuTitle
                                        withAnimation {
                                            expandTitleMenu = false
                                        }
                                    }) {
                                        Image(systemName: titleImageDictionary[menuTitle.rawValue] ?? "")
                                            .font(.system(size: 25))
                                            .frame(maxWidth: 40, maxHeight: 40)
                                        
                                        Spacer()
                                            .frame(maxWidth: 20)
                                        
                                        Text(menuTitle.koreanValue)
                                            .bodyMedium()
                                        
                                        Spacer()
                                        
                                        if stopwatchPlayer.title == menuTitle {
                                            Text("선택됨")
                                        } else if stopwatchPlayer.title == menuTitle && stopwatchPlayer.started {
                                            Text("사용 중")
                                        }
                                    }
                                    .disabled(stopwatchPlayer.title == menuTitle && stopwatchPlayer.started)
                                    .padding()
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height / 3)
                    .background(Color("LightGray-Gray"))
                    .cornerRadius(8)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            }
        }
        .navigationBarHidden(true)
        .tint(Color("Black-White"))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("White-Black"))
        .onTapGesture {
            if stopwatchPlayer.started {
                withAnimation {
                    stopwatchTopBottomBarVisible.toggle()
                }
            }
        }
        .onAppear {
            withAnimation {
                stopwatchPlayer.inStopwatchView = true
            }
        }
        .onDisappear {
            withAnimation {
                stopwatchPlayer.inStopwatchView = false
            }
        }
    }
    
    private func startStopwatchPlayer() {
        stopwatchPlayer.startIt()
    }
    
    private func restartStopwatchPlayer() {
        stopwatchPlayer.restartIt()
        
        let now = Date()
        
        let title = stopwatchPlayer.title.rawValue
        let start = stopwatchPlayer.start
        let finish = now
        let duration = finish.timeIntervalSince(start)

        let startComponents = calendar.dateComponents([.year, .month, .day], from: start)
        let finishComponents = calendar.dateComponents([.year, .month, .day], from: finish)

        if let startDate = calendar.date(from: startComponents), let finishDate = calendar.date(from: finishComponents) {
            // Check if the duration spans across multiple days
            if calendar.isDate(startDate, inSameDayAs: finishDate) {
                // WiD duration is within the same day
                let wiD = WiD(
                    id: 0,
                    date: startDate,
                    title: title,
                    start: start,
                    finish: finish,
                    duration: duration
                )
                wiDService.insertWiD(wid: wiD)
            } else {
                // WiD duration spans across multiple days
                let midnightEndDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startDate)!
                let firstDayWiD = WiD(
                    id: 0,
                    date: startDate,
                    title: title,
                    start: start,
                    finish: midnightEndDate,
                    duration: midnightEndDate.timeIntervalSince(start)
                )
                wiDService.insertWiD(wid: firstDayWiD)

                let nextDayStartDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
                let midnightEndDateNextDay = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: nextDayStartDate)!
                let secondDayWiD = WiD(
                    id: 0,
                    date: nextDayStartDate,
                    title: title,
                    start: midnightEndDateNextDay,
                    finish: finish,
                    duration: finish.timeIntervalSince(midnightEndDateNextDay)
                )
                wiDService.insertWiD(wid: secondDayWiD)
            }
        }
        
        stopwatchPlayer.date = now
        stopwatchPlayer.start = now
    }

    private func pauseStopwatchPlayer() {
        stopwatchPlayer.pauseIt()
        
        let now = Date()
        
        let title = stopwatchPlayer.title.rawValue
        let start = stopwatchPlayer.start
        let finish = now
        let duration = finish.timeIntervalSince(start)

        let startComponents = calendar.dateComponents([.year, .month, .day], from: start)
        let finishComponents = calendar.dateComponents([.year, .month, .day], from: finish)

        if let startDate = calendar.date(from: startComponents),
           let finishDate = calendar.date(from: finishComponents) {

            // Check if the duration spans across multiple days
            if calendar.isDate(startDate, inSameDayAs: finishDate) {
                // WiD duration is within the same day
                let wiD = WiD(
                    id: 0,
                    date: startDate,
                    title: title,
                    start: start,
                    finish: finish,
                    duration: duration
                )
                wiDService.insertWiD(wid: wiD)
            } else {
                // WiD duration spans across multiple days
                let midnightEndDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startDate)!
                let firstDayWiD = WiD(
                    id: 0,
                    date: startDate,
                    title: title,
                    start: start,
                    finish: midnightEndDate,
                    duration: midnightEndDate.timeIntervalSince(start)
                )
                wiDService.insertWiD(wid: firstDayWiD)

                let nextDayStartDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
                let midnightEndDateNextDay = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: nextDayStartDate)!
                let secondDayWiD = WiD(
                    id: 0,
                    date: nextDayStartDate,
                    title: title,
                    start: midnightEndDateNextDay,
                    finish: finish,
                    duration: finish.timeIntervalSince(midnightEndDateNextDay)
                )
                wiDService.insertWiD(wid: secondDayWiD)
            }
        }
    }
    
    private func resetStopwatchPlayer() {
        stopwatchPlayer.resetIt()
    }
}

struct StopWatchView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StopwatchView()
                .environmentObject(StopwatchPlayer())
                .environment(\.colorScheme, .light)
            
            StopwatchView()
                .environmentObject(StopwatchPlayer())
                .environment(\.colorScheme, .dark)
        }
    }
}
