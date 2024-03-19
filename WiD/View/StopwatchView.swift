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
                
                /**
                 하단 바
                 */
                HStack(spacing: 16) {
                    // 제목 선택 버튼
                    Button(action: {
                        isTitleMenuExpanded.toggle()
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
                            Image(systemName: "stop.fill")
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
                    Color("Transparent")
                        .contentShape(Rectangle()) // 배경 색 없어도 클릭할 수 있도록 함.
                        .onTapGesture {
                            isTitleMenuExpanded = false
                        }
                    
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(Title.allCases) { menuTitle in
                                Button(action: {
                                    stopwatchViewModel.setTitle(to: menuTitle)
                                    
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
                                    
                                    if stopwatchViewModel.title == menuTitle {
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
        .background(Color("White-Black")) // 배경 색 없으면 탭 제스처 동작 안함.!!
        .onTapGesture {
            if stopwatchViewModel.stopwatchState == PlayerState.STARTED {
                stopwatchViewModel.setStopwatchTopBottomBarVisible(to: !stopwatchViewModel.stopwatchTopBottomBarVisible)
            }
        }
        .onAppear {
            print("StopwatchView appeared")
        }
        .onDisappear {
            print("StopwatchView disappeared")
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
