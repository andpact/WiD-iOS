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
            .frame(maxWidth: .infinity, maxHeight: 44)
            .padding(.horizontal)
            .disabled(!(stopwatchPlayer.stopwatchState == PlayerState.STOPPED && timerPlayer.timerState == PlayerState.STOPPED))
            .opacity(stopwatchPlayer.stopwatchState == PlayerState.STOPPED && timerPlayer.timerState == PlayerState.STOPPED ? 1 : 0)
            .background(Color("White-Black"))
            .cornerRadius(radius: 16, corners: [.topLeft, .topRight])
         
            // 컨텐츠
            WiDToolHolderView(tabItem: selectedTab)
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            if value.translation.width > 100 {
                                if selectedTab == .TIMER {
                                    withAnimation {
                                        selectedTab = .STOPWATCH
                                    }
                                } else if selectedTab == .POMODORO {
                                    withAnimation {
                                        selectedTab = .TIMER
                                    }
                                } else if selectedTab == .WiDLIST {
                                    withAnimation {
                                        selectedTab = .POMODORO
                                    }
                                }
                            }
                            
                            if value.translation.width < -100 {
                                if selectedTab == .STOPWATCH {
                                    withAnimation {
                                        selectedTab = .TIMER
                                    }
                                } else if selectedTab == .TIMER {
                                    withAnimation {
                                        selectedTab = .POMODORO
                                    }
                                } else if selectedTab == .POMODORO {
                                    withAnimation {
                                        selectedTab = .WiDLIST
                                    }
                                }
                            }
                        }
                )
        }
        .background(stopwatchPlayer.stopwatchState == PlayerState.STOPPED && timerPlayer.timerState == PlayerState.STOPPED ? Color("LimeGreen") : Color("White-Black"))
        .onAppear {
            // 스톱 워치나 타이머를 실행후, 이전 화면으로 전환 후 다시 돌아왔을 때 
            if stopwatchPlayer.stopwatchState == PlayerState.STARTED {
                selectedTab = .STOPWATCH
            } else if timerPlayer.timerState == PlayerState.STARTED {
                selectedTab = .TIMER
            }
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

//step 1 -- Create a shape view which can give shape
struct CornerRadiusShape: Shape {
    var radius = CGFloat.infinity
    var corners = UIRectCorner.allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

//step 2 - embed shape in viewModifier to help use with ease
struct CornerRadiusStyle: ViewModifier {
    var radius: CGFloat
    var corners: UIRectCorner
    func body(content: Content) -> some View {
        content
            .clipShape(CornerRadiusShape(radius: radius, corners: corners))
    }
}
//step 3 - crate a polymorphic view with same name as swiftUI's cornerRadius
extension View {
    func cornerRadius(radius: CGFloat, corners: UIRectCorner) -> some View {
        ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners))
    }
}
