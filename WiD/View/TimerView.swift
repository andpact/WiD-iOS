//
//  WiDCreateTimerView.swift
//  WiD
//
//  Created by jjkim on 2023/09/13.
//

import SwiftUI

struct TimerView: View {
    // 화면
    private let screenHeight = UIScreen.main.bounds.height
    
    // 제목
    @State private var isTitleMenuExpanded: Bool = false
    
    // 타이머, Int 타입으로 선언해야 Picker에서 사용할 수 있다.
    @State private var selectedHour: Int = 0
    @State private var selectedMinute: Int = 0
    @State private var selectedSecond: Int = 0
    
    // 뷰 모델
    @EnvironmentObject var timerViewModel: TimerViewModel
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                /**
                 컨텐츠
                 */
                ZStack {
                    if timerViewModel.timerState == PlayerState.STOPPED {
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
                    } else {
                        getHorizontalTimeView(Int(timerViewModel.remainingTime))
                            .font(.custom("ChivoMono-BlackItalic", size: 70))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                
//                Spacer()
                
                /**
                 하단 바
                 */
                HStack {
                    Button(action: {
                        isTitleMenuExpanded.toggle()
                    }) {
                        Image(systemName: titleImageDictionary[timerViewModel.title.rawValue] ?? "")
                            .font(.system(size: 32))
                    }
                    .frame(maxWidth: 40, maxHeight: 40)
                    .padding()
                    .background(timerViewModel.timerState == PlayerState.STOPPED ? Color("AppIndigo") : Color("DarkGray"))
                    .foregroundColor(Color("White"))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .disabled(timerViewModel.timerState != PlayerState.STOPPED)
                    
                    Spacer()
                    
                    if timerViewModel.timerState == PlayerState.PAUSED {
                        Button(action: {
                            timerViewModel.stopTimer()
                        }) {
                            Image(systemName: "stop.fill")
                                .font(.system(size: 32))
                        }
                        .frame(maxWidth: 40, maxHeight: 40)
                        .padding()
                        .background(Color("DeepSkyBlue"))
                        .foregroundColor(Color("White"))
                        .clipShape(Circle())
                    }
                    
                    Button(action: {
                        if timerViewModel.timerState == PlayerState.STARTED {
                            timerViewModel.pauseTimer()
                        } else {
                            timerViewModel.startTimer()
                        }
                    }) {
                        Image(systemName: timerViewModel.timerState == PlayerState.STARTED ? "pause.fill" : "play.fill")
                            .font(.system(size: 32))
                    }
                    .frame(maxWidth: 40, maxHeight: 40)
                    .padding()
                    .background(timerViewModel.timerState == PlayerState.STARTED ? Color("OrangeRed") : (timerViewModel.timerState == PlayerState.PAUSED ? Color("LimeGreen") : (timerViewModel.selectedTime == 0 ? Color("DarkGray") : Color("Black-White"))))
                    .foregroundColor(timerViewModel.timerState == PlayerState.STOPPED ? Color("White-Black") : Color("White"))
                    .clipShape(Circle())
                    .disabled(timerViewModel.selectedTime == 0)
                }
                .padding()
                .opacity(timerViewModel.timerTopBottomBarVisible ? 1 : 0)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            /**
             대화상자
             */
            if isTitleMenuExpanded {
                ZStack(alignment: .bottom) {
                    Color("Transparent")
                        .contentShape(Rectangle())
                        .onTapGesture {
                            isTitleMenuExpanded = false
                        }
                    
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(Title.allCases) { menuTitle in
                                Button(action: {
                                    timerViewModel.setTitle(to: menuTitle)
                                    
                                    isTitleMenuExpanded = false
                                }) {
                                    Image(systemName: titleImageDictionary[menuTitle.rawValue] ?? "")
                                        .font(.system(size: 24))
                                        .frame(maxWidth: 40, maxHeight: 40)
                                    
                                    Spacer()
                                        .frame(maxWidth: 20)
                                    
                                    Text(menuTitle.koreanValue)
                                        .labelMedium()
                                    
                                    Spacer()
                                    
                                    if timerViewModel.title == menuTitle {
                                        Image(systemName: "checkmark.circle.fill")
                                               .font(.system(size: 20))
                                               .frame(width: 20, height: 20)
                                    } else {
                                        Image(systemName: "circle")
                                               .font(.system(size: 20))
                                               .frame(width: 20, height: 20)
                                    }
                                }
                                .padding()
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: screenHeight / 3)
                    .background(Color("LightGray-Gray"))
                    .cornerRadius(8)
                    .padding()
                    .shadow(color: Color("Black-White"), radius: 1)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
        }
        .navigationBarHidden(true)
        .tint(Color("Black-White"))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("White-Black"))
        .onAppear {
            print("TimerView appeared")
        }
        .onDisappear {
            print("TimerView disappeared")
        }
        .onChange(of: [selectedHour, selectedMinute, selectedSecond]) { _ in
            timerViewModel.selectedTime = TimeInterval(selectedHour * 3600 + selectedMinute * 60 + selectedSecond)
            timerViewModel.remainingTime = TimeInterval(selectedHour * 3600 + selectedMinute * 60 + selectedSecond) // 시간을 선택할 때, 남은 시간을 최초 1회 할당해줌.
        }
        .onTapGesture {
            if timerViewModel.timerState == PlayerState.STARTED {
                timerViewModel.setTimerTopBottomBarVisible(to: !timerViewModel.timerTopBottomBarVisible)
            }
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TimerView()
                .environmentObject(TimerViewModel())
                .environment(\.colorScheme, .light)
            
            TimerView()
                .environmentObject(TimerViewModel())
                .environment(\.colorScheme, .dark)
        }
    }
}
