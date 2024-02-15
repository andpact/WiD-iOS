//
//  WiDCreateTimerView.swift
//  WiD
//
//  Created by jjkim on 2023/09/13.
//

import SwiftUI

struct TimerView: View {
    // 화면
    @Environment(\.presentationMode) var presentationMode
//    @State private var timerTopBottomBarVisible: Bool = true
    private let screenHeight = UIScreen.main.bounds.height
    
    // WiD
//    private let wiDService = WiDService()
    
    // 날짜
//    private let calendar = Calendar.current
    
    // 제목
    @State private var isTitleMenuExpanded: Bool = false
    
    // 타이머 Int 타입으로 선언해야 Picker에서 사용할 수 있다.
    @State private var selectedHour: Int = 0
    @State private var selectedMinute: Int = 0
    @State private var selectedSecond: Int = 0
    @EnvironmentObject var timerPlayer: TimerPlayer
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                /**
                 컨텐츠
                 */
                if timerPlayer.timerState == PlayerState.STOPPED {
                    HStack(spacing: 0) {
                        // 시간(Hour) 선택
                        Picker("", selection: $selectedHour) {
                            ForEach(0..<24, id: \.self) { hour in
                                Text("\(hour)")
                                    .font(selectedHour == hour ? .custom("ChivoMono-BlackItalic", size: 35) : .system(size: 20, weight: .medium))
                            }
                        }
                        .pickerStyle(.inline)
                        
                        Text(":")
                            .bodyMedium()

                        // 분(Minute) 선택
                        Picker("", selection: $selectedMinute) {
                            ForEach(0..<60, id: \.self) { minute in
                                Text(String(format: "%02d", minute))
                                    .font(selectedMinute == minute ? .custom("ChivoMono-BlackItalic", size: 35) : .system(size: 20, weight: .medium))
                            }
                        }
                        .pickerStyle(.inline)

                        Text(":")
                            .bodyMedium()
                        
                        // 초(Second) 선택
                        Picker("", selection: $selectedSecond) {
                            ForEach(0..<60, id: \.self) { second in
                                Text(String(format: "%02d", second))
                                    .font(selectedSecond == second ? .custom("ChivoMono-BlackItalic", size: 35) : .system(size: 20, weight: .medium))
                            }
                        }
                        .pickerStyle(.inline)
                    }
                    .padding(.horizontal)
                    .padding(.top, screenHeight / 10)
                } else {
                    getHorizontalTimeView(Int(timerPlayer.remainingTime))
                        .font(.custom("ChivoMono-BlackItalic", size: 70))
                        .padding(.top, screenHeight / 5)
                }
                
                Spacer()
                
                /**
                 하단 바
                 */
                HStack {
                    Button(action: {
                        withAnimation {
                            isTitleMenuExpanded.toggle()
                        }
                    }) {
                        Image(systemName: titleImageDictionary[timerPlayer.title.rawValue] ?? "")
                            .font(.system(size: 32))
                    }
                    .frame(maxWidth: 40, maxHeight: 40)
                    .padding()
                    .background(timerPlayer.timerState == PlayerState.STOPPED ? Color("AppIndigo") : Color("DarkGray"))
                    .foregroundColor(Color("White"))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .disabled(timerPlayer.timerState != PlayerState.STOPPED)
                    
                    Spacer()
                    
                    if timerPlayer.timerState == PlayerState.PAUSED {
                        Button(action: {
                            timerPlayer.stopTimer()
                        }) {
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 32))
                        }
                        .frame(maxWidth: 40, maxHeight: 40)
                        .padding()
                        .background(Color("DeepSkyBlue"))
                        .foregroundColor(Color("White"))
                        .clipShape(Circle())
                    }
                    
                    Button(action: {
                        if timerPlayer.timerState == PlayerState.STARTED {
                            timerPlayer.pauseTimer()
                        } else {
                            timerPlayer.startTimer()
                        }
                    }) {
                        Image(systemName: timerPlayer.timerState == PlayerState.STARTED ? "pause.fill" : "play.fill")
                            .font(.system(size: 32))
                    }
                    .frame(maxWidth: 40, maxHeight: 40)
                    .padding()
                    .background(timerPlayer.timerState == PlayerState.STARTED ? Color("OrangeRed") : (timerPlayer.timerState == PlayerState.PAUSED ? Color("LimeGreen") : (timerPlayer.selectedTime == 0 ? Color("DarkGray") : Color("Black-White"))))
                    .foregroundColor(timerPlayer.timerState == PlayerState.STOPPED ? Color("White-Black") : Color("White"))
                    .clipShape(Circle())
                    .disabled(timerPlayer.selectedTime == 0)
                }
                .padding()
                .opacity(timerPlayer.timerTopBottomBarVisible ? 1 : 0)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            /**
             대화상자
             */
            if isTitleMenuExpanded {
                ZStack(alignment: .bottom) {
                    Color("Black-White")
                        .opacity(0.3)
                        .onTapGesture {
                            withAnimation {
                                isTitleMenuExpanded = false
                            }
                        }
                    
                    VStack(spacing: 0) {
                        ZStack {
                            Text("제목 선택")
                                .titleMedium()
                            
                            Button(action: {
                                isTitleMenuExpanded = false
                            }) {
                                Text("확인")
                                    .bodyMedium()
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .padding()
                        
                        Divider()
                            .background(Color("Black-White"))
                        
                        ScrollView {
                            VStack(spacing: 0) {
                                ForEach(Title.allCases) { menuTitle in
                                    Button(action: {
                                        timerPlayer.title = menuTitle
                                        withAnimation {
                                            isTitleMenuExpanded = false
                                        }
                                    }) {
                                        Image(systemName: titleImageDictionary[menuTitle.rawValue] ?? "")
                                            .font(.system(size: 24))
                                            .frame(maxWidth: 40, maxHeight: 40)
                                        
                                        Spacer()
                                            .frame(maxWidth: 20)
                                        
                                        Text(menuTitle.koreanValue)
                                            .labelMedium()
                                        
                                        Spacer()
                                        
                                        if timerPlayer.title == menuTitle {
                                            Text("선택됨")
                                                .bodyMedium()
                                        }
                                    }
                                    .padding()
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: screenHeight / 3)
                    .background(Color("White-Black"))
                    .cornerRadius(16)
                }
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            }
        }
        .navigationBarHidden(true)
        .tint(Color("Black-White"))
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("White-Gray"))
        .onAppear {
            timerPlayer.inTimerView = true
        }
        .onDisappear {
            withAnimation {
                timerPlayer.inTimerView = false
            }
        }
        .onChange(of: [selectedHour, selectedMinute, selectedSecond]) { _ in
            timerPlayer.selectedTime = TimeInterval(selectedHour * 3600 + selectedMinute * 60 + selectedSecond)
            timerPlayer.remainingTime = TimeInterval(selectedHour * 3600 + selectedMinute * 60 + selectedSecond) // 시간을 선택할 때, 남은 시간을 최초 1회 할당해줌.
        }
        .onTapGesture {
            if timerPlayer.timerState == PlayerState.STARTED {
                withAnimation {
                    timerPlayer.timerTopBottomBarVisible.toggle()
                }
            }
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TimerView()
                .environmentObject(TimerPlayer())
                .environment(\.colorScheme, .light)
            
            TimerView()
                .environmentObject(TimerPlayer())
                .environment(\.colorScheme, .dark)
        }
    }
}
