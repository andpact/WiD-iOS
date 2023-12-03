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
    
    // 시작 시간
    @State private var start: Date = Date()
    
    // 종료 시간
    @State private var finish: Date = Date()
    
    // 소요 시간
    @State private var duration: TimeInterval = 0
    
    // 설명
    private let detail: String = ""
    
    // 버튼
    @State private var buttonText: String = "시작"
    
    // 타이머
    @State private var timer: Timer?
    @State private var isRecording: Bool = false
    @State private var isRecordingStop: Bool = false
    @State private var isStopWatchReset: Bool = true
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
                    // 상단 바
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                            
                            if isRecording {
                                finishTimer()
                            }
                        }) {
                            Image(systemName: "arrow.backward")
                                .imageScale(.large)
                        }

                        Text("타이머")
                            .bold()
                        
                        Spacer()
                        
                        if isRecording {
                            Text("종료 시간 : \(formatTime(finishTime, format: "a H:mm:ss"))")
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                }
                
                // 컨텐츠
                if isStopWatchReset {
                    HStack(spacing: 0) {
                        // 시간(Hour) 선택
                        Picker("", selection: $selectedHour) {
                            ForEach(0..<24, id: \.self) { hour in
                                if selectedHour == hour {
                                    Text("\(hour)h")
                                        .bold()
                                } else {
                                    Text("\(hour)h")
                                }
                            }
                        }
                        .pickerStyle(.inline)

                        // 분(Minute) 선택
                        Picker("", selection: $selectedMinute) {
                            ForEach(0..<60, id: \.self) { minute in
                                if selectedMinute == minute {
                                    Text("\(minute)m")
                                        .bold()
                                } else {
                                    Text("\(minute)m")
                                }
                            }
                        }
                        .pickerStyle(.inline)

                        // 초(Second) 선택
                        Picker("", selection: $selectedSecond) {
                            ForEach(0..<60, id: \.self) { second in
                                if selectedSecond == second {
                                    Text("\(second)s")
                                        .bold()
                                } else {
                                    Text("\(second)s")
                                }
                            }
                        }
                        .pickerStyle(.inline)
                    }
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
                    // 하단 바
                    HStack {
                        HStack {
                            Circle()
                                .fill(Color(title.rawValue))
                                .frame(width: 10)
                            
                            Picker("", selection: $title) {
                                ForEach(Array(Title.allCases), id: \.self) { title in
                                    Text(title.koreanValue)
                                }
                            }
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 16) {
                            if isRecordingStop {
                                Button(action: {
                                    resetTimer()
                                }) {
                                    Text("초기화")
                                }
                            }
                            
                            Button(action: {
                                if isRecording {
                                    finishTimer()
                                } else {
                                    startTimer()
                                }
                            }) {
                                Text(buttonText)
                                    .foregroundColor(buttonText == "중지" ? .red : (buttonText == "계속" ? .green : nil))
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                }
            }
            .tint(.black)
            .navigationBarBackButtonHidden()
            .padding(.horizontal)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("ghost_white"))
            .onChange(of: [selectedHour, selectedMinute, selectedSecond]) { _ in
                remainingTime = selectedHour * 3600 + selectedMinute * 60 + selectedSecond
                
                finishTime = calendar.date(byAdding: .second, value: remainingTime, to: Date()) ?? Date()
            }
            .onTapGesture {
                if isRecording {
                    timerTopBottomBarVisible = true
                    
                    Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
                        withAnimation {
                            if isRecording {
                                timerTopBottomBarVisible = false
                            }
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    private func startTimer() {
        isRecording = true
        isRecordingStop = false
        isStopWatchReset = false
        buttonText = "중지"
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(timerInterval), repeats: true) { timer in
            if remainingTime > 0 {
                remainingTime -= timerInterval
            } else {
                finishTimer()
                resetTimer()
            }
        }
        
        date = Date()
        start = Date()
        
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
            withAnimation {
                if isRecording {
                    timerTopBottomBarVisible = false
                }
            }
        }
    }

    private func finishTimer() {
        isRecording = false
        isRecordingStop = true
        buttonText = "계속"
        
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
                let wiD = WiD(id: 0, date: startDate, title: title.rawValue, start: start, finish: finish, duration: duration, detail: detail)
                wiDService.insertWiD(wid: wiD)
            } else {
                // WiD duration spans across multiple days
                let midnightEndDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startDate)!
                let firstDayWiD = WiD(id: 0, date: startDate, title: title.rawValue, start: start, finish: midnightEndDate, duration: midnightEndDate.timeIntervalSince(start), detail: detail)
                wiDService.insertWiD(wid: firstDayWiD)

                let nextDayStartDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
                let midnightEndDateNextDay = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: nextDayStartDate)!
                let secondDayWiD = WiD(id: 0, date: nextDayStartDate, title: title.rawValue, start: midnightEndDateNextDay, finish: finish, duration: finish.timeIntervalSince(midnightEndDateNextDay), detail: detail)
                wiDService.insertWiD(wid: secondDayWiD)
            }
        }
        
        timerTopBottomBarVisible = true
    }

    private func resetTimer() {
        isRecordingStop = false
        isStopWatchReset = true
        buttonText = "시작"
        remainingTime = 0
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
