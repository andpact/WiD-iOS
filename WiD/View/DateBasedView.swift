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
    @State private var expandDiary: Bool = false
    @State private var diaryTitleOverflow: Bool = false
    @State private var diaryContentOverflow: Bool = false
    
    // 합계
    @State private var totalDurationDictionary: [String: TimeInterval] = [:]
    
    // 날짜
    private let today = Date()
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
                Spacer()
                    .frame(height: 16)
                
                VStack(alignment: .leading, spacing: 8) {
                    GeometryReader { geo in
                        HStack {
                            getDayStringWith3Lines(date: currentDate)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .font(.system(size: 22, weight: .bold))
                            
                            ZStack {
                                if wiDList.isEmpty {
                                    getEmptyViewWithMultipleLines(message: "표시할\n타임라인이\n없습니다.")
                                } else {
                                    DayPieChartView(wiDList: wiDList)
                                }
                            }
                            .background(.white)
                            .cornerRadius(8)
                            .shadow(radius: 1)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                    .aspectRatio(2 / 1, contentMode: .fit)
                    
                    VStack(spacing: 16) {
                        Text((diary.id < 0 ? "제목을 입력해 주세요." : diary.title))
                            .bodyMedium()
                            .frame(maxWidth: .infinity, minHeight: 20, maxHeight: expandDiary ? nil : 20, alignment: .topLeading)
                            .onTapGesture {
                                if expandDiary == false {
                                    expandDiary = true
                                }
                            }
                        
                        Divider()
                        
                        Text(diary.id < 0 ? "내용을 입력해 주세요." : diary.content)
                            .labelMedium()
                            .frame(maxWidth: .infinity, minHeight: 200, maxHeight: expandDiary ? nil : 200, alignment: .topLeading)
                            .onTapGesture {
                                if expandDiary == false {
                                    expandDiary = true
                                }
                            }
                    }
                    .padding()
                    .background(.white)
                    .cornerRadius(8)
                    .shadow(radius: 1)
                    
                    Button(action: {
                        
                    }) {
                        NavigationLink(destination: DiaryView(date: currentDate)) {
                            Text("다이어리 수정")
                                .bodyMedium()
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                    }
                    .background(.blue)
                    .cornerRadius(8)
                    
                }
                .padding(.horizontal)
                
                Rectangle()
                    .frame(height: 8)
                    .padding(.vertical)
                    .foregroundColor(.white)
                
                // 합계 기록
                VStack(alignment: .leading, spacing: 8) {
                    Text("합계 기록")
                        .titleMedium()
                    
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
                    .foregroundColor(.white)
                
                // WiD 리스트
                VStack(alignment: .leading, spacing: 8) {
                    Text("WiD 리스트")
                        .titleLarge()

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
                                            .labelMedium()
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.forward")
                                            .foregroundColor(.blue)
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                    .background(Color("light_gray"))
                                    
                                    Divider()
                                    
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(formatTime(wiD.start, format: "a HH:mm:ss"))
                                                .bodyMedium()
                                            
                                            Text(formatTime(wiD.finish, format: "a HH:mm:ss"))
                                                .bodyMedium()
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
                
                Spacer()
                    .frame(height: 16)
            }
            .background(Color("ghost_white"))
            
            /**
             하단 바
             */
            HStack {
                DatePicker("", selection: $currentDate, in: ...today, displayedComponents: .date)
                    .labelsHidden()
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        currentDate = Date()
                    }
                }) {
                    Image(systemName: "arrow.clockwise")
                        .frame(maxWidth: 15, maxHeight: 15)
                }
                .disabled(calendar.isDateInToday(currentDate))
                .padding(.horizontal)
                
                Button(action: {
                    withAnimation {
                        currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
                    }
                }) {
                    Image(systemName: "chevron.backward")
                        .frame(maxWidth: 15, maxHeight: 15)
                }
                .padding(.horizontal)
                
                Button(action: {
                    withAnimation {
                        currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
                    }
                }) {
                    Image(systemName: "chevron.forward")
                        .frame(maxWidth: 15, maxHeight: 15)
                }
                .disabled(calendar.isDateInToday(currentDate))
                .padding(.horizontal)
            }
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
