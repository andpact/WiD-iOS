//
//  WiDReadView.swift
//  WiD
//
//  Created by jjkim on 2024/02/06.
//

import SwiftUI

enum WiDDisplayViewTapItem : String, CaseIterable {
    case DAY = "일별 조회"
    case WEEK = "주별 조회"
    case MONTH = "월별 조회"
    case TITLE = "제목별 조회"
}

struct WiDDisplayView: View {
    // 화면
    @State private var selectedTab: WiDDisplayViewTapItem = .DAY
    @Namespace private var animation
    
    // 뷰 모델
    @EnvironmentObject var titleWiDViewModel: TitleWiDViewModel

    var body: some View {
        VStack(spacing: 0) {
            // 상단 바
            HStack {
                Text("WiD")
                    .titleLarge()
                
                Spacer()
                
                if selectedTab == .TITLE {
                    Picker("", selection: $titleWiDViewModel.selectedPeriod) {
                        ForEach(Period.allCases) { period in
                            Text(period.koreanValue)
                                .bodyMedium()
                        }
                    }
                    .labelsHidden()
                    .onChange(of: titleWiDViewModel.selectedPeriod) { newPeriod in
                        titleWiDViewModel.setPeriod(to: newPeriod)
                    }
                    
                    Picker("", selection: $titleWiDViewModel.selectedTitle) {
                        ForEach(Title.allCases) { title in
//                            Image(systemName: titleImageDictionary[title.rawValue] ?? "")
//                                .font(.system(size: 20))
//                                .frame(width: 20, height: 20)
                                
                            Text(title.koreanValue)
                                .bodyMedium()
                        }
                    }
                    .labelsHidden()
                    .onChange(of: titleWiDViewModel.selectedTitle) { newTitle in
                        titleWiDViewModel.setTitle(to: newTitle)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 44)
            .padding(.horizontal)
            .background(Color("LightGray-Gray"))
            
            // 상단 탭
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 16) {
                    ForEach(WiDDisplayViewTapItem.allCases, id: \.self) { item in
                        VStack(spacing: 8) {
                            Text(item.rawValue)
                                .bodyMedium()
                                .foregroundColor(selectedTab == item ? Color("Black-White") : Color("DarkGray"))

                            if selectedTab == item {
                                Rectangle()
                                    .foregroundColor(Color("Black-White"))
                                    .frame(maxWidth: 50, maxHeight: 3)
                                    .matchedGeometryEffect(id: "", in: animation)
                            }       
                        }
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                self.selectedTab = item
                            }
                        }
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: 44)
                .padding(.horizontal)
            }
            .background(Color("White-Black"))
            .cornerRadius(radius: 32, corners: [.topLeft, .topRight])
            .background(Color("LightGray-Gray"))
            
            WiDDisplayHolderView(tabItem: selectedTab)
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            if value.translation.width > 100 {
                                if selectedTab == .WEEK {
                                    selectedTab = .DAY
                                } else if selectedTab == .MONTH {
                                    selectedTab = .WEEK
                                } else if selectedTab == .TITLE {
                                    selectedTab = .MONTH
                                }
                            }
                            
                            if value.translation.width < -100 {
                                if selectedTab == .DAY {
                                    selectedTab = .WEEK
                                } else if selectedTab == .WEEK {
                                    selectedTab = .MONTH
                                } else if selectedTab == .MONTH {
                                    selectedTab = .TITLE
                                }
                            }
                        }
                )
        }
        .tint(Color("Black-White"))
        .onAppear {
            print("WiDDisplay appeared")
        }
        .onDisappear {
            print("WiDDisplay disappeared")
        }
    }
}

struct WiDDisplayHolderView : View {
    var tabItem: WiDDisplayViewTapItem
    
    var body: some View {
        VStack {
            switch tabItem {
            case .DAY:
                DayWiDView()
            case .WEEK:
                WeekWiDView()
            case .MONTH:
                MonthWiDView()
            case .TITLE:
                TitleWiDView()
            }
        }
    }
}

struct WiDDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WiDDisplayView()
                .environmentObject(TitleWiDViewModel())
                .environment(\.colorScheme, .light)
            
            WiDDisplayView()
                .environmentObject(TitleWiDViewModel())
                .environment(\.colorScheme, .dark)
        }
    }
}
