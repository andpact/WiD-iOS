//
//  HomeView.swift
//  WiD
//
//  Created by jjkim on 2023/12/02.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
//                Text("WiD")
//                    .font(.custom("Acme-Regular", size: 50))
                
                Text("제목")
                    .titleLarge()
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(spacing: 0) {
                    ForEach(Title.allCases.indices, id: \.self) { index in
                        let title = Title.allCases[index]
                        HStack {
                            Rectangle()
                                .frame(width: 3)
                                .foregroundColor(Color(title.rawValue))
                            
                            Text(title.koreanValue)
                                .bodyMedium()

                            Spacer()

                            Text(title.example)
                                .labelSmall()
                        }
                        .padding()

                        if index != Title.allCases.count - 1 {
                            Divider()
                                .padding(.horizontal)
                        }
                    }
                }
                
                Rectangle()
                    .frame(height: 8)
                    .padding(.vertical)
                    .foregroundColor(Color("ghost_white"))
                
                Text("도구")
                    .titleLarge()
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .leading, spacing: 0) {
                    NavigationLink(destination: StopWatchView()) {
                        HStack(spacing: 16) {
                            Image(systemName: "stopwatch")
                                .imageScale(.large)
                                .frame(width: 30)
                            
                            VStack(alignment: .leading) {
                                Text("스톱워치")
                                    .bodyMedium()
                                
                                Text("현재 시간부터 기록하기")
                                    .labelSmall()
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.forward")
                        }
                        .padding()
                    }
                    .foregroundColor(.black)
                    
                    Divider()
                        .padding(.horizontal)
                    
                    NavigationLink(destination: TimerView()) {
                        HStack(spacing: 16) {
                            Image(systemName: "timer")
                                .imageScale(.large)
                                .frame(width: 30)
                            
                            VStack(alignment: .leading) {
                                Text("타이머")
                                    .bodyMedium()
                                
                                Text("정해진 시간만큼 기록하기")
                                    .labelSmall()
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.forward")
                        }
                        .padding()
                    }
                    .foregroundColor(.black)
                    
                    Divider()
                        .padding(.horizontal)
                    
                    NavigationLink(destination: NewWiDView()) {
                        HStack(spacing: 16) {
                            Image(systemName: "plus.square")
                                .imageScale(.large)
                                .frame(width: 30)
                            
                            VStack(alignment: .leading) {
                                Text("새로운 WiD")
                                    .bodyMedium()
                                
                                Text("날짜, 제목, 시작 및 종료 시간을 직접 기록하기")
                                    .labelSmall()
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.forward")
                        }
                        .padding()
                    }
                    .foregroundColor(.black)
                }

//                Rectangle()
//                    .frame(height: 8)
//                    .padding(.vertical)
//                    .foregroundColor(Color("ghost_white"))
//
//                Text("랜덤 다이어리")
//                    .titleLarge()
//                    .padding(.horizontal)
//                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .background(.white)
        .tint(.black)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
