//
//  WiDCreateView.swift
//  WiD
//
//  Created by jjkim on 2023/07/06.
//

import SwiftUI

struct WiDCreateStopWatchView: View {
    // 데이터베이스
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
    
    // 버튼
    @State private var buttonText: String = "시작"
    
    // 스톱 워치
    @State private var isRunning: Bool = false
    @State private var timer: Timer?
    @State private var elapsedTime = 0
    private let timerInterval = 1
    
    // 상단, 하단 탭 가시성
    @Binding var buttonsVisible: Bool
    
    var body: some View {
        ZStack {
            formatStopWatchTime(elapsedTime)
                .padding(.bottom, 180)

            HStack {
                HStack {
                    Circle()
                        .fill(Color(title.rawValue))
                        .frame(width: 10)
                    
                    Picker("", selection: $title) {
                        ForEach(Array(Title.allCases), id: \.self) { title in
                            Text(titleDictionary[title.rawValue]!)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                
                Button(action: {
                    resetWiD()
                }) {
                    Text("초기화")
                }
                .frame(maxWidth: .infinity)
                .disabled(isRunning || buttonsVisible)
                
                Button(action: {
                    if !isRunning {
                        startWiD()
                    } else {
                        finishWiD()
                    }
                }) {
                    Text(buttonText)
                        .foregroundColor(buttonText == "중지" ? .red : (buttonText == "계속" ? .green : .black))
                }
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func startWiD() {
        withAnimation() {
            buttonsVisible = false
        }
        isRunning = true
        buttonText = "중지"
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(timerInterval), repeats: true) { timer in
            if elapsedTime < 12 * 60 * 60 {
                elapsedTime += timerInterval
            } else {
                finishWiD()
                resetWiD()
            }
        }
        
        date = Date()
        start = Date()
    }

    private func finishWiD() {
        isRunning = false
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
    }

    private func resetWiD() {
        withAnimation {
            buttonsVisible = true
        }
        elapsedTime = 0
        buttonText = "시작"
    }
}

struct WiDCreateView_Previews: PreviewProvider {
    static var previews: some View {
        let buttonsVisible = Binding.constant(true)
        return WiDCreateStopWatchView(buttonsVisible: buttonsVisible)
    }
}
