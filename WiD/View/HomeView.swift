//
//  HomeView.swift
//  WiD
//
//  Created by jjkim on 2023/12/02.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var stopwatch: Stopwatch
    
    var body: some View {
        VStack(spacing: 0) {
//            if stopwatchPlayer.stopwatchPlayerReset {
                HStack {
                    Text(stopwatch.title.koreanValue)
                        .bodyMedium()
                    
                    Spacer()
                    
                    formatTimerTime(stopwatch.elapsedTime)
                        .bodyMedium()
                }
                .padding(.horizontal)
                .background(Color(stopwatch.stopwatchStarted ? "LimeGreen" : "OrangeRed"))
//                .cornerRadius(8)
                .foregroundColor(Color("White"))
//                .padding(.horizontal)
                .frame(maxWidth: .infinity, maxHeight: 22)
//            }
            
            NavigationView { // 네비게이션 출발지는 무조건 네비게이션 뷰로 감싸야함.
                /**
                 컨텐츠
                 */
                VStack(spacing: 16) {
    //                HStack(spacing: 16) {
    //                    Text("광고\n이미지")
    //                        .padding(8)
    //                        .multilineTextAlignment(.center)
    //                        .background(Color("DarkGray"))
    //                        .cornerRadius(8)
    //
    //                    VStack {
    //                        Text("광고 제목")
    //                        Text("광고 내용")
    //                    }
    //                    .frame(maxWidth: .infinity, alignment: .leading)
    //
    //                    Image(systemName: "chevron.forward")
    //                }
    //                .padding()
    //                .background(Color("LightGray"))
    //                .cornerRadius(8)
    //                .padding(.horizontal)
                    
    //                Spacer()
                    
                    HStack(alignment: .top) {
                        NavigationLink(destination: StopWatchView()) {
                            VStack(spacing: 4) {
                                Image(systemName: "stopwatch")
                                    .frame(maxWidth: 40, maxHeight: 40)
                                    .imageScale(.large)
                                    .padding()
                                    .background(Color("LightGray-Gray"))
                                    .cornerRadius(8)
                                
                                Text("스톱 워치")
                                    .bodyMedium()
                            }
                            .frame(maxWidth: .infinity)
                        }
                        
                        NavigationLink(destination: TimerView()) {
                            VStack(spacing: 4) {
                                Image(systemName: "timer")
                                    .frame(maxWidth: 40, maxHeight: 40)
                                    .imageScale(.large)
                                    .padding()
                                    .background(Color("LightGray-Gray"))
                                    .cornerRadius(8)
                                
                                Text("타이머")
                                    .bodyMedium()
                            }
                            .frame(maxWidth: .infinity)
                        }
                        
                        NavigationLink(destination: NewWiDView()) {
                            VStack(spacing: 4) {
                                Image(systemName: "plus.square")
                                    .frame(maxWidth: 40, maxHeight: 40)
                                    .imageScale(.large)
                                    .padding()
                                    .background(Color("LightGray-Gray"))
                                    .cornerRadius(8)
                                
                                Text("새로운 WiD")
                                    .bodyMedium()
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        NavigationLink(destination: DateBasedView()) {
                            VStack(spacing: 4) {
                                Image(systemName: "scope")
                                    .frame(maxWidth: 40, maxHeight: 40)
                                    .imageScale(.large)
                                    .padding()
                                    .background(Color("LightGray-Gray"))
                                    .cornerRadius(8)
                                
                                Text("날짜 별 조회")
                                    .bodyMedium()
                            }
                            .frame(maxWidth: .infinity)
                        }
                        
                        NavigationLink(destination: PeriodBasedView()) {
                            VStack(spacing: 4) {
                                Image(systemName: "calendar")
                                    .frame(maxWidth: 40, maxHeight: 40)
                                    .imageScale(.large)
                                    .padding()
                                    .background(Color("LightGray-Gray"))
                                    .cornerRadius(8)
                                
                                Text("기간 별 조회")
                                    .bodyMedium()
                            }
                            .frame(maxWidth: .infinity)
                        }
                        
                        NavigationLink(destination: SearchView()) {
                            VStack(spacing: 4) {
                                Image(systemName: "doc.text.magnifyingglass")
                                    .frame(maxWidth: 40, maxHeight: 40)
                                    .imageScale(.large)
                                    .padding()
                                    .background(Color("LightGray-Gray"))
                                    .cornerRadius(8)
                                
                                Text("다이어리 검색")
                                    .bodyMedium()
                            }
                            .frame(maxWidth: .infinity)
                        }
                        
                    }
                    .padding(.horizontal)
                    
    //                Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.vertical)
                .tint(Color("Black-White"))
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(Stopwatch())
    }
}
