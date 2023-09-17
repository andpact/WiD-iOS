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
            animate()
            WiDReadView(currentTab: selectedPicker)
                .background(.white) // 스와이프 용 배경
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width < 0 {
                        // 왼쪽 스와이프: 다음 탭으로 이동
                        withAnimation(.easeInOut) {
                            switch selectedPicker {
                            case .DAY:
                                selectedPicker = .WEEK
                            case .WEEK:
                                selectedPicker = .MONTH
                            case .MONTH:
                                selectedPicker = .DAY
                            }
                        }
                    } else if value.translation.width > 0 {
                        // 오른쪽 스와이프: 이전 탭으로 이동
                        withAnimation(.easeInOut) {
                            switch selectedPicker {
                            case .DAY:
                                selectedPicker = .MONTH
                            case .WEEK:
                                selectedPicker = .DAY
                            case .MONTH:
                                selectedPicker = .WEEK
                            }
                        }
                    }
                }
        )
    }
    
    @ViewBuilder
    private func animate() -> some View {
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
    case DAY = "DAY"
    case WEEK = "WEEK"
    case MONTH = "MONTH"
}

struct WiDReadView: View {
    var currentTab: wiDReadHolderTapInfo
    
    var body: some View {
        switch currentTab {
        case .DAY:
            WiDReadDayView()
        case .WEEK:
            WiDReadWeekView()
        case .MONTH:
            WiDReadMonthView()
        }
    }
}

struct WiDReadHolderView_Previews: PreviewProvider {
    static var previews: some View {
        WiDReadHolderView()
    }
}
