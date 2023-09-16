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
    
    @StateObject var ad = AppOpenAdUtil()
    
    let monitor = NWPathMonitor()
    
    @State var isInternetConnected = false
    
    var body: some Scene {
        WindowGroup {
            if ad.isShowingSplashView {
                SplashView(isInternetConnected: $isInternetConnected)
                    .onAppear {
//                        monitor.pathUpdateHandler = { path in
//                            DispatchQueue.main.async {
//                                isInternetConnected = (path.status == .satisfied)
//                            }
//                        }
//                        if isInternetConnected {
//                            ad.loadAd()
//                        }
                        ad.loadAd()
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
