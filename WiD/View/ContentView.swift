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
        NavigationView { // 네비게이션 뷰로 감싸지 않으면 네비게이션 링크를 통한 전환이 안됨.
            VStack {
                /**
                 상단 바
                 */
                ZStack {
                    Text("WiD")
                        .font(.custom("Acme-Regular", size: 25))
//                        .titleLarge()
                    
//                    Image(systemName: "moon.fill")
//                        .imageScale(.large)
//                        .frame(maxWidth: .infinity, alignment: .trailing)
                    
//                    Image(systemName: "sun.max.fill")
//                        .imageScale(.large)
                }
                .padding()
                
                /**
                 컨텐츠
                 */
                VStack {
                    HStack(alignment: .top) {
                        NavigationLink(destination: StopWatchView()) {
                            VStack {
                                Image(systemName: "stopwatch")
                                    .frame(width: 30, height: 30)
                                    .imageScale(.large)
                                    .padding()
                                    .background(.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                
                                Text("스톱 워치")
                                    .bodyMedium()
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        
                        NavigationLink(destination: TimerView()) {
                            VStack {
                                Image(systemName: "timer")
                                    .frame(width: 30, height: 30)
                                    .imageScale(.large)
                                    .padding()
                                    .background(.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                
                                Text("타이머")
                                    .bodyMedium()
                            }
                            .frame(maxWidth: .infinity)
                        }
                        
                        NavigationLink(destination: NewWiDView()) {
                            VStack {
                                Image(systemName: "plus.square")
                                    .frame(width: 30, height: 30)
                                    .imageScale(.large)
                                    .padding()
                                    .background(.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                
                                Text("새로운 WiD")
                                    .bodyMedium()
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        
    //                    VStack {
    //                        Image(systemName: "rectangle.and.text.magnifyingglass.rtl")
    //                            .frame(width: 30, height: 30)
    //                            .imageScale(.large)
    //                            .padding()
    //                            .background(.gray)
    //                            .foregroundColor(.white)
    //                            .cornerRadius(8)
    //
    //                        Text("WiD\n검색")
    //                            .bodyMedium()
    //                            .multilineTextAlignment(.center)
    //                    }
    //                    .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        NavigationLink(destination: DateBasedView()) {
                            VStack {
                                Image(systemName: "scope")
                                    .frame(width: 30, height: 30)
                                    .imageScale(.large)
                                    .padding()
                                    .background(.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                
                                Text("날짜 별 조회")
                                    .bodyMedium()
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        
                        NavigationLink(destination: PeriodBasedView()) {
                            VStack {
                                Image(systemName: "calendar")
                                    .frame(width: 30, height: 30)
                                    .imageScale(.large)
                                    .padding()
                                    .background(.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                
                                Text("기간 별 조회")
                                    .bodyMedium()
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        
                        NavigationLink(destination: SearchView()) {
                            VStack {
                                Image(systemName: "doc.text.magnifyingglass")
                                    .frame(width: 30, height: 30)
                                    .imageScale(.large)
                                    .padding()
                                    .background(.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                
                                Text("다이어리 검색")
                                    .bodyMedium()
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        
    //                    VStack {
    //                        Image(systemName: "gearshape")
    //                            .frame(width: 30, height: 30)
    //                            .imageScale(.large)
    //                            .padding()
    //                            .background(.gray)
    //                            .foregroundColor(.white)
    //                            .cornerRadius(8)
    //
    //                        Text("환경\n설정")
    //                            .bodyMedium()
    //                            .multilineTextAlignment(.center)
    //                    }
    //                    .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .tint(.black)
        
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
