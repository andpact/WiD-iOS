//
//  AllTitleDurationDictionaryView.swift
//  WiD
//
//  Created by jjkim on 2023/11/02.
//

import SwiftUI

struct TotalDictionaryView: View {
    private let calendar = Calendar.current
    private let today: Date = Date()
    private let wiDService = WiDService()
    
    private let selectedDate: Date
    private let firstDayOfWeek: Date
    private let lastDayOfWeek: Date
    
    private let dailyTotalDictionary: [String: TimeInterval]
    private let weeklyTotalDictionary: [String: TimeInterval]
    private let monthlyTotalDictionary: [String: TimeInterval]
    
    init(selectedDate: Date) {
        self.selectedDate = selectedDate
        
        let weekday = calendar.component(.weekday, from: selectedDate)
        self.firstDayOfWeek = (weekday == 1) ? calendar.date(byAdding: .day, value: -6, to: selectedDate)! : calendar.date(byAdding: .day, value: 2 - weekday, to: selectedDate)!
        self.lastDayOfWeek = (weekday == 1) ? selectedDate : calendar.date(byAdding: .day, value: 8 - weekday, to: selectedDate)!
        
        self.dailyTotalDictionary = wiDService.getDailyTotalDictionary(forDate: selectedDate)
        self.weeklyTotalDictionary = wiDService.getWeeklyTotalDictionary(forDate: selectedDate)
        self.monthlyTotalDictionary = wiDService.getMonthlyTotalDictionary(forDate: selectedDate)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 4) {
                Text("일(Day) 합계")
                    .bold()

                if calendar.isDate(selectedDate, inSameDayAs: today) {
                    Text("오늘")
                        .font(.system(size: 14))
                } else {
                    Text(formatDate(selectedDate, format: "yyyy년 M월 d일"))
                        .font(.system(size: 14))

                    HStack(spacing: 0) {
                        Text("(")
                            .font(.system(size: 14))

                        Text(formatWeekday(selectedDate))
                            .font(.system(size: 14))
                            .foregroundColor(calendar.component(.weekday, from: selectedDate) == 1 ? .red : (calendar.component(.weekday, from: selectedDate) == 7 ? .blue : .black))

                        Text(")")
                            .font(.system(size: 14))
                    }
                }
            }
            .padding(.leading, 8)
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack {
                if dailyTotalDictionary.isEmpty {
                    HStack {
                        Image(systemName: "ellipsis.bubble")
                            .foregroundColor(.gray)

                        Text("표시할 데이터가 없습니다.")
                            .foregroundColor(.gray)
                    }
                } else {
                    ForEach(Array(dailyTotalDictionary), id: \.key) { title, duration in
                        HStack {
                            HStack {
                                Image(systemName: "character.textbox.ko")
                                    .frame(width: 20)
                                
                                Text("제목")
                                    .bold()
                                
                                Text(titleDictionary[title] ?? "")
                                
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color(title))
                                    .background(RoundedRectangle(cornerRadius: 5)
                                        .stroke(.black, lineWidth: 1)
                                    )
                                    .frame(width: 5, height: 20)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack {
                                Image(systemName: "hourglass")
                                    .frame(width: 20)
                                
                                Text("소요")
                                    .bold()
                                
                                Text(formatDuration(duration, mode: 2))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 5)
                .stroke(.black, lineWidth: 1)
            )
            .background(Color("light_gray"))
            .cornerRadius(5)

            HStack(spacing: 4) {
                let currentWeekday = calendar.component(.weekday, from: today)
                let currentFirstDayOfWeek = currentWeekday == 1 ? calendar.date(byAdding: .day, value: -6, to: today)! : calendar.date(byAdding: .day, value: 2 - currentWeekday, to: today)!
                let currentLastDayOfWeek = currentWeekday == 1 ? today : calendar.date(byAdding: .day, value: 8 - currentWeekday, to: today)!
                
                Text("주(Week) 합계")
                    .bold()
                
                // selectedDate가 firstDayOfWeek와 lastDayOfWeek 사이에 있는지 확인.
                if calendar.isDate(selectedDate, inSameDayAs: currentFirstDayOfWeek) || (currentFirstDayOfWeek.compare(selectedDate) == .orderedAscending && currentLastDayOfWeek.compare(selectedDate) == .orderedDescending) || calendar.isDate(selectedDate, inSameDayAs: currentLastDayOfWeek) {
                    Text("이번 주")
                        .font(.system(size: 14))
                } else {
                    if calendar.isDate(firstDayOfWeek, inSameDayAs: today) {
                        Text("오늘")
                            .font(.system(size: 14))
                    } else {
                        Text(formatDate(firstDayOfWeek, format: "yyyy년 M월 d일"))
                            .font(.system(size: 14))
                        
                        HStack(spacing: 0) {
                            Text("(")
                                .font(.system(size: 14))

                            Text(formatWeekday(firstDayOfWeek))
                                .font(.system(size: 14))
                                .foregroundColor(calendar.component(.weekday, from: firstDayOfWeek) == 1 ? .red : (calendar.component(.weekday, from: firstDayOfWeek) == 7 ? .blue : .black))

                            Text(")")
                                .font(.system(size: 14))
                        }
                    }

                    Text("~")
                        .foregroundColor(.gray)

                    if calendar.isDate(lastDayOfWeek, inSameDayAs: today) {
                        Text("오늘")
                            .font(.system(size: 14))
                    } else if !calendar.isDate(lastDayOfWeek, equalTo: firstDayOfWeek, toGranularity: .year) {
                        Text(formatDate(lastDayOfWeek, format: "yyyy년 M월 d일"))
                            .font(.system(size: 14))
                        
                        HStack(spacing: 0) {
                            Text("(")
                                .font(.system(size: 14))

                            Text(formatWeekday(lastDayOfWeek))
                                .font(.system(size: 14))
                                .foregroundColor(calendar.component(.weekday, from: lastDayOfWeek) == 1 ? .red : (calendar.component(.weekday, from: lastDayOfWeek) == 7 ? .blue : .black))

                            Text(")")
                                .font(.system(size: 14))
                        }
                    } else {
                        if calendar.isDate(firstDayOfWeek, equalTo: lastDayOfWeek, toGranularity: .month) {
                            Text(formatDate(lastDayOfWeek, format: "d일"))
                                .font(.system(size: 14))
                        } else {
                            Text(formatDate(lastDayOfWeek, format: "M월 d일"))
                                .font(.system(size: 14))
                        }
                        
                        HStack(spacing: 0) {
                            Text("(")
                                .font(.system(size: 14))

                            Text(formatWeekday(lastDayOfWeek))
                                .font(.system(size: 14))
                                .foregroundColor(calendar.component(.weekday, from: lastDayOfWeek) == 1 ? .red : (calendar.component(.weekday, from: lastDayOfWeek) == 7 ? .blue : .black))

                            Text(")")
                                .font(.system(size: 14))
                        }
                    }
                }
            }
            .padding(.leading, 8)
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack {
                if weeklyTotalDictionary.isEmpty {
                    HStack {
                        Image(systemName: "ellipsis.bubble")
                            .foregroundColor(.gray)
                        
                        Text("표시할 데이터가 없습니다.")
                            .foregroundColor(.gray)
                    }
                } else {
                    ForEach(Array(weeklyTotalDictionary), id: \.key) { title, duration in
                        HStack {
                            HStack {
                                Image(systemName: "character.textbox.ko")
                                    .frame(width: 20)
                                
                                Text("제목")
                                    .bold()
                                
                                Text(titleDictionary[title] ?? "")
                                
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color(title))
                                    .background(RoundedRectangle(cornerRadius: 5)
                                        .stroke(.black, lineWidth: 1)
                                    )
                                    .frame(width: 5, height: 20)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack {
                                Image(systemName: "hourglass")
                                    .frame(width: 20)
                                
                                Text("소요")
                                    .bold()
                                
                                Text((formatDuration(duration, mode: 2)))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 5)
                .stroke(.black, lineWidth: 1)
            )
            .background(Color("light_gray"))
            .cornerRadius(5)

            HStack(spacing: 4) {
                Text("월(Month) 합계")
                    .bold()

                if calendar.isDate(selectedDate, equalTo: today, toGranularity: .month) {
                    Text("이번 달")
                        .font(.system(size: 14))
                } else {
                    Text(formatDate(selectedDate, format: "yyyy년 M월"))
                        .font(.system(size: 14))
                }
            }
            .padding(.leading, 8)
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack {
                if monthlyTotalDictionary.isEmpty {
                    HStack {
                        Image(systemName: "ellipsis.bubble")
                            .foregroundColor(.gray)
                        
                        Text("표시할 데이터가 없습니다.")
                            .foregroundColor(.gray)
                    }
                } else {
                    ForEach(Array(monthlyTotalDictionary), id: \.key) { title, duration in
                        HStack {
                            HStack {
                                Image(systemName: "character.textbox.ko")
                                    .frame(width: 20)
                                
                                Text("제목")
                                    .bold()
                                
                                Text(titleDictionary[title] ?? "")
                                
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color(title))
                                    .background(RoundedRectangle(cornerRadius: 5)
                                        .stroke(.black, lineWidth: 1)
                                    )
                                    .frame(width: 5, height: 20)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack {
                                Image(systemName: "hourglass")
                                    .frame(width: 20)
                                
                                Text("소요")
                                    .bold()
                                
                                Text((formatDuration(duration, mode: 2)))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 5)
                .stroke(.black, lineWidth: 1)
            )
            .background(Color("light_gray"))
            .cornerRadius(5)
        }
    }
}

struct TotalDictionaryView_Previews: PreviewProvider {
    static var previews: some View {
        TotalDictionaryView(selectedDate: Date())
    }
}
