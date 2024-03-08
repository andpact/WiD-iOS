//
//  DiaryDisplayView.swift
//  WiD
//
//  Created by jjkim on 2024/02/06.
//

import SwiftUI

enum DiaryDisplayViewTapItem : String, CaseIterable {
    case DAY = "일별 조회"
    case RANDOM = "랜덤 조회"
    case SEARCH = "검색 조회"
}

struct DiaryDisplayView: View {
    // 화면
//    @Environment(\.presentationMode) var presentationMode
    @State private var selectedTab: DiaryDisplayViewTapItem = .DAY
    @Namespace private var animation
    
    // 도구
//    @EnvironmentObject var stopwatchPlayer: StopwatchPlayer
//    @EnvironmentObject var timerPlayer: TimerPlayer
    
    var body: some View {
//        NavigationView {
            VStack(spacing: 0) {
                // 상단 바
                HStack {
                    Text("다이어리")
                        .titleLarge()
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: 44)
                .padding(.horizontal)
                
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
    //                .background(Color("White-Gray"))
    //                .cornerRadius(radius: 32, corners: [.topLeft, .topRight])
    //                .background(Color("LightGray-Black"))
                }
                
                DiaryDisplayHolderView(tabItem: selectedTab)
                    .gesture(
                        DragGesture()
                            .onEnded { value in
                                if value.translation.width > 100 {
//                                    if selectedTab == .SEARCH {
//                                        withAnimation {
//                                            selectedTab = .DAY
//                                        }
//                                    }
                                    
                                    if selectedTab == .RANDOM {
                                        withAnimation {
                                            selectedTab = .DAY
                                        }
                                    } else if selectedTab == .SEARCH {
                                        withAnimation {
                                            selectedTab = .RANDOM
                                        }
                                    }
                                }
                                
                                if value.translation.width < -100 {
//                                    if selectedTab == .DAY {
//                                        withAnimation {
//                                            selectedTab = .SEARCH
//                                        }
//                                    }
                                    
                                    if selectedTab == .DAY {
                                        withAnimation {
                                            selectedTab = .RANDOM
                                        }
                                    } else if selectedTab == .RANDOM {
                                        withAnimation {
                                            selectedTab = .SEARCH
                                        }
                                    }
                                }
                            }
                    )
            }
//        }
        .navigationBarHidden(true)
        .tint(Color("Black-White"))
    }
}

struct DiaryDisplayHolderView : View {
    var tabItem: DiaryDisplayViewTapItem
    
    var body: some View {
        VStack {
            switch tabItem {
            case .DAY:
                DayDiaryView()
            case .RANDOM:
                RandomDiaryView()
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
//                .environmentObject(StopwatchPlayer())
//                .environmentObject(TimerPlayer())
                .environment(\.colorScheme, .light)
            
            DiaryDisplayView()
//                .environmentObject(StopwatchPlayer())
//                .environmentObject(TimerPlayer())
                .environment(\.colorScheme, .dark)
        }
    }
}
