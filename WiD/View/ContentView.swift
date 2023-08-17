//
//  ContentView.swift
//  WiD
//
//  Created by jjkim on 2023/07/06.
//

import SwiftUI
import GoogleMobileAds

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        VStack {
            admob()
            
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
                .accentColor(.black)
            }
        }
    }
}

@ViewBuilder func admob() -> some View {
    // admob
    GADBanner().frame(width: GADAdSizeBanner.size.width, height: GADAdSizeBanner.size.height)
}

struct GADBanner: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let view = GADBannerView(adSize: GADAdSizeBanner)
        let viewController = UIViewController()
        view.adUnitID = "ca-app-pub-3641806776840744/8651524057" // WiD 용 상단 배너 광고 단위 ID
//        view.adUnitID = "ca-app-pub-3940256099942544/2934735716" // 테스트 용 상단 배너 광고 단위 ID
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: GADAdSizeBanner.size)
        view.load(GADRequest())
        return viewController
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
