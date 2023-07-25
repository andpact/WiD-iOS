//
//  WiDCreateView.swift
//  WiD
//
//  Created by jjkim on 2023/07/06.
//

import SwiftUI

struct WiDCreateView: View {
    
    private let wiDService = WiDService()
    
    @State private var date: Date = Date()
    @State private var title: String = titleArray[0]
    @State private var titleIndex: Int = 0
    private let detail: String = ""
    @State private var startTime: Date = Date()
    @State private var finishTime: Date = Date()
    @State private var duration: TimeInterval = 0
    
    @State private var timerLeft = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    @State private var timeLeftIndex: Int = 0
    private let timeLeftTitle: [String] = ["오늘", "이번 주", "이번 달", "올해"]
    private let timeLeftMiddle: [String] = ["이", "가", "이", "가"]
    @State private var timeLeftPercentage: String = ""
    @State private var timeLeftEnd: String = ""
    
    @State private var startTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var finishTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var wiD: WiD = WiD(id: 0, title: "", detail: "", date: Date(), start: Date(), finish: Date(), duration: 0)
    
    @State private var isRecording = false
    @State private var isRecordingDone = false
    
    @State private var showMinAlert = false
    @State private var showMaxAlert = false
    
    var body: some View {
        VStack {
            HStack {
                Text(timeLeftTitle[timeLeftIndex])
                    .bold()
                    .padding(.trailing, -8)
                
                Text(timeLeftMiddle[timeLeftIndex])
                
                Text(timeLeftPercentage)
                    .bold()
                
                Text(timeLeftEnd)
            }
            
            VStack {
                HStack {
                    Text("WiD")
                        .font(.custom("Acme-Regular", size: 30))
                        .padding(.top)
                    
                    Spacer()

                    Circle()
                        .foregroundColor(Color(title))
                        .frame(width: 20, height: 20)
                }
                .padding(.horizontal)
                
                HStack {
                    Image(systemName: "calendar")
                        .imageScale(.large)
                        .frame(width: 25)
                    
                    Text("날짜")
                        .font(.system(size: 25))

                    HStack {
                        Text(formatDate(date, format: "yyyy.MM.dd"))
                            .font(.system(size: 25))

                        Text(formatWeekday(date))
                            .font(.system(size: 25))
                            .foregroundColor(Calendar.current.component(.weekday, from: date) == 1 ? .red : (Calendar.current.component(.weekday, from: date) == 7 ? .blue : .black))
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)
                .padding(.bottom)

                HStack {
                    Image(systemName: "doc.text.magnifyingglass")
                        .imageScale(.large)
                        .frame(width: 25)
                    
                    Text("제목")
                        .font(.system(size: 25))

                    Button(action: {
                        decreaseTitle()
                    }) {
                        Image(systemName: "chevron.left")
                    }
                    .disabled(isRecording)
                    .opacity(isRecording ? 0 : 1)
                    .padding(.horizontal)

                    Text(titleDictionary[title] ?? "")
                        .font(.system(size: 25))
                        .frame(maxWidth: .infinity)

                    Button(action: {
                        increaseTitle()
                    }) {
                        Image(systemName: "chevron.right")
                    }
                    .disabled(isRecording)
                    .opacity(isRecording ? 0 : 1)
                    .padding(.horizontal)
                }
                .padding(.horizontal)
                .padding(.bottom)

                HStack {
                    Image(systemName: "clock")
                        .imageScale(.large)
                        .frame(width: 25)
                    
                    Text("시작")
                        .font(.system(size: 25))

                    Text(formatTime(startTime, format: "HH:mm:ss"))
                        .font(.system(size: 25))
                        .opacity(isRecording ? 0.5 : 1)
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)
                .padding(.bottom)

                HStack {
                    Image(systemName: "stopwatch")
                        .imageScale(.large)
                        .frame(width: 25)
                    
                    Text("종료")
                        .font(.system(size: 25))

                    Text(formatTime(finishTime, format: "HH:mm:ss"))
                        .font(.system(size: 25))
                        .opacity(isRecording ? 1 : 0)
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)
                .padding(.bottom)

                HStack {
                    Image(systemName: "hourglass")
                        .imageScale(.large)
                        .frame(width: 25)
                    
                    Text("소요")
                        .font(.system(size: 25))

                    Text(formatDuration(duration, isClickedWiD: true))
                        .font(.system(size: 25))
                        .opacity(isRecording ? 1 : 0)
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)
                .padding(.bottom)

            }
            .background(Color("light_purple"))
            .cornerRadius(5)
            .padding(.horizontal)

            HStack {
//                시작 버튼
                Button(action: startRecording) {
                    Image(systemName: "play.fill")
                        .imageScale(.large)
                }
                .frame(maxWidth: .infinity)
                .disabled(isRecording)

//                종료 버튼
                Button(action: stopRecording) {
                    Image(systemName: "stop.fill")
                        .imageScale(.large)
                }
                .frame(maxWidth: .infinity)
                .disabled(!isRecording || isRecordingDone)

//                초기화 버튼
                Button(action: resetRecording) {
                    Image(systemName: "arrow.clockwise.circle.fill")
                        .imageScale(.large)
                }
                .frame(maxWidth: .infinity)
                .disabled(!isRecording || !isRecordingDone)
            }
            .padding(.horizontal)
        }
        .onAppear() {
            timeLeftEnd = "남았습니다."
            
            let currentTime = Date()
            let calendar = Calendar.current
            
            let startOfDay = calendar.startOfDay(for: currentTime)
            let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startOfDay)!
            let totalTime = endOfDay.timeIntervalSince(calendar.startOfDay(for: currentTime))
            let remainingTime = endOfDay.timeIntervalSince(currentTime)
            let percentage = Double(remainingTime / totalTime) * 100
            if remainingTime < 1800 { // 30 minutes = 1800 seconds
                timeLeftPercentage = "곧"
                timeLeftEnd = "지나갑니다."
            } else if percentage.truncatingRemainder(dividingBy: 1) == 0 {
                timeLeftPercentage = String(format: "%.0f%%", percentage)
            } else {
                timeLeftPercentage = String(format: "%.1f%%", percentage)
            }
        }
        .onReceive(timerLeft) { _ in
            timeLeftIndex = (timeLeftIndex + 1) % timeLeftTitle.count
            timeLeftEnd = "남았습니다."
            
            let currentTime = Date()
            let calendar = Calendar.current

            switch timeLeftIndex {
            case 0: // 오늘
                let startOfDay = calendar.startOfDay(for: currentTime)
                let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startOfDay)!
                
                let totalTime = endOfDay.timeIntervalSince(calendar.startOfDay(for: currentTime))
                let remainingTime = endOfDay.timeIntervalSince(currentTime)
                let percentage = Double(remainingTime / totalTime) * 100
                if remainingTime < 1800 { // 30 minutes = 1800 seconds
                    timeLeftPercentage = "곧"
                    timeLeftEnd = "지나갑니다."
                } else if percentage.truncatingRemainder(dividingBy: 1) == 0 {
                    timeLeftPercentage = String(format: "%.0f%%", percentage)
                } else {
                    timeLeftPercentage = String(format: "%.1f%%", percentage)
                }
            case 1: // 이번 주
                let mondayWeekday = 2 // Monday is represented by 2 in `weekday` component

                // Find the closest Monday
                var startOfWeek = currentTime
                while calendar.component(.weekday, from: startOfWeek) != mondayWeekday {
                    startOfWeek = calendar.date(byAdding: .day, value: -1, to: startOfWeek)!
                }
                startOfWeek = calendar.startOfDay(for: startOfWeek)

                // Find the closest Sunday
                var endOfWeek = currentTime
                while calendar.component(.weekday, from: endOfWeek) != 1 { // Sunday is represented by 1 in `weekday` component
                    endOfWeek = calendar.date(byAdding: .day, value: 1, to: endOfWeek)!
                }
                endOfWeek = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: endOfWeek)!

                let totalTime = endOfWeek.timeIntervalSince(startOfWeek)
                let remainingTime = endOfWeek.timeIntervalSince(currentTime)
                let percentage = Double(remainingTime / totalTime) * 100
                if remainingTime < 1800 { // 30 minutes = 1800 seconds
                    timeLeftPercentage = "곧"
                    timeLeftEnd = "지나갑니다."
                } else if percentage.truncatingRemainder(dividingBy: 1) == 0 {
                    timeLeftPercentage = String(format: "%.0f%%", percentage)
                } else {
                    timeLeftPercentage = String(format: "%.1f%%", percentage)
                }
            case 2: // 이번 달

                // Get the first day of the current month with time set to 00:00:00
                let startOfMonth = calendar.startOfDay(for: calendar.date(from: calendar.dateComponents([.year, .month], from: currentTime))!)

                // Get the last day of the current month with time set to 23:59:59
                let lastDayComponents = DateComponents(year: calendar.component(.year, from: currentTime), month: calendar.component(.month, from: currentTime) + 1, day: 0)
                let endOfMonth = calendar.startOfDay(for: calendar.date(from: lastDayComponents)!.addingTimeInterval(-1))
                
                let totalTime = endOfMonth.timeIntervalSince(startOfMonth)
                let remainingTime = endOfMonth.timeIntervalSince(currentTime)
                let percentage = Double(remainingTime / totalTime) * 100
                if remainingTime < 1800 { // 30 minutes = 1800 seconds
                    timeLeftPercentage = "곧"
                    timeLeftEnd = "지나갑니다."
                } else if percentage.truncatingRemainder(dividingBy: 1) == 0 {
                    timeLeftPercentage = String(format: "%.0f%%", percentage)
                } else {
                    timeLeftPercentage = String(format: "%.1f%%", percentage)
                }
            case 3: // 올해

                // Get the first day of the current year with time set to 00:00:00
                let startOfYear = calendar.startOfDay(for: calendar.date(from: calendar.dateComponents([.year], from: currentTime))!)

                // Get the last day of the current year with time set to 23:59:59
                let lastDayComponents = DateComponents(year: calendar.component(.year, from: currentTime) + 1, month: 0, day: 0)
                let endOfYear = calendar.startOfDay(for: calendar.date(from: lastDayComponents)!.addingTimeInterval(-1))

                let totalTime = endOfYear.timeIntervalSince(startOfYear)
                let remainingTime = endOfYear.timeIntervalSince(currentTime)
                let percentage = Double(remainingTime / totalTime) * 100
                if remainingTime < 1800 { // 30 minutes = 1800 seconds
                    timeLeftPercentage = "곧"
                    timeLeftEnd = "지나갑니다."
                } else if percentage.truncatingRemainder(dividingBy: 1) == 0 {
                    timeLeftPercentage = String(format: "%.0f%%", percentage)
                } else {
                    timeLeftPercentage = String(format: "%.1f%%", percentage)
                }
            default:
                break
            }
        }
        .onReceive(startTimer) { _ in
            startTime = Date()
            date = Date() // 날짜도 갱신되어야 함.
        }
        .onReceive(finishTimer) { _ in
            finishTime = Date()
            duration = finishTime.timeIntervalSince(startTime)
            
            let durationLimit: TimeInterval = 12 * 60 * 60 // 12 hours in seconds
            if durationLimit <= duration {
                stopRecording()
                showMaxAlert = true
                resetRecording()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal)
        .alert(isPresented: Binding<Bool>.constant(showMinAlert || showMaxAlert)) {
            switch (showMinAlert, showMaxAlert) {
            case (true, false):
                return Alert(
                    title: Text("기록 종료"),
                    message: Text("1분 이상의 WiD를 기록해주세요."),
                    dismissButton: .default(Text("확인")) {
                        showMinAlert = false
                    }
                )
            case (false, true):
                return Alert(
                    title: Text("기록 종료"),
                    message: Text("12시간이 초과되어 WiD가 자동으로 등록되었습니다."),
                    dismissButton: .default(Text("확인")) {
                        showMaxAlert = false
                    }
                )
            default:
                return Alert(title: Text(""), message: nil, dismissButton: .default(Text("확인")))
            }
        }
//        .alert(isPresented: $showMinAlert) {
//            Alert(
//                title: Text("기록 종료"),
//                message: Text("1분 이상의 WiD를 기록해주세요."),
//                dismissButton: .default(Text("확인"))
//            )
//        }
//        .alert(isPresented: $showMaxAlert) {
//            Alert(
//                title: Text("기록 종료"),
//                message: Text("12시간이 초과되어 WiD가 자동으로 등록되었습니다."),
//                dismissButton: .default(Text("확인"))
//            )
//        }
    }
    
    private func decreaseTitle() {
        titleIndex -= 1
        if titleIndex < 0 {
            titleIndex = titleArray.count - 1
        }
        title = titleArray[titleIndex]
    }

    private func increaseTitle() {
        titleIndex += 1
        if titleIndex >= titleArray.count {
            titleIndex = 0
        }
        title = titleArray[titleIndex]
    }
    
    private func startRecording() {
        startTimer.upstream.connect().cancel()
        isRecording.toggle()
    }

    private func stopRecording() {
        finishTimer.upstream.connect().cancel()
        if duration < 60 {
            showMinAlert = true
            resetRecording()
        } else {
            let calendar = Calendar.current
            let startComponents = calendar.dateComponents([.year, .month, .day], from: startTime)
            let finishComponents = calendar.dateComponents([.year, .month, .day], from: finishTime)

            if let startDate = calendar.date(from: startComponents),
               let finishDate = calendar.date(from: finishComponents) {

                // Check if the duration spans across multiple days
                if calendar.isDate(startDate, inSameDayAs: finishDate) {
                    // WiD duration is within the same day
                    let wiD = WiD(id: 0, title: title, detail: detail, date: startDate, start: startTime, finish: finishTime, duration: duration)
                    wiDService.insertWiD(wid: wiD)
                } else {
                    // WiD duration spans across multiple days
                    let midnightEndDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startDate)!
                    let firstDayWiD = WiD(id: 0, title: title, detail: detail, date: startDate, start: startTime, finish: midnightEndDate, duration: midnightEndDate.timeIntervalSince(startTime))
                    wiDService.insertWiD(wid: firstDayWiD)

                    let nextDayStartDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
                    let midnightEndDateNextDay = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: nextDayStartDate)!
                    let secondDayWiD = WiD(id: 0, title: title, detail: detail, date: nextDayStartDate, start: midnightEndDateNextDay, finish: finishTime, duration: finishTime.timeIntervalSince(midnightEndDateNextDay))
                    wiDService.insertWiD(wid: secondDayWiD)
                }
            }
        }
        isRecordingDone.toggle()
    }

    private func resetRecording() {
        startTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        finishTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        duration = 0
        wiD = WiD(id: 0, title: "", detail: "", date: Date(), start: Date(), finish: Date(), duration: 0)
        isRecording.toggle()
        isRecordingDone.toggle()
    }
}

struct WiDCreateView_Previews: PreviewProvider {
    static var previews: some View {
        WiDCreateView()
    }
}
