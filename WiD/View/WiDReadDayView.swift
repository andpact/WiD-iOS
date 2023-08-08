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
                Text("WiD")
                    .font(.custom("Acme-Regular", size: 20))
                    .padding(.horizontal, 8)
                    .foregroundColor(.white)
                    .background(.black)
                    .cornerRadius(5)
                    .padding(.horizontal, 8)

                HStack {
                    Text(formatDate(currentDate, format: "yyyy년 M월 d일"))
                    
                    HStack(spacing: 0) {
                        Text("(")
                        
                        Text(formatWeekday(currentDate))
                            .foregroundColor(Calendar.current.component(.weekday, from: currentDate) == 1 ? .red : (Calendar.current.component(.weekday, from: currentDate) == 7 ? .blue : .black))

                        Text(")")
                    }
                }
                .padding(.horizontal, -16)
                .frame(maxWidth: .infinity)
                
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
            .padding(.bottom, 8)
            
            // 파이 차트 및 제목 별 총합 표시
            HStack(alignment: .top) {
                PieChartView(data: fetchChartData(date: currentDate), date: currentDate, isForOne: true, isEmpty: false)
                
                VStack {
                    HStack {
                        Rectangle()
                            .fill(Color("light_gray"))
                            .frame(width: 7, height: 20)
                        
                        Text("제목")
                            .frame(minWidth: 30, maxWidth: .infinity)
                        
                        Text("총합")
                            .frame(minWidth: 91, maxWidth: .infinity)
                    }
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
                        .frame(height: 145)
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
                                        .frame(minWidth: 30, maxWidth: .infinity)
                                    
//                                    Text(formatDuration(duration, isClickedWiD: false) + " (\(percentage))")
                                    
                                    Text(formatDuration(duration, isClickedWiD: false))
                                        .frame(minWidth: 91, maxWidth: .infinity)
                                }
                                .background(Color("light_gray"))
                                .cornerRadius(5)
                                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                            }
                        }
                        .frame(height: 145)
                    }
                }
            }
            .padding(.bottom, 8)
            
            // 각 WiD 표시
            VStack {
                HStack {
                    Rectangle()
                        .fill(Color("light_gray"))
                        .frame(width: 7, height: 20)
                        .border(.black)

                    Text("순서")
                        .frame(minWidth: 30, maxWidth: .infinity)
                        .border(.black)

                    Text("제목")
                        .frame(minWidth: 30, maxWidth: .infinity)
                        .border(.black)

                    Text("시작")
                        .frame(minWidth: 50, maxWidth: .infinity)
                        .border(.black)

                    Text("종료")
                        .frame(minWidth: 50, maxWidth: .infinity)
                        .border(.black)

                    Text("경과")
                        .frame(minWidth: 91, maxWidth: .infinity)
                        .border(.black)

                    Text("설명")
                        .frame(minWidth: 30, maxWidth: .infinity)
                        .border(.black)
                }
                .frame(maxWidth: .infinity)
                .background(Color("light_gray"))
                .cornerRadius(5)
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                
//                HStack {
//                    Rectangle()
//                        .fill(.red)
//                        .frame(width: 7, height: 20)
//
//                    Text("99")
////                        .frame(width: 30)
//                        .frame(minWidth: 30, maxWidth: .infinity)
//                        .border(.black)
//
//                    Text("공부")
////                        .frame(width: 30)
//                        .frame(minWidth: 30, maxWidth: .infinity)
//                        .border(.black)
//
//                    Text("99:99")
////                        .frame(width: 50)
//                        .frame(minWidth: 50, maxWidth: .infinity)
//                        .border(.black)
//
//                    Text("99:99")
////                        .frame(width: 50)
//                        .frame(minWidth: 50, maxWidth: .infinity)
//                        .border(.black)
//
//                    Text("99시간 99분")
////                        .frame(maxWidth: .infinity)
//                        .frame(minWidth: 91, maxWidth: .infinity)
//                        .border(.black)
//                        .lineLimit(1)
//
//                    Text("999999")
////                        .frame(width: 30)
//                        .frame(minWidth: 30, maxWidth: .infinity)
//                        .border(.black)
//                        .lineLimit(1)
//                        .truncationMode(.tail)
//                }
//                .frame(maxWidth: .infinity)
//                .background(Color("light_gray"))
//                .cornerRadius(5)
//                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)

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
                                        .frame(minWidth: 30, maxWidth: .infinity)

                                    Text(titleDictionary[wiD.title] ?? "")
                                        .frame(minWidth: 30, maxWidth: .infinity)

                                    Text(formatTime(wiD.start, format: "HH:mm"))
                                        .frame(minWidth: 50, maxWidth: .infinity)

                                    Text(formatTime(wiD.finish, format: "HH:mm"))
                                        .frame(minWidth: 50, maxWidth: .infinity)

//                                    Text(formatDuration(wiD.duration, isClickedWiD: false) + " (\(percentage))")
                                    Text(formatDuration(wiD.duration, isClickedWiD: false))
                                        .frame(minWidth: 91, maxWidth: .infinity)
                                        .lineLimit(1)

                                    Text("\(wiD.detail.count)")
                                        .frame(minWidth: 30, maxWidth: .infinity)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
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
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal)
        .onAppear() {
            withAnimation {
                wiDs = wiDService.selectWiDsByDate(date: currentDate)
            }
        }
    }
}

struct WiDReadView_Previews: PreviewProvider {
    static var previews: some View {
        WiDReadDayView()
    }
}
