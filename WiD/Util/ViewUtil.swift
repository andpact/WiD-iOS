//
//  ViewUtil.swift
//  WiD
//
//  Created by jjkim on 2023/12/08.
//

import SwiftUI
import Foundation

func getEmptyView(message: String) -> some View {
    return HStack {
        Text(message)
            .labelSmall()
    }
    .padding(.vertical, 48)
    .frame(maxWidth: .infinity)
}

func getEmptyViewWithMultipleLines(message: String) -> some View {
    let lines = message.components(separatedBy: " ")
    
    return VStack {
        ForEach(lines, id: \.self) { line in
            Text(line)
                .labelSmall()
                .multilineTextAlignment(.center)
        }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
}
