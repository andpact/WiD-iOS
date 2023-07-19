//
//  WiDReadMonthView.swift
//  WiD
//
//  Created by jjkim on 2023/07/14.
//

import SwiftUI

struct WiDReadMonthView: View {
    @State private var currentDate: Date = getFirstDayOfMonth(for: Date())
    
    var body: some View {
        VStack {
            HStack {
                Text(formatDate(currentDate, format: "yyyy.MM"))
                    .frame(maxWidth: .infinity)
                
                Button(action: {
                    currentDate = getFirstDayOfMonth(for: Date())
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
                .disabled(Calendar.current.isDate(currentDate, equalTo: getFirstDayOfMonth(for: Date()), toGranularity: .month))

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
            
            // 파이차트
            LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 10) {
                let firstDayOfMonth = getFirstDayOfMonth(for: currentDate)
                let weekdayOffset = getWeekdayOffset(for: firstDayOfMonth)
                
                ForEach(0..<weekdayOffset, id: \.self) { _ in
                    // Empty chart for days before the first day of the month
                    PieChartView(data: [], date: firstDayOfMonth, isForOne: false)
                        .frame(width: 50, height: 50)
                }
                
                ForEach(getDaysOfMonth(for: currentDate), id: \.self) { day in
                    PieChartView(data: fetchChartData(date: day), date: day, isForOne: false)
                        .frame(width: 50, height: 50)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .border(Color.black)
        .padding(.horizontal)
    }
    
    // 현재 달의 모든 날짜를 가져오는 함수
    func getDaysOfMonth(for date: Date) -> [Date] {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: date)!
        let days = range.map { day -> Date in
            calendar.date(bySetting: .day, value: day, of: date)!
        }
        return days
    }
    
    func getWeekdayOffset(for date: Date) -> Int {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        return (weekday + 6) % 7
    }
}

struct WiDReadMonthView_Previews: PreviewProvider {
    static var previews: some View {
        WiDReadMonthView()
    }
}
