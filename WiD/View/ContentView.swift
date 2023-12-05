//
//  ContentView.swift
//  WiD
//
//  Created by jjkim on 2023/07/06.
//

import SwiftUI
//import GoogleMobileAds

struct ContentView: View {
    // 선택된 화면
    @State private var selectedPicker: ContentViewTapInfo = .HOME
    
    // 상단, 하단 Bar 가시성
    @State var topBottomBarVisible = true
    
    var body: some View {
        // 전체 화면
        NavigationView {
            VStack(spacing: 0) {
                ContentHolderView(currentTab: selectedPicker, topBottomBarVisible: $topBottomBarVisible)
                
                if topBottomBarVisible {
                    bottomNavigationBar()
                }
            }
            .tint(.black)
        }
    }
    
    @ViewBuilder
    private func bottomNavigationBar() -> some View {
        HStack {
            ForEach(ContentViewTapInfo.allCases, id: \.self) { item in
                Image(systemName: item.rawValue)
                    .frame(maxWidth: .infinity)
                    .imageScale(.large)
                    .background(.clear)
                    .foregroundColor(selectedPicker == item ? .black : .gray)
                    .onTapGesture {
                        self.selectedPicker = item
                    }
            }
        }
        .padding(.vertical)
        .background(.white)
        .compositingGroup() // 자식 뷰에 그림자 적용 방지
        .shadow(radius: 1)
    }
}

enum ContentViewTapInfo: String, CaseIterable {
    case HOME = "house.fill" // 등록 이미지
    case LIST = "list.bullet" // 조회 이미지
    case SEARCH = "magnifyingglass" // 검색 이미지
}

struct ContentHolderView: View {
    var currentTab: ContentViewTapInfo
    @Binding var topBottomBarVisible: Bool
    
    var body: some View {
        switch currentTab {
        case .HOME:
            HomeView()
        case .LIST:
            ListView()
        case .SEARCH:
            SearchView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//@ViewBuilder
//func admob() -> some View {
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
