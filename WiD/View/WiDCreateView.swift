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
    
    @State private var isAfterStart: Bool = false // 기록이 진행 중인지
    @State private var isAfterStop: Bool = false // 기록이 종료 되었는지
    
    @State private var showMaxDurationAlert: Bool = false
    
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
                    
                    Spacer()

                    Circle()
                        .foregroundColor(Color(title))
                        .frame(width: 20, height: 20)
                }
                .padding(.horizontal)
                .padding(.top)
                
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
                    Image(systemName: "text.book.closed")
                        .imageScale(.large)
                        .frame(width: 25)
                    
                    Text("제목")
                        .font(.system(size: 25))

                    Button(action: {
                        decreaseTitle()
                    }) {
                        Image(systemName: "chevron.left")
                    }
                    .disabled(isAfterStart)
                    .padding(.horizontal)

                    Text(titleDictionary[title] ?? "")
                        .font(.system(size: 25))
                        .frame(maxWidth: .infinity)

                    Button(action: {
                        increaseTitle()
                    }) {
                        Image(systemName: "chevron.right")
                    }
                    .disabled(isAfterStart)
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
                        .opacity(isAfterStart ? 0.5 : 1)
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
                        .opacity(isAfterStart ? 1 : 0)
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
                        .opacity(isAfterStart ? 1 : 0)
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .background(Color("light_gray"))
            .cornerRadius(5)
            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)

            HStack {
//                임시 데이터 생성 버튼
//                Button(action: insertTmpWiD) {
//                    Image(systemName: "star.circle.fill")
//                        .imageScale(.large)
//                }
//                .frame(maxWidth: .infinity)

                Button(action: startRecording) {
                    Image(systemName: "play.fill")
                        .imageScale(.large)
                }
                .frame(maxWidth: .infinity)
                .disabled(isAfterStart)

                Button(action: stopRecording) {
                    Image(systemName: "stop.fill")
                        .imageScale(.large)
                }
                .frame(maxWidth: .infinity)
                .disabled(!isAfterStart || isAfterStop)

                Button(action: resetRecording) {
                    Image(systemName: "arrow.clockwise.circle.fill")
                        .imageScale(.large)
                }
                .frame(maxWidth: .infinity)
                .disabled(!isAfterStart || !isAfterStop)
            }
            .padding(.vertical)
        }
        .frame(maxWidth: 300)
        .padding(.horizontal)
        .onAppear() {
            timeLeftEnd = "남았습니다."
            
            let currentTime = Date()
            let calendar = Calendar.current
            
            let startOfDay = calendar.startOfDay(for: currentTime)
            let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: currentTime)!
            
            let totalTime = endOfDay.timeIntervalSince(startOfDay)
            let remainingTime = endOfDay.timeIntervalSince(currentTime)
            
            let percentage = Double(remainingTime / totalTime) * 100
            let roundedpercentage = (percentage * 10).rounded() / 10

            if roundedpercentage.rounded() < 1 {
                timeLeftPercentage = "곧"
                timeLeftEnd = "지나갑니다."
            } else if roundedpercentage.truncatingRemainder(dividingBy: 1) == 0 {
                timeLeftPercentage = String(format: "%.0f%%", roundedpercentage)
            } else {
                timeLeftPercentage = String(format: "%.1f%%", roundedpercentage)
            }
            
            if let savedDate = UserDefaults.standard.object(forKey: "date") as? Date {
                date = savedDate
            }
            
            if let savedTitle = UserDefaults.standard.string(forKey: "title") {
                title = savedTitle
            }
            
            if let savedStartTime = UserDefaults.standard.object(forKey: "startTime") as? Date {
                startTime = savedStartTime
            }
            
            isAfterStart = UserDefaults.standard.bool(forKey: "canStop")
            
            if isAfterStart {
                startTimer.upstream.connect().cancel()
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
                let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: currentTime)!
                
                let totalTime = endOfDay.timeIntervalSince(startOfDay)
                let remainingTime = endOfDay.timeIntervalSince(currentTime)
                
                let percentage = Double(remainingTime / totalTime) * 100
                let roundedpercentage = (percentage * 10).rounded() / 10

                if roundedpercentage.rounded() < 1 {
                    timeLeftPercentage = "곧"
                    timeLeftEnd = "지나갑니다."
                } else if roundedpercentage.truncatingRemainder(dividingBy: 1) == 0 {
                    timeLeftPercentage = String(format: "%.0f%%", roundedpercentage)
                } else {
                    timeLeftPercentage = String(format: "%.1f%%", roundedpercentage)
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
                
                let percentage = Double(remainingTime / totalTime) * 100 // TimeInterval 객체는 Double 타입임.
                let roundedpercentage = (percentage * 10).rounded() / 10

                if roundedpercentage.rounded() < 1 {
                    timeLeftPercentage = "곧"
                    timeLeftEnd = "지나갑니다."
                } else if roundedpercentage.truncatingRemainder(dividingBy: 1) == 0 {
                    timeLeftPercentage = String(format: "%.0f%%", roundedpercentage)
                } else {
                    timeLeftPercentage = String(format: "%.1f%%", roundedpercentage)
                }
            case 2: // 이번 달

                let startOfMonth = calendar.startOfDay(for: calendar.date(from: calendar.dateComponents([.year, .month], from: currentTime))!)
                let lastDayComponents = DateComponents(year: calendar.component(.year, from: currentTime), month: calendar.component(.month, from: currentTime) + 1, day: 0)
                let endOfMonth = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: calendar.startOfDay(for: calendar.date(from: lastDayComponents)!.addingTimeInterval(-1)))! // 다음 달 1일에서 -1일을 해서 이번 달 마지막 날로 이동 후, 23:59:59로 변경
                
                let totalTime = endOfMonth.timeIntervalSince(startOfMonth)
                let remainingTime = endOfMonth.timeIntervalSince(currentTime)
                
                let percentage = Double(remainingTime / totalTime) * 100
                let roundedpercentage = (percentage * 10).rounded() / 10

                if roundedpercentage.rounded() < 1 {
                    timeLeftPercentage = "곧"
                    timeLeftEnd = "지나갑니다."
                } else if roundedpercentage.truncatingRemainder(dividingBy: 1) == 0 {
                    timeLeftPercentage = String(format: "%.0f%%", roundedpercentage)
                } else {
                    timeLeftPercentage = String(format: "%.1f%%", roundedpercentage)
                }
            case 3: // 올해

                let startOfYear = calendar.startOfDay(for: calendar.date(from: calendar.dateComponents([.year], from: currentTime))!)
                let lastDayComponents = DateComponents(year: calendar.component(.year, from: currentTime) + 1, month: 0, day: 0)
                let endOfYear = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: calendar.startOfDay(for: calendar.date(from: lastDayComponents)!.addingTimeInterval(-1)))! // 다음 해 1일에서 -1일을 해서 올해 마지막 날로 이동 후, 23:59:59로 변경

                let totalTime = endOfYear.timeIntervalSince(startOfYear)
                let remainingTime = endOfYear.timeIntervalSince(currentTime)
                
                let percentage = Double(remainingTime / totalTime) * 100
                let roundedpercentage = (percentage * 10).rounded() / 10

                if roundedpercentage.rounded() < 1 {
                    timeLeftPercentage = "곧"
                    timeLeftEnd = "지나갑니다."
                } else if roundedpercentage.truncatingRemainder(dividingBy: 1) == 0 {
                    timeLeftPercentage = String(format: "%.0f%%", roundedpercentage)
                } else {
                    timeLeftPercentage = String(format: "%.1f%%", roundedpercentage)
                }
            default:
                break
            }
        }
        .onReceive(startTimer) { _ in
            startTime = Date()
            date = Date() // 날짜도 갱신되어야 자정을 지났을 때 날짜가 갱신됨.
        }
        .onReceive(finishTimer) { _ in
            finishTime = Date()
            duration = finishTime.timeIntervalSince(startTime)
            
            let durationLimit: TimeInterval = 60 * 60 * 12
            if durationLimit <= duration {
                finishTime = startTime.addingTimeInterval(durationLimit)
//                duration = durationLimit // 앱 종료 후 다시 켰을 때 12시간이 지나있으면 duration을 12시간으로 할당해버림.
                duration = finishTime.timeIntervalSince(startTime)
                stopRecording()
                showMaxDurationAlert = true
            }
        }
        .alert(isPresented: $showMaxDurationAlert) {
           Alert(
               title: Text("기록 종료"),
               message: Text("12시간이 초과되어 WiD가 자동으로 등록되었습니다."),
               dismissButton: .default(Text("확인"))
           )
       }
    }
    
    private func decreaseTitle() {
        titleIndex -= 1
        if titleIndex < 0 {
            titleIndex = titleArray.count - 1
        }
        withAnimation {
            title = titleArray[titleIndex]
        }
    }

    private func increaseTitle() {
        titleIndex += 1
        if titleIndex >= titleArray.count {
            titleIndex = 0
        }
        withAnimation {
            title = titleArray[titleIndex]
        }
    }
    
    private func startRecording() {
        startTimer.upstream.connect().cancel()
        isAfterStart.toggle()
        
        UserDefaults.standard.set(date, forKey: "date")
        UserDefaults.standard.set(title, forKey: "title")
        UserDefaults.standard.set(startTime, forKey: "startTime")
        UserDefaults.standard.set(isAfterStart, forKey: "canStop")
    }

    private func stopRecording() {
        UserDefaults.standard.removeObject(forKey: "date")
        UserDefaults.standard.removeObject(forKey: "title")
        UserDefaults.standard.removeObject(forKey: "startTime")
        UserDefaults.standard.removeObject(forKey: "canStop")
        
        finishTimer.upstream.connect().cancel()
        
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
        isAfterStop.toggle()
    }

    private func resetRecording() {
        startTime = Date() // 이 코드가 없으면 startTime이 startTimer에 의해 1초의 딜레이를 가지고 갱신되기 때문에 리셋하자마자 초기화해버림.
        startTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        finishTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        duration = 0
        isAfterStart.toggle()
        isAfterStop.toggle()
    }
    
//    private func insertTmpWiD() {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
//
//        var wiDs: [WiD] = []
//
////        ======================================================= 2023.07.24 월
//
//        wiDs.append(WiD(id: 0, title: "SLEEP", detail: "", date: dateFormatter.date(from: "2023.07.24 00:00:00")!,
//                        start: dateFormatter.date(from: "2023.07.24 01:23:23")!,
//                        finish: dateFormatter.date(from: "2023.07.24 07:54:26")!,
//                        duration: 6 * 3600 + 31 * 60 + 3))
//
//        wiDs.append(WiD(id: 0, title: "STUDY", detail: "", date: dateFormatter.date(from: "2023.07.24 00:00:00")!,
//                        start: dateFormatter.date(from: "2023.07.24 09:10:53")!,
//                        finish: dateFormatter.date(from: "2023.07.24 12:34:22")!,
//                        duration: 3 * 3600 + 23 * 60 + 29))
//
//        wiDs.append(WiD(id: 0, title: "STUDY", detail: "", date: dateFormatter.date(from: "2023.07.24 00:00:00")!,
//                        start: dateFormatter.date(from: "2023.07.24 14:12:28")!,
//                        finish: dateFormatter.date(from: "2023.07.24 17:54:38")!,
//                        duration: 3 * 3600 + 42 * 60 + 10))
//
//        wiDs.append(WiD(id: 0, title: "EXERCISE", detail: "", date: dateFormatter.date(from: "2023.07.24 00:00:00")!,
//                        start: dateFormatter.date(from: "2023.07.24 19:03:18")!,
//                        finish: dateFormatter.date(from: "2023.07.24 20:37:25")!,
//                        duration: 1 * 3600 + 34 * 60 + 7))
//
//        wiDs.append(WiD(id: 0, title: "HOBBY", detail: "", date: dateFormatter.date(from: "2023.07.24 00:00:00")!,
//                        start: dateFormatter.date(from: "2023.07.24 21:12:53")!,
//                        finish: dateFormatter.date(from: "2023.07.24 23:38:59")!,
//                        duration: 2 * 3600 + 26 * 60 + 6))
//
////        ======================================================= 2023.07.25 화
//
//        wiDs.append(WiD(id: 0, title: "SLEEP", detail: "", date: dateFormatter.date(from: "2023.07.25 00:00:00")!,
//                        start: dateFormatter.date(from: "2023.07.25 00:33:53")!,
//                        finish: dateFormatter.date(from: "2023.07.25 07:34:46")!,
//                        duration: 7 * 3600 + 0 * 60 + 53))
//
//        wiDs.append(WiD(id: 0, title: "STUDY", detail: "", date: dateFormatter.date(from: "2023.07.25 00:00:00")!,
//                        start: dateFormatter.date(from: "2023.07.25 08:12:13")!,
//                        finish: dateFormatter.date(from: "2023.07.25 12:24:25")!,
//                        duration: 4 * 3600 + 12 * 60 + 12))
//
//        wiDs.append(WiD(id: 0, title: "STUDY", detail: "", date: dateFormatter.date(from: "2023.07.25 00:00:00")!,
//                        start: dateFormatter.date(from: "2023.07.25 14:32:58")!,
//                        finish: dateFormatter.date(from: "2023.07.25 17:34:48")!,
//                        duration: 3 * 3600 + 1 * 60 + 50))
//
//        wiDs.append(WiD(id: 0, title: "STUDY", detail: "", date: dateFormatter.date(from: "2023.07.25 00:00:00")!,
//                        start: dateFormatter.date(from: "2023.07.25 18:42:18")!,
//                        finish: dateFormatter.date(from: "2023.07.25 22:44:18")!,
//                        duration: 4 * 3600 + 2 * 60 + 0))
//
////        ======================================================= 2023.07.26 수
//
//        wiDs.append(WiD(id: 0, title: "SLEEP", detail: "", date: dateFormatter.date(from: "2023.07.26 00:00:00")!,
//                        start: dateFormatter.date(from: "2023.07.26 00:53:53")!,
//                        finish: dateFormatter.date(from: "2023.07.26 07:24:46")!,
//                        duration: 6 * 3600 + 30 * 60 + 53))
//
//        wiDs.append(WiD(id: 0, title: "STUDY", detail: "", date: dateFormatter.date(from: "2023.07.26 00:00:00")!,
//                        start: dateFormatter.date(from: "2023.07.26 08:42:13")!,
//                        finish: dateFormatter.date(from: "2023.07.26 12:34:25")!,
//                        duration: 3 * 3600 + 52 * 60 + 12))
//
//        wiDs.append(WiD(id: 0, title: "STUDY", detail: "", date: dateFormatter.date(from: "2023.07.26 00:00:00")!,
//                        start: dateFormatter.date(from: "2023.07.26 13:52:58")!,
//                        finish: dateFormatter.date(from: "2023.07.26 17:24:48")!,
//                        duration: 3 * 3600 + 31 * 60 + 50))
//
//        wiDs.append(WiD(id: 0, title: "READING", detail: "", date: dateFormatter.date(from: "2023.07.26 00:00:00")!,
//                        start: dateFormatter.date(from: "2023.07.26 19:55:18")!,
//                        finish: dateFormatter.date(from: "2023.07.26 22:34:18")!,
//                        duration: 2 * 3600 + 39 * 60 + 0))
//
////        ======================================================= 2023.07.27 목
//
//        wiDs.append(WiD(id: 0, title: "SLEEP", detail: "", date: dateFormatter.date(from: "2023.07.27 00:00:00")!,
//                        start: dateFormatter.date(from: "2023.07.27 01:03:23")!,
//                        finish: dateFormatter.date(from: "2023.07.27 07:14:26")!,
//                        duration: 6 * 3600 + 11 * 60 + 3))
//
//        wiDs.append(WiD(id: 0, title: "STUDY", detail: "", date: dateFormatter.date(from: "2023.07.27 00:00:00")!,
//                        start: dateFormatter.date(from: "2023.07.27 08:13:53")!,
//                        finish: dateFormatter.date(from: "2023.07.27 12:24:22")!,
//                        duration: 4 * 3600 + 10 * 60 + 29))
//
//        wiDs.append(WiD(id: 0, title: "STUDY", detail: "", date: dateFormatter.date(from: "2023.07.27 00:00:00")!,
//                        start: dateFormatter.date(from: "2023.07.27 13:52:28")!,
//                        finish: dateFormatter.date(from: "2023.07.27 17:44:38")!,
//                        duration: 3 * 3600 + 52 * 60 + 10))
//
//        wiDs.append(WiD(id: 0, title: "EXERCISE", detail: "", date: dateFormatter.date(from: "2023.07.27 00:00:00")!,
//                        start: dateFormatter.date(from: "2023.07.27 18:53:18")!,
//                        finish: dateFormatter.date(from: "2023.07.27 20:27:25")!,
//                        duration: 1 * 3600 + 34 * 60 + 7))
//
//        wiDs.append(WiD(id: 0, title: "READING", detail: "", date: dateFormatter.date(from: "2023.07.27 00:00:00")!,
//                        start: dateFormatter.date(from: "2023.07.27 21:22:53")!,
//                        finish: dateFormatter.date(from: "2023.07.27 23:18:59")!,
//                        duration: 1 * 3600 + 56 * 60 + 6))
//
////        ======================================================= 2023.07.28 금
//
//        wiDs.append(WiD(id: 0, title: "SLEEP", detail: "", date: dateFormatter.date(from: "2023.07.28 00:00:00")!,
//                        start: dateFormatter.date(from: "2023.07.28 00:33:23")!,
//                        finish: dateFormatter.date(from: "2023.07.28 07:24:26")!,
//                        duration: 6 * 3600 + 51 * 60 + 3))
//
//        wiDs.append(WiD(id: 0, title: "STUDY", detail: "", date: dateFormatter.date(from: "2023.07.28 00:00:00")!,
//                        start: dateFormatter.date(from: "2023.07.28 08:03:53")!,
//                        finish: dateFormatter.date(from: "2023.07.28 12:25:22")!,
//                        duration: 4 * 3600 + 21 * 60 + 29))
//
//        wiDs.append(WiD(id: 0, title: "STUDY", detail: "", date: dateFormatter.date(from: "2023.07.28 00:00:00")!,
//                        start: dateFormatter.date(from: "2023.07.28 13:32:28")!,
//                        finish: dateFormatter.date(from: "2023.07.28 17:24:38")!,
//                        duration: 3 * 3600 + 52 * 60 + 10))
//
//        wiDs.append(WiD(id: 0, title: "EXERCISE", detail: "", date: dateFormatter.date(from: "2023.07.28 00:00:00")!,
//                        start: dateFormatter.date(from: "2023.07.28 18:33:18")!,
//                        finish: dateFormatter.date(from: "2023.07.28 20:07:25")!,
//                        duration: 1 * 3600 + 34 * 60 + 7))
//
//        wiDs.append(WiD(id: 0, title: "HOBBY", detail: "", date: dateFormatter.date(from: "2023.07.28 00:00:00")!,
//                        start: dateFormatter.date(from: "2023.07.28 21:02:53")!,
//                        finish: dateFormatter.date(from: "2023.07.28 23:08:59")!,
//                        duration: 2 * 3600 + 6 * 60 + 6))
//
////        ======================================================= 2023.07.29 토
//
//        wiDs.append(WiD(id: 0, title: "SLEEP", detail: "", date: dateFormatter.date(from: "2023.07.29 00:00:00")!,
//                        start: dateFormatter.date(from: "2023.07.29 00:13:23")!,
//                        finish: dateFormatter.date(from: "2023.07.29 08:24:26")!,
//                        duration: 8 * 3600 + 11 * 60 + 3))
//
//        wiDs.append(WiD(id: 0, title: "EXERCISE", detail: "", date: dateFormatter.date(from: "2023.07.29 00:00:00")!,
//                        start: dateFormatter.date(from: "2023.07.29 08:53:53")!,
//                        finish: dateFormatter.date(from: "2023.07.29 10:45:22")!,
//                        duration: 1 * 3600 + 51 * 60 + 29))
//
//        wiDs.append(WiD(id: 0, title: "HOBBY", detail: "", date: dateFormatter.date(from: "2023.07.29 00:00:00")!,
//                        start: dateFormatter.date(from: "2023.07.29 11:12:28")!,
//                        finish: dateFormatter.date(from: "2023.07.29 12:44:38")!,
//                        duration: 1 * 3600 + 32 * 60 + 10))
//
//        wiDs.append(WiD(id: 0, title: "HOBBY", detail: "", date: dateFormatter.date(from: "2023.07.29 00:00:00")!,
//                        start: dateFormatter.date(from: "2023.07.29 13:33:18")!,
//                        finish: dateFormatter.date(from: "2023.07.29 17:57:25")!,
//                        duration: 4 * 3600 + 24 * 60 + 7))
//
//        wiDs.append(WiD(id: 0, title: "READING", detail: "", date: dateFormatter.date(from: "2023.07.29 00:00:00")!,
//                        start: dateFormatter.date(from: "2023.07.29 18:22:53")!,
//                        finish: dateFormatter.date(from: "2023.07.29 21:38:59")!,
//                        duration: 3 * 3600 + 16 * 60 + 6))
//
////        ======================================================= 2023.07.30 일
//
//        wiDs.append(WiD(id: 0, title: "SLEEP", detail: "", date: dateFormatter.date(from: "2023.07.30 00:00:00")!,
//                        start: dateFormatter.date(from: "2023.07.30 00:33:23")!,
//                        finish: dateFormatter.date(from: "2023.07.30 08:14:26")!,
//                        duration: 7 * 3600 + 41 * 60 + 3))
//
//        wiDs.append(WiD(id: 0, title: "EXERCISE", detail: "", date: dateFormatter.date(from: "2023.07.30 00:00:00")!,
//                        start: dateFormatter.date(from: "2023.07.30 08:23:53")!,
//                        finish: dateFormatter.date(from: "2023.07.30 10:15:22")!,
//                        duration: 1 * 3600 + 51 * 60 + 29))
//
//        wiDs.append(WiD(id: 0, title: "HOBBY", detail: "", date: dateFormatter.date(from: "2023.07.30 00:00:00")!,
//                        start: dateFormatter.date(from: "2023.07.30 10:42:28")!,
//                        finish: dateFormatter.date(from: "2023.07.30 12:34:38")!,
//                        duration: 1 * 3600 + 52 * 60 + 10))
//
//        wiDs.append(WiD(id: 0, title: "HOBBY", detail: "", date: dateFormatter.date(from: "2023.07.30 00:00:00")!,
//                        start: dateFormatter.date(from: "2023.07.30 13:23:18")!,
//                        finish: dateFormatter.date(from: "2023.07.30 17:47:25")!,
//                        duration: 4 * 3600 + 24 * 60 + 7))
//
//        wiDs.append(WiD(id: 0, title: "READING", detail: "", date: dateFormatter.date(from: "2023.07.30 00:00:00")!,
//                        start: dateFormatter.date(from: "2023.07.30 18:24:53")!,
//                        finish: dateFormatter.date(from: "2023.07.30 21:28:59")!,
//                        duration: 3 * 3600 + 4 * 60 + 6))
//
//        for wiD in wiDs {
//            wiDService.insertWiD(wid: wiD)
//        }
//    }
}

struct WiDCreateView_Previews: PreviewProvider {
    static var previews: some View {
        WiDCreateView()
    }
}
