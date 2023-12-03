//
//  WiDReadView.swift
//  WiD
//
//  Created by jjkim on 2023/07/08.
//

import SwiftUI

struct DateBasedView: View {
    // WiD
    private let wiDService = WiDService()
    @State private var wiDList: [WiD] = []
    
    // 다이어리
    private let diaryService = DiaryService()
    @State private var diary: Diary = Diary(id: -1, date: Date(), title: "", content: "")
    
    // 합계
    @State private var totalDurationDictionary: [String: TimeInterval] = [:]
    
    // 날짜
    private let calendar = Calendar.current
    @State private var currentDate: Date = Date()
    
    var body: some View {
        // 전체 화면
        VStack {
            // 컨텐츠
            ScrollView {
                VStack(spacing: 32) {
                    // 파이 차트
                    VStack(alignment: .leading, spacing: 8) {
                        Text("시간 그래프")
                            .font(.custom("BlackHanSans-Regular", size: 20))
                        
                        if wiDList.isEmpty {
                            HStack {
                                Image(systemName: "ellipsis.bubble")
                                    .foregroundColor(.gray)
                                
                                Text("표시할 그래프가 없습니다.")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .padding(.vertical, 32)
                            .frame(maxWidth: .infinity)
                            .background(.white)
                            .cornerRadius(8)
                            .shadow(radius: 1)
                        } else {
                            GeometryReader { geo in
                                HStack(spacing: 0) {
                                    DayPieChartView(wiDList: wiDList)
                                        .frame(width: geo.size.width * 2 / 3)
                                    
                                    VStack(spacing: 10) {
                                        Text("기록률")
                                            .bold()
                                        
                                        Text("\(getTotalDurationPercentageFromWiDList(wiDList: wiDList))%")
                                            .font(.custom("BlackHanSans-Regular", size: 40))
                                            .foregroundColor(wiDList.isEmpty ? .gray : .black)
                                        
                                        Text("\(formatDuration(getTotalDurationFromWiDList(wiDList: wiDList), mode: 2)) / 24시간")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.trailing)
                                    .frame(width: geo.size.width * 1 / 3)
                                }
                                .background(.white)
                                .cornerRadius(8)
                                .shadow(radius: 1)
                            }
                            .aspectRatio(1.5, contentMode: .fit) // 파이 차트의 폭만큼 높이를 차지해야해서 1.5를 적용함.
                        }
                    }
                    .padding(.horizontal)
                    
                    // 다이어리
                    VStack(alignment: .leading, spacing: 8) {
                        Text("다이어리")
                            .font(.custom("BlackHanSans-Regular", size: 20))
                        
                        if diary.id < 0 { // 다이어리가 데이터베이스에 없을 때
                            HStack {
                                Image(systemName: "ellipsis.bubble")
                                    .foregroundColor(.gray)
                                
                                Text("표시할 다이어리가 없습니다.")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .padding(.vertical, 32)
                            .frame(maxWidth: .infinity)
                            .background(.white)
                            .cornerRadius(8)
                            .shadow(radius: 1)
                        } else {
                            VStack(alignment: .leading) {
                                Text(diary.title)
                                    .bold()
                                    .lineLimit(1)
                            
                                Text(diary.content)
                            }
                        }
                        
                        Button(action: {
                            
                        }) {
                            NavigationLink(destination: DiaryView(date: currentDate)) {
                                Text("다이어리 수정")
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.blue)
                        .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    
                    // 합계 기록
                    VStack(alignment: .leading, spacing: 8) {
                        Text("합계 기록")
                            .font(.custom("BlackHanSans-Regular", size: 20))
                        
                        if wiDList.isEmpty {
                            HStack {
                                Image(systemName: "ellipsis.bubble")
                                    .foregroundColor(.gray)
                                
                                Text("표시할 기록이 없습니다.")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .padding(.vertical, 32)
                            .frame(maxWidth: .infinity)
                            .background(.white)
                            .cornerRadius(8)
                            .shadow(radius: 1)
                        } else {
                            VStack(spacing: 8) {
                                ForEach(Array(totalDurationDictionary), id: \.key) { title, duration in
                                    HStack {
                                        HStack {
                                            Image(systemName: "character.textbox.ko")
                                                .frame(width: 20)
                                            
                                            Text("제목")
                                                .bold()
                                            
                                            Text(titleDictionary[title] ?? "")
                                            
                                            Circle()
                                                .fill(Color(title))
                                                .frame(width: 10)
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
                            .padding()
                            .background(.white)
                            .cornerRadius(8)
                            .shadow(radius: 1)
                        }
                    }
                    .padding(.horizontal)

                    // WiD 리스트
                    VStack(alignment: .leading, spacing: 8) {
                        Text("WiD 리스트")
                            .font(.custom("BlackHanSans-Regular", size: 20))

                        if wiDList.isEmpty {
                            HStack {
                                Image(systemName: "ellipsis.bubble")
                                    .foregroundColor(.gray)
                                
                                Text("표시할 WiD가 없습니다.")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .padding(.vertical, 32)
                            .frame(maxWidth: .infinity)
                            .background(.white)
                            .cornerRadius(8)
                            .shadow(radius: 1)
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
                                    .cornerRadius(8)
                                    .shadow(radius: 1)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            Divider()
            
            // 하단 바
            HStack {
                getDayString(date: currentDate)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
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
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .onAppear {
            self.wiDList = wiDService.selectWiDsByDate(date: currentDate)
            self.totalDurationDictionary = getTotalDurationDictionaryByTitle(wiDList: wiDList)
            self.diary = diaryService.selectDiaryByDate(date: currentDate) ?? Diary(id: -1, date: Date(), title: "", content: "")
        }
        .onChange(of: currentDate) { newDate in
            withAnimation {
                wiDList = wiDService.selectWiDsByDate(date: newDate)
                totalDurationDictionary = getTotalDurationDictionaryByTitle(wiDList: wiDList)
                diary = diaryService.selectDiaryByDate(date: newDate) ?? Diary(id: -1, date: Date(), title: "", content: "")
            }
        }
    }
}

struct DateBasedView_Previews: PreviewProvider {
    static var previews: some View {
        DateBasedView()
    }
}
