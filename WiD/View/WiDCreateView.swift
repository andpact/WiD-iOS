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
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("WiD")
                        .font(.system(size: 30))
                    
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
            .cornerRadius(10)
            .padding(.horizontal)

            HStack {
                Button(action: { // 시작 버튼
                    startTimer.upstream.connect().cancel()
                    isRecording.toggle()
                }) {
                    Image(systemName: "play.fill")
                        .imageScale(.large)
                }
                .frame(maxWidth: .infinity)
                .disabled(isRecording)
                
                Button(action: { // 종료 버튼
                    finishTimer.upstream.connect().cancel()
                    duration += 60 * 60 * 1 // 1시간 추가
                    wiD = WiD(id: 0, title: title, detail: detail, date: date, start: startTime, finish: finishTime, duration: duration)
                    wiDService.insertWiD(wid: wiD)
                    isRecordingDone.toggle()
                }) {
                    Image(systemName: "stop.fill")
                        .imageScale(.large)
                }
                .frame(maxWidth: .infinity)
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
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal)
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
}

struct WiDCreateView_Previews: PreviewProvider {
    static var previews: some View {
        WiDCreateView()
    }
}
