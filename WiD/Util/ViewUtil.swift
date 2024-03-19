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
    .background(Color("White-Black"))
    .cornerRadius(8)
    .shadow(color: Color("Black-White"), radius: 1)
    .padding(.horizontal)
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

//step 1 -- Create a shape view which can give shape
struct CornerRadiusShape: Shape {
    var radius = CGFloat.infinity
    var corners = UIRectCorner.allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

//step 2 - embed shape in viewModifier to help use with ease
struct CornerRadiusStyle: ViewModifier {
    var radius: CGFloat
    var corners: UIRectCorner
    func body(content: Content) -> some View {
        content
            .clipShape(CornerRadiusShape(radius: radius, corners: corners))
    }
}
//step 3 - crate a polymorphic view with same name as swiftUI's cornerRadius
extension View {
    func cornerRadius(radius: CGFloat, corners: UIRectCorner) -> some View {
        ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners))
    }
}
