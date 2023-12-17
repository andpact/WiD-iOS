//
//  WiDReadHolderView.swift
//  WiD
//
//  Created by jjkim on 2023/07/14.
//

import SwiftUI

struct ListView: View {
    @State private var selectedPicker: ListTapInfo = .DATEBASED
    @Namespace private var animation
    
    var body: some View {
        VStack(spacing: 0) {
            topTabBar()
            
            ListHolderView(currentTab: selectedPicker)
        }
        .background(Color("ghost_white")) // 배경이 없으면 스와이프할 수 없기 때문에 배경색을 추가함.
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width < 0 {
                        // 왼쪽 스와이프: 다음 탭으로 이동
                        withAnimation(.easeInOut) {
                            switch selectedPicker {
                            case .DATEBASED:
                                selectedPicker = .PERIODBASED
                            case .PERIODBASED:
                                selectedPicker = .DATEBASED
                            }
                        }
                    } else if 0 < value.translation.width {
                        // 오른쪽 스와이프: 이전 탭으로 이동
                        withAnimation(.easeInOut) {
                            switch selectedPicker {
                            case .DATEBASED:
                                selectedPicker = .PERIODBASED
                            case .PERIODBASED:
                                selectedPicker = .DATEBASED
                            }
                        }
                    }
                }
        )
    }
    
    @ViewBuilder
    private func topTabBar() -> some View {
        HStack(spacing: 0) {
            ForEach(ListTapInfo.allCases, id: \.self) { item in
                VStack {
                    Text(item.rawValue)
                        .font(.system(size: 18, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .foregroundColor(selectedPicker == item ? .black : .gray)
                    if selectedPicker == item {
                        Rectangle()
                            .foregroundColor(.black)
                            .frame(height: 3)
                            .matchedGeometryEffect(id: "DATEBASED", in: animation)
//                            .matchedGeometryEffect(id: "PERIODBASED", in: animation)
//                            .matchedGeometryEffect(id: "\(item.rawValue)", in: animation)
                    }
                }
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        self.selectedPicker = item
                    }
                }
            }
        }
        .background(.white)
        .compositingGroup()
        .shadow(radius: 1)
    }
}

enum ListTapInfo: String, CaseIterable {
    case DATEBASED = "날짜"
    case PERIODBASED = "기간"
}

struct ListHolderView: View {
    var currentTab: ListTapInfo
    
    var body: some View {
        switch currentTab {
        case .DATEBASED:
            DateBasedView()
        case .PERIODBASED:
            PeriodBasedView()
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
