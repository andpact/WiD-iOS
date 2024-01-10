//
//  TmpStopWatchView.swift
//  WiD
//
//  Created by jjkim on 2024/01/10.
//

import SwiftUI

class StopwatchPlayer: ObservableObject {
    @Published var elapsedTime: TimeInterval = 0.0
    @Published var isRunning: Bool = false
    private var timer: Timer?

    func startStopWatch() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            self.elapsedTime += 0.01
        }
        isRunning = true
    }

    func stopStopWatch() {
        timer?.invalidate()
        timer = nil
        isRunning = false
    }
    
    func resetStopWatch() {
        elapsedTime = 0.0
    }
}

struct TmpStopWatchView: View {
    @EnvironmentObject var stopwatchPlayer: StopwatchPlayer

    var body: some View {
        VStack {
            Text(String(format: "%.1f", stopwatchPlayer.elapsedTime))
                .font(.largeTitle)
                .padding()

            HStack {
                Button(action: {
                    if stopwatchPlayer.isRunning {
                        stopwatchPlayer.stopStopWatch()
                    } else {
                        stopwatchPlayer.startStopWatch()
                    }
                }) {
                    Text(stopwatchPlayer.isRunning ? "Stop" : "Start")
                }

                Button(action: {
                    stopwatchPlayer.resetStopWatch()
                }) {
                    Text("Reset")
                }
            }
            .padding()
        }
    }
}

struct TmpStopWatchView_Previews: PreviewProvider {
    static var previews: some View {
        TmpStopWatchView()
            .environmentObject(StopwatchPlayer())
    }
}
