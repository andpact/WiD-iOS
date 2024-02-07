//
//  RandomDiaryView.swift
//  WiD
//
//  Created by jjkim on 2024/02/06.
//

import SwiftUI

struct RandomDiaryView: View {
    var body: some View {
        VStack {
            Text("RandomDiaryView")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarHidden(true)
    }
}

struct RandomDiaryView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RandomDiaryView()
                .environment(\.colorScheme, .light)
            
            RandomDiaryView()
                .environment(\.colorScheme, .dark)
        }
    }
}
