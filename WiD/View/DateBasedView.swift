//
//  WiDReadView.swift
//  WiD
//
//  Created by jjkim on 2023/07/08.
//

import SwiftUI

struct DateBasedView: View {
    // 화면
    @Environment(\.presentationMode) var presentationMode
    
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
    @State private var expandDatePicker: Bool = false
    
    var body: some View {
        VStack(spacing: 0) { // spacing: 0일 때, 상단 바에 그림자를 적용시키면 컨텐츠가 상단 바의 그림자를 덮어서 가림. (상단 바가 렌더링 된 후, 컨텐츠가 렌더링되기 때문)
            /**
             상단 바
             */
            ZStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.backward")
                        .imageScale(.large)
                    
//                    Text("뒤로 가기")
//                        .bodyMedium()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.blue)

                Text("날짜 별 조회")
                    .titleLarge()
            }
            .padding()
            
            Divider()
            
            /**
             컨텐츠
             */
            ScrollView {
                VStack(spacing: 16) {
                    // 다이어리 및 타임라인
                    VStack(spacing: 0) {
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
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                        }
                        .aspectRatio(2 / 1, contentMode: .fit)
                        
                        Divider()
                            .padding(.horizontal)
                        
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
                        .padding()
                    }
                    .background(.white)
                    
                    // 합계 기록
                    VStack(spacing: 0) {
                        Text("합계 기록")
                            .titleMedium()
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if wiDList.isEmpty {
                            getEmptyView(message: "표시할 기록이 없습니다.")
                        } else {
    //                        ForEach(totalDurationDictionary.sorted(by: { $0.key < $1.key }), id: \.key) { title, duration in // 정렬 안되는 듯?
//                            ForEach(Array(totalDurationDictionary), id: \.key) { title, duration in
                            ForEach(Array(totalDurationDictionary.enumerated()), id: \.element.key) { item in
                                let (index, (title, duration)) = item // 이 변수를 위 item에 직접 사용하면 동작을 안함.
                                
                                HStack {
                                    Text(titleDictionary[title] ?? "")
                                        .font(.custom("PyeongChangPeace-Bold", size: 20))
                                    
                                    Spacer()
                                    
                                    Text(formatDuration(duration, mode: 3))
                                        .font(.custom("PyeongChangPeace-Bold", size: 20))
                                }
                                .padding()
                                
                                if index != totalDurationDictionary.count - 1 {
                                     Divider()
                                         .padding(.horizontal)
                                }
                            }
                        }
                    }
                    .padding(.vertical)
                    .background(.white)
                    
                    // WiD 리스트
                    VStack(spacing: 0) {
                        Text("WiD 리스트")
                            .titleLarge()
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        if wiDList.isEmpty {
                            getEmptyView(message: "표시할 WiD가 없습니다.")
                        } else {
                            ForEach(Array(wiDList.enumerated()), id: \.element.id) { (index, wiD) in
                                NavigationLink(destination: WiDView(clickedWiDId: wiD.id)) {
                                    VStack(spacing: 8) {
                                        HStack {
                                            Rectangle()
                                                .fill(Color(wiD.title))
                                                .frame(width: 5)
                                            
                                            Text(titleDictionary[wiD.title] ?? "")
                                                .bodyMedium()
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.forward")
                                        }
                                        
                                        HStack {
                                            VStack(alignment: .leading) {
                                                HStack {
                                                    Text(formatTime(wiD.start, format: "a"))
                                                        .bodyMedium()
                                                    
                                                    Text(formatTime(wiD.start, format: "hh:mm:ss"))
                                                        .font(.custom("ChivoMono-Regular", size: 17))
                                                }
                                                
                                                HStack {
                                                    Text(formatTime(wiD.finish, format: "a"))
                                                        .bodyMedium()
                                                    
                                                    Text(formatTime(wiD.finish, format: "hh:mm:ss"))
                                                        .font(.custom("ChivoMono-Regular", size: 17))
                                                }
                                            }
                                            
                                            Spacer()
                                            
                                            Text(formatDuration(wiD.duration, mode: 3))
                                                .font(.custom("PyeongChangPeace-Bold", size: 20))
                                        }
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                }
                                
                                if index < wiDList.count - 1 {
                                    Divider()
                                        .padding(.horizontal)
                                }
                            }
                        }
                    }
                    .padding(.vertical)
                    .background(.white)
                }
            }
            .background(Color("ghost_white"))
            
            Divider()
            
            /**
             하단 바
             */
            VStack(spacing: 8) {
                if expandDatePicker {
                    HStack {
                        Text("날짜를 선택해 주세요.")
                            .bodyMedium()
                            .foregroundColor(.blue)
                        
                        Spacer()
                        
                        DatePicker("", selection: $currentDate, in: ...today, displayedComponents: .date)
                            .labelsHidden()
                    }
                    .padding(8)
                }
                
                HStack(spacing: 32) {
                    Button(action: {
                        withAnimation {
                            expandDatePicker.toggle()
                        }
                    }) {
                        Image(systemName: "calendar")
                            .imageScale(.large)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            currentDate = Date()
                        }
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .imageScale(.large)
                    }
                    .disabled(calendar.isDateInToday(currentDate))
                    
                    Button(action: {
                        withAnimation {
                            currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
                        }
                    }) {
                        Image(systemName: "chevron.backward")
                            .imageScale(.large)
                    }
                    
                    Button(action: {
                        withAnimation {
                            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
                        }
                    }) {
                        Image(systemName: "chevron.forward")
                            .imageScale(.large)
                    }
                    .disabled(calendar.isDateInToday(currentDate))
                }
            }
            .padding()
            .background(.white)
        }
        .tint(.black)
        .navigationBarHidden(true)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
