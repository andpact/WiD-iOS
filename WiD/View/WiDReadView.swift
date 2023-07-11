//
//  WiDReadView.swift
//  WiD
//
//  Created by jjkim on 2023/07/08.
//

import SwiftUI

struct WiDReadView: View {
    @State private var wiDs: [WiD] = []
    private let wiDService = WiDService()
    
    @State private var currentDate: Date = Date()
    
    var body: some View {
        VStack {
            HStack {
                HStack {
                    Text(formatDate(currentDate, format: "yyyy.MM.dd"))
                    
                    Text(formatWeekday(currentDate))
                }
                .frame(maxWidth: .infinity)
                
                Text("현재")
                
                Button(action: {
                    currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
                }) {
                    Image(systemName: "chevron.left")
                }
                
                Button(action: {
                    currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
                }) {
                    Image(systemName: "chevron.right")
                }
            }
            .border(Color.black)
            
            VStack {
                Text("Add pie chart here")
            }
            .frame(maxHeight: .infinity)
        }
        .frame(maxHeight: .infinity)
        .border(Color.black)
        .padding()
    }
    
    func formatDate(_ date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    func formatWeekday(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        return dateFormatter.string(from: date)
    }
}

struct WiDReadView_Previews: PreviewProvider {
    static var previews: some View {
        WiDReadView()
    }
}
