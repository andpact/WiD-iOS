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
            .font(.system(size: 16, weight: .light))
            .foregroundColor(.gray)
    }
//    .padding()
    .padding(.vertical, 48)
    .frame(maxWidth: .infinity)
//    .background(Color("ghost_white"))
//    .cornerRadius(8)
//    .shadow(radius: 1)
}

func getEmptyViewWithMultipleLines(message: String) -> some View {
    let lines = message.components(separatedBy: " ")
    
    return VStack {
        ForEach(lines, id: \.self) { line in
            Text(line)
                .font(.system(size: 16, weight: .light))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
}
