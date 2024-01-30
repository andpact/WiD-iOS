//
//  WiDCreateView.swift
//  WiD
//
//  Created by jjkim on 2023/07/06.
//

import SwiftUI

/**
 제목, 날짜, 시작 시간은 스톱 워치 클래스에서 관리
 종료 시간, 소요 시간, WiD 생성 및 저장은 스톱 워치 뷰에서 관리
 */
struct StopwatchView: View {
    // 화면
    @Environment(\.presentationMode) var presentationMode
    @State private var stopwatchTopBottomBarVisible: Bool = true
    private let screenHeight = UIScreen.main.bounds.height
    
    // WiD
    private let wiDService = WiDService()
    
    // 날짜
    private let calendar = Calendar.current
    
    // 제목
    @State private var isTitleMenuExpanded: Bool = false
    
    // 스톱 워치
    @EnvironmentObject var stopwatchPlayer: StopwatchPlayer
    
    var body: some View {
        ZStack {
            /**
             상단 바
             */
            if stopwatchTopBottomBarVisible {
                ZStack {
                    ZStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "arrow.backward")
                                .font(.system(size: 24))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        Text("스톱워치")
                            .titleLarge()
                    }
                    .frame(maxWidth: .infinity, maxHeight: 44)
                    .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            
            /**
             컨텐츠
             */
            getVerticalTimeView(stopwatchPlayer.elapsedTime)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom, screenHeight / 2)
            
            /**
             하단 바
             */
            if stopwatchTopBottomBarVisible {
                VStack(spacing: 32) {
                    if stopwatchPlayer.stopwatchState == PlayerState.PAUSED {
                        Button(action: {
                            stopwatchPlayer.stopStopwatch()
                        }) {
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 32))
                        }
                    }
                    
                    HStack(spacing: 32) {
                        Button(action: {
                            withAnimation {
                                isTitleMenuExpanded.toggle()
                            }
                        }) {
                            Image(systemName: titleImageDictionary[stopwatchPlayer.title.rawValue] ?? "")
                                .font(.system(size: 32))
                        }
                        .frame(maxWidth: 40, maxHeight: 40)
                        .disabled(stopwatchPlayer.stopwatchState != PlayerState.STOPPED)
                        
                        Button(action: {
                            if stopwatchPlayer.stopwatchState == PlayerState.STARTED {
                                stopwatchPlayer.pauseStopwatch()
                                
                                let now = Date()
                                
                                createWiD(now: now)
                            } else {
                                stopwatchPlayer.startStopwatch()
                            }
                        }) {
                            Image(systemName: stopwatchPlayer.stopwatchState == PlayerState.STARTED ? "pause.fill" : "play.fill")
                                .font(.system(size: 32))
                        }
                        .frame(maxWidth: 40, maxHeight: 40)
                        .padding()
                        .background(stopwatchPlayer.stopwatchState == PlayerState.STARTED ? Color("OrangeRed") : (stopwatchPlayer.stopwatchState == PlayerState.PAUSED ? Color("LimeGreen") : Color("Black-White")))
                        .foregroundColor(stopwatchPlayer.stopwatchState == PlayerState.STOPPED ? Color("White-Black") : Color("White"))
                        .clipShape(Circle())
                        
                        Button(action: {
                            withAnimation {
                                isTitleMenuExpanded.toggle()
                            }
                        }) {
                            Image(systemName: "chevron.forward.2")
                                .font(.system(size: 32))
                        }
                        .frame(maxWidth: 40, maxHeight: 40)
                        .disabled(stopwatchPlayer.stopwatchState != PlayerState.STARTED)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding()
            }
            
            /**
             제목 바텀 시트
             */
            if isTitleMenuExpanded {
                ZStack(alignment: .bottom) {
                    Color("Black-White")
                        .opacity(0.3)
                        .onTapGesture {
                            isTitleMenuExpanded = false
                        }
                    
                    VStack(spacing: 0) {
                        ZStack {
                            Text(stopwatchPlayer.stopwatchState == PlayerState.STARTED ? "이어서 사용할 제목 선택" : "제목 선택")
                                .titleMedium()
                            
                            Button(action: {
                                isTitleMenuExpanded = false
                            }) {
                                Text("확인")
                                    .bodyMedium()
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .padding()
                        
                        Divider()
                            .background(Color("Black-White"))
                        
                        ScrollView {
                            VStack(spacing: 0) {
                                ForEach(Title.allCases) { menuTitle in
                                    Button(action: {
                                        if stopwatchPlayer.stopwatchState == PlayerState.STARTED && stopwatchPlayer.title != menuTitle { // 이어서 기록
                                            stopwatchPlayer.restartStopwatch()
                                        
                                            let now = Date()
                                            
                                            createWiD(now: now)
                                            
                                            // 기존의 WiD를 저장하고, 새로운 WiD의 날짜와 시작 시간을 기록해줌.
                                            stopwatchPlayer.date = now
                                            stopwatchPlayer.start = now
                                        }
                                        
                                        stopwatchPlayer.title = menuTitle
                                        
                                        withAnimation {
                                            isTitleMenuExpanded = false
                                        }
                                    }) {
                                        Image(systemName: titleImageDictionary[menuTitle.rawValue] ?? "")
                                            .font(.system(size: 24))
                                            .frame(maxWidth: 40, maxHeight: 40)
                                        
                                        Spacer()
                                            .frame(maxWidth: 20)
                                        
                                        Text(menuTitle.koreanValue)
                                            .labelMedium()
                                        
                                        Spacer()
                                        
                                        if stopwatchPlayer.title == menuTitle {
                                            Text("선택됨")
                                                .bodyMedium()
                                        } else if stopwatchPlayer.title == menuTitle && stopwatchPlayer.stopwatchState == PlayerState.STARTED {
                                            Text("사용 중")
                                                .bodyMedium()
                                        }
                                    }
                                    .disabled(stopwatchPlayer.title == menuTitle && stopwatchPlayer.stopwatchState == PlayerState.STARTED)
                                    .padding()
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: screenHeight / 2)
                    .background(Color("White-Black"))
                    .cornerRadius(16)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            }
        }
        .navigationBarHidden(true)
        .tint(Color("Black-White"))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("White-Black"))
        .onTapGesture {
            if stopwatchPlayer.stopwatchState == PlayerState.STARTED {
                withAnimation {
                    stopwatchTopBottomBarVisible.toggle()
                }
            }
        }
        .onAppear {
            withAnimation {
                stopwatchPlayer.inStopwatchView = true
            }
        }
        .onDisappear {
            withAnimation {
                stopwatchPlayer.inStopwatchView = false
            }
        }
    }
    
    private func createWiD(now: Date) {
        let title = stopwatchPlayer.title.rawValue
        let start = calendar.date(bySetting: .nanosecond, value: 0, of: stopwatchPlayer.start)! // 밀리 세컨드 제거하여 초 단위만 사용
        let finish = calendar.date(bySetting: .nanosecond, value: 0, of: now)! // 밀리 세컨드 제거하여 초 단위만 사용
        let duration = finish.timeIntervalSince(start)

        guard 0 <= duration else {
            return
        }
        
        // Check if the duration spans across multiple days
        if calendar.isDate(start, inSameDayAs: finish) {
            // WiD duration is within the same day
            let wiD = WiD(
                id: 0,
                date: start,
                title: title,
                start: start,
                finish: finish,
                duration: duration
            )
            wiDService.createWiD(wid: wiD)
        } else {
            // WiD duration spans across multiple days
            let finishOfStart = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: start)!
            let firstDayWiD = WiD(
                id: 0,
                date: start,
                title: title,
                start: start,
                finish: finishOfStart,
                duration: finishOfStart.timeIntervalSince(start)
            )
            wiDService.createWiD(wid: firstDayWiD)

            let startOfFinish = calendar.startOfDay(for: finish)
            let secondDayWiD = WiD(
                id: 0,
                date: finish,
                title: title,
                start: startOfFinish,
                finish: finish,
                duration: finish.timeIntervalSince(startOfFinish)
            )
            wiDService.createWiD(wid: secondDayWiD)
        }
    }
}

struct StopwatchView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StopwatchView()
                .environmentObject(StopwatchPlayer())
                .environment(\.colorScheme, .light)
            
            StopwatchView()
                .environmentObject(StopwatchPlayer())
                .environment(\.colorScheme, .dark)
        }
    }
}
