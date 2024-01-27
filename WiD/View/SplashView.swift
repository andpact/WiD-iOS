//
//  SplashView.swift
//  WiD
//
//  Created by jjkim on 2023/09/16.
//

import SwiftUI

struct SplashView: View {
//    @Binding var isInternetConnected: Bool
    
    var body: some View {
        ZStack {
            VStack {
                Text("WiD")
                    .font(.custom("Acme-Regular", size: 70))
            }
            
//            if !isInternetConnected {
//                VStack {
//                    Text("인터넷 연결을 확인하세요.")
//                        .padding(.top, 80)
//                        .foregroundColor(.white)
//                }
//            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
//        let isInternetConnected = Binding.constant(true)
//        SplashView(isInternetConnected: isInternetConnected)
        
        Group {
            SplashView()
                .environment(\.colorScheme, .light)
            
            SplashView()
                .environment(\.colorScheme, .dark)
        }
    }
}
