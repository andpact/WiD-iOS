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
    @State private var titleMenuExpand: Bool = false
    
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
            if timerPlayer.reset {
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
                formatTimerTime(timerPlayer.remainingTime)
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
                    if titleMenuExpand {
                        Text("사용할 제목을 선택해 주세요.")
                            .bodyMedium()
                        
                        LazyVGrid(columns: Array(repeating: GridItem(), count: 5)) {
                            ForEach(Title.allCases) { menuTitle in
                                Button(action: {
                                    timerPlayer.title = menuTitle
                                    withAnimation {
                                        titleMenuExpand.toggle()
                                    }
                                }) {
                                    Text(menuTitle.koreanValue)
                                        .bodyMedium()
                                        .frame(maxWidth: .infinity)
                                        .padding(8)
                                        .background(timerPlayer.title == menuTitle ? Color("Black-White") : Color("White-Black"))
                                        .foregroundColor(timerPlayer.title == menuTitle ? Color("White-Black") : Color("Black-White"))
                                        .clipShape(Capsule())
                                }
                            }
                        }
                        
                        Divider()
                            .background(Color("LightGray"))
                    }

                    HStack {
                        Button(action: {
                            withAnimation {
                                titleMenuExpand.toggle()
                            }
                        }) {
                            Rectangle()
                                .frame(maxWidth: 5, maxHeight: 20)
                                .foregroundColor(Color(timerPlayer.title.rawValue))
                            
                            Text(timerPlayer.title.koreanValue)
                                .bodyMedium()
                            
                            if timerPlayer.reset {
                                Image(systemName: "chevron.up.chevron.down")
                                    .imageScale(.small)
                            }
                        }
                        .disabled(!timerPlayer.reset)
                        
                        Spacer()
                        
                        if timerPlayer.paused {
                            Button(action: {
                                resetTimer()
                            }) {
                                Image(systemName: "arrow.clockwise")
                                    .imageScale(.large)
                            }
                            .frame(maxWidth: 25, maxHeight: 25)
                            .padding()
                            .background(Color("DeepSkyBlue"))
                            .foregroundColor(Color("White"))
                            .clipShape(Circle())
                        }
                        
                        Button(action: {
                            if timerPlayer.started {
                                pauseTimer()
                            } else {
                                startTimer()
                            }
                        }) {
                            Image(systemName: timerPlayer.started ? "pause.fill" : "play.fill")
                                .imageScale(.large)
                        }
                        .frame(maxWidth: 25, maxHeight: 25)
                        .padding()
                        .background(timerPlayer.started ? Color("OrangeRed") : (timerPlayer.paused ? Color("LimeGreen") : (timerPlayer.remainingTime == 0 ? Color("DarkGray") : Color("Black-White"))))
                        .foregroundColor(timerPlayer.reset ? Color("White-Black") : Color("White"))
                        .clipShape(Circle())
                        .disabled(timerPlayer.remainingTime == 0)
                    }
                }
                .padding()
                .background(Color("LightGray-Gray"))
                .cornerRadius(8)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
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
        .onTapGesture {
            if timerPlayer.started {
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
    
    private func startTimer() {
        timerPlayer.startIt()
    }
    
    private func pauseTimer() {
        timerPlayer.pauseIt()
        
//        finishTime = calendar.date(byAdding: .second, value: remainingTime, to: Date()) ?? Date()
        let now = Date()
        
        let title = timerPlayer.title.rawValue
        let start = timerPlayer.start
        let finish = now
        let duration = finish.timeIntervalSince(start)
        
        let startComponents = calendar.dateComponents([.year, .month, .day], from: start)
        let finishComponents = calendar.dateComponents([.year, .month, .day], from: finish)

        if let startDate = calendar.date(from: startComponents),
           let finishDate = calendar.date(from: finishComponents) {

            // Check if the duration spans across multiple days
            if calendar.isDate(startDate, inSameDayAs: finishDate) {
                // WiD duration is within the same day
                let wiD = WiD(
                    id: 0,
                    date: startDate,
                    title: title,
                    start: start,
                    finish: finish,
                    duration: duration
                )
                wiDService.insertWiD(wid: wiD)
            } else {
                // WiD duration spans across multiple days
                let midnightEndDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startDate)!
                let firstDayWiD = WiD(
                    id: 0,
                    date: startDate,
                    title: title,
                    start: start,
                    finish: midnightEndDate,
                    duration: midnightEndDate.timeIntervalSince(start)
                )
                wiDService.insertWiD(wid: firstDayWiD)

                let nextDayStartDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
                let midnightEndDateNextDay = calendar.startOfDay(for: nextDayStartDate)
                let secondDayWiD = WiD(
                    id: 0,
                    date: nextDayStartDate,
                    title: title,
                    start: midnightEndDateNextDay,
                    finish: finish,
                    duration: finish.timeIntervalSince(midnightEndDateNextDay)
                )
                wiDService.insertWiD(wid: secondDayWiD)
            }
        }
    }

    private func resetTimer() {
        timerPlayer.resetIt()
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TimerView()
                .environment(\.colorScheme, .light)
            
            TimerView()
                .environment(\.colorScheme, .dark)
        }
    }
}
