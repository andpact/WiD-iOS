//
//  WiDApp.swift
//  WiD
//
//  Created by jjkim on 2023/07/06.
//

import SwiftUI
import Network

@main
struct WiDApp: App {
//    @Environment(\.scenePhase) private var scenePhase
    @State var isShowingSplashView = true
    
    @StateObject var appOpenAdUtil = AppOpenAdUtil()
    
    let monitor = NWPathMonitor()
    
    @State var isInternetConnected = false
    
    var body: some Scene {
        WindowGroup {
            if appOpenAdUtil.isShowingSplashView {
                SplashView(isInternetConnected: $isInternetConnected)
                    .onAppear {
                        // 모니터를 시작하고 인터넷 연결 상태를 확인합니다.
                        let queue = DispatchQueue(label: "NetworkMonitor")
                        monitor.start(queue: queue)
                        
                        monitor.pathUpdateHandler = { path in
                            // 연결 상태가 변경될 때마다 isInternetConnected 변수를 업데이트합니다.
                            isInternetConnected = (path.status == .satisfied)
                            if isInternetConnected {
                                appOpenAdUtil.loadAd()
                            }
                        }
                    }
            } else {
                ContentView()
            }
        }
//        .onChange(of: scenePhase) { phase in
//            if phase == .active {
//                ad.loadAd()
//            }
//        }
    }
}
