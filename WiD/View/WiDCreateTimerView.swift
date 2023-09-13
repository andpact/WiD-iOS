//
//  WiDCreateTimerView.swift
//  WiD
//
//  Created by jjkim on 2023/09/13.
//

import SwiftUI

struct WiDCreateTimerView: View {
    private let wiDService = WiDService()
    
    @State private var date: Date = Date()
    
    @State private var title: String = titleArray[0]
    @State private var titleIndex: Int = 0
    
    @State private var start: Date = Date()
    @State private var finish: Date = Date()
    @State private var duration: TimeInterval = 0
    
    private let detail: String = ""
    
    @State private var buttonText: String = "시작"
    
    @State private var isRunning: Bool = false
    
    @State private var timer: Timer?
    
    @State private var remainingTime: Int = 0
    private let timerInterval = 1
    
    @State private var minusButtonDisabled: Bool = true
    @State private var plusButtonDisabled: Bool = false
    
    var body: some View {
        VStack {
            VStack(spacing: 40) {
                HStack {
                    Button(action: {
                        prevTitle()
                    }) {
                        Image(systemName: "chevron.left")
                            .imageScale(.large)
                    }
                    .padding(.horizontal)

                    Text(titleDictionary[title] ?? "")
                        .font(.system(size: 40))
                        .frame(maxWidth: .infinity)

                    Button(action: {
                        nextTitle()
                    }) {
                        Image(systemName: "chevron.right")
                            .imageScale(.large)
                    }
                    .padding(.horizontal)
                }
                
                HStack {
                    Button(action: {
                        remainingTime -= 3600
                        if remainingTime <= 0 {
                            minusButtonDisabled = true
                        }
                        if remainingTime < 12 * 3_600 {
                            plusButtonDisabled = false
                        }
                    }) {
                        Image(systemName: "minus")
                            .imageScale(.large)
                    }
                    .padding(.horizontal)
                    .disabled(minusButtonDisabled)
                    
                    Text(formatElapsedTime(remainingTime))
                        .font(.system(size: 50))
                        .frame(maxWidth: .infinity)
                    
                    Button(action: {
                        remainingTime += 3600
                        if remainingTime > 0 {
                            minusButtonDisabled = false
                        }
                        if remainingTime >= 12 * 3_600 {
                            plusButtonDisabled = true
                        }
                    }) {
                        Image(systemName: "plus")
                            .imageScale(.large)
                    }
                    .padding(.horizontal)
                    .disabled(plusButtonDisabled)
                }
                
                HStack {
                    Button(action: {
                        if !isRunning {
                            startWiD()
                        } else {
                            finishWiD()
                        }
                    }) {
                        Text(buttonText)
                            .font(.system(size: 30))
                            .foregroundColor(buttonText == "중지" ? .red : (buttonText == "계속" ? .green : .black))
                    }
                    .frame(maxWidth: .infinity)
                    .disabled(minusButtonDisabled)

                    Button(action: resetWiD) {
                        Text("초기화")
                            .font(.system(size: 30))
                    }
                    .frame(maxWidth: .infinity)
                    .disabled(isRunning)
                }
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal)
    }
    
    private func prevTitle() {
        titleIndex -= 1
        if titleIndex < 0 {
            titleIndex = titleArray.count - 1
        }
        withAnimation {
            title = titleArray[titleIndex]
        }
    }

    private func nextTitle() {
        titleIndex += 1
        if titleIndex >= titleArray.count {
            titleIndex = 0
        }
        withAnimation {
            title = titleArray[titleIndex]
        }
    }
    
    private func startWiD() {
        isRunning = true
        buttonText = "중지"
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(timerInterval), repeats: true) { timer in
            if remainingTime > 0 {
                remainingTime -= 1
            } else {
                // 남은 시간이 0이 되면 타이머 중지
                timer.invalidate()
                isRunning = false
                buttonText = "시작"
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
        duration = finish.timeIntervalSince(start)
        
        let calendar = Calendar.current
        let startComponents = calendar.dateComponents([.year, .month, .day], from: start)
        let finishComponents = calendar.dateComponents([.year, .month, .day], from: finish)

        if let startDate = calendar.date(from: startComponents),
           let finishDate = calendar.date(from: finishComponents) {

            // Check if the duration spans across multiple days
            if calendar.isDate(startDate, inSameDayAs: finishDate) {
                // WiD duration is within the same day
                let wiD = WiD(id: 0, date: startDate, title: title, start: start, finish: finish, duration: duration, detail: detail)
                wiDService.insertWiD(wid: wiD)
            } else {
                // WiD duration spans across multiple days
                let midnightEndDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startDate)!
                let firstDayWiD = WiD(id: 0, date: startDate, title: title, start: start, finish: midnightEndDate, duration: midnightEndDate.timeIntervalSince(start), detail: detail)
                wiDService.insertWiD(wid: firstDayWiD)

                let nextDayStartDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
                let midnightEndDateNextDay = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: nextDayStartDate)!
                let secondDayWiD = WiD(id: 0, date: nextDayStartDate, title: title, start: midnightEndDateNextDay, finish: finish, duration: finish.timeIntervalSince(midnightEndDateNextDay), detail: detail)
                wiDService.insertWiD(wid: secondDayWiD)
            }
        }
    }

    private func resetWiD() {
        buttonText = "시작"
        remainingTime = 0
        
        timer?.invalidate()
        timer = nil
    }
}

struct WiDCreateTimerView_Previews: PreviewProvider {
    static var previews: some View {
        WiDCreateTimerView()
    }
}
