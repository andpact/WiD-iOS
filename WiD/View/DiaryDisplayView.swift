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
    case SEARCH = "검색"
}

struct DiaryDisplayView: View {
    // 화면
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedTab: DiaryDisplayViewTapItem = .DAY
    @Namespace private var animation
    @GestureState private var translation: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.backward")
                        .font(.system(size: 24))
                }
                
                Text("다이어리 조회")
                    .titleLarge()
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: 44)
            .padding(.horizontal)
            .tint(Color("Black"))

            HStack(alignment: .top, spacing: 16) {
                ForEach(DiaryDisplayViewTapItem.allCases, id: \.self) { item in
                    VStack(spacing: 8) {
                        Text(item.rawValue)
                            .bodyMedium()
                            .foregroundColor(selectedTab == item ? Color("Black") : Color("DarkGray"))

                        if selectedTab == item {
                            Rectangle()
                                .foregroundColor(Color("Black"))
                                .frame(maxWidth: 50, maxHeight: 3)
                                .matchedGeometryEffect(id: "STOPWATCH", in: animation)
                        }
                            
                    }
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            self.selectedTab = item
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 44, alignment: .leading)
            .padding(.horizontal)
            
            DiaryDisplayHolderView(tabItem: selectedTab)
                .gesture(
                    DragGesture().updating($translation) { value, state, _ in
                        state = value.translation.width
                    }
                    .onEnded { value in
                        let offset = value.translation.width
                        if offset > 50 {
                            // 스와이프 우측으로 이동하면 이전 탭으로 변경
                            withAnimation {
                                changeTab(by: -1)
                            }
                        } else if offset < -50 {
                            // 스와이프 좌측으로 이동하면 다음 탭으로 변경
                            withAnimation {
                                changeTab(by: 1)
                            }
                        }
                    }
                )
        }
    }
    
    private func changeTab(by offset: Int) {
        guard let currentIndex = DiaryDisplayViewTapItem.allCases.firstIndex(of: selectedTab) else {
            return
        }
        let newIndex = (currentIndex + offset + DiaryDisplayViewTapItem.allCases.count) % DiaryDisplayViewTapItem.allCases.count
        selectedTab = DiaryDisplayViewTapItem.allCases[newIndex]
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
                .environment(\.colorScheme, .light)
            
            DiaryDisplayView()
                .environment(\.colorScheme, .dark)
        }
    }
}
