//
//  HomeView.swift
//  WiD
//
//  Created by jjkim on 2023/12/02.
//

import SwiftUI

struct HomeView: View {
    // 뷰 모델
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // 상단 바
            HStack {
                Text("홈")
                    .titleLarge()
                
                Spacer()
                
                // 환경 설정 화면 구성 후 활성화하자.
//                NavigationLink(destination: SettingView()) {
//                    Image(systemName: "gearshape.fill")
//                        .font(.system(size: 24))
//                }
            }
            .frame(maxWidth: .infinity, maxHeight: 44)
            .padding(.horizontal)
            .background(Color("LightGray-Gray"))
            
            // 가장 최근의 WiD나 다이어리가 없을 떄(초기 화면)
            if homeViewModel.wiD.id == -1 || homeViewModel.diary.id == -1 {
                VStack(spacing: 16) {
                    Text("WiD - What I Did")
                        .font(.system(size: 40, weight: .bold))

                    Text("WiD로 행동을 기록하고,\n다이어리로 생각을 기록하세요.\n기록된 모든 순간을 통해\n본인의 여정을 파악하세요.")
                        .font(.system(size: 25, weight: .bold))
                        .multilineTextAlignment(.center)
                        .lineSpacing(10)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        VStack(spacing: 0) {
                            Text("최근 활동")
                                .titleLarge()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                            
                            VStack(spacing: 0) {
                                // 날짜
                                HStack(spacing: 0) {
                                    Image(systemName: "calendar")
                                        .font(.system(size: 24))
                                        .frame(width: 30, height: 30)
                                        .padding()
                                    
                                    Divider()
                                        .background(Color("Black-White"))
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("날짜")
                                            .labelMedium()
                                        
                                        getDateStringView(date: homeViewModel.wiD.date)
                                            .bodyMedium()
                                    }
                                    .padding(.horizontal)
                                    
                                    Spacer()
                                }
                                .background(Color("White-Black"))
                                
                                Divider()
                                    .background(Color("Black-White"))
                                
                                // 제목
                                HStack(spacing: 0) {
                                    Image(systemName: titleImageDictionary[homeViewModel.wiD.title] ?? "")
                                        .font(.system(size: 24))
                                        .frame(width: 30, height: 30)
                                        .padding()
                                    
                                    Divider()
                                        .background(Color("Black-White"))
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("제목")
                                            .labelMedium()
                                        
                                        Text(titleDictionary[homeViewModel.wiD.title] ?? "공부")
                                            .bodyMedium()
                                    }
                                    .padding(.horizontal)
                                    
                                    Spacer()
                                }
                                .background(Color("White-Black"))
                                
                                Divider()
                                    .background(Color("Black-White"))
                                
                                // 시작 시간 선택
                                HStack(spacing: 0) {
                                    Image(systemName: "clock")
                                        .font(.system(size: 24))
                                        .frame(width: 30, height: 30)
                                        .padding()

                                    Divider()
                                        .background(Color("Black-White"))
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("시작")
                                            .labelMedium()
                                        
                                        Text(getTimeString(homeViewModel.wiD.start))
                                            .bodyMedium()
                                    }
                                    .padding(.horizontal)
                                    
                                    Spacer()
                                }
                                .background(Color("White-Black"))
                                
                                Divider()
                                    .background(Color("Black-White"))
                                
                                // 종료 시간 선택
                                HStack(spacing: 0) {
                                    Image(systemName: "clock.badge.checkmark")
                                        .font(.system(size: 24))
                                        .frame(width: 30, height: 30)
                                        .padding()
                                    
                                    Divider()
                                        .background(Color("Black-White"))
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("종료")
                                            .labelMedium()
                                        
                                        Text(getTimeString(homeViewModel.wiD.finish))
                                            .bodyMedium()
                                    }
                                    .padding(.horizontal)
                                    
                                    Spacer()
                                }
                                .background(Color("White-Black"))
                                
                                Divider()
                                    .background(Color("Black-White"))
                                
                                // 소요 시간
                                HStack(spacing: 0) {
                                    Image(systemName: "hourglass")
                                        .font(.system(size: 24))
                                        .frame(width: 30, height: 30)
                                        .padding()
                                    
                                    Divider()
                                        .background(Color("Black-White"))
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("소요")
                                            .labelMedium()

                                        Text(getDurationString(homeViewModel.wiD.duration, mode: 3))
                                            .bodyMedium()
                                    }
                                    .padding(.horizontal)
                                    
                                    Spacer()
                                }
                                .background(Color("White-Black"))
                            }
                            .fixedSize(horizontal: false, vertical: true)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color("Black-White"), lineWidth: 0.5)
                            )
                            .padding(.horizontal)
                        }
                        
                        VStack(spacing: 0) {
                            Text("최근 다이어리")
                                .titleLarge()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                            
                            VStack(alignment: .leading, spacing: 16) {
                                HStack(spacing: 0) {
                                    getDateStringViewWith3Lines(date: homeViewModel.diary.date)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .font(.system(size: 22, weight: .bold))

                                    ZStack {
                                        let wiDList = homeViewModel.wiDList

                                        if wiDList.isEmpty {
                                            getEmptyViewWithMultipleLines(message: "표시할\n타임라인이\n없습니다.")
                                        } else {
                                            DiaryPieChartView(wiDList: wiDList)
                                        }
                                    }
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                }
                                .aspectRatio(2.5 / 1, contentMode: .fit)
                                .padding(.horizontal)

                                Text(homeViewModel.diary.title)
                                    .bodyMedium()

                                Text(homeViewModel.diary.content)
                                    .bodyMedium()
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color("Black-White"), lineWidth: 0.5)
                            )
                            .padding(.horizontal)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color("White-Black"))
        .tint(Color("Black-White"))
        .onAppear {
            print("HomeView appeared")
            
            // 최근 생성한 WiD나 다이어리가 화면에 반영되도록.
            homeViewModel.fetchMostRecentWiD()
            homeViewModel.fetchMostRecentDiary()
        }
        .onDisappear {
            print("HomeView disappeared")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeView()
                .environmentObject(HomeViewModel())
                .environmentObject(StopwatchViewModel())
                .environmentObject(TimerViewModel())
                .environment(\.colorScheme, .light)
            
            HomeView()
                .environmentObject(HomeViewModel())
                .environmentObject(StopwatchViewModel())
                .environmentObject(TimerViewModel())
                .environment(\.colorScheme, .dark)
        }
    }
}

//struct SlideInAndOutAnimation: ViewModifier {
//    enum Direction {
//        case topToBottom
//        case bottomToTop
//    }
//
//    var direction: Direction
//    var duration: Double = 0.5
//
//    func body(content: Content) -> some View {
//        content
//            .transition(
//                .move(edge: direction == .topToBottom ? .top : .bottom)
//                    .combined(with: .opacity)
//            )
//            .animation(.easeInOut(duration: duration))
//    }
//}
//
//extension View {
//    func slideInAndOutAnimation(direction: SlideInAndOutAnimation.Direction, duration: Double = 0.5) -> some View {
//        self.modifier(SlideInAndOutAnimation(direction: direction, duration: duration))
//    }
//}
