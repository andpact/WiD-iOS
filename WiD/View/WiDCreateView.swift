//
//  WiDCreateHolderView.swift
//  WiD
//
//  Created by jjkim on 2023/09/13.
//

import SwiftUI

struct WiDCreateView: View {
    @State private var selectedPicker: wiDCreateHolderTapInfo = .STOPWATCH
    @Namespace private var animation
    
    // 상단, 하단 Bar 가시성
    @Binding var topBottomBarVisible: Bool
    
    var body: some View {
        VStack {
            if topBottomBarVisible {
                topTabBar()
            }

            WiDCreateHolderView(currentTab: selectedPicker, topBottomBarVisible: $topBottomBarVisible)
        }
        .background(Color("ghost_white")) // 배경이 없으면 스와이프할 수 없기 때문에 배경색을 추가함.
        .gesture(
            DragGesture()
                .onEnded { value in
                    if topBottomBarVisible { // 상단, 하단 탭이 보일 때만 좌우 스와이프 가능함.
                        if value.translation.width < 0 {
                            // 왼쪽 스와이프: 다음 탭으로 이동
                            withAnimation(.easeInOut) {
                                switch selectedPicker {
                                case .STOPWATCH:
                                    selectedPicker = .TIMER
                                case .TIMER:
                                    selectedPicker = .MANUAL
                                case .MANUAL:
                                    selectedPicker = .STOPWATCH
                                }
                            }
                        } else if value.translation.width > 0 {
                            // 오른쪽 스와이프: 이전 탭으로 이동
                            withAnimation(.easeInOut) {
                                switch selectedPicker {
                                case .TIMER:
                                    selectedPicker = .STOPWATCH
                                case .STOPWATCH:
                                    selectedPicker = .MANUAL
                                case .MANUAL:
                                    selectedPicker = .TIMER
                                }
                            }
                        }
                    }
                }
        )
    }
    
    @ViewBuilder
    private func topTabBar() -> some View {
        HStack {
            ForEach(wiDCreateHolderTapInfo.allCases, id: \.self) { item in
                VStack {
                    Text(item.rawValue)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(selectedPicker == item ? .black : .gray)
                    if selectedPicker == item {
                        Capsule()
                            .foregroundColor(.black)
                            .frame(height: 3)
                            .matchedGeometryEffect(id: "STOPWATCH", in: animation)
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

enum wiDCreateHolderTapInfo: String, CaseIterable {
    case STOPWATCH = "스톱워치"
    case TIMER = "타이머"
    case MANUAL = "직접 입력"
}

struct WiDCreateHolderView: View {
    var currentTab: wiDCreateHolderTapInfo
    @Binding var topBottomBarVisible: Bool
    
    var body: some View {
        switch currentTab {
        case .STOPWATCH:
            WiDCreateStopWatchView(topBottomBarVisible: $topBottomBarVisible)
        case .TIMER:
            WiDCreateTimerView(topBottomBarVisible: $topBottomBarVisible)
        case .MANUAL:
            WiDCreateManualView()
        }
    }
}

struct WiDCreateHolderView_Previews: PreviewProvider {
    static var previews: some View {
        let topBottomBarVisible = Binding.constant(true)
        return WiDCreateView(topBottomBarVisible: topBottomBarVisible)
    }
}
