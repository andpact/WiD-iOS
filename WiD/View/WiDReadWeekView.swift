//
//  WiDReadWeekView.swift
//  WiD
//
//  Created by jjkim on 2023/07/14.
//

import SwiftUI

struct WiDReadWeekView: View {
    
    @State private var currentDate: Date = getFirstDayOfWeek(for: Date())
    
//    제목 별 시간 총합을 나타내기 위한 딕셔너리가 필요함.
    
    var body: some View {
        VStack {
            HStack {
                HStack {
                    Text(formatDate(currentDate, format: "yyyy년"))
                        
                    Text("\(weekNumber(for: currentDate))번째 주")
                }
                .frame(maxWidth: .infinity)

                Button(action: {
                    currentDate = getFirstDayOfWeek(for: Date())
                }) {
                    Text("현재")
                }
                
                Button(action: {
                    currentDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: currentDate) ?? currentDate
                }) {
                    Image(systemName: "chevron.left")
                }

                Button(action: {
                    currentDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: currentDate) ?? currentDate
                }) {
                    Image(systemName: "chevron.right")
                }
                .disabled(Calendar.current.isDate(currentDate, equalTo: getFirstDayOfWeek(for: Date()), toGranularity: .weekOfYear))
            }
            .border(Color.black)
            
            HStack(spacing: 0) {
                ForEach(1...7, id: \.self) { index in
                    let textColor = index == 7 ? Color.red : (index == 6 ? Color.blue : Color.black)
                    
                    Text(formatWeekdayLetter(index))
                        .frame(maxWidth: .infinity)
                        .foregroundColor(textColor)
                }
            }
            .frame(maxWidth: .infinity)
            
            HStack(spacing: 0) {
                ForEach(0..<7) { index in
                    PieChartView(data: fetchChartData(date: Calendar.current.date(byAdding: .day, value: index, to: currentDate) ?? currentDate), date: Calendar.current.date(byAdding: .day, value: index, to: currentDate) ?? currentDate, isForOne: false)
                }
            }
            .frame(maxWidth: .infinity)
            .border(Color.red)
        }
        .frame(maxWidth: .infinity)
        .border(Color.black)
        .padding(.horizontal)
    }
}

struct WiDReadWeekView_Previews: PreviewProvider {
    static var previews: some View {
        WiDReadWeekView()
    }
}
