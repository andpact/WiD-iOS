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
    // 스톱 워치
    private var timer: Timer?
    @Published var elapsedTime = 0 // 화면에 시간만을 표시하기 위한 프로퍼티
    @Published var stopwatchState: PlayerState = PlayerState.STOPPED
    @Published var inStopwatchView = false // 현재 스톱 워치 뷰 안에 있는지?
    
    // 날짜
    var date: Date = Date()
    
    // 제목
    @Published var title: Title = .STUDY
    
    // 시작 시간
    var start: Date = Date()

    // 스톱 워치 플레이어 시작
    func startStopwatch() {
        stopwatchState = PlayerState.STARTED
        
        let now = Date()
        
        self.date = now
        self.start = now
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.elapsedTime += 1
        }
    }
    
    // 스톱 워치 플레이어 이어서 시작
    func restartStopwatch() {
        self.elapsedTime = 0
    }

    // 스톱 워치 플레이어 중지
    func pauseStopwatch() {
        stopwatchState = PlayerState.PAUSED
        
        self.timer?.invalidate()
        self.timer = nil
    }
    
    // 스톱 워치 플레이어 정지(초기화)
    func stopStopwatch() {
        stopwatchState = PlayerState.STOPPED
        
        self.elapsedTime = 0
    }
}
