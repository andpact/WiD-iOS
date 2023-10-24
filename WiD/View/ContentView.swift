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
    @State var buttonsVisible = true
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
    //            admob()
                
                NavigationView {
                    TabView(selection: $selectedTab) {
                        WiDCreateHolderView(buttonsVisible: $buttonsVisible)
                            .tabItem {
                                Label("Add", systemImage: "square.and.pencil")
                            }
                            .tag(0)
                        
                        WiDReadHolderView()
                            .tabItem {
                                Label("List", systemImage: "list.dash")
                            }
                            .tag(1)
                        
                        WiDSearchView()
                            .tabItem {
                                Label("Search", systemImage: "magnifyingglass")
                            }
                            .tag(2)
                    }
                    .accentColor(.black)
                }
                
                if !buttonsVisible {
                    VStack {
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: .infinity, height: geo.size.height / 15)

                        Spacer()

                        Rectangle()
                            .fill(Color.white)
                            .frame(width: .infinity, height: geo.size.height / 15)
                        
                    }
                }
            }
        }
    }
}

//@ViewBuilder func admob() -> some View {
//    // admob
//    GADBanner().frame(width: GADAdSizeBanner.size.width, height: GADAdSizeBanner.size.height)
//}
//
//struct GADBanner: UIViewControllerRepresentable {
//
//    func makeUIViewController(context: Context) -> some UIViewController {
//        let view = GADBannerView(adSize: GADAdSizeBanner)
//        let viewController = UIViewController()
////        view.adUnitID = "ca-app-pub-3641806776840744/8651524057" // WiD 용 상단 배너 광고 단위 ID
////        view.adUnitID = "ca-app-pub-3940256099942544/2934735716" // 테스트 용 상단 배너 광고 단위 ID
//        view.rootViewController = viewController
//        viewController.view.addSubview(view)
//        viewController.view.frame = CGRect(origin: .zero, size: GADAdSizeBanner.size)
//        view.load(GADRequest())
//        return viewController
//    }
//    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
//
//    }
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
