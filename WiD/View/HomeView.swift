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
        VStack(spacing: 0) {
            if stopwatchPlayer.stopwatchState != PlayerState.STOPPED && !stopwatchPlayer.inStopwatchView {
                ZStack {
                    Text("스톱 워치")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bodyMedium()
                    
                    HStack {
                        Text(stopwatchPlayer.title.koreanValue)
                            .bodyMedium()
                        
                        getHorizontalTimeView(stopwatchPlayer.elapsedTime)
                            .font(.custom("ChivoMono-Regular", size: 18))
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.horizontal)
                .background(Color(stopwatchPlayer.stopwatchState == PlayerState.STARTED ? "LimeGreen" : "OrangeRed"))
                .foregroundColor(Color("White"))
                .frame(maxWidth: .infinity, maxHeight: 22)
            }
            
            if timerPlayer.timerState != PlayerState.STOPPED && !timerPlayer.inTimerView {
                ZStack {
                    Text("타이머")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bodyMedium()
                    
                    HStack {
                        Text(timerPlayer.title.koreanValue)
                            .bodyMedium()
                        
                        getHorizontalTimeView(timerPlayer.remainingTime)
                            .font(.custom("ChivoMono-Regular", size: 18))
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.horizontal)
                .background(Color(timerPlayer.timerState == PlayerState.STARTED ? "LimeGreen" : "OrangeRed"))
                .foregroundColor(Color("White"))
                .frame(maxWidth: .infinity, maxHeight: 22)
            }
            
            NavigationView { // 네비게이션 출발지는 무조건 네비게이션 뷰로 감싸야함.
                VStack(spacing: 16) {
                    /**
                     상단 바
                     */
                    ZStack {
                        Text("WiD")
                            .titleLarge()
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, maxHeight: 44)
//
//                    HStack(spacing: 16) {
//                        Text("광고\n이미지")
//                            .padding(8)
//                            .multilineTextAlignment(.center)
//                            .background(Color("DarkGray"))
//                            .cornerRadius(24)
//
//                        VStack {
//                            Text("광고 제목")
//                            Text("광고 내용")
//                        }
//                        .frame(maxWidth: .infinity, alignment: .leading)
//
//                        Image(systemName: "chevron.forward")
//                    }
//                    .padding()
//                    .background(Color("LightGray"))
//                    .cornerRadius(24)
//                    .padding(.horizontal)
                    
                    Spacer()
                    
                    HStack(alignment: .top, spacing: 32) {
                        VStack(spacing: 4) {
                            NavigationLink(destination: StopwatchView()) {
                                Image(systemName: "stopwatch")
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .aspectRatio(1, contentMode: .fit)
                                    .font(.system(size: 48))
                                    .background(Color("LightGray-Gray"))
                                    .cornerRadius(24)
                                    .shadow(color: Color("Black-White"), radius: 1)
                            }
                            .disabled(timerPlayer.timerState != PlayerState.STOPPED)
                            
                            Text("스톱 워치")
                                .bodyMedium()
                        }
                        
                        VStack(spacing: 4) {
                            NavigationLink(destination: TimerView()) {
                                Image(systemName: "timer")
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .aspectRatio(1, contentMode: .fit)
                                    .font(.system(size: 48))
                                    .background(Color("LightGray-Gray"))
                                    .cornerRadius(24)
                                    .shadow(color: Color("Black-White"), radius: 1)
                            }
                            .disabled(stopwatchPlayer.stopwatchState != PlayerState.STOPPED)

                            Text("타이머")
                                .bodyMedium()
                        }
                        
                        VStack(spacing: 4) {
                            NavigationLink(destination: NewWiDView()) {
                                Image(systemName: "plus.square")
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .aspectRatio(1 / 1, contentMode: .fit)
                                    .font(.system(size: 48))
                                    .background(Color("LightGray-Gray"))
                                    .cornerRadius(24)
                                    .shadow(color: Color("Black-White"), radius: 1)
                            }
                            .disabled(timerPlayer.timerState != PlayerState.STOPPED || stopwatchPlayer.stopwatchState != PlayerState.STOPPED)

                            Text("새로운 WiD")
                                .bodyMedium()
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.horizontal, 32)
                    
                    HStack(alignment: .top, spacing: 32) {
                        VStack(spacing: 4) {
                            NavigationLink(destination: DateBasedView()) {
                                Image(systemName: "scope")
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .aspectRatio(1, contentMode: .fit)
                                    .font(.system(size: 48))
                                    .background(Color("LightGray-Gray"))
                                    .cornerRadius(24)
                                    .shadow(color: Color("Black-White"), radius: 1)
                            }
                            
                            Text("날짜 조회")
                                .bodyMedium()
                        }
                        
                        VStack(spacing: 4) {
                            NavigationLink(destination: PeriodBasedView()) {
                                Image(systemName: "calendar")
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .aspectRatio(1, contentMode: .fit)
                                    .font(.system(size: 48))
                                    .background(Color("LightGray-Gray"))
                                    .cornerRadius(24)
                                    .shadow(color: Color("Black-White"), radius: 1)
                            }
                            
                            Text("기간 조회")
                                .bodyMedium()
                        }
                        
                        VStack(spacing: 4) {
                            NavigationLink(destination: SearchView()) {
                                Image(systemName: "magnifyingglass")
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .aspectRatio(1 / 1, contentMode: .fit)
                                    .font(.system(size: 48))
                                    .background(Color("LightGray-Gray"))
                                    .cornerRadius(24)
                                    .shadow(color: Color("Black-White"), radius: 1)
                            }

                            Text("다이어리 검색")
                                .bodyMedium()
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.horizontal, 32)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .tint(Color("Black-White"))
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
