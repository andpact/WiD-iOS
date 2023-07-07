//
//  WiDCreateView.swift
//  WiD
//
//  Created by jjkim on 2023/07/06.
//

import SwiftUI

struct WiDCreateView: View {
    @State private var wiD: WiD? = nil
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("WiD")
                    Text("titleColor")
                }
                HStack {
                    Text("날짜")
                    Text("2023.7.7")
                }
                HStack {
                    Text("제목")
                    Text("공부")
                }
                HStack {
                    Text("시작")
                    Text("12:00:00")
                }
                HStack {
                    Text("종료")
                    Text("13:00:00")
                }
                HStack {
                    Text("경과")
                    Text("1시간")
                }
            }
            .padding()
            .border(Color.black)
            
            // 버튼 추가
            HStack {
                Button(action: {
                    startWiD()
                }) {
                    Text("시작")
                }
                
                Button(action: {
                    finishWiD()
                }) {
                    Text("종료")
                }
                
                Button(action: {
                    // 버튼 3 동작
                }) {
                    Text("초기화")
                }
            }
        }
    }
    
    func startWiD() {
        let currentDate = Date()
        let startTime = Date()
        
        wiD = WiD(id: 1, title: "공부", detail: "", date: currentDate, start: startTime, finish: Date(), duration: 0)
    }
    
    func finishWiD() {
        guard var currentWiD = wiD else { return }
        
        let finishTime = Date()
        let duration = finishTime.timeIntervalSince(currentWiD.start)
        
        currentWiD.finish = finishTime
        currentWiD.duration = duration
        
        wiD = currentWiD
    }
}

struct WiDCreateView_Previews: PreviewProvider {
    static var previews: some View {
        WiDCreateView()
    }
}
