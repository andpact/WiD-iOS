//
//  WiDReadHolderView.swift
//  WiD
//
//  Created by jjkim on 2023/07/14.
//

import SwiftUI

struct WiDReadHolderView: View {
    @State private var selectedPicker: wiDReadHolderTapInfo = .DAY
    @Namespace private var animation
    
    var body: some View {
        VStack {
            topTabBar()
            
            WiDReadView(currentTab: selectedPicker)
            //배경이 없으면 스와이프할 수 없기 때문에 배경색을 추가함.
                .background(.white)
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width < 0 {
                        // 왼쪽 스와이프: 다음 탭으로 이동
                        withAnimation(.easeInOut) {
                            switch selectedPicker {
                            case .DAY:
                                selectedPicker = .CALENDAR
                            case .CALENDAR:
                                selectedPicker = .DAY
                            }
                        }
                    } else if value.translation.width > 0 {
                        // 오른쪽 스와이프: 이전 탭으로 이동
                        withAnimation(.easeInOut) {
                            switch selectedPicker {
                            case .DAY:
                                selectedPicker = .CALENDAR
                            case .CALENDAR:
                                selectedPicker = .DAY
                            }
                        }
                    }
                }
        )
    }
    
    @ViewBuilder
    private func topTabBar() -> some View {
        HStack {
            ForEach(wiDReadHolderTapInfo.allCases, id: \.self) { item in
                VStack {
                    Text(item.rawValue)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(selectedPicker == item ? .black : .gray)
                    if selectedPicker == item {
                        Capsule()
                            .foregroundColor(.black)
                            .frame(height: 3)
                            .matchedGeometryEffect(id: "DAY", in: animation)
                    }
                }
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        self.selectedPicker = item
                    }
                }
            }
        }
    }
}

enum wiDReadHolderTapInfo: String, CaseIterable {
    case DAY = "날짜 별 기록"
    case CALENDAR = "기간 별 기록"
}

struct WiDReadView: View {
    var currentTab: wiDReadHolderTapInfo
    
    var body: some View {
        switch currentTab {
        case .DAY:
            WiDReadDayView()
        case .CALENDAR:
            WiDReadCalendarView()
        }
    }
}

struct WiDReadHolderView_Previews: PreviewProvider {
    static var previews: some View {
        WiDReadHolderView()
    }
}
