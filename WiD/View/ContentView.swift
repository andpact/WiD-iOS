//
//  ContentView.swift
//  WiD
//
//  Created by jjkim on 2023/07/06.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            WiDCreateView()
            .tabItem {
                Image(systemName: "1.circle")
                Text("등록")
            }
            .tag(0)
            
            // Second Tab
           Text("Second Tab")
               .tabItem {
                   Image(systemName: "2.circle")
                   Text("목록")
               }
               .tag(1)
           
           // Third Tab
           Text("Third Tab")
               .tabItem {
                   Image(systemName: "3.circle")
                   Text("조회")
               }
               .tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
