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
//    @State var isShowingSplashView = true
    
//    @StateObject var appOpenAdUtil = AppOpenAdUtil()
    
//    let monitor = NWPathMonitor()
    
//    @State var isInternetConnected = false
    
    @State private var isSplashScreenActive = true
    
    var body: some Scene {
        WindowGroup {
//            if appOpenAdUtil.isShowingSplashView {
//                SplashView(isInternetConnected: $isInternetConnected)
//                    .onAppear {
//                        let queue = DispatchQueue(label: "NetworkMonitor")
//                        monitor.start(queue: queue)
//                        monitor.pathUpdateHandler = { path in
//                            isInternetConnected = (path.status == .satisfied)
//                            if isInternetConnected {
//                                appOpenAdUtil.loadAd()
//                            }
//                        }
//                    }
//            } else {
//                ContentView()
//            }
            
            if isSplashScreenActive {
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isSplashScreenActive = false
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
