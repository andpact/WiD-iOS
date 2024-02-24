//
//  MainView.swift
//  WiD
//
//  Created by jjkim on 2024/02/23.
//

import SwiftUI

struct MainView: View {
    // 화면
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedTabIndex = 0
    
    @EnvironmentObject var stopwatchPlayer: StopwatchPlayer
    @EnvironmentObject var timerPlayer: TimerPlayer
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTabIndex) {
                VStack(spacing: 0) {
                    HomeView()
                    
                    if stopwatchPlayer.stopwatchState != PlayerState.STOPPED {
                        HStack(spacing: 16) {
                            Image(systemName: titleImageDictionary[stopwatchPlayer.title.rawValue] ?? "")
                                .font(.system(size: 24))
                                .frame(maxWidth: 15, maxHeight: 15)
                                .padding()
                                .background(Color("White-Black"))
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 4) { // 내용물이 앞쪽 정렬됨.
                                Text(stopwatchPlayer.title.koreanValue)
                                    .bodyMedium()
                                
                                getHorizontalTimeView(Int(stopwatchPlayer.totalDuration))
                                    .font(.custom("ChivoMono-Regular", size: 18))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading) // 프레임의 내용물이 앞쪽부터 채워짐.
                            
                            if stopwatchPlayer.stopwatchState == PlayerState.PAUSED {
                                // 정지 버튼
                                Button(action: {
                                    stopwatchPlayer.stopStopwatch()
                                }) {
                                    Image(systemName: "stop.fill")
                                        .font(.system(size: 24))
                                }
                                .frame(maxWidth: 24, maxHeight: 24)
                            }
                            
                            // 시작, 중지 선택 버튼
                            Button(action: {
                                if stopwatchPlayer.stopwatchState == PlayerState.STARTED {
                                    stopwatchPlayer.pauseStopwatch()
                                } else {
                                    stopwatchPlayer.startStopwatch()
                                }
                            }) {
                                Image(systemName: stopwatchPlayer.stopwatchState == PlayerState.STARTED ? "pause.fill" : "play.fill")
                                    .font(.system(size: 24))
                            }
                            .frame(maxWidth: 24, maxHeight: 24)
                        }
                        .padding()
//                        .tint(Color("Black-White"))
                        .background(Color(stopwatchPlayer.title.rawValue))
                    } else if timerPlayer.timerState != PlayerState.STOPPED {
                        HStack(spacing: 16) {
                            Image(systemName: titleImageDictionary[timerPlayer.title.rawValue] ?? "")
                                .font(.system(size: 24))
                                .frame(maxWidth: 15, maxHeight: 15)
                                .padding()
                                .background(Color("White-Black"))
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 4) { // 내용물이 앞쪽 정렬됨.
                                Text(timerPlayer.title.koreanValue)
                                    .bodyMedium()
                                
                                getHorizontalTimeView(Int(timerPlayer.remainingTime))
                                    .font(.custom("ChivoMono-Regular", size: 18))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading) // 프레임의 내용물이 앞쪽부터 채워짐.
                            
                            if timerPlayer.timerState == PlayerState.PAUSED {
                                // 정지 버튼
                                Button(action: {
                                    timerPlayer.stopTimer()
                                }) {
                                    Image(systemName: "stop.fill")
                                        .font(.system(size: 24))
                                }
                                .frame(maxWidth: 24, maxHeight: 24)
                            }
                            
                            // 시작, 중지 선택 버튼
                            Button(action: {
                                if timerPlayer.timerState == PlayerState.STARTED {
                                    timerPlayer.pauseTimer()
                                } else {
                                    timerPlayer.startTimer()
                                }
                            }) {
                                Image(systemName: timerPlayer.timerState == PlayerState.STARTED ? "pause.fill" : "play.fill")
                                    .font(.system(size: 24))
                            }
                            .frame(maxWidth: 24, maxHeight: 24)
                        }
                        .padding()
                        .background(Color(timerPlayer.title.rawValue))
                    }
                }
                .tabItem {
                    Image(systemName: stopwatchPlayer.stopwatchTopBottomBarVisible && timerPlayer.timerTopBottomBarVisible ? "house.fill" : "")
                }
                .tag(0)
                
                WiDToolView()
                    .tabItem {
                        Image(systemName: stopwatchPlayer.stopwatchTopBottomBarVisible && timerPlayer.timerTopBottomBarVisible ? "plus.app" : "")
                    }
                    .tag(1)
                
                VStack(spacing: 0) {
                    WiDDisplayView()
                    
                    if stopwatchPlayer.stopwatchState != PlayerState.STOPPED {
                        HStack(spacing: 16) {
                            Image(systemName: titleImageDictionary[stopwatchPlayer.title.rawValue] ?? "")
                                .font(.system(size: 24))
                                .frame(maxWidth: 15, maxHeight: 15)
                                .padding()
                                .background(Color("White-Black"))
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 4) { // 내용물이 앞쪽 정렬됨.
                                Text(stopwatchPlayer.title.koreanValue)
                                    .bodyMedium()
                                
                                getHorizontalTimeView(Int(stopwatchPlayer.totalDuration))
                                    .font(.custom("ChivoMono-Regular", size: 18))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading) // 프레임의 내용물이 앞쪽부터 채워짐.
                            
                            if stopwatchPlayer.stopwatchState == PlayerState.PAUSED {
                                // 정지 버튼
                                Button(action: {
                                    stopwatchPlayer.stopStopwatch()
                                }) {
                                    Image(systemName: "stop.fill")
                                        .font(.system(size: 24))
                                }
                                .frame(maxWidth: 24, maxHeight: 24)
                            }
                            
                            // 시작, 중지 선택 버튼
                            Button(action: {
                                if stopwatchPlayer.stopwatchState == PlayerState.STARTED {
                                    stopwatchPlayer.pauseStopwatch()
                                } else {
                                    stopwatchPlayer.startStopwatch()
                                }
                            }) {
                                Image(systemName: stopwatchPlayer.stopwatchState == PlayerState.STARTED ? "pause.fill" : "play.fill")
                                    .font(.system(size: 24))
                            }
                            .frame(maxWidth: 24, maxHeight: 24)
                        }
                        .padding()
//                        .tint(Color("Black-White"))
                        .background(Color(stopwatchPlayer.title.rawValue))
                    } else if timerPlayer.timerState != PlayerState.STOPPED {
                        HStack(spacing: 16) {
                            Image(systemName: titleImageDictionary[timerPlayer.title.rawValue] ?? "")
                                .font(.system(size: 24))
                                .frame(maxWidth: 15, maxHeight: 15)
                                .padding()
                                .background(Color("White-Black"))
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 4) { // 내용물이 앞쪽 정렬됨.
                                Text(timerPlayer.title.koreanValue)
                                    .bodyMedium()
                                
                                getHorizontalTimeView(Int(timerPlayer.remainingTime))
                                    .font(.custom("ChivoMono-Regular", size: 18))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading) // 프레임의 내용물이 앞쪽부터 채워짐.
                            
                            if timerPlayer.timerState == PlayerState.PAUSED {
                                // 정지 버튼
                                Button(action: {
                                    timerPlayer.stopTimer()
                                }) {
                                    Image(systemName: "stop.fill")
                                        .font(.system(size: 24))
                                }
                                .frame(maxWidth: 24, maxHeight: 24)
                            }
                            
                            // 시작, 중지 선택 버튼
                            Button(action: {
                                if timerPlayer.timerState == PlayerState.STARTED {
                                    timerPlayer.pauseTimer()
                                } else {
                                    timerPlayer.startTimer()
                                }
                            }) {
                                Image(systemName: timerPlayer.timerState == PlayerState.STARTED ? "pause.fill" : "play.fill")
                                    .font(.system(size: 24))
                            }
                            .frame(maxWidth: 24, maxHeight: 24)
                        }
                        .padding()
                        .background(Color(timerPlayer.title.rawValue))
                    }
                }
                .tabItem {
                    Image(systemName: stopwatchPlayer.stopwatchTopBottomBarVisible && timerPlayer.timerTopBottomBarVisible ? "deskclock" : "")
                }
                .tag(2)
                
                VStack(spacing: 0) {
                    DiaryDisplayView()
                    
                    if stopwatchPlayer.stopwatchState != PlayerState.STOPPED {
                        HStack(spacing: 16) {
                            Image(systemName: titleImageDictionary[stopwatchPlayer.title.rawValue] ?? "")
                                .font(.system(size: 24))
                                .frame(maxWidth: 15, maxHeight: 15)
                                .padding()
                                .background(Color("White-Black"))
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 4) { // 내용물이 앞쪽 정렬됨.
                                Text(stopwatchPlayer.title.koreanValue)
                                    .bodyMedium()
                                
                                getHorizontalTimeView(Int(stopwatchPlayer.totalDuration))
                                    .font(.custom("ChivoMono-Regular", size: 18))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading) // 프레임의 내용물이 앞쪽부터 채워짐.
                            
                            if stopwatchPlayer.stopwatchState == PlayerState.PAUSED {
                                // 정지 버튼
                                Button(action: {
                                    stopwatchPlayer.stopStopwatch()
                                }) {
                                    Image(systemName: "stop.fill")
                                        .font(.system(size: 24))
                                }
                                .frame(maxWidth: 24, maxHeight: 24)
                            }
                            
                            // 시작, 중지 선택 버튼
                            Button(action: {
                                if stopwatchPlayer.stopwatchState == PlayerState.STARTED {
                                    stopwatchPlayer.pauseStopwatch()
                                } else {
                                    stopwatchPlayer.startStopwatch()
                                }
                            }) {
                                Image(systemName: stopwatchPlayer.stopwatchState == PlayerState.STARTED ? "pause.fill" : "play.fill")
                                    .font(.system(size: 24))
                            }
                            .frame(maxWidth: 24, maxHeight: 24)
                        }
                        .padding()
//                        .tint(Color("Black-White"))
                        .background(Color(stopwatchPlayer.title.rawValue))
                    } else if timerPlayer.timerState != PlayerState.STOPPED {
                        HStack(spacing: 16) {
                            Image(systemName: titleImageDictionary[timerPlayer.title.rawValue] ?? "")
                                .font(.system(size: 24))
                                .frame(maxWidth: 15, maxHeight: 15)
                                .padding()
                                .background(Color("White-Black"))
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 4) { // 내용물이 앞쪽 정렬됨.
                                Text(timerPlayer.title.koreanValue)
                                    .bodyMedium()
                                
                                getHorizontalTimeView(Int(timerPlayer.remainingTime))
                                    .font(.custom("ChivoMono-Regular", size: 18))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading) // 프레임의 내용물이 앞쪽부터 채워짐.
                            
                            if timerPlayer.timerState == PlayerState.PAUSED {
                                // 정지 버튼
                                Button(action: {
                                    timerPlayer.stopTimer()
                                }) {
                                    Image(systemName: "stop.fill")
                                        .font(.system(size: 24))
                                }
                                .frame(maxWidth: 24, maxHeight: 24)
                            }
                            
                            // 시작, 중지 선택 버튼
                            Button(action: {
                                if timerPlayer.timerState == PlayerState.STARTED {
                                    timerPlayer.pauseTimer()
                                } else {
                                    timerPlayer.startTimer()
                                }
                            }) {
                                Image(systemName: timerPlayer.timerState == PlayerState.STARTED ? "pause.fill" : "play.fill")
                                    .font(.system(size: 24))
                            }
                            .frame(maxWidth: 24, maxHeight: 24)
                        }
                        .padding()
                        .background(Color(timerPlayer.title.rawValue))
                    }
                }
                .tabItem {
                    Image(systemName: stopwatchPlayer.stopwatchTopBottomBarVisible && timerPlayer.timerTopBottomBarVisible ? "menucard" : "")
                }
                .tag(3)
                
                VStack(spacing: 0) {
                    SettingView()
                    
                    if stopwatchPlayer.stopwatchState != PlayerState.STOPPED {
                        HStack(spacing: 16) {
                            Image(systemName: titleImageDictionary[stopwatchPlayer.title.rawValue] ?? "")
                                .font(.system(size: 24))
                                .frame(maxWidth: 15, maxHeight: 15)
                                .padding()
                                .background(Color("White-Black"))
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 4) { // 내용물이 앞쪽 정렬됨.
                                Text(stopwatchPlayer.title.koreanValue)
                                    .bodyMedium()
                                
                                getHorizontalTimeView(Int(stopwatchPlayer.totalDuration))
                                    .font(.custom("ChivoMono-Regular", size: 18))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading) // 프레임의 내용물이 앞쪽부터 채워짐.
                            
                            if stopwatchPlayer.stopwatchState == PlayerState.PAUSED {
                                // 정지 버튼
                                Button(action: {
                                    stopwatchPlayer.stopStopwatch()
                                }) {
                                    Image(systemName: "stop.fill")
                                        .font(.system(size: 24))
                                }
                                .frame(maxWidth: 24, maxHeight: 24)
                            }
                            
                            // 시작, 중지 선택 버튼
                            Button(action: {
                                if stopwatchPlayer.stopwatchState == PlayerState.STARTED {
                                    stopwatchPlayer.pauseStopwatch()
                                } else {
                                    stopwatchPlayer.startStopwatch()
                                }
                            }) {
                                Image(systemName: stopwatchPlayer.stopwatchState == PlayerState.STARTED ? "pause.fill" : "play.fill")
                                    .font(.system(size: 24))
                            }
                            .frame(maxWidth: 24, maxHeight: 24)
                        }
                        .padding()
//                        .tint(Color("Black-White"))
                        .background(Color(stopwatchPlayer.title.rawValue))
                    } else if timerPlayer.timerState != PlayerState.STOPPED {
                        HStack(spacing: 16) {
                            Image(systemName: titleImageDictionary[timerPlayer.title.rawValue] ?? "")
                                .font(.system(size: 24))
                                .frame(maxWidth: 15, maxHeight: 15)
                                .padding()
                                .background(Color("White-Black"))
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 4) { // 내용물이 앞쪽 정렬됨.
                                Text(timerPlayer.title.koreanValue)
                                    .bodyMedium()
                                
                                getHorizontalTimeView(Int(timerPlayer.remainingTime))
                                    .font(.custom("ChivoMono-Regular", size: 18))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading) // 프레임의 내용물이 앞쪽부터 채워짐.
                            
                            if timerPlayer.timerState == PlayerState.PAUSED {
                                // 정지 버튼
                                Button(action: {
                                    timerPlayer.stopTimer()
                                }) {
                                    Image(systemName: "stop.fill")
                                        .font(.system(size: 24))
                                }
                                .frame(maxWidth: 24, maxHeight: 24)
                            }
                            
                            // 시작, 중지 선택 버튼
                            Button(action: {
                                if timerPlayer.timerState == PlayerState.STARTED {
                                    timerPlayer.pauseTimer()
                                } else {
                                    timerPlayer.startTimer()
                                }
                            }) {
                                Image(systemName: timerPlayer.timerState == PlayerState.STARTED ? "pause.fill" : "play.fill")
                                    .font(.system(size: 24))
                            }
                            .frame(maxWidth: 24, maxHeight: 24)
                        }
                        .padding()
                        .background(Color(timerPlayer.title.rawValue))
                    }
                }
                .tabItem {
                    Image(systemName: stopwatchPlayer.stopwatchTopBottomBarVisible && timerPlayer.timerTopBottomBarVisible ? "gearshape.fill" : "")
                }
                .tag(4)
            }
            .tint(
                stopwatchPlayer.stopwatchTopBottomBarVisible && timerPlayer.timerTopBottomBarVisible ? Color("Black-White") : Color("White-Black")
            )
        }
        .onChange(of: selectedTabIndex) { newIndex in
            if stopwatchPlayer.stopwatchTopBottomBarVisible && timerPlayer.timerTopBottomBarVisible {
                self.selectedTabIndex = newIndex
            } else {
                self.selectedTabIndex = 1 // 스톱 워치나 타이머 동작 시 탭을 클릭해도 '도구' 탭으로 오도록 해서 다른 탭을 사용하지 못하도록 함.
            }
        }
        .onAppear {
            UITabBar.appearance().backgroundColor = UIColor(Color("White-Black"))
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainView()
                .environmentObject(StopwatchPlayer())
                .environmentObject(TimerPlayer())
                .environment(\.colorScheme, .light)
            
            MainView()
                .environmentObject(StopwatchPlayer())
                .environmentObject(TimerPlayer())
                .environment(\.colorScheme, .dark)
        }
    }
}
