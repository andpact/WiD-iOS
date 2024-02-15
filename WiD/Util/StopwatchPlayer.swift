//
//  Stopwatch.swift
//  WiD
//
//  Created by jjkim on 2024/01/11.
//

import Foundation
import SwiftUI

/**
 렌더링이 필요한 프로퍼티(제목, 소요 시간)만 @Published 사용함.
 값만 사용하는 프로퍼티는 @Published 사용 안 함.
 */
class StopwatchPlayer: ObservableObject {
    // WiD
    private let wiDService = WiDService()
    
    // 스톱 워치
    private var timer: Timer?
    private var prevDuration = TimeInterval.zero
    @Published var totalDuration = TimeInterval.zero
    @Published var stopwatchState: PlayerState = PlayerState.STOPPED
    @Published var inStopwatchView = false // 현재 스톱 워치 뷰 안에 있는지?
    @Published var stopwatchTopBottomBarVisible: Bool = true
    
    // 날짜
    private let calendar = Calendar.current
    var date: Date = Date()
    
    // 제목
    @Published var title: Title = .STUDY
    
    // 시작 시간
    var start: Date = Date()
    
    // 종료 시간
    var finish: Date = Date()

    // 스톱 워치 플레이어 시작
    func startStopwatch() {
        print("StopwatchPlayer : startStopwatch executed")
        
        stopwatchState = PlayerState.STARTED
        
        let now = calendar.date(bySetting: .nanosecond, value: 0, of: Date())! // 밀리 세컨드 제거하여 초 단위만 사용
        
        self.date = now
        self.start = now
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            let now = self.calendar.date(bySetting: .nanosecond, value: 0, of: Date())!
            self.finish = now
            
            if self.calendar.isDate(self.start, inSameDayAs: self.finish) {
                self.totalDuration = self.prevDuration + self.finish.timeIntervalSince(self.start)
            } else { // 자정 넘어가는 경우
                self.totalDuration = self.prevDuration + self.calendar.date(bySettingHour: 23, minute: 59, second: 59, of: self.start)!.timeIntervalSince(self.start)
                + self.finish.timeIntervalSince(self.calendar.startOfDay(for: self.finish))
            }
        }
    }

    // 스톱 워치 플레이어 중지
    func pauseStopwatch() {
        print("StopwatchPlayer : pauseStopwatch executed")
        
        stopwatchState = PlayerState.PAUSED
        
        let currentDuration = self.finish.timeIntervalSince(self.start)
        
        // Check if the duration spans across multiple days
        if calendar.isDate(start, inSameDayAs: finish) {
            guard 0 <= currentDuration else {
                return
            }
            
            // WiD duration is within the same day
            let wiD = WiD(
                id: 0,
                date: start,
                title: title.rawValue,
                start: start,
                finish: finish,
                duration: currentDuration
            )
            wiDService.createWiD(wid: wiD)
        } else {
            // WiD duration spans across multiple days
            let finishOfStart = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: start)!
            let firstDayWiD = WiD(
                id: 0,
                date: start,
                title: title.rawValue,
                start: start,
                finish: finishOfStart,
                duration: finishOfStart.timeIntervalSince(start)
            )
            wiDService.createWiD(wid: firstDayWiD)

            let startOfFinish = calendar.startOfDay(for: finish)
            let secondDayWiD = WiD(
                id: 0,
                date: finish,
                title: title.rawValue,
                start: startOfFinish,
                finish: finish,
                duration: finish.timeIntervalSince(startOfFinish)
            )
            wiDService.createWiD(wid: secondDayWiD)
        }
        
        prevDuration = totalDuration
        
        self.timer?.invalidate()
        self.timer = nil
    }
    
    // 스톱 워치 플레이어 정지(초기화)
    func stopStopwatch() {
        print("StopwatchPlayer : stopStopwatch executed")
        
        stopwatchState = PlayerState.STOPPED
        
        self.totalDuration = TimeInterval.zero
        self.prevDuration = self.totalDuration
    }
}
