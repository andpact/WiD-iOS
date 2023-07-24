//
//  WiDCreateView.swift
//  WiD
//
//  Created by jjkim on 2023/07/06.
//

import SwiftUI

struct WiDCreateView: View {
    
    private let wiDService = WiDService()
    
    private let date: Date = Date()
    @State private var title: String = titleArray[0]
    @State private var titleIndex: Int = 0
    private let detail: String = ""
    @State private var startTime: Date = Date()
    @State private var finishTime: Date = Date()
    @State private var duration: TimeInterval = 0
    
    @State private var startTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var finishTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var wiD: WiD = WiD(id: 0, title: "", detail: "", date: Date(), start: Date(), finish: Date(), duration: 0)
    
    @State private var isRecording = false
    @State private var isRecordingDone = false
    
    @State private var showMinAlert = false
    @State private var showMaxAlert = false
    
    var body: some View {
        VStack {
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
        .onReceive(startTimer) { input in
            startTime = Date()
        }
        .onReceive(finishTimer) { input in
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
                    title: Text("WiD 기록 종료"),
                    message: Text("1분 이상의 WiD를 기록해주세요."),
                    dismissButton: .default(Text("확인")) {
                        showMinAlert = false
                    }
                )
            case (false, true):
                return Alert(
                    title: Text("WiD 기록 종료"),
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
