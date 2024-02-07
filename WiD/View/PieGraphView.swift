//
//  PieGraphView.swift
//  WiD
//
//  Created by jjkim on 2024/02/07.
//

import SwiftUI
import DGCharts

struct DayPieGraphView: UIViewRepresentable {

    func makeUIView(context: Context) -> PieChartView {
        return PieChartView()
    }
    
    func updateUIView(_ uiView: PieChartView, context: Context) {

    }
}

struct PieGraphView_Previews: PreviewProvider {
    static var previews: some View {
        DayPieGraphView()
    }
}
