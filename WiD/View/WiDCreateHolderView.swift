//
//  WiDCreateHolderView.swift
//  WiD
//
//  Created by jjkim on 2023/09/13.
//

import SwiftUI

struct WiDCreateHolderView: View {
    @State private var selectedPicker: wiDCreateHolderTapInfo = .STOPWATCH
    @Namespace private var animation
    
    var body: some View {
        VStack {
            animate()
            WiDCreateView(currentTab: selectedPicker)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width < 0 {
                        // 왼쪽 스와이프: 다음 탭으로 이동
                        withAnimation(.easeInOut) {
                            switch selectedPicker {
                            case .STOPWATCH:
                                selectedPicker = .TIMER
                            case .TIMER:
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
                                selectedPicker = .TIMER
                            }
                        }
                    }
                }
        )
    }
    
    @ViewBuilder
    private func animate() -> some View {
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
    case STOPWATCH = "STOPWATCH"
    case TIMER = "TIMER"
}

struct WiDCreateView: View {
    var currentTab: wiDCreateHolderTapInfo
    
    var body: some View {
        switch currentTab {
        case .STOPWATCH:
            WiDCreateStopWatchView()
        case .TIMER:
            WiDCreateTimerView()
        }
    }
}

struct WiDCreateHolderView_Previews: PreviewProvider {
    static var previews: some View {
        WiDCreateHolderView()
    }
}