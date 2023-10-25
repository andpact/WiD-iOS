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
    @State private var currentDate: Date = Date()
    
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
        GeometryReader { geo in
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
                        Text(formatDate(currentDate, format: "M월 d일"))
                        
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
                
                PieChartView(pieChartData: fetchPieChartData(date: currentDate), date: currentDate, isForOne: true, isEmpty: false)
                    .padding(.bottom, 8)
                
                // 각 WiD 표시
                VStack {
                    HStack(spacing: 0) {
                        Rectangle()
                            .fill(Color("light_gray"))
                            .frame(width: geo.size.width * 0.02, height: 25)

                        Text("순서")
                            .frame(width: geo.size.width * 0.11)

                        Text("제목")
                            .frame(width: geo.size.width * 0.11)

                        Text("시작")
                            .frame(width: geo.size.width * 0.26)

                        Text("종료")
                            .frame(width: geo.size.width * 0.26)

                        Text("경과")
                            .frame(width: geo.size.width * 0.24)
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color("light_gray"))
                    .cornerRadius(5)
                    
//                    HStack(spacing: 0) {
//                        Rectangle()
//                            .fill(Color.red)
//                            .frame(width: geo.size.width * 0.02, height: 60)
//                        VStack(spacing: 5) {
//                            HStack(spacing: 0) {
//                                Text("99")
//                                    .frame(width: geo.size.width * 0.11)
//
//                                Text("공부")
//                                    .frame(width: geo.size.width * 0.11)
//
//                                Text("오전 99:99")
//                                    .frame(width: geo.size.width * 0.26)
//
//                                Text("오후 99:99")
//                                    .frame(width: geo.size.width * 0.26)
//
//                                Text("99.9시간")
//                                    .frame(width: geo.size.width * 0.24)
//                            }
//
//                            Divider()
//                                .padding(.horizontal, 8)
//
//                            HStack(spacing: 0) {
//                                Text("설명")
//                                    .frame(width: geo.size.width * 0.11)
//
//                                Text("detailddddd")
//                                    .frame(width: geo.size.width * 0.87, alignment: .leading)
//                                    .lineLimit(1)
//                                    .truncationMode(.tail)
//                            }
//                        }
//                    }
//                    .frame(maxWidth: .infinity)
//                    .background(Color("light_gray"))
//                    .cornerRadius(5)

                    if wiDs.isEmpty {
                        Spacer()
                        Text("표시할 WiD가 없습니다.")
                            .foregroundColor(.gray)
                    } else {
                        ScrollView {
                            ForEach(Array(wiDs.enumerated()), id: \.element.id) { (index, wiD) in
                                NavigationLink(destination: WiDView(clickedWiDId: wiD.id)) {
                                    HStack(spacing: 0) {
                                        Rectangle()
                                            .fill(Color(wiD.title))
                                            .frame(width: geo.size.width * 0.02, height: 60)
                                        VStack(spacing: 5) {
                                            HStack(spacing: 0) {
                                                Text("\(index + 1)")
                                                    .frame(width: geo.size.width * 0.11)

                                                Text(titleDictionary[wiD.title] ?? "")
                                                    .frame(width: geo.size.width * 0.11)

                                                Text(formatTime(wiD.start, format: "a h:mm"))
                                                    .frame(width: geo.size.width * 0.26)

                                                Text(formatTime(wiD.finish, format: "a h:mm"))
                                                    .frame(width: geo.size.width * 0.26)

                                                Text(formatDuration(wiD.duration, mode: 1))
                                                    .frame(width: geo.size.width * 0.24)
                                            }
                                            
                                            Divider()
                                                .padding(.horizontal, 8)
                                            
                                            HStack(spacing: 0) {
                                                Text("설명")
                                                    .frame(width: geo.size.width * 0.11)
                                                
                                                Text(wiD.detail.isEmpty ? "입력.." : wiD.detail)
                                                    .frame(width: geo.size.width * 0.87, alignment: .leading)
                                                    .lineLimit(1)
                                                    .truncationMode(.tail)
                                                    .foregroundColor(wiD.detail.isEmpty ? Color.gray : Color.black)
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
            .onAppear() {
                withAnimation {
                    wiDs = wiDService.selectWiDsByDate(date: currentDate)
                }
            }
            .onChange(of: currentDate) { newValue in
                withAnimation {
                    wiDs = wiDService.selectWiDsByDate(date: newValue)
                }
            }
        }
        .padding(.horizontal)
    }
}

struct WiDReadView_Previews: PreviewProvider {
    static var previews: some View {
        WiDReadDayView()
    }
}
