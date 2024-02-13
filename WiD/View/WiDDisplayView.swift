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
            .background(Color("LightGray-Black"))
            .tint(Color("Black-White"))

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
            .background(Color("White-Gray"))
            .cornerRadius(radius: 32, corners: [.topLeft, .topRight])
            .background(Color("LightGray-Black"))
         
            WiDDisplayHolderView(tabItem: selectedTab)
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            if value.translation.width > 100 {
                                if selectedTab == .WEEK {
                                    withAnimation {
                                        selectedTab = .DAY
                                    }
                                } else if selectedTab == .MONTH {
                                    withAnimation {
                                        selectedTab = .WEEK
                                    }
                                } else if selectedTab == .TITLE {
                                    withAnimation {
                                        selectedTab = .MONTH
                                    }
                                }
                            }
                            
                            if value.translation.width < -100 {
                                if selectedTab == .DAY {
                                    withAnimation {
                                        selectedTab = .WEEK
                                    }
                                } else if selectedTab == .WEEK {
                                    withAnimation {
                                        selectedTab = .MONTH
                                    }
                                } else if selectedTab == .MONTH {
                                    withAnimation {
                                        selectedTab = .TITLE
                                    }
                                }
                            }
                        }
                )
        }
        .tint(Color("Black-White"))
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
                .environment(\.colorScheme, .light)
            
            WiDDisplayView()
                .environment(\.colorScheme, .dark)
        }
    }
}
