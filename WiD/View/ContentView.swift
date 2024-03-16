//
//  ContentView.swift
//  WiD
//
//  Created by jjkim on 2023/07/06.
//

import SwiftUI
//import GoogleMobileAds

struct ContentView: View {
    // 화면
//    @State private var selectedPicker: ContentViewTapInfo = .HOME
    
    // 뷰 모델
    @StateObject private var homeViewModel = HomeViewModel()
    
    @StateObject private var stopwatchViewModel = StopwatchViewModel()
    @StateObject private var timerViewModel = TimerViewModel()
    @StateObject private var wiDListViewModel = WiDListViewModel()
    
    @StateObject private var dayWiDViewModel = DayWiDViewModel()
    @StateObject private var weekWiDViewModel = WeekWiDViewModel()
    @StateObject private var monthWiDViewModel = MonthWiDViewModel()
    @StateObject private var titleWiDViewModel = TitleWiDViewModel()
    
    @StateObject private var dayDiaryViewModel = DayDiaryViewModel()
//    @StateObject private var randomDiaryViewModel = RandomDiaryViewModel() // 구현하기 어려워서 일단 제외함.
    @StateObject private var searchDiaryViewModel = SearchDiaryViewModel()
    
    var body: some View {
        // 전체 화면
//        NavigationView {
//            VStack(spacing: 0) {
//                ContentHolderView(currentTab: selectedPicker)
//
//                bottomNavigationBar()
//            }
//            .tint(.black)
//        }
            
        MainView()
            .environmentObject(homeViewModel)
            .environmentObject(stopwatchViewModel)
            .environmentObject(timerViewModel)
            .environmentObject(wiDListViewModel)
            .environmentObject(dayWiDViewModel)
            .environmentObject(weekWiDViewModel)
            .environmentObject(monthWiDViewModel)
            .environmentObject(titleWiDViewModel)
            .environmentObject(dayDiaryViewModel)
//            .environmentObject(randomDiaryViewModel)
            .environmentObject(searchDiaryViewModel)
    }
    
//    @ViewBuilder
//    private func bottomNavigationBar() -> some View {
//        HStack {
//            ForEach(ContentViewTapInfo.allCases, id: \.self) { item in
//                Image(systemName: item.rawValue)
//                    .frame(maxWidth: .infinity)
//                    .imageScale(.large)
//                    .background(.clear)
//                    .foregroundColor(selectedPicker == item ? .black : .gray)
//                    .onTapGesture {
//                        self.selectedPicker = item
//                    }
//            }
//        }
//        .padding(.vertical)
//        .background(.white)
//        .compositingGroup() // 자식 뷰에 그림자 적용 방지
//        .shadow(radius: 1)
//    }
}

//enum ContentViewTapInfo: String, CaseIterable {
//    case HOME = "house.fill" // 홈
////    case LIST = "list.bullet" // 조회
//    case DATE = "list.bullet" // 날짜
//    case PERIOD = "square.grid.2x2.fill" // 기간
//    case SEARCH = "magnifyingglass" // 검색
//}
//
//struct ContentHolderView: View {
//    var currentTab: ContentViewTapInfo
//
//    var body: some View {
//        switch currentTab {
//        case .HOME:
//            HomeView()
////        case .LIST:
////            ListView()
//        case .DATE:
//            DateBasedView()
//        case .PERIOD:
//            PeriodBasedView()
//        case .SEARCH:
//            SearchView()
//        }
//    }
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .environment(\.colorScheme, .light)
            
            ContentView()
                .environment(\.colorScheme, .dark)
        }
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
