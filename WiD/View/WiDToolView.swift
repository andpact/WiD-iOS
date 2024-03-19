//
//  WiDCreateView.swift
//  WiD
//
//  Created by jjkim on 2024/02/06.
//

import SwiftUI

enum WiDToolViewTapItem : String, CaseIterable {
    case STOPWATCH = "스톱 워치"
    case TIMER = "타이머"
    // 포모 도로 기능, 뷰 구성 후 활성화하자.
//    case POMODORO = "포모 도로"
    case WiDLIST = "WiD 리스트"
}

struct WiDToolView: View {
    // 화면
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedTab: WiDToolViewTapItem = .STOPWATCH
    @Namespace private var animation
    
    // 뷰 모델
    @EnvironmentObject var stopwatchViewModel: StopwatchViewModel
    @EnvironmentObject var timerViewModel: TimerViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // 상단 바
            HStack {
                Text("도구")
                    .titleLarge()
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: 44)
            .padding(.horizontal)
            .background(Color("LightGray-Gray"))
            .opacity(stopwatchViewModel.stopwatchTopBottomBarVisible && timerViewModel.timerTopBottomBarVisible ? 1 : 0)
            
            
            // 상단 탭
            ScrollView(.horizontal) {
                HStack(alignment: .top, spacing: 16) {
                    ForEach(WiDToolViewTapItem.allCases, id: \.self) { item in
                        VStack(spacing: 8) {
                            Text(item.rawValue)
                                .bodyMedium()
                                .foregroundColor(selectedTab == item ? Color("Black-White") : Color("DarkGray"))

                            if selectedTab == item {
                                Rectangle()
                                    .foregroundColor(Color("Black-White"))
                                    .frame(maxWidth: 40, maxHeight: 3)
                                    .matchedGeometryEffect(id: "STOPWATCH", in: animation)
                            }
                                
                        }
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                self.selectedTab = item
                            }
                        }
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: 44)
                .padding(.horizontal)
            }
            .background(Color("White-Black"))
            .cornerRadius(radius: 32, corners: [.topLeft, .topRight])
            .background(Color("LightGray-Gray"))
            .disabled(!(stopwatchViewModel.stopwatchState == PlayerState.STOPPED && timerViewModel.timerState == PlayerState.STOPPED))
            .opacity(stopwatchViewModel.stopwatchState == PlayerState.STOPPED && timerViewModel.timerState == PlayerState.STOPPED ? 1 : 0)
         
            // 컨텐츠
            WiDToolHolderView(tabItem: selectedTab)
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            if value.translation.width > 100 && (stopwatchViewModel.stopwatchState == PlayerState.STOPPED && timerViewModel.timerState == PlayerState.STOPPED) {
                                if selectedTab == .TIMER {
                                    selectedTab = .STOPWATCH
                                } else if selectedTab == .WiDLIST {
                                    selectedTab = .TIMER
                                }
                                
//                                if selectedTab == .TIMER {
//                                    selectedTab = .STOPWATCH
//                                } else if selectedTab == .POMODORO {
//                                    selectedTab = .TIMER
//                                } else if selectedTab == .WiDLIST {
//                                    selectedTab = .POMODORO
//                                }
                            }
                            
                            if value.translation.width < -100 && (stopwatchViewModel.stopwatchState == PlayerState.STOPPED && timerViewModel.timerState == PlayerState.STOPPED) {
                                if selectedTab == .STOPWATCH {
                                    selectedTab = .TIMER
                                } else if selectedTab == .TIMER {
                                    selectedTab = .WiDLIST
                                }
                                
//                                if selectedTab == .STOPWATCH {
//                                    selectedTab = .TIMER
//                                } else if selectedTab == .TIMER {
//                                    selectedTab = .POMODORO
//                                } else if selectedTab == .POMODORO {
//                                    selectedTab = .WiDLIST
//                                }
                            }
                        }
                )
        }
        .onAppear {
            print("WiDToolView appeared")
            
            // 스톱 워치나 타이머를 실행후, 이전 화면으로 전환 후 다시 돌아왔을 때 
            if stopwatchViewModel.stopwatchState == PlayerState.STARTED || stopwatchViewModel.stopwatchState == PlayerState.PAUSED {
                selectedTab = .STOPWATCH
            } else if timerViewModel.timerState == PlayerState.STARTED || timerViewModel.timerState == PlayerState.PAUSED {
                selectedTab = .TIMER
            }
        }
        .onDisappear {
            print("WiDToolView disappeared")
        }
    }
}

struct WiDToolHolderView : View {
    var tabItem: WiDToolViewTapItem
    
    var body: some View {
        VStack {
            switch tabItem {
            case .STOPWATCH:
                StopwatchView()
            case .TIMER:
                TimerView()
//            case .POMODORO:
//                PomodoroView()
            case .WiDLIST:
                WiDListView()
            }
        }
    }
}

struct WiDToolView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WiDToolView()
                .environmentObject(StopwatchViewModel())
                .environmentObject(TimerViewModel())
                .environment(\.colorScheme, .light)
            
            WiDToolView()
                .environmentObject(StopwatchViewModel())
                .environmentObject(TimerViewModel())
                .environment(\.colorScheme, .dark)
        }
    }
}
