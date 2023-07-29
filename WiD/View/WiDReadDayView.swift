//
//  WiDReadView.swift
//  WiD
//
//  Created by jjkim on 2023/07/08.
//

import SwiftUI

struct WiDReadDayView: View {
    private let wiDService = WiDService()
    
    @State private var wiDs: [WiD] = []
    @State private var currentDate: Date = Date() {
        didSet {
            wiDs = wiDService.selectWiDsByDate(date: currentDate)
        }
    }
    
    private var totalDurationDictionary: [String: TimeInterval] {
        var result: [String: TimeInterval] = [:]

        for wiD in wiDs {
            if let currentDuration = result[wiD.title] {
                result[wiD.title] = currentDuration + wiD.duration
            } else {
                result[wiD.title] = wiD.duration
            }
        }

        return result
    }
    
    private var sortedTotalDurationDictionary: [(key: String, value: TimeInterval)] {
        totalDurationDictionary.sorted { $0.value > $1.value }
    }
    
    var body: some View {
        VStack {
            // 날짜 표시
            HStack {
                HStack {
                    Text(formatDate(currentDate, format: "yyyy.MM.dd"))
                    
                    Text(formatWeekday(currentDate))
                        .foregroundColor(Calendar.current.component(.weekday, from: currentDate) == 1 ? .red : (Calendar.current.component(.weekday, from: currentDate) == 7 ? .blue : .black))
                }
                .frame(maxWidth: .infinity)
                
//                Button(action: {
//                    // 스크린 샷 버튼을 클릭했을 때 동작
//                }) {
//                    Image(systemName: "photo.on.rectangle")
//                }
//                .padding(.horizontal, 8)
                
                Button(action: {
                    withAnimation {
                        currentDate = Date()
                    }
                }) {
                    Image(systemName: "arrow.clockwise")
                }
                .padding(.horizontal, 8)
                
                Button(action: {
                    withAnimation {
                        currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
                    }
                }) {
                    Image(systemName: "chevron.left")
                }
                .padding(.horizontal, 8)
                
                Button(action: {
                    withAnimation {
                        currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
                    }
                }) {
                    Image(systemName: "chevron.right")
                }
                .disabled(Calendar.current.isDateInToday(currentDate))
                .padding(.horizontal, 8)
            }
            
            // 파이 차트 및 제목 별 총합 표시
            HStack(alignment: .top) {
                PieChartView(data: fetchChartData(date: currentDate), date: currentDate, isForOne: true, isEmpty: false)
                
                VStack(alignment: .center) {
                    HStack {
                        Rectangle()
                            .fill(Color("light_gray"))
                            .frame(width: 7, height: 20)
                        
                        Text("제목")
                            .frame(width: 30)
                        
                        Spacer()
                        
                        Text("총합")
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color("light_gray"))
                    .cornerRadius(5)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                    
                    if sortedTotalDurationDictionary.isEmpty {
                        VStack {
                            Text("표시할")

                            Text("데이터가")

                            Text("없습니다.")
                        }
                        .foregroundColor(.gray)
                        .frame(maxHeight: .infinity)

                    } else {
                        ScrollView {
                            ForEach(sortedTotalDurationDictionary, id: \.key) { (title, duration) in
//                                let totalDurationOfDay = 60 * 60 * 24
//                                let percentage = (Double(duration) / Double(totalDurationOfDay)) * 100
                                
                                HStack {
                                    Rectangle()
                                        .fill(Color(title))
                                        .frame(width: 7, height: 20)
                                    
                                    Text(titleDictionary[title] ?? "")
                                        .frame(width: 30)
                                    
                                    Spacer()
                                    
//                                    Text(formatDuration(duration, isClickedWiD: false) + " (\(percentage))")
                                    Text(formatDuration(duration, isClickedWiD: false))
                                    
                                    Spacer()
                                }
                                .background(Color("light_gray"))
                                .cornerRadius(5)
                                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                            }
                        }
                    }
                }
                .frame(maxWidth: 155)
//                .frame(maxWidth: .infinity)
            }
            .frame(maxHeight: 180)
            
            // 각 WiD 표시
            VStack {
                HStack {
                    Rectangle()
                        .fill(Color("light_gray"))
                        .frame(width: 7, height: 20)

                    Text("순서")
                        .frame(width: 30)

                    Text("제목")
                        .frame(width: 30)

                    Text("시작")
                        .frame(width: 50)

                    Text("종료")
                        .frame(width: 50)

                    Text("경과")
                        .frame(maxWidth: .infinity)

                    Text("설명")
                        .frame(width: 35)
                }
                .frame(maxWidth: .infinity)
                .background(Color("light_gray"))
                .cornerRadius(5)
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)

                if wiDs.isEmpty {
                    Spacer()
                    Text("표시할 WiD가 없습니다.")
                        .foregroundColor(.gray)
                    
                } else {
                    ScrollView {
                        ForEach(Array(wiDs.enumerated()), id: \.element.id) { (index, wiD) in
                            NavigationLink(destination: WiDView(clickedWiDId: wiD.id)) {
                                HStack {
//                                    let totalDurationOfDay = 24 * 60 * 60
//
//                                    let percentage = (Double(wiD.duration) / Double(totalDurationOfDay)) * 100
                                    
                                    Rectangle()
                                        .fill(Color(wiD.title))
                                        .frame(width: 7, height: 20)

                                    Text("\(index + 1)")
                                        .frame(width: 30)

                                    Text(titleDictionary[wiD.title] ?? "")
                                        .frame(width: 30)

                                    Text(formatTime(wiD.start, format: "HH:mm"))
                                        .frame(width: 50)

                                    Text(formatTime(wiD.finish, format: "HH:mm"))
                                        .frame(width: 50)

//                                    Text(formatDuration(wiD.duration, isClickedWiD: false) + " (\(percentage))")
                                    Text(formatDuration(wiD.duration, isClickedWiD: false))
                                        .frame(maxWidth: .infinity)

                                    Text("\(wiD.detail.count)")
                                        .frame(width: 35)
                                }
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.black)
                                .background(Color("light_gray"))
                                .cornerRadius(5)
                                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                            }
                        }
                    }
                }
                Spacer()
            }
            .padding(.top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal)
        .onAppear() {
            wiDs = wiDService.selectWiDsByDate(date: currentDate)
        }
    }
}

struct WiDReadView_Previews: PreviewProvider {
    static var previews: some View {
        WiDReadDayView()
    }
}
