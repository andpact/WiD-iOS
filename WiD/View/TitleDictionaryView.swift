//
//  TitleDurationDictionaryView.swift
//  WiD
//
//  Created by jjkim on 2023/11/02.
//

import SwiftUI

struct TitleDictionaryView: View {
    // 날짜
    private let calendar = Calendar.current
    private let today: Date = Date()
    private let selectedDate: Date
    private let startDate: Date
    private let finishDate: Date
    
    // 제목
    private let selectedTitle: TitleWithALL
    
    // 데이터베이스
    private let wiDList: [WiD]
    private let dailyAllTitleDurationDictionary: [String: TimeInterval]
    private let weeklyAllTitleDurationDictionary: [String: TimeInterval]
    private let monthlyAllTitleDurationDictionary: [String: TimeInterval]
    private let weeklyAverageTitleDuration: TimeInterval
    private let monthlyAverageTitleDuration: TimeInterval
    private let weeklyMaxTitleDuration: TimeInterval
    private let monthlyMaxTitleDuration: TimeInterval
    private let currentStreak: Date?
    private let longestStreak: (Date, Date)?
    
    init(selectedDate: Date, startDate: Date, finishDate: Date, selectedTitle: TitleWithALL, wiDList: [WiD]) {
        self.selectedDate = selectedDate
        self.startDate = startDate
        self.finishDate = finishDate
        
        self.selectedTitle = selectedTitle
        
        self.wiDList = wiDList
        
        self.dailyAllTitleDurationDictionary = getDailyAllTitleDurationDictionary(wiDList: wiDList, forDate: selectedDate)
        self.weeklyAllTitleDurationDictionary = getWeeklyAllTitleDurationDictionary(wiDList: wiDList, forDate: selectedDate)
        self.monthlyAllTitleDurationDictionary = getMonthlyAllTitleDurationDictionary(wiDList: wiDList, forDate: selectedDate)
        self.weeklyAverageTitleDuration = getWeeklyAverageTitleDuration(wiDList: wiDList, title: selectedTitle.rawValue, forDate: selectedDate)
        self.monthlyAverageTitleDuration = getWeeklyAverageTitleDuration(wiDList: wiDList, title: selectedTitle.rawValue, forDate: selectedDate)
        self.weeklyMaxTitleDuration = getWeeklyMaxTitleDuration(wiDList: wiDList, title: selectedTitle.rawValue, forDate: selectedDate)
        self.monthlyMaxTitleDuration = getMonthlyMaxTitleDuration(wiDList: wiDList, title: selectedTitle.rawValue, forDate: selectedDate)
        self.currentStreak = getCurrentStreak(wiDList: wiDList, title: selectedTitle.rawValue, startDate: startDate, finishDate: finishDate)
        self.longestStreak = getLongestStreak(wiDList: wiDList, title: selectedTitle.rawValue, startDate: startDate, finishDate: finishDate)
    }
    
    var body: some View {
        // 전체 화면
        VStack(spacing: 32) {
            // 합계 기록
            VStack(alignment: .leading, spacing: 8) {
                Text("1️⃣ 합계 기록")
                    .font(.custom("BlackHanSans-Regular", size: 20))

                VStack(spacing: 8) {
                    HStack {
                        HStack {
                            Image(systemName: "1.square")
                                .frame(width: 20)
                            
                            Text("일(Day)")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        HStack {
                            Image(systemName: "hourglass")
                                .frame(width: 20)
                            
                            Text("\(formatDuration(dailyAllTitleDurationDictionary[selectedTitle.rawValue] ?? 0, mode: 2))")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    HStack {
                        HStack {
                            Image(systemName: "7.square")
                                .frame(width: 20)
                            
                            Text("주(Week)")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        HStack {
                            Image(systemName: "hourglass")
                                .frame(width: 20)
                            
                            Text("\(formatDuration(weeklyAllTitleDurationDictionary[selectedTitle.rawValue] ?? 0, mode: 2))")
                                
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    HStack {
                        HStack {
                            Image(systemName: "30.square")
                                .frame(width: 20)
                            
                            Text("월(Month)")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        HStack {
                            Image(systemName: "hourglass")
                                .frame(width: 20)
                            
                            Text("\(formatDuration(monthlyAllTitleDurationDictionary[selectedTitle.rawValue] ?? 0, mode: 2))")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.white)
                .cornerRadius(5)
                .shadow(radius: 1)
            }
            
            // 평균 기록
            VStack(alignment: .leading, spacing: 8) {
                Text("2️⃣ 평균 기록")
                    .font(.custom("BlackHanSans-Regular", size: 20))

                VStack(spacing: 8) {
                    HStack {
                        HStack {
                            Image(systemName: "7.square")
                                .frame(width: 20)
                            
                            Text("주(Week)")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        HStack {
                            Image(systemName: "hourglass")
                                .frame(width: 20)
                            
                            Text("\(formatDuration(weeklyAverageTitleDuration, mode: 2))")
                                
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    HStack {
                        HStack {
                            Image(systemName: "30.square")
                                .frame(width: 20)
                            
                            Text("월(Month)")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        HStack {
                            Image(systemName: "hourglass")
                                .frame(width: 20)
                            
                            Text("\(formatDuration(monthlyAverageTitleDuration, mode: 2))")
                                
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.white)
                .cornerRadius(5)
                .shadow(radius: 1)
            }
            
            // 최고 기록
            VStack(alignment: .leading, spacing: 8) {
                Text("3️⃣ 최고 기록")
                    .font(.custom("BlackHanSans-Regular", size: 20))

                VStack(spacing: 8) {
                    HStack {
                        HStack {
                            Image(systemName: "7.square")
                                .frame(width: 20)
                            
                            Text("주(Week)")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        HStack {
                            Image(systemName: "hourglass")
                                .frame(width: 20)
                            
                            Text("\(formatDuration(weeklyMaxTitleDuration, mode: 2))")
                                
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    HStack {
                        HStack {
                            Image(systemName: "30.square")
                                .frame(width: 20)
                            
                            Text("월(Month)")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        HStack {
                            Image(systemName: "hourglass")
                                .frame(width: 20)
                            
                            Text("\(formatDuration(monthlyMaxTitleDuration, mode: 2))")
                                
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.white)
                .cornerRadius(5)
                .shadow(radius: 1)
            }
            
            // 연속 기록
            VStack(alignment: .leading, spacing: 8) {
                Text("4️⃣ 연속 기록")
                    .font(.custom("BlackHanSans-Regular", size: 20))

                VStack(spacing: 8) {
                    // 현재 진행
                    VStack(spacing: 0) {
                        HStack {
                            HStack {
                                Image(systemName: "arrow.left.and.right")
                                    .frame(width: 20)
                                
                                Text("현재 진행")
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)

                            HStack {
                                Image(systemName: "hourglass")
                                    .frame(width: 20)
                                
                                if currentStreak != nil {
                                    Text("\((calendar.dateComponents([.day], from: currentStreak ?? Date(), to: today).day ?? 0) + 1)일")
                                } else {
                                    Text("기간 없음")
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        if currentStreak != nil {
                            HStack(spacing: 0) {
                                if calendar.isDateInToday(currentStreak ?? Date()) {
                                    Text("오늘")
                                        .font(.system(size: 14))
                                } else {
                                    Text(formatDate(currentStreak ?? Date(), format: "yyyy년 M월 d일"))
                                        .font(.system(size: 14))
                                    
                                    HStack(spacing: 0) {
                                        Text("(")
                                            .font(.system(size: 14))

                                        Text(formatWeekday(currentStreak ?? Date()))
                                            .font(.system(size: 14))
                                            .foregroundColor(calendar.component(.weekday, from: currentStreak ?? Date()) == 1 ? .red : (calendar.component(.weekday, from: currentStreak ?? Date()) == 7 ? .blue : .black))

                                        Text(")")
                                            .font(.system(size: 14))
                                    }
                                    
                                    Text(" ~ 오늘")
                                        .font(.system(size: 14))
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }

                    // 최장 기간
                    VStack(spacing: 0) {
                        HStack {
                            HStack {
                                Image(systemName: "arrow.right.to.line")
                                    .frame(width: 20)
                                
                                Text("최장 기간")
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)

                            HStack {
                                Image(systemName: "hourglass")
                                    .frame(width: 20)
                                
                                if longestStreak != nil {
                                    Text("\((calendar.dateComponents([.day], from: longestStreak?.0 ?? Date(), to: longestStreak?.1 ?? Date()).day ?? 0) + 1)일")
                                } else {
                                    Text("기간 없음")
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        if longestStreak != nil {
                            HStack(spacing: 0) {
                                if calendar.isDate(longestStreak?.0 ?? Date(), inSameDayAs: longestStreak?.1 ?? Date()) {
                                    if calendar.isDateInToday(longestStreak?.0 ?? Date()) {
                                        Text("오늘")
                                            .font(.system(size: 14))
                                    } else {
                                        Text(formatDate(longestStreak?.0 ?? Date(), format: "yyyy년 M월 d일"))
                                            .font(.system(size: 14))
                                        
                                        HStack(spacing: 0) {
                                            Text("(")
                                                .font(.system(size: 14))

                                            Text(formatWeekday(longestStreak?.0 ?? Date()))
                                                .font(.system(size: 14))
                                                .foregroundColor(calendar.component(.weekday, from: longestStreak?.0 ?? Date()) == 1 ? .red : (calendar.component(.weekday, from: longestStreak?.0 ?? Date()) == 7 ? .blue : .black))

                                            Text(")")
                                                .font(.system(size: 14))
                                        }
                                    }
                                } else {
                                    Text(formatDate(longestStreak?.0 ?? Date(), format: "yyyy년 M월 d일"))
                                        .font(.system(size: 14))
                                    
                                    HStack(spacing: 0) {
                                        Text("(")
                                            .font(.system(size: 14))

                                        Text(formatWeekday(longestStreak?.0 ?? Date()))
                                            .font(.system(size: 14))
                                            .foregroundColor(calendar.component(.weekday, from: longestStreak?.0 ?? Date()) == 1 ? .red : (calendar.component(.weekday, from: longestStreak?.0 ?? Date()) == 7 ? .blue : .black))

                                        Text(")")
                                            .font(.system(size: 14))
                                    }
                                    
                                    Text(" ~ ")
                                    
                                    if !calendar.isDate(longestStreak?.0 ?? Date(), equalTo: longestStreak?.1 ?? Date(), toGranularity: .year) {
                                        Text(formatDate(longestStreak?.1 ?? Date(), format: "yyyy년 M월 d일"))
                                            .font(.system(size: 14))
                                    } else if !calendar.isDate(longestStreak?.0 ?? Date(), equalTo: longestStreak?.1 ?? Date(), toGranularity: .month) {
                                        Text(formatDate(longestStreak?.1 ?? Date(), format: "M월 d일"))
                                            .font(.system(size: 14))
                                    } else {
                                        Text(formatDate(longestStreak?.1 ?? Date(), format: "d일"))
                                            .font(.system(size: 14))
                                    }
                                    
                                    HStack(spacing: 0) {
                                        Text("(")
                                            .font(.system(size: 14))

                                        Text(formatWeekday(longestStreak?.1 ?? Date()))
                                            .font(.system(size: 14))
                                            .foregroundColor(calendar.component(.weekday, from: longestStreak?.1 ?? Date()) == 1 ? .red : (calendar.component(.weekday, from: longestStreak?.1 ?? Date()) == 7 ? .blue : .black))

                                        Text(")")
                                            .font(.system(size: 14))
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.white)
                .cornerRadius(5)
                .shadow(radius: 1)
            }
        }
        .padding(.horizontal)
    }
}

struct TitleDictionaryView_Previews: PreviewProvider {
    static var previews: some View {
        TitleDictionaryView(selectedDate: Date(), startDate: Date(), finishDate: Date(), selectedTitle: .ALL, wiDList: [])
    }
}
