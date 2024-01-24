//
//  WiDCreateTimerView.swift
//  WiD
//
//  Created by jjkim on 2023/09/13.
//

import SwiftUI

struct TimerView: View {
    // 화면
    @Environment(\.presentationMode) var presentationMode
    @State private var timerTopBottomBarVisible: Bool = true
    
    // WiD
    private let wiDService = WiDService()
    
    // 날짜
    private let calendar = Calendar.current
    
    // 제목
    @State private var isTitleMenuExpanded: Bool = false
    
    // 타이머
    @State private var selectedHour: Int = 0
    @State private var selectedMinute: Int = 0
    @State private var selectedSecond: Int = 0
    @EnvironmentObject var timerPlayer: TimerPlayer
    
    var body: some View {
        ZStack {
            /**
             상단 바
             */
            if timerTopBottomBarVisible {
                ZStack {
                    ZStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                            
//                            if timerStarted {
//                                pauseTimer()
//                            }
                        }) {
                            Image(systemName: "arrow.backward")
                                .imageScale(.large)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        Text("타이머")
                            .titleLarge()
                        
    //                        if timerStarted {
    //                            Text("종료 시간 : \(formatTime(finishTime, format: "a H:mm:ss"))")
    //                                .frame(maxWidth: .infinity, alignment: .trailing)
    //                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: 44)
                    .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            
            /**
             컨텐츠
             */
//            if timerPlayer.reset {
            if timerPlayer.timerState == PlayerState.STOPPED {
                HStack(spacing: 0) {
                    // 시간(Hour) 선택
                    Picker("", selection: $selectedHour) {
                        ForEach(0..<24, id: \.self) { hour in
                            if selectedHour == hour {
                                Text("\(hour)")
                                    .font(.custom("ChivoMono-BlackItalic", size: 35))
                            } else {
                                Text("\(hour)")
                                    .font(.system(size: 20, weight: .medium))
                            }
                        }
                    }
                    .pickerStyle(.inline)
                    
                    Text(":")

                    // 분(Minute) 선택
                    Picker("", selection: $selectedMinute) {
                        ForEach(0..<60, id: \.self) { minute in
                            if selectedMinute == minute {
                                Text("\(minute)")
                                    .font(.custom("ChivoMono-BlackItalic", size: 35))
                            } else {
                                Text("\(minute)")
                                    .font(.system(size: 20, weight: .medium))
                            }
                        }
                    }
                    .pickerStyle(.inline)

                    Text(":")
                    
                    // 초(Second) 선택
                    Picker("", selection: $selectedSecond) {
                        ForEach(0..<60, id: \.self) { second in
                            if selectedSecond == second {
                                Text("\(second)")
                                    .font(.custom("ChivoMono-BlackItalic", size: 35))
                            } else {
                                Text("\(second)")
                                    .font(.system(size: 20, weight: .medium))
                            }
                        }
                    }
                    .pickerStyle(.inline)
                }
                .padding()
            } else {
                formatTimeHorizontally(timerPlayer.remainingTime)
                    .font(.custom("ChivoMono-BlackItalic", size: 70))
                
                // 타이머 시간 추가
//                HStack(spacing: 20) {
//                    Button(action: {
//                        remainingTime += 5 * 60
//
//                        finishTime = calendar.date(byAdding: .second, value: remainingTime, to: Date()) ?? Date()
//                    }) {
//                        Text("+ 5m")
//                    }
//
//                    Button(action: {
//                        remainingTime += 15 * 60
//
//                        finishTime = calendar.date(byAdding: .second, value: remainingTime, to: Date()) ?? Date()
//                    }) {
//                        Text("+ 15m")
//                    }
//
//                    Button(action: {
//                        remainingTime += 30 * 60
//
//                        finishTime = calendar.date(byAdding: .second, value: remainingTime, to: Date()) ?? Date()
//                    }) {
//                        Text("+ 30m")
//                    }
//
//                    Button(action: {
//                        remainingTime += 60 * 60
//
//                        finishTime = calendar.date(byAdding: .second, value: remainingTime, to: Date()) ?? Date()
//                    }) {
//                        Text("+ 60m")
//                    }
//                }
            }
            
            if timerTopBottomBarVisible {
                /**
                 하단 바
                 */
                VStack {
                    HStack {
                        Button(action: {
                            withAnimation {
                                isTitleMenuExpanded.toggle()
                            }
                        }) {
                            Image(systemName: titleImageDictionary[timerPlayer.title.rawValue] ?? "")
                                .font(.system(size: 30))
                        }
                        .frame(maxWidth: 25, maxHeight: 25)
                        .padding()
                        .background(Color("AppIndigo"))
                        .foregroundColor(Color("White"))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .disabled(timerPlayer.timerState != PlayerState.STOPPED)
                        
                        Spacer()
                        
                        if timerPlayer.timerState == PlayerState.PAUSED {
                            Button(action: {
                                timerPlayer.stopTimer()
                            }) {
                                Image(systemName: "arrow.clockwise")
                                    .font(.system(size: 30))
                            }
                            .frame(maxWidth: 25, maxHeight: 25)
                            .padding()
                            .background(Color("DeepSkyBlue"))
                            .foregroundColor(Color("White"))
                            .clipShape(Circle())
                        }
                        
                        Button(action: {
                            if timerPlayer.timerState == PlayerState.STARTED {
                                timerPlayer.pauseTimer()
                                
                                createWiD()
                            } else {
                                timerPlayer.startTimer()
                            }
                        }) {
                            Image(systemName: timerPlayer.timerState == PlayerState.STARTED ? "pause.fill" : "play.fill")
                                .font(.system(size: 30))
                        }
                        .frame(maxWidth: 25, maxHeight: 25)
                        .padding()
                        .background(timerPlayer.timerState == PlayerState.STARTED ? Color("OrangeRed") : (timerPlayer.timerState == PlayerState.PAUSED ? Color("LimeGreen") : (timerPlayer.remainingTime == 0 ? Color("DarkGray") : Color("Black-White"))))
                        .foregroundColor(timerPlayer.timerState == PlayerState.STOPPED ? Color("White-Black") : Color("White"))
                        .clipShape(Circle())
                        .disabled(timerPlayer.remainingTime == 0)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
            
            if isTitleMenuExpanded {
                ZStack(alignment: .bottom) {
                    Color("Black").opacity(0.5)
                        .onTapGesture {
                            isTitleMenuExpanded = false
                        }
                    
                    VStack(spacing: 0) {
                        ZStack {
                            Text("제목 선택")
                                .titleLarge()
                            
                            Button(action: {
                                isTitleMenuExpanded = false
                            }) {
                                Image(systemName: "xmark")
                                    .imageScale(.large)
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .padding()
                        
                        Divider()
                        
                        ScrollView {
                            VStack(spacing: 0) {
                                ForEach(Title.allCases) { menuTitle in
                                    Button(action: {
                                        timerPlayer.title = menuTitle
                                        withAnimation {
                                            isTitleMenuExpanded = false
                                        }
                                    }) {
                                        Image(systemName: titleImageDictionary[menuTitle.rawValue] ?? "")
                                            .font(.system(size: 25))
                                            .frame(maxWidth: 40, maxHeight: 40)
                                        
                                        Spacer()
                                            .frame(maxWidth: 20)
                                        
                                        Text(menuTitle.koreanValue)
                                            .bodyMedium()
                                        
                                        Spacer()    
                                        
                                        if timerPlayer.title == menuTitle {
                                            Text("선택됨")
                                        }
                                    }
                                    .padding()
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height / 3)
                    .background(Color("LightGray-Gray"))
                    .cornerRadius(8)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            }
        }
        .navigationBarHidden(true)
        .tint(Color("Black-White"))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("White-Black"))
        .onChange(of: [selectedHour, selectedMinute, selectedSecond]) { _ in
            timerPlayer.remainingTime = selectedHour * 3600 + selectedMinute * 60 + selectedSecond
            
//            finishTime = calendar.date(byAdding: .second, value: remainingTime, to: Date()) ?? Date()
        }
        .onChange(of: timerPlayer.remainingTime) { newRemainingTime in
            if timerPlayer.timerState == PlayerState.STARTED && newRemainingTime <= 0 {
                createWiD()
            }
        }
        .onTapGesture {
            if timerPlayer.timerState == PlayerState.STARTED {
                withAnimation {
                    timerTopBottomBarVisible.toggle()
                }
            }
        }
        .onAppear {
            withAnimation {
                timerPlayer.inTimerView = true
            }
        }
        .onDisappear {
            withAnimation {
                timerPlayer.inTimerView = false
            }
        }
    }
    
    func createWiD() {
        let now = Date()
        
        let title = timerPlayer.title.rawValue
        let start = calendar.date(bySetting: .nanosecond, value: 0, of: timerPlayer.start)! // 밀리 세컨드 제거하여 초 단위만 사용
        let finish = calendar.date(bySetting: .nanosecond, value: 0, of: now)!
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
            wiDService.insertWiD(wid: wiD)
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
            wiDService.insertWiD(wid: firstDayWiD)

            let startOfFinish = calendar.startOfDay(for: finish)
            let secondDayWiD = WiD(
                id: 0,
                date: finish,
                title: title,
                start: startOfFinish,
                finish: finish,
                duration: finish.timeIntervalSince(startOfFinish)
            )
            wiDService.insertWiD(wid: secondDayWiD)
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TimerView()
                .environmentObject(TimerPlayer())
                .environment(\.colorScheme, .light)
            
            TimerView()
                .environmentObject(TimerPlayer())
                .environment(\.colorScheme, .dark)
        }
    }
}
