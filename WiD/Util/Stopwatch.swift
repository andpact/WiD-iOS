//
//  Stopwatch.swift
//  WiD
//
//  Created by jjkim on 2024/01/11.
//

import Foundation

/**
 렌더링이 필요한 프로퍼티만 @Published 사용함.
 값만 가지는 프로퍼티는 @Published 사용 안 함.
 */
class Stopwatch: ObservableObject {
    // 스톱 워치
    @Published var elapsedTime = 0 // 화면에 시간만을 표시하기 위한 프로퍼티
    @Published var stopwatchStarted: Bool = false
    @Published var stopwatchPaused: Bool = false
    @Published var stopwatchReset: Bool = true
    private var timer: Timer?
    
    // 날짜
    var date: Date = Date()
    
    // 제목
    @Published var title: Title = .STUDY
    
    // 시작 시간
    var start: Date = Date()

    // 스톱 워치 플레이어 시작
    func startStopwatchPlayer() {
        self.stopwatchStarted = true
        self.stopwatchPaused = false
        self.stopwatchReset = false
        
        let now = Date()
        
        self.date = now
        self.start = now
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.elapsedTime += 1
        }
    }
    
    // 스톱 워치 플레이어 이어서 시작
    func restartStopwatchPlayer() {
        self.elapsedTime = 0
    }

    // 스톱 워치 플레이어 중지
    func pauseStopwatchPlayer() {
        self.stopwatchStarted = false
        self.stopwatchPaused = true
        
        self.timer?.invalidate()
        self.timer = nil
    }
    
    // 스톱 워치 플레이어 초기화
    func resetStopwatchPlayer() {
        self.stopwatchPaused = false
        self.stopwatchReset = true
        self.elapsedTime = 0
    }
}
