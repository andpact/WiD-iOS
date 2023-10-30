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
    
    @Binding var buttonsVisible: Bool
    
    var body: some View {
        VStack {
            animate()
                .disabled(!buttonsVisible)

            WiDCreateView(currentTab: selectedPicker, buttonsVisible: $buttonsVisible)
                .background(.white) // 스와이프 용 배경
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if buttonsVisible {
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
    case STOPWATCH = "스톱워치"
    case TIMER = "타이머"
    case MANUAL = "직접 입력"
}

struct WiDCreateView: View {
    var currentTab: wiDCreateHolderTapInfo
    @Binding var buttonsVisible: Bool
    
    var body: some View {
        switch currentTab {
        case .STOPWATCH:
            WiDCreateStopWatchView(buttonsVisible: $buttonsVisible)
        case .TIMER:
            WiDCreateTimerView(buttonsVisible: $buttonsVisible)
        case .MANUAL:
            WiDCreateManualView()
        }
    }
}

struct WiDCreateHolderView_Previews: PreviewProvider {
    static var previews: some View {
        let buttonsVisible = Binding.constant(true)
        return WiDCreateHolderView(buttonsVisible: buttonsVisible)
    }
}
