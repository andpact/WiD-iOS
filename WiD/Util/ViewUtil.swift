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
        Image(systemName: "ellipsis.bubble")

        Text(message)
    }
    .padding()
    .padding(.vertical, 32)
    .frame(maxWidth: .infinity)
    .foregroundColor(.gray)
    .background(.white)
    .cornerRadius(8)
    .shadow(radius: 1)
}
