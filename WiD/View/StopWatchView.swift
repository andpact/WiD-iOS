//
//  WiDCreateView.swift
//  WiD
//
//  Created by jjkim on 2023/07/06.
//

import SwiftUI

struct StopWatchView: View {
    // 화면
    @Environment(\.presentationMode) var presentationMode
    @State private var stopWatchTopBottomBarVisible: Bool = true
    
    // WiD
    private let wiDService = WiDService()
    
    // 날짜
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
    
    // 스톱 워치
    @State private var timer: Timer?
    @State private var isRecording: Bool = false
    @State private var isRecordingStop: Bool = false
    @State private var isStopWatchReset: Bool = true
    @State private var elapsedTime = 0
    @State private var buttonText: String = "시작"
    private let timerInterval = 1
    
    var body: some View {
        NavigationView {
            // 전체 화면
            ZStack {
                if stopWatchTopBottomBarVisible {
                    // 상단 바
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                            
                            if isRecording {
                                finishStopWatch()
                            }
                        }) {
                            Image(systemName: "arrow.backward")
                                .imageScale(.large)
                        }

                        Text("스톱워치")
                            .bold()
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                }
                
                // 컨텐츠
                formatStopWatchTime(elapsedTime)
                
                if stopWatchTopBottomBarVisible {
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
                                    resetStopWatch()
                                }) {
                                    Text("초기화")
                                }
                            }
                            
                            Button(action: {
                                if isRecording {
                                    finishStopWatch()
                                } else {
                                    startStopWatch()
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
            .padding(.horizontal)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("ghost_white"))
            .onTapGesture {
                if isRecording {
                    stopWatchTopBottomBarVisible = true
                    
                    Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
                        withAnimation {
                            if isRecording {
                                stopWatchTopBottomBarVisible = false
                            }
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    private func startStopWatch() {
        isRecording = true
        isRecordingStop = false
        isStopWatchReset = false
        buttonText = "중지"
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(timerInterval), repeats: true) { timer in
            if elapsedTime < 12 * 60 * 60 {
                elapsedTime += timerInterval
            } else {
                finishStopWatch()
                resetStopWatch()
            }
        }
        
        date = Date()
        start = Date()
        
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
            withAnimation {
                if isRecording {
                    stopWatchTopBottomBarVisible = false
                }
            }
        }
    }

    private func finishStopWatch() {
        isRecording = false
        isRecordingStop = true
        buttonText = "계속"
        
        timer?.invalidate()
        timer = nil
        
        finish = Date()
//        finish = Date().addingTimeInterval(60 * 60)
        duration = finish.timeIntervalSince(start)

        let calendar = Calendar.current
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
        
        stopWatchTopBottomBarVisible = true
    }

    private func resetStopWatch() {
        isRecordingStop = false
        isStopWatchReset = true
        elapsedTime = 0
        buttonText = "시작"
    }
}

struct StopWatchView_Previews: PreviewProvider {
    static var previews: some View {
        return StopWatchView()
    }
}
