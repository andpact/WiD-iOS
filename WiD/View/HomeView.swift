//
//  HomeView.swift
//  WiD
//
//  Created by jjkim on 2023/12/02.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        // 전체화면
        VStack {
            ZStack {
                Text("WiD")
                    .font(.custom("Acme-Regular", size: 100))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            ZStack {
                HStack {
                    Button(action: {
                    }) {
                        NavigationLink(destination: StopWatchView()) {
                            VStack(spacing: 8) {
                                Image(systemName: "stopwatch")
                                    .imageScale(.large)
                                
                                Text("스톱워치")
                                    .bodyMedium()
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    Button(action: {
                    }) {
                        NavigationLink(destination: TimerView()) {
                            VStack(spacing: 8) {
                                Image(systemName: "timer")
                                    .imageScale(.large)
                                
                                Text("타이머")
                                    .bodyMedium()
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                 
                    Button(action: {
                    }) {
                        NavigationLink(destination: NewWiDView()) {
                            VStack(spacing: 8) {
                                Image(systemName: "plus.square")
                                    .imageScale(.large)
                                
                                Text("새로운 WiD")
                                    .bodyMedium()
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 1)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .padding()
        .background(Color("ghost_white"))
        .tint(.black)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
