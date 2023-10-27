//
//  WiDReadCalendarView.swift
//  WiD
//
//  Created by jjkim on 2023/10/24.
//

import SwiftUI

struct WiDReadCalendarView: View {
    private let wiDService = WiDService()
//    private var wiDList: [WiD] { return wiDService.selectWiDsBetweenDates(startDate: startDate ?? Date(), finishDate: finishDate) }
    private var wiDList: [WiD] = []
    
    private var startDate = Calendar.current.date(byAdding: .day, value: -364, to: Date()) ?? Date()
    private var finishDate = Date()
    
    @State private var title: Title = .STUDY
    
    init() {
        self.wiDList = wiDService.selectWiDsBetweenDates(startDate: startDate, finishDate: finishDate)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(formatDate(startDate, format: "yyyy년 M월 d일"))
                
                Text("~")
                
                Text(formatDate(finishDate, format: "yyyy년 M월 d일"))
            }
            
            Divider()
                .background(Color.black)
            
            HStack {
                Text("최근 1년")
                
                Text("2023")
                
                Spacer()
                
                Picker("", selection: $title) {
                    ForEach(Array(Title.allCases), id: \.self) { title in
                        Text(titleDictionary[title.rawValue]!)
                    }
                }
            }
            .padding(.horizontal)
//            .border(.black)
            
            Divider()
                .background(Color.black)
            
            VStack(spacing: 0) {
                Text("달력")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(spacing: 0) {
                    HStack {
                        Text("날짜")
                            .frame(maxWidth: .infinity)
                        
                        ForEach(0...6, id: \.self) { index in
                            let textColor = index == 0 ? Color.red : (index == 6 ? Color.blue : Color.black)
                            
                            Text(formatWeekdayLetter(index))
                                .frame(maxWidth: .infinity)
                                .foregroundColor(textColor)
                        }
                    }
                    
                    Divider()
                        .background(Color.black)
                    
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(), count: 8)) {
                            let daysDifference = Calendar.current.dateComponents([.day], from: startDate, to: finishDate).day! + 1
                            
                            ForEach(0..<daysDifference, id: \.self) { daysOffset in
                                let calendar = Calendar.current
                                let tmpStartDate = calendar.date(byAdding: .day, value: daysOffset, to: startDate) ?? Date()
                                
                                if daysOffset % 8 == 0 {
                                    Text(formatDate(tmpStartDate, format: "M월"))
                                        .font(.system(size: 14))
                                } else {
                                    let filteredWiDList = wiDList.filter { wiD in
                                        return calendar.isDate(wiD.date, inSameDayAs: tmpStartDate)
                                    }
                                    
                                    TmpPieChartView(date: tmpStartDate, wiDList: filteredWiDList)
                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray, lineWidth: 1)
                    .background(.white)
                )
                
                ZStack {
                    HStack {
                        Text("달력을 클릭하여 조회")
                            .font(.system(size: 14))
                        
                        Spacer()
                        
                        Text("0시간 ~ 10시간")
                            .font(.system(size: 14))
                    }

                    Image(systemName: "equal")
                }
                
                Text("날짜 및 기간별 기록")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(spacing: 0) {
                    HStack {
                        Text("제목")
                            .frame(maxWidth: .infinity)
                        
                        Text("10일")
                            .frame(maxWidth: .infinity)
                        
                        Text("10일 ~ 16일")
                            .frame(maxWidth: .infinity)
                        
                        Text("11월")
                            .frame(maxWidth: .infinity)
                    }
                    
                    Divider()
                        .background(Color.black)
                    
                    HStack {
                        Text("공부")
                            .frame(maxWidth: .infinity)
                        
                        Text("99시간")
                            .frame(maxWidth: .infinity)
                        
                        Text("999.9시간")
                            .frame(maxWidth: .infinity)
                        
                        Text("999.9시간")
                            .frame(maxWidth: .infinity)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .background(RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray, lineWidth: 1)
                    .background(.white)
                )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .border(.black)
            .padding(.horizontal)
        }
    }
}

struct WiDReadCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        WiDReadCalendarView()
    }
}
