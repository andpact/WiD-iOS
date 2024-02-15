//
//  Timer.swift
//  WiD
//
//  Created by jjkim on 2024/01/12.
//

import Foundation
import SwiftUI

class TimerPlayer: ObservableObject {
    // WiD
    private let wiDService = WiDService()
    
    // 타이머
    private var timer: Timer?
    @Published var remainingTime = TimeInterval.zero // 시간 표시용
    @Published var selectedTime = TimeInterval.zero // 시간 선택용
    private var currentTime = TimeInterval.zero // 시간 선택용
    @Published var timerState: PlayerState = PlayerState.STOPPED
    @Published var inTimerView = false // 현재 타이머 뷰 안에 있는지?
    @Published var timerTopBottomBarVisible: Bool = true
    
    // 날짜
    private let calendar = Calendar.current
    var date: Date = Date()
    
    // 제목
    @Published var title: Title = .STUDY
    
    // 시작 시간
    var start: Date = Date()
    
    // 종료 시간
    var finish: Date = Date()
    
    func startTimer() {
        print("TimerPlayer : startTimer executed")
        
        timerState = PlayerState.STARTED
        
        let now = calendar.date(bySetting: .nanosecond, value: 0, of: Date())! // 밀리 세컨드 제거하여 초 단위만 사용
        
        self.date = now
        self.start = now
        
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(1), repeats: true) { _ in
            let now = self.calendar.date(bySetting: .nanosecond, value: 0, of: Date())! // 밀리 세컨드 제거하여 초 단위만 사용
            self.finish = now
            
            if self.calendar.isDate(self.start, inSameDayAs: self.finish) {
                self.remainingTime = self.selectedTime - self.finish.timeIntervalSince(self.start) - self.currentTime
            } else { // 자정 넘어갈 때
                self.remainingTime = self.selectedTime - self.calendar.date(bySettingHour: 23, minute: 59, second: 59, of: self.start)!.timeIntervalSince(self.start)
                - self.finish.timeIntervalSince(self.calendar.startOfDay(for: self.finish)) - self.currentTime
            }
            
            if self.remainingTime < 0 { // 남은 시간이 0이 될 때
                self.pauseTimer()
                self.stopTimer()
            }
        }
    }
    
    func pauseTimer() {
        print("TimerPlayer : pauseTimer executed")
        
        timerState = PlayerState.PAUSED
        
        currentTime = self.finish.timeIntervalSince(self.start)
//        
//        // Check if the duration spans across multiple days
//        if calendar.isDate(start, inSameDayAs: finish) {
//            guard 0 <= currentDuration else {
//                return
//            }
//            
//            // WiD duration is within the same day
//            let wiD = WiD(
//                id: 0,
//                date: start,
//                title: title.rawValue,
//                start: start,
//                finish: finish,
//                duration: currentTime
//            )
//            wiDService.createWiD(wid: wiD)
//        } else {
//            // WiD duration spans across multiple days
//            let finishOfStart = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: start)!
//            let firstDayWiD = WiD(
//                id: 0,
//                date: start,
//                title: title.rawValue,
//                start: start,
//                finish: finishOfStart,
//                duration: finishOfStart.timeIntervalSince(start)
//            )
//            wiDService.createWiD(wid: firstDayWiD)
//
//            let startOfFinish = calendar.startOfDay(for: finish)
//            let secondDayWiD = WiD(
//                id: 0,
//                date: finish,
//                title: title.rawValue,
//                start: startOfFinish,
//                finish: finish,
//                duration: finish.timeIntervalSince(startOfFinish)
//            )
//            wiDService.createWiD(wid: secondDayWiD)
//        }
        
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func stopTimer() {
        print("TimerPlayer : stopTimer executed")
        
        timerState = PlayerState.STOPPED
        
        self.remainingTime = TimeInterval.zero
        self.currentTime = TimeInterval.zero
        self.selectedTime = TimeInterval.zero
    }
}
