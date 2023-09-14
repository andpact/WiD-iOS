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
    
//    private var totalDurationDictionary: [String: TimeInterval] {
//        var result: [String: TimeInterval] = [:]
//
//        for wiD in wiDs {
//            if let currentDuration = result[wiD.title] {
//                result[wiD.title] = currentDuration + wiD.duration
//            } else {
//                result[wiD.title] = wiD.duration
//            }
//        }
//        return result
//    }
    
//    private var sortedTotalDurationDictionary: [(key: String, value: TimeInterval)] {
//        totalDurationDictionary.sorted { $0.value > $1.value }
//    }
    
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
                .disabled(Calendar.current.isDateInToday(currentDate))
                
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
            
            PieChartView(data: fetchChartData(date: currentDate), date: currentDate, isForOne: true, isEmpty: false)
                .padding(.bottom, 8)
            
            // 각 WiD 표시
            VStack {
                HStack {
                    Rectangle()
                        .fill(Color("light_gray"))
                        .frame(width: 7, height: 20)

                    Text("순서")
                        .frame(minWidth: 30, maxWidth: .infinity)
                        .border(.black)

                    Text("제목")
                        .frame(minWidth: 30, maxWidth: .infinity)
                        .border(.black)

                    Text("시작")
                        .frame(minWidth: 70, maxWidth: .infinity)
                        .border(.black)

                    Text("종료")
                        .frame(minWidth: 70, maxWidth: .infinity)
                        .border(.black)

                    Text("경과")
                        .frame(minWidth: 110, maxWidth: .infinity)
                        .border(.black)
                }
                .frame(maxWidth: .infinity)
                .background(Color("light_gray"))
                .cornerRadius(5)
                
                HStack {
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: 7, height: 45)
                    VStack(spacing: 5) {
                        HStack {
                            Text("99")
                                .frame(minWidth: 30, maxWidth: .infinity)
                                .border(.blue)

                            Text("공부")
                                .frame(minWidth: 30, maxWidth: .infinity)
                                .border(.blue)

                            Text("99:99")
                                .frame(minWidth: 70, maxWidth: .infinity)
                                .border(.blue)

                            Text("99:99")
                                .frame(minWidth: 70, maxWidth: .infinity)
                                .border(.blue)

                            Text("99시간 99분")
                                .frame(minWidth: 110, maxWidth: .infinity)
                                .border(.blue)
                        }
                        
                        HStack {
                            Text("설명")
                                .frame(minWidth: 30, maxWidth: .infinity)
                                .border(.blue)
                            
                            Text("detailddddd")
                                .frame(minWidth: 303, maxWidth: .infinity, alignment: .leading)
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .border(.blue)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .background(Color("light_gray"))
                .cornerRadius(5)

                if wiDs.isEmpty {
                    Spacer()
                    Text("표시할 WiD가 없습니다.")
                        .foregroundColor(.gray)
                    
                } else {
                    ScrollView {
                        ForEach(Array(wiDs.enumerated()), id: \.element.id) { (index, wiD) in
                            NavigationLink(destination: WiDView(clickedWiDId: wiD.id)) {
                                HStack {
                                    Rectangle()
                                        .fill(Color(wiD.title))
                                        .frame(width: 7, height: 45)
                                    VStack(spacing: 5) {
                                        HStack {
                                            Text("\(index + 1)")
                                                .frame(minWidth: 20, maxWidth: .infinity)

                                            Text(titleDictionary[wiD.title] ?? "")
                                                .frame(minWidth: 30, maxWidth: .infinity)

                                            Text(formatTime(wiD.start, format: "HH:mm"))
                                                .frame(minWidth: 70, maxWidth: .infinity)

                                            Text(formatTime(wiD.finish, format: "HH:mm"))
                                                .frame(minWidth: 70, maxWidth: .infinity)

                                            Text(formatDuration(wiD.duration, isClickedWiD: false))
                                                .frame(minWidth: 110, maxWidth: .infinity)
                                        }
                                        
                                        HStack {
                                            Text("설명")
                                                .frame(minWidth: 20, maxWidth: .infinity)
                                            
                                            Text(" : ")
                                            
                                            Text(wiD.detail)
                                                .frame(minWidth: 302, maxWidth: .infinity, alignment: .leading)
                                                .lineLimit(1)
                                                .truncationMode(.tail)
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .background(Color("light_gray"))
                                .cornerRadius(5)
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
