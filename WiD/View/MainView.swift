//
//  MainView.swift
//  WiD
//
//  Created by jjkim on 2024/02/23.
//

import SwiftUI

enum MainViewTap: String, CaseIterable {
    case HOME = "house.fill"
    case WiDTOOL = "plus.app.fill"
    case WiDDISPLAY = "deskclock.fill"
    case DIARYDISPLAY = "menucard.fill"
//    case SETTING = "gearshape.fill"
}

struct MainView: View {
    // 화면
//    @Environment(\.colorScheme) var colorScheme
//    @State private var selectedTabIndex = 0
    
    // 화면
    @State private var selectedTab: MainViewTap = .HOME
    
    @EnvironmentObject private var stopwatchViewModel: StopwatchViewModel
    @EnvironmentObject private var timerViewModel: TimerViewModel
    
//    @StateObject private var stopwatchViewModel = StopwatchViewModel()
//    @StateObject private var timerViewModel = TimerViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 상단 바
//                HStack {
//                    switch selectedTab {
//                        case .HOME:
//                            Text("홈")
//                        case .WiDTOOL:
//                            Text("WiD 도구")
//                        case .WiDDISPLAY:
//                            Text("WiD 조회")
//                        case .DIARYDISPLAY:
//                            Text("다이어리 조회")
////                        case .SETTING:
////                            Text("환경설정")
//                    }
//
//                    Spacer()
//                }
//                .frame(maxWidth: .infinity, maxHeight: 44)
//                .padding(.horizontal)
//                .titleLarge()
//                .opacity(stopwatchViewModel.stopwatchTopBottomBarVisible && timerViewModel.timerTopBottomBarVisible ? 1 : 0)
                
                switch selectedTab {
                    case .HOME:
                        HomeView()
                    case .WiDTOOL:
                        WiDToolView()
                    case .WiDDISPLAY:
                        WiDDisplayView()
                    case .DIARYDISPLAY:
                        DiaryDisplayView()
//                    case .SETTING:
//                        SettingView()
                }
                
                if stopwatchViewModel.stopwatchState != PlayerState.STOPPED && selectedTab != .WiDTOOL{
                    HStack(spacing: 16) {
                        Image(systemName: titleImageDictionary[stopwatchViewModel.title.rawValue] ?? "")
                            .font(.system(size: 24)) // large - 22, medium(기본) - 17, small - 14(정확하지 않음)
                            .frame(maxWidth: 15, maxHeight: 15)
                            .padding()
                            .background(Color("White-Black"))
                            .clipShape(Circle())

                        VStack(alignment: .leading, spacing: 4) { // 내용물이 앞쪽 정렬됨.
                            Text(stopwatchViewModel.title.koreanValue)
                                .bodyMedium()

                            getHorizontalTimeView(Int(stopwatchViewModel.totalDuration))
                                .font(.custom("ChivoMono-Regular", size: 18))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading) // 프레임의 내용물이 앞쪽부터 채워짐.

                        if stopwatchViewModel.stopwatchState == PlayerState.PAUSED {
                            // 정지 버튼
                            Button(action: {
                                stopwatchViewModel.stopStopwatch()
                            }) {
                                Image(systemName: "stop.fill")
                                    .font(.system(size: 24))
                            }
                            .frame(maxWidth: 24, maxHeight: 24)
                        }

                        // 시작, 중지 선택 버튼
                        Button(action: {
                            if stopwatchViewModel.stopwatchState == PlayerState.STARTED {
                                stopwatchViewModel.pauseStopwatch()
                            } else {
                                stopwatchViewModel.startStopwatch()
                            }
                        }) {
                            Image(systemName: stopwatchViewModel.stopwatchState == PlayerState.STARTED ? "pause.fill" : "play.fill")
                                .font(.system(size: 24))
                        }
                        .frame(maxWidth: 24, maxHeight: 24)
                    }
                    .padding()
                    .tint(Color("Black-White"))
                    .background(Color(stopwatchViewModel.title.rawValue))
                } else if timerViewModel.timerState != PlayerState.STOPPED && selectedTab != .WiDTOOL{
                    HStack(spacing: 16) {
                        Image(systemName: titleImageDictionary[timerViewModel.title.rawValue] ?? "")
                            .font(.system(size: 24))
                            .frame(maxWidth: 15, maxHeight: 15)
                            .padding()
                            .background(Color("White-Black"))
                            .clipShape(Circle())

                        VStack(alignment: .leading, spacing: 4) { // 내용물이 앞쪽 정렬됨.
                            Text(timerViewModel.title.koreanValue)
                                .bodyMedium()

                            getHorizontalTimeView(Int(timerViewModel.remainingTime))
                                .font(.custom("ChivoMono-Regular", size: 18))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading) // 프레임의 내용물이 앞쪽부터 채워짐.

                        if timerViewModel.timerState == PlayerState.PAUSED {
                            // 정지 버튼
                            Button(action: {
                                timerViewModel.stopTimer()
                            }) {
                                Image(systemName: "stop.fill")
                                    .font(.system(size: 24))
                            }
                            .frame(maxWidth: 24, maxHeight: 24)
                        }

                        // 시작, 중지 선택 버튼
                        Button(action: {
                            if timerViewModel.timerState == PlayerState.STARTED {
                                timerViewModel.pauseTimer()
                            } else {
                                timerViewModel.startTimer()
                            }
                        }) {
                            Image(systemName: timerViewModel.timerState == PlayerState.STARTED ? "pause.fill" : "play.fill")
                                .font(.system(size: 24))
                        }
                        .frame(maxWidth: 24, maxHeight: 24)
                    }
                    .padding()
                    .tint(Color("Black-White"))
                    .background(Color(timerViewModel.title.rawValue))
                }
                
                HStack {
                    ForEach(MainViewTap.allCases, id: \.self) { tabItem in
                        Image(systemName: tabItem.rawValue)
                            .frame(maxWidth: .infinity)
                            .font(.system(size: 24))
//                            .frame(width: 30, height: 30)
                            .foregroundColor(selectedTab == tabItem ? Color("Black-White") : Color("DarkGray"))
                            .onTapGesture {
                                self.selectedTab = tabItem
                            }
                    }
                }
                .padding(.vertical)
                .background(Color("White-Black"))
                .opacity(stopwatchViewModel.stopwatchTopBottomBarVisible && timerViewModel.timerTopBottomBarVisible ? 1 : 0)
            }
            
//            TabView(selection: $selectedTabIndex) {
//                VStack(spacing: 0) {
//                    HomeView()
//
//                    if stopwatchViewModel.stopwatchState != PlayerState.STOPPED {
//                        HStack(spacing: 16) {
//                            Image(systemName: titleImageDictionary[stopwatchViewModel.title.rawValue] ?? "")
//                                .font(.system(size: 24))
//                                .frame(maxWidth: 15, maxHeight: 15)
//                                .padding()
//                                .background(Color("White-Black"))
//                                .clipShape(Circle())
//
//                            VStack(alignment: .leading, spacing: 4) { // 내용물이 앞쪽 정렬됨.
//                                Text(stopwatchViewModel.title.koreanValue)
//                                    .bodyMedium()
//
//                                getHorizontalTimeView(Int(stopwatchViewModel.totalDuration))
//                                    .font(.custom("ChivoMono-Regular", size: 18))
//                            }
//                            .frame(maxWidth: .infinity, alignment: .leading) // 프레임의 내용물이 앞쪽부터 채워짐.
//
//                            if stopwatchViewModel.stopwatchState == PlayerState.PAUSED {
//                                // 정지 버튼
//                                Button(action: {
//                                    stopwatchViewModel.stopStopwatch()
//                                }) {
//                                    Image(systemName: "stop.fill")
//                                        .font(.system(size: 24))
//                                }
//                                .frame(maxWidth: 24, maxHeight: 24)
//                            }
//
//                            // 시작, 중지 선택 버튼
//                            Button(action: {
//                                if stopwatchViewModel.stopwatchState == PlayerState.STARTED {
//                                    stopwatchViewModel.pauseStopwatch()
//                                } else {
//                                    stopwatchViewModel.startStopwatch()
//                                }
//                            }) {
//                                Image(systemName: stopwatchViewModel.stopwatchState == PlayerState.STARTED ? "pause.fill" : "play.fill")
//                                    .font(.system(size: 24))
//                            }
//                            .frame(maxWidth: 24, maxHeight: 24)
//                        }
//                        .padding()
////                        .tint(Color("Black-White"))
//                        .background(Color(stopwatchViewModel.title.rawValue))
//                    } else if timerViewModel.timerState != PlayerState.STOPPED {
//                        HStack(spacing: 16) {
//                            Image(systemName: titleImageDictionary[timerViewModel.title.rawValue] ?? "")
//                                .font(.system(size: 24))
//                                .frame(maxWidth: 15, maxHeight: 15)
//                                .padding()
//                                .background(Color("White-Black"))
//                                .clipShape(Circle())
//
//                            VStack(alignment: .leading, spacing: 4) { // 내용물이 앞쪽 정렬됨.
//                                Text(timerViewModel.title.koreanValue)
//                                    .bodyMedium()
//
//                                getHorizontalTimeView(Int(timerViewModel.remainingTime))
//                                    .font(.custom("ChivoMono-Regular", size: 18))
//                            }
//                            .frame(maxWidth: .infinity, alignment: .leading) // 프레임의 내용물이 앞쪽부터 채워짐.
//
//                            if timerViewModel.timerState == PlayerState.PAUSED {
//                                // 정지 버튼
//                                Button(action: {
//                                    timerViewModel.stopTimer()
//                                }) {
//                                    Image(systemName: "stop.fill")
//                                        .font(.system(size: 24))
//                                }
//                                .frame(maxWidth: 24, maxHeight: 24)
//                            }
//
//                            // 시작, 중지 선택 버튼
//                            Button(action: {
//                                if timerViewModel.timerState == PlayerState.STARTED {
//                                    timerViewModel.pauseTimer()
//                                } else {
//                                    timerViewModel.startTimer()
//                                }
//                            }) {
//                                Image(systemName: timerViewModel.timerState == PlayerState.STARTED ? "pause.fill" : "play.fill")
//                                    .font(.system(size: 24))
//                            }
//                            .frame(maxWidth: 24, maxHeight: 24)
//                        }
//                        .padding()
//                        .background(Color(timerViewModel.title.rawValue))
//                    }
//                }
//                .tabItem {
//                    Image(systemName: stopwatchViewModel.stopwatchTopBottomBarVisible && timerViewModel.timerTopBottomBarVisible ? "house.fill" : "")
//                }
//                .tag(0)
//
//                WiDToolView()
//                    .tabItem {
//                        Image(systemName: stopwatchViewModel.stopwatchTopBottomBarVisible && timerViewModel.timerTopBottomBarVisible ? "plus.app" : "")
//                    }
//                    .tag(1)
//
//                VStack(spacing: 0) {
//                    WiDDisplayView()
//
//                    if stopwatchViewModel.stopwatchState != PlayerState.STOPPED {
//                        HStack(spacing: 16) {
//                            Image(systemName: titleImageDictionary[stopwatchViewModel.title.rawValue] ?? "")
//                                .font(.system(size: 24))
//                                .frame(maxWidth: 15, maxHeight: 15)
//                                .padding()
//                                .background(Color("White-Black"))
//                                .clipShape(Circle())
//
//                            VStack(alignment: .leading, spacing: 4) { // 내용물이 앞쪽 정렬됨.
//                                Text(stopwatchViewModel.title.koreanValue)
//                                    .bodyMedium()
//
//                                getHorizontalTimeView(Int(stopwatchViewModel.totalDuration))
//                                    .font(.custom("ChivoMono-Regular", size: 18))
//                            }
//                            .frame(maxWidth: .infinity, alignment: .leading) // 프레임의 내용물이 앞쪽부터 채워짐.
//
//                            if stopwatchViewModel.stopwatchState == PlayerState.PAUSED {
//                                // 정지 버튼
//                                Button(action: {
//                                    stopwatchViewModel.stopStopwatch()
//                                }) {
//                                    Image(systemName: "stop.fill")
//                                        .font(.system(size: 24))
//                                }
//                                .frame(maxWidth: 24, maxHeight: 24)
//                            }
//
//                            // 시작, 중지 선택 버튼
//                            Button(action: {
//                                if stopwatchViewModel.stopwatchState == PlayerState.STARTED {
//                                    stopwatchViewModel.pauseStopwatch()
//                                } else {
//                                    stopwatchViewModel.startStopwatch()
//                                }
//                            }) {
//                                Image(systemName: stopwatchViewModel.stopwatchState == PlayerState.STARTED ? "pause.fill" : "play.fill")
//                                    .font(.system(size: 24))
//                            }
//                            .frame(maxWidth: 24, maxHeight: 24)
//                        }
//                        .padding()
////                        .tint(Color("Black-White"))
//                        .background(Color(stopwatchViewModel.title.rawValue))
//                    } else if timerViewModel.timerState != PlayerState.STOPPED {
//                        HStack(spacing: 16) {
//                            Image(systemName: titleImageDictionary[timerViewModel.title.rawValue] ?? "")
//                                .font(.system(size: 24))
//                                .frame(maxWidth: 15, maxHeight: 15)
//                                .padding()
//                                .background(Color("White-Black"))
//                                .clipShape(Circle())
//
//                            VStack(alignment: .leading, spacing: 4) { // 내용물이 앞쪽 정렬됨.
//                                Text(timerViewModel.title.koreanValue)
//                                    .bodyMedium()
//
//                                getHorizontalTimeView(Int(timerViewModel.remainingTime))
//                                    .font(.custom("ChivoMono-Regular", size: 18))
//                            }
//                            .frame(maxWidth: .infinity, alignment: .leading) // 프레임의 내용물이 앞쪽부터 채워짐.
//
//                            if timerViewModel.timerState == PlayerState.PAUSED {
//                                // 정지 버튼
//                                Button(action: {
//                                    timerViewModel.stopTimer()
//                                }) {
//                                    Image(systemName: "stop.fill")
//                                        .font(.system(size: 24))
//                                }
//                                .frame(maxWidth: 24, maxHeight: 24)
//                            }
//
//                            // 시작, 중지 선택 버튼
//                            Button(action: {
//                                if timerViewModel.timerState == PlayerState.STARTED {
//                                    timerViewModel.pauseTimer()
//                                } else {
//                                    timerViewModel.startTimer()
//                                }
//                            }) {
//                                Image(systemName: timerViewModel.timerState == PlayerState.STARTED ? "pause.fill" : "play.fill")
//                                    .font(.system(size: 24))
//                            }
//                            .frame(maxWidth: 24, maxHeight: 24)
//                        }
//                        .padding()
//                        .background(Color(timerViewModel.title.rawValue))
//                    }
//                }
//                .tabItem {
//                    Image(systemName: stopwatchViewModel.stopwatchTopBottomBarVisible && timerViewModel.timerTopBottomBarVisible ? "deskclock" : "")
//                }
//                .tag(2)
//
//                VStack(spacing: 0) {
//                    DiaryDisplayView()
//
//                    if stopwatchViewModel.stopwatchState != PlayerState.STOPPED {
//                        HStack(spacing: 16) {
//                            Image(systemName: titleImageDictionary[stopwatchViewModel.title.rawValue] ?? "")
//                                .font(.system(size: 24))
//                                .frame(maxWidth: 15, maxHeight: 15)
//                                .padding()
//                                .background(Color("White-Black"))
//                                .clipShape(Circle())
//
//                            VStack(alignment: .leading, spacing: 4) { // 내용물이 앞쪽 정렬됨.
//                                Text(stopwatchViewModel.title.koreanValue)
//                                    .bodyMedium()
//
//                                getHorizontalTimeView(Int(stopwatchViewModel.totalDuration))
//                                    .font(.custom("ChivoMono-Regular", size: 18))
//                            }
//                            .frame(maxWidth: .infinity, alignment: .leading) // 프레임의 내용물이 앞쪽부터 채워짐.
//
//                            if stopwatchViewModel.stopwatchState == PlayerState.PAUSED {
//                                // 정지 버튼
//                                Button(action: {
//                                    stopwatchViewModel.stopStopwatch()
//                                }) {
//                                    Image(systemName: "stop.fill")
//                                        .font(.system(size: 24))
//                                }
//                                .frame(maxWidth: 24, maxHeight: 24)
//                            }
//
//                            // 시작, 중지 선택 버튼
//                            Button(action: {
//                                if stopwatchViewModel.stopwatchState == PlayerState.STARTED {
//                                    stopwatchViewModel.pauseStopwatch()
//                                } else {
//                                    stopwatchViewModel.startStopwatch()
//                                }
//                            }) {
//                                Image(systemName: stopwatchViewModel.stopwatchState == PlayerState.STARTED ? "pause.fill" : "play.fill")
//                                    .font(.system(size: 24))
//                            }
//                            .frame(maxWidth: 24, maxHeight: 24)
//                        }
//                        .padding()
////                        .tint(Color("Black-White"))
//                        .background(Color(stopwatchViewModel.title.rawValue))
//                    } else if timerViewModel.timerState != PlayerState.STOPPED {
//                        HStack(spacing: 16) {
//                            Image(systemName: titleImageDictionary[timerViewModel.title.rawValue] ?? "")
//                                .font(.system(size: 24))
//                                .frame(maxWidth: 15, maxHeight: 15)
//                                .padding()
//                                .background(Color("White-Black"))
//                                .clipShape(Circle())
//
//                            VStack(alignment: .leading, spacing: 4) { // 내용물이 앞쪽 정렬됨.
//                                Text(timerViewModel.title.koreanValue)
//                                    .bodyMedium()
//
//                                getHorizontalTimeView(Int(timerViewModel.remainingTime))
//                                    .font(.custom("ChivoMono-Regular", size: 18))
//                            }
//                            .frame(maxWidth: .infinity, alignment: .leading) // 프레임의 내용물이 앞쪽부터 채워짐.
//
//                            if timerViewModel.timerState == PlayerState.PAUSED {
//                                // 정지 버튼
//                                Button(action: {
//                                    timerViewModel.stopTimer()
//                                }) {
//                                    Image(systemName: "stop.fill")
//                                        .font(.system(size: 24))
//                                }
//                                .frame(maxWidth: 24, maxHeight: 24)
//                            }
//
//                            // 시작, 중지 선택 버튼
//                            Button(action: {
//                                if timerViewModel.timerState == PlayerState.STARTED {
//                                    timerViewModel.pauseTimer()
//                                } else {
//                                    timerViewModel.startTimer()
//                                }
//                            }) {
//                                Image(systemName: timerViewModel.timerState == PlayerState.STARTED ? "pause.fill" : "play.fill")
//                                    .font(.system(size: 24))
//                            }
//                            .frame(maxWidth: 24, maxHeight: 24)
//                        }
//                        .padding()
//                        .background(Color(timerViewModel.title.rawValue))
//                    }
//                }
//                .tabItem {
//                    Image(systemName: stopwatchViewModel.stopwatchTopBottomBarVisible && timerViewModel.timerTopBottomBarVisible ? "menucard" : "")
//                }
//                .tag(3)
//
//                VStack(spacing: 0) {
//                    SettingView()
//
//                    if stopwatchViewModel.stopwatchState != PlayerState.STOPPED {
//                        HStack(spacing: 16) {
//                            Image(systemName: titleImageDictionary[stopwatchViewModel.title.rawValue] ?? "")
//                                .font(.system(size: 24))
//                                .frame(maxWidth: 15, maxHeight: 15)
//                                .padding()
//                                .background(Color("White-Black"))
//                                .clipShape(Circle())
//
//                            VStack(alignment: .leading, spacing: 4) { // 내용물이 앞쪽 정렬됨.
//                                Text(stopwatchViewModel.title.koreanValue)
//                                    .bodyMedium()
//
//                                getHorizontalTimeView(Int(stopwatchViewModel.totalDuration))
//                                    .font(.custom("ChivoMono-Regular", size: 18))
//                            }
//                            .frame(maxWidth: .infinity, alignment: .leading) // 프레임의 내용물이 앞쪽부터 채워짐.
//
//                            if stopwatchViewModel.stopwatchState == PlayerState.PAUSED {
//                                // 정지 버튼
//                                Button(action: {
//                                    stopwatchViewModel.stopStopwatch()
//                                }) {
//                                    Image(systemName: "stop.fill")
//                                        .font(.system(size: 24))
//                                }
//                                .frame(maxWidth: 24, maxHeight: 24)
//                            }
//
//                            // 시작, 중지 선택 버튼
//                            Button(action: {
//                                if stopwatchViewModel.stopwatchState == PlayerState.STARTED {
//                                    stopwatchViewModel.pauseStopwatch()
//                                } else {
//                                    stopwatchViewModel.startStopwatch()
//                                }
//                            }) {
//                                Image(systemName: stopwatchViewModel.stopwatchState == PlayerState.STARTED ? "pause.fill" : "play.fill")
//                                    .font(.system(size: 24))
//                            }
//                            .frame(maxWidth: 24, maxHeight: 24)
//                        }
//                        .padding()
////                        .tint(Color("Black-White"))
//                        .background(Color(stopwatchViewModel.title.rawValue))
//                    } else if timerViewModel.timerState != PlayerState.STOPPED {
//                        HStack(spacing: 16) {
//                            Image(systemName: titleImageDictionary[timerViewModel.title.rawValue] ?? "")
//                                .font(.system(size: 24))
//                                .frame(maxWidth: 15, maxHeight: 15)
//                                .padding()
//                                .background(Color("White-Black"))
//                                .clipShape(Circle())
//
//                            VStack(alignment: .leading, spacing: 4) { // 내용물이 앞쪽 정렬됨.
//                                Text(timerViewModel.title.koreanValue)
//                                    .bodyMedium()
//
//                                getHorizontalTimeView(Int(timerViewModel.remainingTime))
//                                    .font(.custom("ChivoMono-Regular", size: 18))
//                            }
//                            .frame(maxWidth: .infinity, alignment: .leading) // 프레임의 내용물이 앞쪽부터 채워짐.
//
//                            if timerViewModel.timerState == PlayerState.PAUSED {
//                                // 정지 버튼
//                                Button(action: {
//                                    timerViewModel.stopTimer()
//                                }) {
//                                    Image(systemName: "stop.fill")
//                                        .font(.system(size: 24))
//                                }
//                                .frame(maxWidth: 24, maxHeight: 24)
//                            }
//
//                            // 시작, 중지 선택 버튼
//                            Button(action: {
//                                if timerViewModel.timerState == PlayerState.STARTED {
//                                    timerViewModel.pauseTimer()
//                                } else {
//                                    timerViewModel.startTimer()
//                                }
//                            }) {
//                                Image(systemName: timerViewModel.timerState == PlayerState.STARTED ? "pause.fill" : "play.fill")
//                                    .font(.system(size: 24))
//                            }
//                            .frame(maxWidth: 24, maxHeight: 24)
//                        }
//                        .padding()
//                        .background(Color(timerViewModel.title.rawValue))
//                    }
//                }
//                .tabItem {
//                    Image(systemName: stopwatchViewModel.stopwatchTopBottomBarVisible && timerViewModel.timerTopBottomBarVisible ? "gearshape.fill" : "")
//                }
//                .tag(4)
//            }
//            .tint(
//                stopwatchViewModel.stopwatchTopBottomBarVisible && timerViewModel.timerTopBottomBarVisible ? Color("Black-White") : Color("White-Black")
//            )
        }
//        .onChange(of: selectedTabIndex) { newIndex in
//            if stopwatchViewModel.stopwatchTopBottomBarVisible && timerViewModel.timerTopBottomBarVisible {
//                self.selectedTabIndex = newIndex
//            } else {
//                self.selectedTabIndex = 1 // 스톱 워치나 타이머 동작 시 탭을 클릭해도 '도구' 탭으로 오도록 해서 다른 탭을 사용하지 못하도록 함.
//            }
//        }
//        .onAppear {
//            UITabBar.appearance().backgroundColor = UIColor(Color("White-Black"))
//        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainView()
                .environmentObject(StopwatchViewModel())
                .environmentObject(TimerViewModel())
                .environment(\.colorScheme, .light)
            
            MainView()
                .environmentObject(StopwatchViewModel())
                .environmentObject(TimerViewModel())
                .environment(\.colorScheme, .dark)
        }
    }
}
