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
    @State private var titleMenuExpand: Bool = false
    
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
    @State private var stopWatchStarted: Bool = false
    @State private var stopWatchPaused: Bool = false
    @State private var stopWatchReset: Bool = true
    @State private var elapsedTime = 0
    @State private var buttonText: String = "시작"
    private let timerInterval = 1
    
    var body: some View {
        NavigationView {
            ZStack {
                if stopWatchTopBottomBarVisible {
                    /**
                     상단 바
                     */
                    ZStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                            
                            if stopWatchStarted {
                                pauseStopWatch()
                            }
                        }) {
                            Image(systemName: "chevron.backward")
                            
                            Text("뒤로 가기")
                                .bodyMedium()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.blue)

                        Text("스톱워치")
                            .titleLarge()
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    
                }
                
                /**
                 컨텐츠
                 */
                formatStopWatchTime(elapsedTime)
                
                /**
                 하단 바
                 */
                if stopWatchTopBottomBarVisible {
                    VStack {
                        if titleMenuExpand {
                            Text("현재 사용할 제목을 선택해 주세요.")
                                .titleMedium()
                                .foregroundColor(.white)
//                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(), count: 5)) {
                                ForEach(Title.allCases) { buttonTitle in
                                    Button(action: {
                                        title = buttonTitle
                                        withAnimation {
                                            titleMenuExpand.toggle()
                                        }
                                    }) {
                                        Text(buttonTitle.koreanValue)
                                            .bodyMedium()
                                            .frame(maxWidth: .infinity)
                                            .padding(8)
                                            .background(title == buttonTitle ? .white : .gray)
                                            .foregroundColor(title == buttonTitle ? .black : .white)
                                            .cornerRadius(8)
                                    }
                                }
                            }
                            
                            Divider()
                                .background(.white)
                        }

                        HStack {
                            Button(action: {
                                withAnimation {
                                    titleMenuExpand.toggle()
                                }
                            }) {
                                Rectangle()
                                    .frame(maxWidth: 5, maxHeight: 20)
                                    .foregroundColor(Color(title.rawValue))
                                
                                Text(title.koreanValue)
                                    .bodyMedium()
                                
                                Image(systemName: "chevron.up.chevron.down")
                                    .imageScale(.small)
                            }
                            .foregroundColor(.white)
                            
                            Spacer()
                            
                            if stopWatchPaused {
                                Button(action: {
                                    resetStopWatch()
                                }) {
                                    Image(systemName: "arrow.clockwise")
                                        .imageScale(.large)
                                }
                                .frame(maxWidth: 25, maxHeight: 25)
                                .padding()
                                .background(.blue)
                                .foregroundColor(.white)
                                .cornerRadius(80)
                            }
                            
                            Button(action: {
                                if stopWatchStarted {
                                    pauseStopWatch()
                                } else {
                                    startStopWatch()
                                }
                            }) {
                                Image(systemName: buttonText == "중지" ? "pause.fill" : "play.fill")
                                    .imageScale(.large)
                            }
                            .frame(maxWidth: 25, maxHeight: 25)
                            .padding()
                            .background(buttonText == "중지" ? .red : (buttonText == "계속" ? .green : .blue))
                            .foregroundColor(.white)
                            .cornerRadius(80)
                        }
                    }
                    .padding()
                    .background(.black)
                    .cornerRadius(8)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                }
            }
            .tint(.black)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.white)
            .onTapGesture {
                if stopWatchStarted {
                    withAnimation {
                        stopWatchTopBottomBarVisible.toggle()
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private func startStopWatch() {
        stopWatchStarted = true
        stopWatchPaused = false
        stopWatchReset = false
        buttonText = "중지"
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(timerInterval), repeats: true) { timer in
            if elapsedTime < 12 * 60 * 60 {
                elapsedTime += timerInterval
            } else {
                pauseStopWatch()
                resetStopWatch()
            }
        }
        
        date = Date()
        start = Date()
    }

    private func pauseStopWatch() {
        stopWatchStarted = false
        stopWatchPaused = true
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

    private func resetStopWatch() {
        stopWatchPaused = false
        stopWatchReset = true
        elapsedTime = 0
        buttonText = "시작"
    }
}

struct StopWatchView_Previews: PreviewProvider {
    static var previews: some View {
        return StopWatchView()
    }
}
