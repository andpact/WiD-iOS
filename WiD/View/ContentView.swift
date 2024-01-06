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
    
    var body: some View {
        NavigationView { // 네비게이션 출발지는 무조건 네비게이션 뷰로 감싸야함.
            VStack {
                /**
                 컨텐츠
                 */
                VStack {
                    HStack(alignment: .top) {
                        NavigationLink(destination: StopWatchView()) {
                            VStack {
                                Image(systemName: "stopwatch")
                                    .frame(maxWidth: 40, maxHeight: 40)
                                    .imageScale(.large)
                                    .padding()
                                    .background(Color("LightGray-Gray"))
                                    .cornerRadius(8)
                                
                                Text("스톱 워치")
                                    .bodyMedium()
                            }
                            .frame(maxWidth: .infinity)
                        }
                        
                        NavigationLink(destination: TimerView()) {
                            VStack {
                                Image(systemName: "timer")
                                    .frame(maxWidth: 40, maxHeight: 40)
                                    .imageScale(.large)
                                    .padding()
                                    .background(Color("LightGray-Gray"))
                                    .cornerRadius(8)
                                
                                Text("타이머")
                                    .bodyMedium()
                            }
                            .frame(maxWidth: .infinity)
                        }
                        
                        NavigationLink(destination: NewWiDView()) {
                            VStack {
                                Image(systemName: "plus.square")
                                    .frame(maxWidth: 40, maxHeight: 40)
                                    .imageScale(.large)
                                    .padding()
                                    .background(Color("LightGray-Gray"))
                                    .cornerRadius(8)
                                
                                Text("새로운 WiD")
                                    .bodyMedium()
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        NavigationLink(destination: DateBasedView()) {
                            VStack {
                                Image(systemName: "scope")
                                    .frame(maxWidth: 40, maxHeight: 40)
                                    .imageScale(.large)
                                    .padding()
                                    .background(Color("LightGray-Gray"))
                                    .cornerRadius(8)
                                
                                Text("날짜 별 조회")
                                    .bodyMedium()
                            }
                            .frame(maxWidth: .infinity)
                        }
                        
                        NavigationLink(destination: PeriodBasedView()) {
                            VStack {
                                Image(systemName: "calendar")
                                    .frame(maxWidth: 40, maxHeight: 40)
                                    .imageScale(.large)
                                    .padding()
                                    .background(Color("LightGray-Gray"))
                                    .cornerRadius(8)
                                
                                Text("기간 별 조회")
                                    .bodyMedium()
                            }
                            .frame(maxWidth: .infinity)
                        }
                        
                        NavigationLink(destination: SearchView()) {
                            VStack {
                                Image(systemName: "doc.text.magnifyingglass")
                                    .frame(maxWidth: 40, maxHeight: 40)
                                    .imageScale(.large)
                                    .padding()
                                    .background(Color("LightGray-Gray"))
                                    .cornerRadius(8)
                                
                                Text("다이어리 검색")
                                    .bodyMedium()
                            }
                            .frame(maxWidth: .infinity)
                        }
                        
                    }
                    .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .tint(Color("Black-White"))
                
                /**
                 하단 바
                 */
                ZStack {
                    Text("WiD")
                        .font(.custom("Acme-Regular", size: 25))
                }
                .frame(maxWidth: .infinity, maxHeight: 44)
            }
        }
        
        // 전체 화면
//        NavigationView {
//            VStack(spacing: 0) {
//                ContentHolderView(currentTab: selectedPicker)
//
//                bottomNavigationBar()
//            }
//            .tint(.black)
//        }
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
