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
    @State private var remainingSeconds: Int = 0
    @State private var remainingPercentage: Float = 0
    private let totalSecondsInADay: Int = 24 * 60 * 60
    
    // WiD
    private let wiDService = WiDService()
    @State private var wiDList: [WiD] = []
    
    // 도구
    @EnvironmentObject var stopwatchPlayer: StopwatchPlayer
    @EnvironmentObject var timerPlayer: TimerPlayer
    
    @State private var timer: Timer?
    
    var body: some View {
        VStack(spacing: 0) {
            if !stopwatchPlayer.reset && !stopwatchPlayer.inStopwatchView {
                ZStack {
                    Text("스톱 워치")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bodyMedium()
                    
                    HStack {
                        Text(stopwatchPlayer.title.koreanValue)
                        
                        formatTimeHorizontally(stopwatchPlayer.elapsedTime)
                            .font(.custom("ChivoMono-Regular", size: 18))
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
                        
                        formatTimeHorizontally(timerPlayer.remainingTime)
                            .font(.custom("ChivoMono-Regular", size: 18))
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
                                ZStack {
                                    Text("오늘")
                                        .frame(maxHeight: .infinity, alignment: .top)
                                        .titleLarge()
                                    
                                    Text("\(Int(remainingPercentage))%")
                                        .font(.system(size: 50, weight: .black))
                                    
                                    formatTimeHorizontally(remainingSeconds)
                                        .frame(maxHeight: .infinity, alignment: .bottom)
                                        .font(.custom("ChivoMono-Regular", size: 20))
//                                        .font(.system(size: 18, weight: .medium, design: .monospaced))
                                }
                                .padding(.vertical)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .aspectRatio(1, contentMode: .fit)
                                .background(Color("LightGray-Gray"))
                                .cornerRadius(8)
                                
                                Text("남은 시간")
                                    .bodySmall()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        VStack(spacing: 4) {
                            VStack(spacing: 4) {
                                if wiDList.isEmpty {
                                    getEmptyViewWithMultipleLines(message: "표시할\n타임라인이\n없습니다.")
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .aspectRatio(1, contentMode: .fit)
                                        .background(Color("LightGray-Gray"))
                                        .cornerRadius(8)
                                    
                                    Text("타임라인")
                                        .bodySmall()
                                } else {
                                    DayPieChartView(wiDList: wiDList)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .aspectRatio(1, contentMode: .fit)
                                        .background(Color("LightGray-Gray"))
                                        .cornerRadius(8)
                                    
                                    let today = Date()
                                    let daysDifference = calendar.dateComponents([.day], from: wiDList.first?.date ?? today, to: today).day ?? 0
                                    
                                    Text(daysDifference == 0 ? "오늘" : daysDifference == 1 ? "어제" : "\(daysDifference)일 전")
                                        .bodySmall()
                                }
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
            wiDList = wiDService.selectWiDListByRandomDate()
            
            // 생성자 내에서 아래 변수를 초기화 하면, 화면이 나타났을 때, 렌더링이 안된다.
            let today = Date()
            let startOfToday = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: today)!
            let elepsedSecondsUntilNow = today.timeIntervalSince(startOfToday)

            remainingSeconds = totalSecondsInADay - Int(elepsedSecondsUntilNow)

            remainingPercentage = (Float(remainingSeconds) / Float(totalSecondsInADay)) * 100
            
            startTimer()
//
//            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
//                let today = Date()
//                let startOfToday = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: today)!
//                let elepsedSecondsUntilNow = today.timeIntervalSince(startOfToday)
//
//                remainingSeconds = totalSecondsInADay - Int(elepsedSecondsUntilNow)
//
//                remainingPercentage = (Float(remainingSeconds) / Float(totalSecondsInADay)) * 100
//            }
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            let today = Date()
            let startOfToday = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: today)!
            let elapsedSecondsUntilNow = today.timeIntervalSince(startOfToday)

            remainingSeconds = totalSecondsInADay - Int(elapsedSecondsUntilNow)

            remainingPercentage = (Float(remainingSeconds) / Float(totalSecondsInADay)) * 100
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
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
