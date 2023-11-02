//
//  TitleDurationDictionaryView.swift
//  WiD
//
//  Created by jjkim on 2023/11/02.
//

import SwiftUI

struct TitleDictionaryView: View {
    private let wiDService = WiDService()
    
    private let selectedDate: Date
    private let selectedTitle: Title2
    
    private let dailyTotalDictionary: [String: TimeInterval]
    private let weeklyTotalDictionary: [String: TimeInterval]
    private let monthlyTotalDictionary: [String: TimeInterval]
    
    init(selectedDate: Date, selectedTitle: Title2) {
        self.selectedDate = selectedDate
        self.selectedTitle = selectedTitle
        
        self.dailyTotalDictionary = wiDService.getDailyTotalDictionary(forDate: selectedDate)
        self.weeklyTotalDictionary = wiDService.getWeeklyTotalDictionary(forDate: selectedDate)
        self.monthlyTotalDictionary = wiDService.getMonthlyTotalDictionary(forDate: selectedDate)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Text("합계")
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 8)

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
                        
                        Text("\(formatDuration(dailyTotalDictionary[selectedTitle.rawValue] ?? 0, mode: 2))")
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
                        
                        Text("\(formatDuration(weeklyTotalDictionary[selectedTitle.rawValue] ?? 0, mode: 2))")
                            
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
                        
                        Text("\(formatDuration(monthlyTotalDictionary[selectedTitle.rawValue] ?? 0, mode: 2))")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 5)
                .stroke(.black, lineWidth: 1)
            )
            .background(.white)
            .cornerRadius(5)

            Text("평균")
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 8)

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
                        
                        Text("10시간")
                            
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
                        
                        Text("10시간")
                            
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 5)
                .stroke(.black, lineWidth: 1)
            )
            .background(.white)
            .cornerRadius(5)

            Text("최고")
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 8)

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
                        
                        Text("10시간")
                            
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
                        
                        Text("10시간")
                            
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 5)
                .stroke(.black, lineWidth: 1)
            )
            .background(.white)
            .cornerRadius(5)
            
            Text("연속")
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 8)

            VStack(spacing: 8) {
                HStack {
                    HStack {
                        Image(systemName: "arrow.left.and.right")
                            .frame(width: 20)
                        
                        Text("최장 기간")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    HStack {
                        Image(systemName: "hourglass")
                            .frame(width: 20)
                        
                        Text("10일")
                            
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                HStack {
                    HStack {
                        Image(systemName: "arrow.right.to.line")
                            .frame(width: 20)
                        
                        Text("현재 진행")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    HStack {
                        Image(systemName: "hourglass")
                            .frame(width: 20)
                        
                        Text("10일")
                            
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 5)
                .stroke(.black, lineWidth: 1)
            )
            .background(.white)
            .cornerRadius(5)
        }
    }
}

struct TitleDictionaryView_Previews: PreviewProvider {
    static var previews: some View {
        TitleDictionaryView(selectedDate: Date(), selectedTitle: .ALL)
    }
}
