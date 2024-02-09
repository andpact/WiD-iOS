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
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedTab: WiDDisplayViewTapItem = .DAY
    @Namespace private var animation
//    @GestureState private var translation: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.backward")
                        .font(.system(size: 24))
                }
                
                Text("WiD 조회")
                    .titleLarge()
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: 44)
            .padding(.horizontal)
            .tint(Color("Black"))

            HStack(alignment: .top, spacing: 16) {
                ForEach(WiDDisplayViewTapItem.allCases, id: \.self) { item in
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
         
            WiDDisplayHolderView(tabItem: selectedTab)
//                .gesture(
//                    DragGesture().updating($translation) { value, state, _ in
//                        state = value.translation.width
//                    }
//                    .onEnded { value in
//                        let offset = value.translation.width
//                        if offset > 50 {
//                            // 스와이프 우측으로 이동하면 이전 탭으로 변경
//                            withAnimation {
//                                changeTab(by: -1)
//                            }
//                        } else if offset < -50 {
//                            // 스와이프 좌측으로 이동하면 다음 탭으로 변경
//                            withAnimation {
//                                changeTab(by: 1)
//                            }
//                        }
//                    }
//                )
        }
    }
    
//    private func changeTab(by offset: Int) {
//        guard let currentIndex = WiDDisplayViewTapItem.allCases.firstIndex(of: selectedTab) else {
//            return
//        }
//        let newIndex = (currentIndex + offset + WiDDisplayViewTapItem.allCases.count) % WiDDisplayViewTapItem.allCases.count
//        selectedTab = WiDDisplayViewTapItem.allCases[newIndex]
//    }
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
                .environment(\.colorScheme, .light)
            
            WiDDisplayView()
                .environment(\.colorScheme, .dark)
        }
    }
}
