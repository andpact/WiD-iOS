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
    @State private var title: Title = .study
    private let detail: String = ""
    @State private var startTime: Date = Date()
    @State private var finishTime: Date = Date()
    @State private var duration: TimeInterval = 0
    
    @State private var startTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var finishTimer = Timer.publish(every: 1, on: .main, in: .common)
    
    @State private var wiD: WiD = WiD(id: 0, title: "", detail: "", date: Date(), start: Date(), finish: Date(), duration: 0)
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("날짜")
                    HStack {
                        Text(formatDate(date, format: "yyyy.MM.dd"))
                        
                        Text(formatWeekday(date))
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                
                HStack {
                    Text("제목")
                    
                    Button(action: {
                        decreaseTitle()
                    }) {
                        Image(systemName: "chevron.left")
                    }

                    Text(title.stringValue)
                        .frame(maxWidth: .infinity, alignment: .center)

                    Button(action: {
                        increaseTitle()
                    }) {
                        Image(systemName: "chevron.right")
                    }
                }
                
                HStack {
                    Text("시작")
                    
                    Text(formatTime(startTime, format: "HH:mm:ss"))
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                
                HStack {
                    Text("종료")
                    
                    Text(formatTime(finishTime, format: "HH:mm:ss"))
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                
                HStack {
                    Text("소요")
                    
                    Text(formatDuration(duration))
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .border(Color.black)

            HStack {
                Button(action: {
                    startTimer.upstream.connect().cancel()
                    _ = finishTimer.connect()
                }) {
                    Text("시작")
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                Button(action: {
                    finishTimer.connect().cancel()
                    duration += 60 * 60 * 1 // 1시간 추가
                    wiD = WiD(id: 0, title: title.stringValue, detail: detail, date: date, start: startTime, finish: finishTime, duration: duration)
                    wiDService.insertWiD(wid: wiD)
                }) {
                    Text("종료")
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                Button(action: {
                    startTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                    finishTimer = Timer.publish(every: 1, on: .main, in: .common)
                    duration = 0
                    wiD = WiD(id: 0, title: "", detail: "", date: Date(), start: Date(), finish: Date(), duration: 0)
                }) {
                    Text("초기화")
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .onReceive(startTimer) { input in
            startTime = Date()
        }
        .onReceive(finishTimer) { input in
            finishTime = Date()
            duration = finishTime.timeIntervalSince(startTime)
        }
        .frame(maxHeight: .infinity)
//        .padding(50)
        .border(Color.black)
        .padding()
    }
    
    func formatDate(_ date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    func formatWeekday(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        return dateFormatter.string(from: date)
    }
    
    private func decreaseTitle() {
        switch title {
        case .study:
            title = .other
        case .work:
            title = .study
        case .reading:
            title = .work
        case .exercise:
            title = .reading
        case .hobby:
            title = .exercise
        case .meal:
            title = .hobby
        case .shower:
            title = .meal
        case .travel:
            title = .shower
        case .sleep:
            title = .travel
        case .other:
            title = .sleep
        }
    }

    private func increaseTitle() {
        switch title {
        case .study:
            title = .work
        case .work:
            title = .reading
        case .reading:
            title = .exercise
        case .exercise:
            title = .hobby
        case .hobby:
            title = .meal
        case .meal:
            title = .shower
        case .shower:
            title = .travel
        case .travel:
            title = .sleep
        case .sleep:
            title = .other
        case .other:
            title = .study
        }
    }
    
    func formatTime(_ date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    func formatDuration(_ interval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: interval) ?? ""
    }
}

struct WiDCreateView_Previews: PreviewProvider {
    static var previews: some View {
        WiDCreateView()
    }
}
