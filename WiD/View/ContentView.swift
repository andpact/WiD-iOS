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
        NavigationView {
            TabView(selection: $selectedTab) {
                WiDCreateView()
                    .tabItem {
                        Label("등록", systemImage: "square.and.pencil")
                    }
                    .tag(0)
                
                WiDReadHolderView()
                    .tabItem {
                        Label("목록", systemImage: "list.dash")
                    }
                    .tag(1)
                
                WiDSearchView()
                    .tabItem {
                        Label("검색", systemImage: "magnifyingglass")
                    }
                    .tag(2)
            }
//            .onAppear {
//                UITabBar.appearance().backgroundColor = .purple
//            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
