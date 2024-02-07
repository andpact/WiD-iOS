//
//  PomodoroView.swift
//  WiD
//
//  Created by jjkim on 2024/02/06.
//

import SwiftUI

struct PomodoroView: View {
    var body: some View {
        VStack {
            Text("PomodoroView")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarHidden(true)
    }
}

struct PomodoroView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PomodoroView()
                .environment(\.colorScheme, .light)
            
            PomodoroView()
                .environment(\.colorScheme, .dark)
        }
    }
}
