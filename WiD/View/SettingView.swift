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
//    @EnvironmentObject var stopwatchPlayer: StopwatchViewModel
//    @EnvironmentObject var timerPlayer: TimerViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                /**
                 상단 바
                 */
                ZStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.backward")
                            .font(.system(size: 24))
                    }
                    .tint(Color("Black-White"))
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Text("환경 설정")
                        .titleLarge()
                }
                .frame(maxWidth: .infinity, maxHeight: 44)
                .padding(.horizontal)
                
                VStack(spacing: 16) {
                    VStack(spacing: 4) {
                        Text("계정")
                            .bodyLarge()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(spacing: 16) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("아이디")
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
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color("Black-White"), lineWidth: 0.5)
                        )
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
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color("Black-White"), lineWidth: 0.5)
                        )
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
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color("Black-White"), lineWidth: 0.5)
                        )
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
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color("Black-White"), lineWidth: 0.5)
                        )
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
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color("Black-White"), lineWidth: 0.5)
                        )
                    }
                    .padding(.horizontal)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarHidden(true)
        .background(Color("White-Black"))
        .tint(Color("Black-White"))
        .onAppear {
            print("SettingView appeared")
        }
        .onDisappear {
            print("SettingView disappeared")
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SettingView()
                .environmentObject(StopwatchViewModel())
                .environmentObject(TimerViewModel())
                .environment(\.colorScheme, .light)
            
            SettingView()
                .environmentObject(StopwatchViewModel())
                .environmentObject(TimerViewModel())
                .environment(\.colorScheme, .dark)
        }
    }
}
