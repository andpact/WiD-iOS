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
        /**
         전체 화면
         */
        VStack(spacing: 0) {
            /**
             컨텐츠
             */
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        GeometryReader { geo in
                            getDayStringWith3Lines(date: currentDate)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .font(.system(size: 22, weight: .bold))
                        }
                        .aspectRatio(contentMode: .fit)
                        
                        GeometryReader { geo in
                            ZStack(alignment: .center) {
                                if wiDList.isEmpty {
                                    getEmptyViewWithMultipleLines(message: "표시할\n타임라인이\n없습니다.")
                                } else {
                                    HStack(spacing: 0) {
                                        DayPieChartView(wiDList: wiDList)
        //                                        .frame(width: geo.size.width * 2 / 3)
                                        
        //                                VStack(spacing: 10) {
        //                                    Text("기록률")
        //                                        .bold()
        //
        //                                    Text("\(getTotalDurationPercentageFromWiDList(wiDList: wiDList))%")
        //                                        .font(.custom("PyeongChangPeace-Bold", size: 30))
        //
        //                                    Text("\(formatDuration(getTotalDurationFromWiDList(wiDList: wiDList), mode: 1)) / 24시간")
        //                                        .font(.system(size: 14))
        //                                        .foregroundColor(.gray)
        //                                }
        //                                .padding(.trailing)
                                    }
//                                    .background(.white)
//                                    .cornerRadius(8)
//                                    .shadow(radius: 1)
                                }
                            }
                            .background(.white)
                            .cornerRadius(8)
                            .shadow(radius: 1)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                }
                .padding(.horizontal)
                
                // 다이어리
                VStack(alignment: .leading, spacing: 8) {
//                    if diary.id < 0 { // 다이어리가 데이터베이스에 없을 때
//                        getEmptyView(message: "표시할 다이어리가 없습니다.")
//                    } else {
//                        VStack(alignment: .leading, spacing: 8) {
//                            Text(diary.title)
//                                .bold()
//                                .lineLimit(1)
//                                .frame(maxWidth: .infinity, alignment: .leading)
//
//                            Text(diary.content)
//                                .frame(maxWidth: .infinity, alignment: .leading)
//                        }
//                        .padding()
//                        .background(.white)
//                        .cornerRadius(8)
//                        .shadow(radius: 1)
//                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text(diary.id < 0 ? "제목을 입력해 주세요." : diary.title)
                            .font(.system(size: 18, weight: .medium))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Divider()
                    
                        Text(diary.id < 0 ? "내용을 입력해 주세요." : diary.content)
                            .font(.system(size: 18, weight: .light))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                    .background(.white)
                    .cornerRadius(8)
                    .shadow(radius: 1)
                }
                .padding(.horizontal)
                
                Button(action: {
                    
                }) {
                    NavigationLink(destination: DiaryView(date: currentDate)) {
                        Text("다이어리 수정")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                }
                .background(.blue)
                .cornerRadius(8)
                .padding(.horizontal)
                
                Rectangle()
                    .frame(height: 8)
                    .padding(.vertical)
                    .foregroundColor(.red)
                
                // 합계 기록
                VStack(alignment: .leading, spacing: 8) {
                    Text("합계 기록")
                        .font(.system(size: 18, weight: .bold))
                    
                    if wiDList.isEmpty {
                        getEmptyView(message: "표시할 기록이 없습니다.")
                    } else {
                        VStack(spacing: 8) {
                            ForEach(Array(totalDurationDictionary), id: \.key) { title, duration in
                                HStack {
                                    Text(titleDictionary[title] ?? "")
                                        .font(.custom("PyeongChangPeace-Bold", size: 20))
                                    
                                    Spacer()
                                
                                    Text(formatDuration(duration, mode: 3))
                                        .font(.custom("PyeongChangPeace-Bold", size: 20))
                                }
                                .padding()
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color(title), Color.white]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(8)
                                .shadow(radius: 1)
                            }
                        }
                    }
                }
                .padding(.horizontal)

                Rectangle()
                    .frame(height: 8)
                    .padding(.vertical)
                    .foregroundColor(.red)
                
                // WiD 리스트
                VStack(alignment: .leading, spacing: 8) {
                    Text("WiD 리스트")
                        .font(.system(size: 18, weight: .bold))

                    if wiDList.isEmpty {
                        getEmptyView(message: "표시할 WiD가 없습니다.")
                    } else {
                        ForEach(Array(wiDList.enumerated()), id: \.element.id) { (index, wiD) in
                            NavigationLink(destination: WiDView(clickedWiDId: wiD.id)) {
                                VStack(spacing: 0) {
                                    HStack {
                                        Circle()
                                            .fill(Color(wiD.title))
                                            .frame(width: 10)
                                        
                                        Text(titleDictionary[wiD.title] ?? "")
                                        
                                        Spacer()
                                        
                                        Image(systemName: "arrow.forward")
                                            .foregroundColor(.blue)
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                    .background(Color("light_gray"))
                                    
                                    Divider()
                                    
                                    HStack {
                                        VStack(alignment: .leading, spacing: 8) {
                                            HStack(spacing: 0) {
                                                Text(formatTime(wiD.start, format: "a h:mm:ss"))
                                                    .bold()
                                                
                                                Text("부터")
                                            }

                                            HStack(spacing: 0) {
                                                Text(formatTime(wiD.finish, format: "a h:mm:ss"))
                                                    .bold()
                                                
                                                Text("까지")
                                            }
                                        }
                                        
                                        Spacer()
                                        
                                        Text(formatDuration(wiD.duration, mode: 3))
                                            .font(.custom("PyeongChangPeace-Bold", size: 20))
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                    
//                                        Divider()
//                                        
//                                        Text(wiD.detail.isEmpty ? "설명 입력.." : wiD.detail)
//                                            .padding(.horizontal)
//                                            .padding(.vertical, 8)
//                                            .frame(maxWidth: .infinity, alignment: .leading)
//                                            .foregroundColor(wiD.detail.isEmpty ? .gray : .black)
                                }
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
            
            // 하단 바
            HStack {
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
                    Image(systemName: "arrowtriangle.backward.fill")
                }
                .padding(.horizontal, 8)
                
                Button(action: {
                    withAnimation {
                        currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
                    }
                }) {
                    Image(systemName: "arrowtriangle.forward.fill")
                }
                .padding(.horizontal, 8)
                .disabled(calendar.isDateInToday(currentDate))
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding()
            .background(.white)
            .compositingGroup()
            .shadow(radius: 1)
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
