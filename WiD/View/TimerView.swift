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
    @State private var date: Date = Date()
    
    // 제목
    @State private var title: Title = .STUDY
    @State private var titleMenuExpand: Bool = false
    
    // 시작 시간
    @State private var start: Date = Date()
    
    // 종료 시간
    @State private var finish: Date = Date()
    
    // 소요 시간
    @State private var duration: TimeInterval = 0
    
    // 타이머
    @State private var timer: Timer?
    @State private var timerStarted: Bool = false
    @State private var timerPaused: Bool = false
    @State private var timerReset: Bool = true
    @State private var remainingTime: Int = 0 // 초 단위
    private let timerInterval = 1
    @State private var finishTime: Date = Date()
    @State private var selectedHour: Int = 0
    @State private var selectedMinute: Int = 0
    @State private var selectedSecond: Int = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                if timerTopBottomBarVisible {
                    /**
                     상단 바
                     */
                    ZStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                            
                            if timerStarted {
                                pauseTimer()
                            }
                        }) {
                            Image(systemName: "chevron.backward")
                            
                            Text("뒤로 가기")
                                .bodyMedium()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.blue)

                        Text("타이머")
                            .titleLarge()
                            .frame(maxWidth: .infinity, alignment: .center)
                        
//                        if timerStarted {
//                            Text("종료 시간 : \(formatTime(finishTime, format: "a H:mm:ss"))")
//                                .frame(maxWidth: .infinity, alignment: .trailing)
//                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                }
                
                /**
                 컨텐츠
                 */
                if timerReset {
                    HStack(spacing: 0) {
                        // 시간(Hour) 선택
                        Picker("", selection: $selectedHour) {
                            ForEach(0..<24, id: \.self) { hour in
                                if selectedHour == hour {
                                    Text("\(hour)h")
                                        .titleMedium()
                                } else {
                                    Text("\(hour)h")
                                        .bodyMedium()
                                }
                            }
                        }
                        .pickerStyle(.inline)

                        // 분(Minute) 선택
                        Picker("", selection: $selectedMinute) {
                            ForEach(0..<60, id: \.self) { minute in
                                if selectedMinute == minute {
                                    Text("\(minute)m")
                                        .titleMedium()
                                } else {
                                    Text("\(minute)m")
                                        .bodyMedium()
                                }
                            }
                        }
                        .pickerStyle(.inline)

                        // 초(Second) 선택
                        Picker("", selection: $selectedSecond) {
                            ForEach(0..<60, id: \.self) { second in
                                if selectedSecond == second {
                                    Text("\(second)s")
                                        .titleMedium()
                                } else {
                                    Text("\(second)s")
                                        .bodyMedium()
                                }
                            }
                        }
                        .pickerStyle(.inline)
                    }
                    .padding()
                } else {
                    formatTimerTime(remainingTime)
                    
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
                                .titleMedium()
                            
                            LazyVGrid(columns: Array(repeating: GridItem(), count: 5)) {
                                ForEach(Title.allCases) { menuTitle in
                                    Button(action: {
//                                        if timerStarted && title != menuTitle { // 이어서 기록
//                                            restartTimer()
//                                        }
                                        title = menuTitle
                                        withAnimation {
                                            titleMenuExpand.toggle()
                                        }
                                    }) {
                                        Text(menuTitle.koreanValue)
                                            .bodyMedium()
                                            .frame(maxWidth: .infinity)
                                            .padding(8)
                                            .background(title == menuTitle ? .black : .white)
                                            .foregroundColor(title == menuTitle ? .white : .black)
                                            .cornerRadius(8)
                                    }
                                }
                            }
                            
                            Divider()
                        }

                        HStack {
                            Button(action: {
                                withAnimation {
                                    titleMenuExpand.toggle()
                                }
                            }) {
                                Rectangle()
                                    .frame(maxWidth: 5, maxHeight: 20)
                                    .foregroundColor(Color(title.rawValue))
                                
                                Text(title.koreanValue)
                                    .bodyMedium()
                                
                                if timerReset {
                                    Image(systemName: "chevron.up.chevron.down")
                                        .imageScale(.small)
                                }
                            }
                            .disabled(!timerReset)
                            
                            Spacer()
                            
                            if timerPaused {
                                Button(action: {
                                    resetTimer()
                                }) {
                                    Image(systemName: "arrow.clockwise")
                                        .imageScale(.large)
                                }
                                .frame(maxWidth: 25, maxHeight: 25)
                                .padding()
                                .background(.blue)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                            }
                            
                            Button(action: {
                                if timerStarted {
                                    pauseTimer()
                                } else {
                                    startTimer()
                                }
                            }) {
                                Image(systemName: timerStarted ? "pause.fill" : "play.fill")
                                    .imageScale(.large)
                            }
                            .frame(maxWidth: 25, maxHeight: 25)
                            .padding()
                            .background(timerStarted ? .red : (timerPaused ? .green : (remainingTime == 0 ? .gray : .blue)))
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .disabled(remainingTime == 0)
                        }
                    }
                    .padding()
                    .background(Color("light_gray"))
                    .cornerRadius(8)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                }
            }
            .tint(.black)
            .navigationBarBackButtonHidden()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.white)
            .onChange(of: [selectedHour, selectedMinute, selectedSecond]) { _ in
                remainingTime = selectedHour * 3600 + selectedMinute * 60 + selectedSecond
                
                finishTime = calendar.date(byAdding: .second, value: remainingTime, to: Date()) ?? Date()
            }
            .onTapGesture {
                if timerStarted {
                    withAnimation {
                        timerTopBottomBarVisible.toggle()
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private func startTimer() {
        timerStarted = true
        timerPaused = false
        timerReset = false
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(timerInterval), repeats: true) { timer in
            if remainingTime > 0 {
                remainingTime -= timerInterval
            } else {
                pauseTimer()
                resetTimer()
            }
        }
        
        date = Date()
        start = Date()
    }
    
//    private func restartTimer() {
//
//    }

    private func pauseTimer() {
        timerStarted = false
        timerPaused = true
        
        timer?.invalidate()
        timer = nil
        
        finishTime = calendar.date(byAdding: .second, value: remainingTime, to: Date()) ?? Date()
        
        finish = Date()
        duration = finish.timeIntervalSince(start)
        
        let startComponents = calendar.dateComponents([.year, .month, .day], from: start)
        let finishComponents = calendar.dateComponents([.year, .month, .day], from: finish)

        if let startDate = calendar.date(from: startComponents),
           let finishDate = calendar.date(from: finishComponents) {

            // Check if the duration spans across multiple days
            if calendar.isDate(startDate, inSameDayAs: finishDate) {
                // WiD duration is within the same day
                let wiD = WiD(id: 0, date: startDate, title: title.rawValue, start: start, finish: finish, duration: duration)
                wiDService.insertWiD(wid: wiD)
            } else {
                // WiD duration spans across multiple days
                let midnightEndDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startDate)!
                let firstDayWiD = WiD(id: 0, date: startDate, title: title.rawValue, start: start, finish: midnightEndDate, duration: midnightEndDate.timeIntervalSince(start))
                wiDService.insertWiD(wid: firstDayWiD)

                let nextDayStartDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
                let midnightEndDateNextDay = calendar.startOfDay(for: nextDayStartDate)
                let secondDayWiD = WiD(id: 0, date: nextDayStartDate, title: title.rawValue, start: midnightEndDateNextDay, finish: finish, duration: finish.timeIntervalSince(midnightEndDateNextDay))
                wiDService.insertWiD(wid: secondDayWiD)
            }
        }
    }

    private func resetTimer() {
        timerPaused = false
        timerReset = true
        remainingTime = 0
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
