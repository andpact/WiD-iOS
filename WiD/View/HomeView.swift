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
//    private let wiDService = WiDService()
//    @State private var wiDList: [WiD] = []
    
    // 도구
    @EnvironmentObject var stopwatchPlayer: StopwatchPlayer
    @EnvironmentObject var timerPlayer: TimerPlayer
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            /**
             상단 바
             */
//            ZStack {
//                Text("WiD")
//                    .titleLarge()
//            }
//            .padding(.horizontal)
//            .frame(maxWidth: .infinity, maxHeight: 44)
            
            NavigationView { // 네비게이션 출발지는 무조건 네비게이션 뷰로 감싸야함.
                VStack(spacing: 0) {
                    Spacer()
                    
                    Text("달력")
                    
                    Spacer()
                    
                    Text("총 WiD 갯수, 다이어리 수")
                    
                    Spacer()
                    
                    HStack(spacing: 0) {
                        NavigationLink(destination: WiDToolView()) {
                            Image(systemName: "plus.app")
                                .frame(maxWidth: .infinity)
                                .font(.system(size: 36))
                        }

                        NavigationLink(destination: WiDDisplayView()) {
                            Image(systemName: "deskclock")
                                .frame(maxWidth: .infinity)
                                .font(.system(size: 36))
                        }

                        NavigationLink(destination: DiaryDisplayView()) {
                            Image(systemName: "square.text.square")
                                .frame(maxWidth: .infinity)
                                .font(.system(size: 36))
                        }

                        NavigationLink(destination: SettingView()) {
                            Image(systemName: "gearshape")
                                .frame(maxWidth: .infinity)
                                .font(.system(size: 36))
                        }
                    }
                    .padding()
                    .background(Color("White-Gray"))
                    .cornerRadius(8)
                    .padding()
                }
                .background(Color("LightGray-Black")) // 배경 색을 여기 지정해야 적용됨.
                .tint(Color("Black-White"))
            }
            
            if stopwatchPlayer.stopwatchState != PlayerState.STOPPED && !stopwatchPlayer.inStopwatchView {
                HStack {
                    Text(stopwatchPlayer.title.koreanValue)
                        .bodyMedium()
                    
                    getHorizontalTimeView(stopwatchPlayer.elapsedTime)
                        .font(.custom("ChivoMono-Regular", size: 18))
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color(stopwatchPlayer.stopwatchState == PlayerState.STARTED ? "LimeGreen" : "OrangeRed"))
                .foregroundColor(Color("White"))
                .cornerRadius(8)
                .frame(maxHeight: 44)
                .padding(.horizontal)
            }
            
            if timerPlayer.timerState != PlayerState.STOPPED && !timerPlayer.inTimerView {
                HStack {
                    Text(timerPlayer.title.koreanValue)
                        .bodyMedium()
                    
                    getHorizontalTimeView(timerPlayer.remainingTime)
                        .font(.custom("ChivoMono-Regular", size: 18))
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color(timerPlayer.timerState == PlayerState.STARTED ? "LimeGreen" : "OrangeRed"))
                .foregroundColor(Color("White"))
                .cornerRadius(8)
                .frame(maxHeight: 44)
                .padding(.horizontal)
            }
        }
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
