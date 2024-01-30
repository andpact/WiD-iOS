//
//  Timer.swift
//  WiD
//
//  Created by jjkim on 2024/01/12.
//

import Foundation
import SwiftUI

class TimerPlayer: ObservableObject {
    // 타이머
    private var timer: Timer?
    @Published var remainingTime = 0 // 화면에 시간만을 표시하기 위한 프로퍼티
    private let timerInterval = 1
    @Published var timerState: PlayerState = PlayerState.STOPPED
    @Published var inTimerView = false // 현재 타이머 뷰 안에 있는지?
    
    // 날짜
    var date: Date = Date()
    
    // 제목
    @Published var title: Title = .STUDY
    
    // 시작 시간
    var start: Date = Date()
    
    func startTimer() {
        print("TimerPlayer : startTimer executed")
        
        timerState = PlayerState.STARTED
        
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(timerInterval), repeats: true) { _ in
            if self.remainingTime > 0 {
                self.remainingTime -= self.timerInterval
            } else {
                self.pauseTimer()
                self.stopTimer()
            }
        }
        
        let now = Date()
        
        self.date = now
        self.start = now
    }
    
    func pauseTimer() {
        print("TimerPlayer : pauseTimer executed")
        
        timerState = PlayerState.PAUSED
        
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func stopTimer() {
        print("TimerPlayer : stopTimer executed")
        
        timerState = PlayerState.STOPPED
        
        self.remainingTime = 0
    }
}
