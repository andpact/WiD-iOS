//
//  HomeView.swift
//  WiD
//
//  Created by jjkim on 2023/12/02.
//

import SwiftUI

struct HomeView: View {
    // 날짜
//    private let calendar = Calendar.current
//    @State private var remainingSeconds: Int = 0
//    @State private var remainingPercentage: Float = 0
//    private let totalSecondsInADay: Int = 24 * 60 * 60
    
    // WiD
    private let wiDService = WiDService()
    private let totalWiDCounts: Int
    
    // 다이어리
    private let diaryService = DiaryService()
    private let totalDiaryCounts: Int
    
    init() {
        self.totalWiDCounts = wiDService.readTotalWiDCount()
        self.totalDiaryCounts = diaryService.readTotalDiaryCount()
    }
    
    // 도구
//    @EnvironmentObject var stopwatchPlayer: StopwatchPlayer
//    @EnvironmentObject var timerPlayer: TimerPlayer
    
    var body: some View {
//        NavigationView { // 네비게이션 출발지는 무조건 네비게이션 뷰로 감싸야함.
            VStack(spacing: 0) {
//                ZStack {
//                    if stopwatchPlayer.stopwatchState != PlayerState.STOPPED && !stopwatchPlayer.inStopwatchView {
//                        HStack {
//                            Text(stopwatchPlayer.title.koreanValue)
//                                .bodyMedium()
//                            
//                            getHorizontalTimeView(Int(stopwatchPlayer.totalDuration))
//                                .font(.custom("ChivoMono-Regular", size: 18))
//                        }
//                        .padding(.horizontal, 8)
//                        .padding(.vertical, 4)
//                        .background(Color(stopwatchPlayer.stopwatchState == PlayerState.STARTED ? "LimeGreen" : "OrangeRed"))
//                        .foregroundColor(Color("White"))
//                        .cornerRadius(8)
//                    } else if timerPlayer.timerState != PlayerState.STOPPED && !timerPlayer.inTimerView {
//                        HStack {
//                            Text(timerPlayer.title.koreanValue)
//                                .bodyMedium()
//                            
//                            getHorizontalTimeView(Int(timerPlayer.remainingTime))
//                                .font(.custom("ChivoMono-Regular", size: 18))
//                        }
//                        .padding(.horizontal, 8)
//                        .padding(.vertical, 4)
//                        .background(Color(timerPlayer.timerState == PlayerState.STARTED ? "LimeGreen" : "OrangeRed"))
//                        .foregroundColor(Color("White"))
//                        .cornerRadius(8)
//                    } else {
//                        Text("WiD")
//                            .titleLarge()
//                    }
//                }
//                .padding(.horizontal)
//                .frame(maxWidth: .infinity, maxHeight: 44)
                
                Spacer()
                
                HStack {
                    Text("달력")
                        .titleLarge()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color("LightGray-Gray"))
                .cornerRadius(8)
                .padding()
                
                Spacer()
                
                HStack {
                    VStack(spacing: 16) {
                        Text("총 WiD")
                            .bodyMedium()
                        
                        Text("\(totalWiDCounts)개")
                            .titleLarge()
                    }
                    .frame(maxWidth: .infinity)
                    
                    VStack(spacing: 16) {
                        Text("총 다이어리")
                            .bodyMedium()
                        
                        Text("\(totalDiaryCounts)개")
                            .titleLarge()
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color("LightGray-Gray"))
                .cornerRadius(8)
                .padding()
                
                Spacer()
                
//                HStack(spacing: 0) {
//                    NavigationLink(destination: WiDToolView()) {
//                        Image(systemName: "plus.app")
//                            .frame(maxWidth: .infinity)
//                            .font(.system(size: 36))
//                    }
//
//                    NavigationLink(destination: WiDDisplayView()) {
//                        Image(systemName: "deskclock")
//                            .frame(maxWidth: .infinity)
//                            .font(.system(size: 36))
//                    }
//
//                    NavigationLink(destination: DiaryDisplayView()) {
//                        Image(systemName: "square.text.square")
//                            .frame(maxWidth: .infinity)
//                            .font(.system(size: 36))
//                    }
//
//                    NavigationLink(destination: SettingView()) {
//                        Image(systemName: "gearshape")
//                            .frame(maxWidth: .infinity)
//                            .font(.system(size: 36))
//                    }
//                }
//                .padding(.vertical)
//                .cornerRadius(8)
            }
//            .background(Color("White-Black"))
            .tint(Color("Black-White"))
//        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeView()
                .environmentObject(StopwatchPlayer())
                .environmentObject(TimerPlayer())
                .environment(\.colorScheme, .light)
            
            HomeView()
                .environmentObject(StopwatchPlayer())
                .environmentObject(TimerPlayer())
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
