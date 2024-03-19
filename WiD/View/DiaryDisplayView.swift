//
//  DiaryDisplayView.swift
//  WiD
//
//  Created by jjkim on 2024/02/06.
//

import SwiftUI

enum DiaryDisplayViewTapItem : String, CaseIterable {
    case DAY = "일별 조회"
//    case RANDOM = "랜덤 조회"
    case SEARCH = "검색 조회"
}

struct DiaryDisplayView: View {
    // 화면
    @State private var selectedTab: DiaryDisplayViewTapItem = .DAY
    @Namespace private var animation
    
    // 도구
    @EnvironmentObject var searchDiaryViewModel: SearchDiaryViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // 상단 바
            HStack {
                Text("다이어리")
                    .titleLarge()
                
                Spacer()
                
                if selectedTab == .SEARCH {
                    Picker("", selection: $searchDiaryViewModel.searchFilter) {
                        ForEach(SearchFilter.allCases) { filter in
                            Text(filter.koreanValue)
                                .bodyMedium()
                        }
                    }
                    .labelsHidden()
                    .onChange(of: searchDiaryViewModel.searchFilter) { newFilter in
                        searchDiaryViewModel.changeSearchFilter(to: newFilter)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 44)
            .padding(.horizontal)
            .background(Color("LightGray-Gray"))
            
            // 상단 탭
            ScrollView(.horizontal) {
                HStack(alignment: .top, spacing: 16) {
                    ForEach(DiaryDisplayViewTapItem.allCases, id: \.self) { item in
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
            
            DiaryDisplayHolderView(tabItem: selectedTab)
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            if value.translation.width > 100 {
                                if selectedTab == .SEARCH {
                                    selectedTab = .DAY
                                }
                                
//                                if selectedTab == .RANDOM {
//                                    selectedTab = .DAY
//                                } else if selectedTab == .SEARCH {
//                                    selectedTab = .RANDOM
//                                }
                            }
                            
                            if value.translation.width < -100 {
                                if selectedTab == .DAY {
                                    selectedTab = .SEARCH
                                }
                                
//                                if selectedTab == .DAY {
//                                    selectedTab = .RANDOM
//                                } else if selectedTab == .RANDOM {
//                                    selectedTab = .SEARCH
//                                }
                            }
                        }
                )
        }
        .navigationBarHidden(true)
        .tint(Color("Black-White"))
        .onAppear {
            print("DiaryDisplayView appeared")
        }
        .onDisappear {
            print("DiaryDisplayView disappeared")
        }
    }
}

struct DiaryDisplayHolderView : View {
    var tabItem: DiaryDisplayViewTapItem
    
    var body: some View {
        VStack {
            switch tabItem {
            case .DAY:
                DayDiaryView()
//            case .RANDOM:
//                RandomDiaryView()
            case .SEARCH:
                SearchDiaryView()
            }
        }
    }
}

struct DiaryDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DiaryDisplayView()
                .environment(\.colorScheme, .light)
            
            DiaryDisplayView()
                .environment(\.colorScheme, .dark)
        }
    }
}
