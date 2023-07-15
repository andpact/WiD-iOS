//
//  WiDReadMonthView.swift
//  WiD
//
//  Created by jjkim on 2023/07/14.
//

import SwiftUI

struct WiDReadMonthView: View {
    @State private var currentDate: Date = Date()
    
    var body: some View {
        VStack {
            HStack {
                Text(formatDate(currentDate, format: "yyyy.MM"))
                    .frame(maxWidth: .infinity)
                
                Button(action: {
                    currentDate = Date()
                }) {
                    Text("현재")
                }
                
                Button(action: {
                    currentDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
                }) {
                    Image(systemName: "chevron.left")
                }
                
                Button(action: {
                    currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
                }) {
                    Image(systemName: "chevron.right")
                }
                .disabled(Calendar.current.isDate(currentDate, equalTo: Date(), toGranularity: .month))
            }
            .border(Color.black)
            
            HStack(spacing: 0) {
                ForEach(0...6, id: \.self) { index in
                    let textColor = index == 0 ? Color.red : (index == 6 ? Color.blue : Color.black)
                    
                    Text(formatWeekdayLetter(index))
                        .frame(maxWidth: .infinity)
                        .foregroundColor(textColor)
                }
            }
            .frame(maxWidth: .infinity)
            
            Text("월 단위")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .border(Color.black)
        .padding(.horizontal)
    }
}

struct WiDReadMonthView_Previews: PreviewProvider {
    static var previews: some View {
        WiDReadMonthView()
    }
}
