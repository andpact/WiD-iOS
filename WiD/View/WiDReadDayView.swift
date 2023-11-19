//
//  WiDReadView.swift
//  WiD
//
//  Created by jjkim on 2023/07/08.
//

import SwiftUI

struct WiDReadDayView: View {
    // 데이터베이스
    private let wiDService = WiDService()
    @State private var wiDList: [WiD] = []
    
    // 날짜
    private let calendar = Calendar.current
    @State private var currentDate: Date = Date()
    
    var body: some View {
        // 전체 화면
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
            
            // 파이 차트 및 WiD 리스트
            VStack(spacing: 32) {
                // 파이 차트
                VStack(alignment: .leading, spacing: 8) {
                    Text("⭕️ 파이차트")
                        .font(.custom("BlackHanSans-Regular", size: 20))
                    
                    GeometryReader { geo in
                        HStack(spacing: 0) {
                            DayPieChartView(wiDList: wiDList)
                                .frame(width: geo.size.width * 2 / 3)
                            
                            VStack(spacing: 10) {
                                Text("기록된 시간")
                                    .bold()
                                
                                Text("\(getDailyTotalDurationPercentage(wiDList: wiDList))%")
                                    .font(.custom("BlackHanSans-Regular", size: 40))
                                    .foregroundColor(wiDList.isEmpty ? .gray : .black)
                                
                                Text("\(formatDuration(getDailyTotalDuration(wiDList: wiDList), mode: 2)) / 24시간")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                            .padding(.trailing)
                            .frame(width: geo.size.width * 1 / 3)
                        }
                        .background(.white)
                        .cornerRadius(5)
                        .shadow(radius: 1)
                    }
                    .aspectRatio(1.5, contentMode: .fit) // 파이 차트의 폭만큼 높이를 차지해야해서 1.5를 적용함.
                }

                // WiD 리스트
                VStack(alignment: .leading, spacing: 8) {
                    Text("📜 WiD 리스트")
                        .font(.custom("BlackHanSans-Regular", size: 20))
                    
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
                            .background(.white)
                            .cornerRadius(5)
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
                                                
                                                Circle()
                                                    .fill(Color(wiD.title))
                                                    .frame(width: 10)
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                            HStack {
                                                Image(systemName: "hourglass")
                                                    .frame(width: 20)
                                                
                                                Text("소요")
                                                    .bold()
                                                
                                                Text(formatDuration(wiD.duration, mode: 2))
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
                                    .background(.white)
                                    .cornerRadius(5)
                                }
                            }
                        }
                    }
                    .shadow(radius: 1) // shadow는 가장 바깥 뷰에 적용해야 테두리에 제대로 표시됨.
                }
            }
        }
        .padding(.horizontal)
//        .background(Color("ghost_white"))
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
