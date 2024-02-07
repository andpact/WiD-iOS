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
    case POMODORO = "포모 도로"
    case WiDLIST = "WiD 리스트"
}

struct WiDToolView: View {
    // 화면
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedTab: WiDToolViewTapItem = .STOPWATCH
    @Namespace private var animation
    @GestureState private var translation: CGFloat = 0
    
    // 도구
    @EnvironmentObject var stopwatchPlayer: StopwatchPlayer
    @EnvironmentObject var timerPlayer: TimerPlayer
    
    var body: some View {
        VStack(spacing: 0) {
            // 상단 바
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.backward")
                        .font(.system(size: 24))
                }
                
                Text("WiD 도구")
                    .titleLarge()
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: 44)
            .padding(.horizontal)
            .tint(Color("Black-White"))
            .opacity(stopwatchPlayer.stopwatchTopBottomBarVisible && timerPlayer.timerTopBottomBarVisible ? 1 : 0)
            
            // 상단 탭
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
            }
            .frame(maxWidth: .infinity, maxHeight: 44, alignment: .leading)
            .padding(.horizontal)
            .disabled(!(stopwatchPlayer.stopwatchState == PlayerState.STOPPED && timerPlayer.timerState == PlayerState.STOPPED))
            .opacity(stopwatchPlayer.stopwatchState == PlayerState.STOPPED && timerPlayer.timerState == PlayerState.STOPPED ? 1 : 0)
         
            // 컨텐츠
            WiDToolHolderView(tabItem: selectedTab)
                .gesture(
                    DragGesture().updating($translation) { value, state, _ in
                        state = value.translation.width
                    }
                    .onEnded { value in
                        if stopwatchPlayer.stopwatchState == PlayerState.STOPPED && timerPlayer.timerState == PlayerState.STOPPED {
                            let offset = value.translation.width
                            if offset > 50 {
                                // 스와이프 우측으로 이동하면 이전 탭으로 변경
                                withAnimation {
                                    changeTab(by: -1)
                                }
                            } else if offset < -50 {
                                // 스와이프 좌측으로 이동하면 다음 탭으로 변경
                                withAnimation {
                                    changeTab(by: 1)
                                }
                            }
                        }
                    }
                )
        }
    }
    
    private func changeTab(by offset: Int) {
        guard let currentIndex = WiDToolViewTapItem.allCases.firstIndex(of: selectedTab) else {
            return
        }
        let newIndex = (currentIndex + offset + WiDToolViewTapItem.allCases.count) % WiDToolViewTapItem.allCases.count
        selectedTab = WiDToolViewTapItem.allCases[newIndex]
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
            case .POMODORO:
                PomodoroView()
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
                .environmentObject(StopwatchPlayer())
                .environmentObject(TimerPlayer())
                .environment(\.colorScheme, .light)
            
            WiDToolView()
                .environmentObject(StopwatchPlayer())
                .environmentObject(TimerPlayer())
                .environment(\.colorScheme, .dark)
        }
    }
}
