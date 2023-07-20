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
    @State private var title: Title = .STUDY
    private let detail: String = ""
    @State private var startTime: Date = Date()
    @State private var finishTime: Date = Date()
    @State private var duration: TimeInterval = 0
    
    @State private var startTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var finishTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var wiD: WiD = WiD(id: 0, title: "", detail: "", date: Date(), start: Date(), finish: Date(), duration: 0)
    
    @State private var isRecording = false
    @State private var isRecordingDone = false
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("WiD")
                        .font(.system(size: 30))

                    Circle()
                        .foregroundColor(Color(title.stringValue))
                        .frame(width: 20, height: 20)
                }
                HStack {
                    Image(systemName: "calendar")
                        .imageScale(.large)
                    Text("날짜")
                        .font(.system(size: 30))

                    HStack {
                        Text(formatDate(date, format: "yyyy.MM.dd"))
                            .font(.system(size: 30))

                        Text(formatWeekday(date))
                            .font(.system(size: 30))
                            .foregroundColor(Calendar.current.component(.weekday, from: date) == 1 ? .red : (Calendar.current.component(.weekday, from: date) == 7 ? .blue : .black))
                    }
                }

                HStack {
                    Image(systemName: "doc.text.magnifyingglass")
                        .imageScale(.large)
                    Text("제목")
                        .font(.system(size: 30))

                    Button(action: {
                        decreaseTitle()
                    }) {
                        Image(systemName: "chevron.left")
                    }
                    .disabled(isRecording)
                    .opacity(isRecording ? 0 : 1)

                    Text(title.stringValue)
                        .font(.system(size: 30))

                    Button(action: {
                        increaseTitle()
                    }) {
                        Image(systemName: "chevron.right")
                    }
                    .disabled(isRecording)
                    .opacity(isRecording ? 0 : 1)
                }

                HStack {
                    Image(systemName: "clock")
                        .imageScale(.large)
                    Text("시작")
                        .font(.system(size: 30))

                    Text(formatTime(startTime, format: "HH:mm:ss"))
                        .font(.system(size: 30))
                        .opacity(isRecording ? 0.5 : 1)
                }

                HStack {
                    Image(systemName: "stopwatch")
                        .imageScale(.large)
                    Text("종료")
                        .font(.system(size: 30))

                    Text(formatTime(finishTime, format: "HH:mm:ss"))
                        .font(.system(size: 30))
                        .opacity(isRecording ? 1 : 0)
                }

                HStack {
                    Image(systemName: "hourglass")
                        .imageScale(.large)
                    Text("소요")
                        .font(.system(size: 30))

                    Text(formatDuration(duration, isClickedWiD: true))
                        .font(.system(size: 30))
                        .opacity(isRecording ? 1 : 0)
                }

            }
            .border(Color.black)

            HStack {
                Button(action: { // 시작 버튼
                    startTimer.upstream.connect().cancel()
                    isRecording.toggle()
                }) {
                    Image(systemName: "play.fill")
                        .imageScale(.large)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .disabled(isRecording)
                
                Button(action: { // 종료 버튼
                    finishTimer.upstream.connect().cancel()
                    duration += 60 * 60 * 1 // 1시간 추가
                    wiD = WiD(id: 0, title: title.stringValue, detail: detail, date: date, start: startTime, finish: finishTime, duration: duration)
                    wiDService.insertWiD(wid: wiD)
                    isRecordingDone.toggle()
                }) {
                    Image(systemName: "stop.fill")
                        .imageScale(.large)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .disabled(!isRecording || isRecordingDone)
                
                Button(action: { // 초기화 버튼
                    startTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                    finishTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                    duration = 0
                    wiD = WiD(id: 0, title: "", detail: "", date: Date(), start: Date(), finish: Date(), duration: 0)
                    isRecording.toggle()
                    isRecordingDone.toggle()
                }) {
                    Image(systemName: "arrow.clockwise.circle.fill")
                        .imageScale(.large)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .disabled(!isRecording || !isRecordingDone)
            }
        }
        .onReceive(startTimer) { input in
            startTime = Date()
        }
        .onReceive(finishTimer) { input in
            finishTime = Date()
            duration = finishTime.timeIntervalSince(startTime)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .border(Color.black)
        .padding(.horizontal)
    }
    
    private func decreaseTitle() {
        switch title {
            case .STUDY:
            title = .OTHER
            case .WORK:
            title = .STUDY
            case .READING:
            title = .WORK
            case .EXERCISE:
            title = .READING
            case .HOBBY:
            title = .EXERCISE
            case .MEAL:
            title = .HOBBY
            case .SHOWER:
            title = .MEAL
            case .TRAVEL:
            title = .SHOWER
            case .SLEEP:
            title = .TRAVEL
            case .OTHER:
            title = .SLEEP
        }
    }

    private func increaseTitle() {
        switch title {
            case .STUDY:
            title = .WORK
            case .WORK:
            title = .READING
            case .READING:
            title = .EXERCISE
            case .EXERCISE:
            title = .HOBBY
            case .HOBBY:
            title = .MEAL
            case .MEAL:
            title = .SHOWER
            case .SHOWER:
            title = .TRAVEL
            case .TRAVEL:
            title = .SLEEP
            case .SLEEP:
            title = .OTHER
            case .OTHER:
            title = .STUDY
        }
    }
}

struct WiDCreateView_Previews: PreviewProvider {
    static var previews: some View {
        WiDCreateView()
    }
}
