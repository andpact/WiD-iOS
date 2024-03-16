//
//  WiDCreateView.swift
//  WiD
//
//  Created by jjkim on 2023/07/06.
//

import SwiftUI

/**
 제목, 날짜, 시작 시간은 스톱 워치 클래스에서 관리
 종료 시간, 소요 시간, WiD 생성 및 저장은 스톱 워치 뷰에서 관리
 */
struct StopwatchView: View {
    // 화면
//    @Environment(\.presentationMode) var presentationMode
    private let screenHeight = UIScreen.main.bounds.height
    
    // 제목
    @State private var isTitleMenuExpanded: Bool = false
    
    // 뷰 모델
    @EnvironmentObject var stopwatchViewModel: StopwatchViewModel
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                /**
                 컨텐츠
                 */
                ZStack {
                    getVerticalTimeView(Int(stopwatchViewModel.totalDuration))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
//                    .padding(.top, screenHeight / 5)
                
//                Spacer()
                
                /**
                 하단 바
                 */
                HStack(spacing: 16) {
                    // 제목 선택 버튼
                    Button(action: {
                        withAnimation {
                            isTitleMenuExpanded.toggle()
                        }
                    }) {
                        Image(systemName: titleImageDictionary[stopwatchViewModel.title.rawValue] ?? "")
                            .font(.system(size: 32))
                    }
                    .frame(maxWidth: 40, maxHeight: 40)
                    .padding()
                    .background(stopwatchViewModel.stopwatchState == PlayerState.STOPPED ? Color("AppIndigo") : Color("DarkGray"))
                    .foregroundColor(Color("White"))
                    .cornerRadius(8)
                    .disabled(stopwatchViewModel.stopwatchState != PlayerState.STOPPED)
                    
                    Spacer()
                    
                    if stopwatchViewModel.stopwatchState == PlayerState.PAUSED {
                        // 정지 버튼
                        Button(action: {
                            stopwatchViewModel.stopStopwatch()
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
                    
                    // 시작, 중지 선택 버튼
                    Button(action: {
                        if stopwatchViewModel.stopwatchState == PlayerState.STARTED {
                            stopwatchViewModel.pauseStopwatch()
                        } else {
                            stopwatchViewModel.startStopwatch()
                        }
                    }) {
                        Image(systemName: stopwatchViewModel.stopwatchState == PlayerState.STARTED ? "pause.fill" : "play.fill")
                            .font(.system(size: 32))
                    }
                    .frame(maxWidth: 40, maxHeight: 40)
                    .padding()
                    .background(stopwatchViewModel.stopwatchState == PlayerState.STARTED ? Color("OrangeRed") : (stopwatchViewModel.stopwatchState == PlayerState.PAUSED ? Color("LimeGreen") : Color("Black-White")))
                    .foregroundColor(stopwatchViewModel.stopwatchState == PlayerState.STOPPED ? Color("White-Black") : Color("White"))
                    .clipShape(Circle())
                }
                .padding()
                .opacity(stopwatchViewModel.stopwatchTopBottomBarVisible ? 1 : 0)
            }
            
            /**
             제목 바텀 시트
             */
            if isTitleMenuExpanded {
                ZStack(alignment: .bottom) {
                    Color("Black-White")
                        .opacity(0.3)
                        .onTapGesture {
                            isTitleMenuExpanded = false
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
//                                        stopwatchViewModel.title = menuTitle
                                        stopwatchViewModel.setTitle(to: menuTitle)
                                        
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
                                        
                                        if stopwatchViewModel.title == menuTitle {
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
//                    .background(Color("LightGray-Gray"))
                    .background(Color("White-Black"))
                    .cornerRadius(8)
                    .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .edgesIgnoringSafeArea(.all)
            }
        }
        .navigationBarHidden(true)
        .tint(Color("Black-White"))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("White-Black")) // 배경 색 없으면 탭 제스처 동작 안함.!!
        .onTapGesture {
            if stopwatchViewModel.stopwatchState == PlayerState.STARTED {
                withAnimation {
//                    stopwatchViewModel.stopwatchTopBottomBarVisible.toggle()
                    stopwatchViewModel.setStopwatchTopBottomBarVisible(to: !stopwatchViewModel.stopwatchTopBottomBarVisible)
                }
            }
        }
        .onAppear {
//            stopwatchViewModel.inStopwatchView = true // onAppear에 애니메이션을 적용하면 스톰 워치 뷰로 화면 전환 시 화면이 상하로 움직임.
        }
        .onDisappear {
//            withAnimation {
//                stopwatchViewModel.inStopwatchView = false
//            }
        }
    }
}

struct StopwatchView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StopwatchView()
                .environmentObject(StopwatchViewModel())
                .environment(\.colorScheme, .light)
            
            StopwatchView()
                .environmentObject(StopwatchViewModel())
                .environment(\.colorScheme, .dark)
        }
    }
}
