//
//  WiDReadView.swift
//  WiD
//
//  Created by jjkim on 2023/07/08.
//

import SwiftUI

struct WiDReadDayView: View {
    private let wiDService = WiDService()
    private let calendar = Calendar.current
    
    @State private var wiDList: [WiD] = []
    @State private var currentDate: Date = Date()
    
    var body: some View {
        VStack {
            // 날짜 표시
            HStack {
                Text("WiD")
                    .font(.custom("Acme-Regular", size: 20))
                
                HStack {
                    Text(formatDate(currentDate, format: "M월 d일"))
                    
                    HStack(spacing: 0) {
                        Text("(")

                        Text(formatWeekday(currentDate))
                            .foregroundColor(calendar.component(.weekday, from: currentDate) == 1 ? .red : (calendar.component(.weekday, from: currentDate) == 7 ? .blue : .black))

                        Text(")")
                    }
                }
                .frame(maxWidth: .infinity)
                
                Button(action: {
                    withAnimation {
                        currentDate = Date()
                    }
                }) {
                    Image(systemName: "arrow.clockwise")
                }
                .padding(.horizontal, 8)
                .disabled(calendar.isDateInToday(currentDate))
                
                Button(action: {
                    withAnimation {
                        currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
                    }
                }) {
                    Image(systemName: "chevron.left")
                }
                .padding(.horizontal, 8)
                
                Button(action: {
                    withAnimation {
                        currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
                    }
                }) {
                    Image(systemName: "chevron.right")
                }
                .padding(.horizontal)
                .disabled(calendar.isDateInToday(currentDate))
            }
            
            // 파이 차트
            VStack(spacing: 0) {
                Text("파이차트")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    DayPieChartView(wiDList: wiDList)
                    
                    VStack {
                        Text("기록된 시간")
                            .bold()
                        
                        Text("0%")
                        
                        Text("0초 / 24시간")
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 5)
                    .stroke(.black, lineWidth: 1)
                )
            }

            // WiD 리스트
            VStack(spacing: 0) {
                Text("WiD 리스트")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ScrollView {
                    if wiDList.isEmpty {
                        HStack {
                            Image(systemName: "ellipsis.bubble")
                                .foregroundColor(.gray)
                            
                            Text("표시할 WiD가 없습니다.")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 5)
                            .stroke(.black, lineWidth: 1)
                        )
                    } else {
                        ForEach(Array(wiDList.enumerated()), id: \.element.id) { (index, wiD) in
                            NavigationLink(destination: WiDView(clickedWiDId: wiD.id)) {
                                VStack(spacing: 8) {
                                    HStack {
                                        HStack {
                                            Image(systemName: "character.textbox.ko")
                                                .frame(width: 20)
                                            
                                            Text("제목")
                                                .bold()
                                            
                                            Text(titleDictionary[wiD.title] ?? "")
                                            
                                            RoundedRectangle(cornerRadius: 5)
                                                .fill(Color(wiD.title))
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
                                            
                                            Text(formatDuration(wiD.duration, mode: 1))
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    
                                    HStack {
                                        HStack {
                                            Image(systemName: "play")
                                                .frame(width: 20)
                                            
                                            Text("시작")
                                                .bold()
                                            
                                            Text(formatTime(wiD.start, format: "a h:mm"))
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        HStack {
                                            Image(systemName: "play.fill")
                                                .frame(width: 20)
                                            
                                            Text("종료")
                                                .bold()
                                            
                                            Text(formatTime(wiD.finish, format: "a h:mm"))
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    
                                    HStack {
                                        Image(systemName: "text.bubble")
                                            .frame(width: 20)
                                        
                                        Text("설명")
                                            .bold()
                                        
                                        Text(wiD.detail.isEmpty ? "입력.." : wiD.detail)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .lineLimit(1)
                                            .truncationMode(.tail)
                                            .foregroundColor(wiD.detail.isEmpty ? Color.gray : Color.black)
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
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .onAppear {
            wiDList = wiDService.selectWiDsByDate(date: currentDate)
        }
        .onChange(of: currentDate) { newValue in
            withAnimation {
                wiDList = wiDService.selectWiDsByDate(date: newValue)
            }
        }
    }
}

struct WiDReadView_Previews: PreviewProvider {
    static var previews: some View {
        WiDReadDayView()
    }
}
