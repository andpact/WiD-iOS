//
//  HomeView.swift
//  WiD
//
//  Created by jjkim on 2023/12/02.
//

import SwiftUI

//struct HomeView: View {
//    var body: some View {
//        ScrollView {
//            VStack(spacing: 16) {
//                HStack(alignment: .top) {
//                    NavigationLink(destination: StopWatchView()) {
//                        VStack {
//                            Image(systemName: "stopwatch")
//                                .frame(width: 30, height: 30)
//                                .imageScale(.large)
//                                .padding()
//                                .background(Color("light_gray"))
//                                .cornerRadius(8)
//
//                            Text("스톱\n워치")
//                                .bodyMedium()
//                                .multilineTextAlignment(.center)
//                        }
//                        .frame(maxWidth: .infinity)
//                    }
//
//                    NavigationLink(destination: TimerView()) {
//                        VStack {
//                            Image(systemName: "timer")
//                                .frame(width: 30, height: 30)
//                                .imageScale(.large)
//                                .padding()
//                                .background(Color("light_gray"))
//                                .cornerRadius(8)
//
//                            Text("타이머")
//                                .bodyMedium()
//                        }
//                        .frame(maxWidth: .infinity)
//                    }
//
//                    NavigationLink(destination: NewWiDView()) {
//                        VStack {
//                            Image(systemName: "plus.square")
//                                .frame(width: 30, height: 30)
//                                .imageScale(.large)
//                                .padding()
//                                .background(Color("light_gray"))
//                                .cornerRadius(8)
//
//                            Text("새로운\nWiD")
//                                .bodyMedium()
//                                .multilineTextAlignment(.center)
//                        }
//                        .frame(maxWidth: .infinity)
//                    }
//
//                    VStack {
//                        Image(systemName: "rectangle.and.text.magnifyingglass.rtl")
//                            .frame(width: 30, height: 30)
//                            .imageScale(.large)
//                            .padding()
//                            .background(Color("light_gray"))
//                            .cornerRadius(8)
//
//                        Text("WiD\n검색")
//                            .bodyMedium()
//                            .multilineTextAlignment(.center)
//                    }
//                    .frame(maxWidth: .infinity)
//                }
//                .padding()
//                .background(.blue)
//
//                HStack {
//                    NavigationLink(destination: DateBasedView()) {
//                        VStack {
//                            Image(systemName: "scope")
//                                .frame(width: 30, height: 30)
//                                .imageScale(.large)
//                                .padding()
//                                .background(Color("light_gray"))
//                                .cornerRadius(8)
//
//                            Text("날짜 별\n조회")
//                                .bodyMedium()
//                                .multilineTextAlignment(.center)
//                        }
//                        .frame(maxWidth: .infinity)
//                    }
//
//                    NavigationLink(destination: PeriodBasedView()) {
//                        VStack {
//                            Image(systemName: "calendar")
//                                .frame(width: 30, height: 30)
//                                .imageScale(.large)
//                                .padding()
//                                .background(Color("light_gray"))
//                                .cornerRadius(8)
//
//                            Text("기간 별\n조회")
//                                .bodyMedium()
//                                .multilineTextAlignment(.center)
//                        }
//                        .frame(maxWidth: .infinity)
//                    }
//
//                    NavigationLink(destination: SearchView()) {
//                        VStack {
//                            Image(systemName: "doc.text.magnifyingglass")
//                                .frame(width: 30, height: 30)
//                                .imageScale(.large)
//                                .padding()
//                                .background(Color("light_gray"))
//                                .cornerRadius(8)
//
//                            Text("다이어리\n검색")
//                                .bodyMedium()
//                                .multilineTextAlignment(.center)
//                        }
//                        .frame(maxWidth: .infinity)
//                    }
//
//                    VStack {
//                        Image(systemName: "gearshape.fill")
//                            .frame(width: 30, height: 30)
//                            .imageScale(.large)
//                            .padding()
//                            .background(Color("light_gray"))
//                            .cornerRadius(8)
//
//                        Text("환경\n설정")
//                            .bodyMedium()
//                            .multilineTextAlignment(.center)
//                    }
//                    .frame(maxWidth: .infinity)
//                }
//                .padding()
//                .background(.red)
//            }
            
//            VStack(spacing: 16) {
//                Text("WiD")
//                    .font(.custom("Acme-Regular", size: 80))
//
//                VStack(spacing: 0) {
//                    Text("도구")
//                        .titleMedium()
//                        .padding(.horizontal)
//                        .frame(maxWidth: .infinity, alignment: .leading)
//
//                    NavigationLink(destination: StopWatchView()) {
//                        HStack(spacing: 16) {
//                            Image(systemName: "stopwatch")
//                                .imageScale(.large)
//                                .frame(width: 30)
//                                .padding(.leading, 8)
//
//                            VStack(alignment: .leading) {
//                                Text("스톱워치")
//                                    .bodyMedium()
//
//                                Text("현재 시간부터 기록하기")
//                                    .labelSmall()
//                            }
//
//                            Spacer()
//
//                            Image(systemName: "chevron.forward")
//                        }
//                        .padding()
//                    }
//                    .foregroundColor(.black)
//
//                    Divider()
//                        .padding(.horizontal)
//
//                    NavigationLink(destination: TimerView()) {
//                        HStack(spacing: 16) {
//                            Image(systemName: "timer")
//                                .imageScale(.large)
//                                .frame(width: 30)
//                                .padding(.leading, 8)
//
//                            VStack(alignment: .leading) {
//                                Text("타이머")
//                                    .bodyMedium()
//
//                                Text("정해진 시간만큼 기록하기")
//                                    .labelSmall()
//                            }
//
//                            Spacer()
//
//                            Image(systemName: "chevron.forward")
//                        }
//                        .padding()
//                    }
//                    .foregroundColor(.black)
//
//                    Divider()
//                        .padding(.horizontal)
//
//                    NavigationLink(destination: NewWiDView()) {
//                        HStack(spacing: 16) {
//                            Image(systemName: "plus.square")
//                                .imageScale(.large)
//                                .frame(width: 30)
//                                .padding(.leading, 8)
//
//                            VStack(alignment: .leading) {
//                                Text("새로운 WiD")
//                                    .bodyMedium()
//
//                                Text("날짜, 제목, 시작 및 종료 시간을 직접 기록하기")
//                                    .labelSmall()
//                            }
//
//                            Spacer()
//
//                            Image(systemName: "chevron.forward")
//                        }
//                        .padding()
//                    }
//                    .foregroundColor(.black)
//                }
//                .padding(.vertical)
//                .background(.white)
//
//                VStack(spacing: 0) {
//                    Text("사용 가능한 제목")
//                        .titleMedium()
//                        .padding(.horizontal)
//                        .frame(maxWidth: .infinity, alignment: .leading)
//
//                    ForEach(Title.allCases.indices, id: \.self) { index in
//                        let title = Title.allCases[index]
//
//                        HStack {
//                            Rectangle()
//                                .frame(width: 5)
//                                .foregroundColor(Color(title.rawValue))
//
//                            Text(title.koreanValue)
//                                .bodyMedium()
//
//                            Spacer()
//
//                            Text(title.example)
//                                .labelSmall()
//                        }
//                        .padding()
//
//                        if index != Title.allCases.count - 1 {
//                            Divider()
//                                .padding(.horizontal)
//                        }
//                    }
//                }
//                .padding(.vertical)
//                .background(.white)
//
//                VStack(spacing: 0) {
//                    Text("랜덤 다이어리")
//                        .titleLarge()
//                        .padding(.horizontal)
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                }
//                .padding(.vertical)
//                .background(.white)
//            }
//        }
//        .background(Color("ghost_white"))
//        .tint(.black)
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//    }
//}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
