//
//  HomeView.swift
//  WiD
//
//  Created by jjkim on 2023/12/02.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            ZStack {
                Text("WiD")
                    .bold()
                    .font(.custom("Acme-Regular", size: 100))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            VStack {
                GeometryReader { geometry in
                    HStack {
                        Button(action: {
                        }) {
                            NavigationLink(destination: WiDCreateStopWatchView()) { // 버튼을 링크로 감싸면 동작을 안함.
                                ZStack {
                                    Text("스톱워치")
                                        .padding()
                                        .font(.custom("BlackHanSans-Regular", size: 30))
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                    
                                    Image(systemName: "arrow.forward.square.fill")
                                        .imageScale(.large)
                                        .padding()
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                                }
                                .frame(width: .infinity, height: geometry.size.width / 2)
                            }
                        }
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 1)

                        Button(action: {
                        }) {
                            NavigationLink(destination: WiDCreateStopWatchView()) {
                                ZStack {
                                    Text("타이머")
                                        .padding()
                                        .font(.custom("BlackHanSans-Regular", size: 30))
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                    
                                    Image(systemName: "arrow.forward.square.fill")
                                        .imageScale(.large)
                                        .padding()
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                                }
                                .frame(width: .infinity, height: geometry.size.width / 2, alignment: .topLeading)
                            }
                                
                        }
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 1)
                    }
                }
                .aspectRatio(2, contentMode: .fit)

                Button(action: {
                    
                }) {
                    NavigationLink(destination: WiDCreateManualView()) {
                        Text("직접 입력")
                            .font(.custom("BlackHanSans-Regular", size: 30))
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Image(systemName: "arrow.forward.square.fill")
                            .imageScale(.large)
                            .padding()
                            .frame(alignment: .trailing)
                    }
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 1)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .padding()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
