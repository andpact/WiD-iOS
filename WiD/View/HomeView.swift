//
//  HomeView.swift
//  WiD
//
//  Created by jjkim on 2023/12/02.
//

import SwiftUI

struct HomeView: View {
    // 날짜
    private let calendar = Calendar.current
    @State private var today = Date()
    @State private var remainingTime: TimeInterval = 0
    
    // 도구
    @EnvironmentObject var stopwatchPlayer: StopwatchPlayer
    @EnvironmentObject var timerPlayer: TimerPlayer
    
    var body: some View {
        VStack(spacing: 0) {
            if !stopwatchPlayer.reset && !stopwatchPlayer.inStopwatchView {
                ZStack {
                    Text("스톱 워치")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bodyMedium()
                    
                    HStack {
                        Text(stopwatchPlayer.title.koreanValue)
                        
                        formatTimerTime(stopwatchPlayer.elapsedTime)
                            .font(.system(.body, design: .monospaced))
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .bodyMedium()
                }
                .padding(.horizontal)
                .background(Color(stopwatchPlayer.started ? "LimeGreen" : "OrangeRed"))
                .foregroundColor(Color("White"))
                .frame(maxWidth: .infinity, maxHeight: 22)
            }
            
            if !timerPlayer.reset && !timerPlayer.inTimerView {
                ZStack {
                    Text("타이머")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bodyMedium()
                    
                    HStack {
                        Text(timerPlayer.title.koreanValue)
                        
                        formatTimerTime(timerPlayer.remainingTime)
                            .font(.system(.body, design: .monospaced))
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .bodyMedium()
                }
                .padding(.horizontal)
                .background(Color(timerPlayer.started ? "LimeGreen" : "OrangeRed"))
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
                    
//                    HStack(spacing: 16) {
//                        Text("광고\n이미지")
//                            .padding(8)
//                            .multilineTextAlignment(.center)
//                            .background(Color("DarkGray"))
//                            .cornerRadius(8)
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
//                    .cornerRadius(8)
//                    .padding(.horizontal)
                    
                    Spacer()
                    
                    HStack(alignment: .top, spacing: 16) {
                        VStack(spacing: 4) {
                            HStack(spacing: 16) {
                                VStack(spacing: 4) {
                                    NavigationLink(destination: StopwatchView()) {
                                        Image(systemName: "stopwatch")
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                            .aspectRatio(1, contentMode: .fit)
                                            .font(.system(size: 30))
                                            .background(Color("LightGray-Gray"))
                                            .cornerRadius(8)
                                    }
                                    .disabled(!timerPlayer.reset)
                                    
                                    Text("스톱 워치")
                                        .bodySmall()
                                }
                                
                                VStack(spacing: 4) {
                                    NavigationLink(destination: TimerView()) {
                                        Image(systemName: "timer")
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                            .aspectRatio(1, contentMode: .fit)
                                            .font(.system(size: 30))
                                            .background(Color("LightGray-Gray"))
                                            .cornerRadius(8)
                                    }
                                    .disabled(!stopwatchPlayer.reset)

                                    Text("타이머")
                                        .bodySmall()
                                }
                            }

                            VStack(spacing: 4) {
                                NavigationLink(destination: NewWiDView()) {
                                    Image(systemName: "plus.square")
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .aspectRatio(2.5 / 1, contentMode: .fit)
                                        .font(.system(size: 30))
                                        .background(Color("LightGray-Gray"))
                                        .cornerRadius(8)
                                }
                                .disabled(!timerPlayer.reset || !stopwatchPlayer.reset)

                                Text("새로운 WiD")
                                    .bodySmall()
                            }
                            
                            VStack(spacing: 4) {
                                VStack {
                                    Text("오늘")
                                    
                                    Text(formatTime(today, format: "HH:mm:ss"))
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .aspectRatio(1, contentMode: .fit)
                                .font(.system(size: 30))
                                .background(Color("LightGray-Gray"))
                                .cornerRadius(8)
                                
                                Text("남은 시간")
                                    .bodySmall()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        VStack(spacing: 4) {
                            VStack(spacing: 4) {
                                Image(systemName: "chart.pie")
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .aspectRatio(1, contentMode: .fit)
                                    .font(.system(size: 30))
                                    .background(Color("LightGray-Gray"))
                                    .cornerRadius(8)
                                
                                Text("88일 전")
                                    .bodySmall()
                            }
                            
                            HStack(spacing: 16) {
                                VStack(spacing: 4) {
                                    NavigationLink(destination: DateBasedView()) {
                                        Image(systemName: "scope")
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                            .aspectRatio(1, contentMode: .fit)
                                            .font(.system(size: 30))
                                            .background(Color("LightGray-Gray"))
                                            .cornerRadius(8)
                                    }
                                    
                                    Text("날짜 조회")
                                        .bodySmall()
                                }
                                
                                VStack(spacing: 4) {
                                    NavigationLink(destination: PeriodBasedView()) {
                                        Image(systemName: "calendar")
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                            .aspectRatio(1, contentMode: .fit)
                                            .font(.system(size: 30))
                                            .background(Color("LightGray-Gray"))
                                            .cornerRadius(8)
                                    }
                                    
                                    Text("기간 조회")
                                        .bodySmall()
                                }
                            }
                            
                            VStack(spacing: 4) {
                                NavigationLink(destination: SearchView()) {
                                    Image(systemName: "magnifyingglass")
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .aspectRatio(2.5 / 1, contentMode: .fit)
                                        .font(.system(size: 30))
                                        .background(Color("LightGray-Gray"))
                                        .cornerRadius(8)
                                }

                                Text("다이어리 검색")
                                    .bodySmall()
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .tint(Color("Black-White"))
            }
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                today = Date()
            }
            
//            let midnightToday = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: today)!
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
