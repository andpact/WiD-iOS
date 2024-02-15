//
//  SettingView.swift
//  WiD
//
//  Created by jjkim on 2024/02/13.
//

import SwiftUI

struct SettingView: View {
    @Environment(\.presentationMode) var presentationMode
    
    // 도구
    @EnvironmentObject var stopwatchPlayer: StopwatchPlayer
    @EnvironmentObject var timerPlayer: TimerPlayer
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.backward")
                        .font(.system(size: 24))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                if stopwatchPlayer.stopwatchState != PlayerState.STOPPED && !stopwatchPlayer.inStopwatchView {
                    HStack {
                        Text(stopwatchPlayer.title.koreanValue)
                            .bodyMedium()
                        
                        getHorizontalTimeView(Int(stopwatchPlayer.totalDuration))
                            .font(.custom("ChivoMono-Regular", size: 18))
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(stopwatchPlayer.stopwatchState == PlayerState.STARTED ? "LimeGreen" : "OrangeRed"))
                    .foregroundColor(Color("White"))
                    .cornerRadius(8)
                } else if timerPlayer.timerState != PlayerState.STOPPED && !timerPlayer.inTimerView {
                    HStack {
                        Text(timerPlayer.title.koreanValue)
                            .bodyMedium()
                        
                        getHorizontalTimeView(Int(timerPlayer.remainingTime))
                            .font(.custom("ChivoMono-Regular", size: 18))
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(timerPlayer.timerState == PlayerState.STARTED ? "LimeGreen" : "OrangeRed"))
                    .foregroundColor(Color("White"))
                    .cornerRadius(8)
                } else {
                    Text("환경설정")
                        .titleLarge()
                }
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, maxHeight: 44)
            
            ScrollView {
                VStack(spacing: 32) {
                    VStack(spacing: 4) {
                        Text("계정")
                            .bodyLarge()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(spacing: 16) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("ID")
                                        .titleMedium()
                                }
                                
                                Spacer()
                                
                                Text("USERNAME")
                                    .titleLarge()
                            }
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("사용 중인 요금제")
                                        .titleMedium()
                                }
                                
                                Spacer()
                                
                                Text("스탠다드")
                                    .titleLarge()
                            }
                        }
                        .padding()
                        .background(Color("White-Gray"))
                        .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    
                    VStack(spacing: 4) {
                        Text("일반")
                            .bodyLarge()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(spacing: 16) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("언어 설정 / Language")
                                        .titleMedium()
                                }
                                
                                Spacer()
                                
                                Text("한국어")
                                    .titleLarge()
                            }
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("12/24 시간제 설정")
                                        .titleMedium()
                                }
                                
                                Spacer()
                                
                                Text("12시간제")
                                    .titleLarge()
                            }
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("최소 시간")
                                        .titleMedium()
                                    
                                    Text("WiD가 저장될 수 있는 최소 시간을 설정합니다.")
                                        .labelSmall()
                                }
                                
                                Spacer()
                                
                                Text("1분")
                                    .titleLarge()
                            }
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("시간 간격")
                                        .titleMedium()
                                    
                                    Text("직전에 생성된 WiD와 새로 생성될 WiD 사이에 무시할 시간 간격을 설정합니다.")
                                        .labelSmall()
                                }
                                
                                Spacer()
                                
                                Text("1분")
                                    .titleLarge()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("White-Gray"))
                        .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    
                    VStack(spacing: 4) {
                        Text("스톱 워치")
                            .bodyLarge()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(spacing: 16) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("최대 시간")
                                        .titleMedium()
                                    
                                    Text("해당 시간에 도달하면 자동으로 WiD가 저장됩니다.")
                                        .labelSmall()
                                }
                                
                                Spacer()
                                
                                Text("10시간")
                                    .titleLarge()
                            }
                        }
                        .padding()
                        .background(Color("White-Gray"))
                        .cornerRadius(8)
                    }
                    .padding(.horizontal)

                    VStack(spacing: 4) {
                        Text("타이머")
                            .bodyLarge()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(spacing: 0) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("종료 후 동작")
                                        .titleMedium()
                                }
                                
                                Spacer()
                                
                                Text("진동")
                                    .titleLarge()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("White-Gray"))
                        .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    
                    VStack(spacing: 4) {
                        Text("다이어리")
                            .bodyLarge()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(spacing: 16) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("알림 설정")
                                        .titleMedium()
                                    
                                    Text("다이어리가 작성되지 않았을 때, 알림을 보냅니다.")
                                        .labelSmall()
                                }
                                
                                Spacer()
                                
                                Text("ON")
                                    .titleLarge()
                            }
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("알림 시간")
                                        .titleMedium()
                                }
                                
                                Spacer()
                                
                                Text("오후 10시")
                                    .titleLarge()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("White-Gray"))
                        .cornerRadius(8)
                    }
                    .padding(.horizontal)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarHidden(true)
        .background(Color("LightGray-Black")) // 배경 색을 여기 지정해야 적용됨.
        .tint(Color("Black-White"))
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SettingView()
                .environmentObject(StopwatchPlayer())
                .environmentObject(TimerPlayer())
                .environment(\.colorScheme, .light)
            
            SettingView()
                .environmentObject(StopwatchPlayer())
                .environmentObject(TimerPlayer())
                .environment(\.colorScheme, .dark)
        }
    }
}
