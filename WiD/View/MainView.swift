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
}

struct MainView: View {
    // 화면
    @State private var selectedTab: MainViewTap = .HOME
    
    @EnvironmentObject private var stopwatchViewModel: StopwatchViewModel
    @EnvironmentObject private var timerViewModel: TimerViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                switch selectedTab {
                    case .HOME:
                        HomeView()
                    case .WiDTOOL:
                        WiDToolView()
                    case .WiDDISPLAY:
                        WiDDisplayView()
                    case .DIARYDISPLAY:
                        DiaryDisplayView()
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
                
                // 바텀 네비게이션
                HStack {
                    ForEach(MainViewTap.allCases, id: \.self) { tabItem in
                        Image(systemName: tabItem.rawValue)
                            .frame(maxWidth: .infinity)
                            .font(.system(size: 24))
                            .foregroundColor(selectedTab == tabItem ? Color("Black-White") : Color("DarkGray"))
                            .onTapGesture {
                                self.selectedTab = tabItem
                            }
                    }
                }
                .padding(.vertical)
                .background(Color("LightGray-Gray"))
                .opacity(stopwatchViewModel.stopwatchTopBottomBarVisible && timerViewModel.timerTopBottomBarVisible ? 1 : 0)
            }
        }
        .onAppear {
            print("MainView appeared")
        }
        .onDisappear {
            print("MainView disappeared")
        }
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
