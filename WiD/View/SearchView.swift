//
//  WiDSearchView.swift
//  WiD
//
//  Created by jjkim on 2023/07/14.
//

import SwiftUI

struct SearchView: View {
    // WiD
    private let wiDService = WiDService()
//    @State private var wiDList: [WiD] = []
    
    // 다이어리
    private let diaryService = DiaryService()
    @State private var diaryList: [Diary] = []
    @State private var searchText: String = ""
    
    // 날짜
    private let calendar = Calendar.current
    
    var body: some View {
        VStack(spacing: 0) {
            /**
             검색 창
             */
            HStack {
                Image(systemName: "magnifyingglass")
                
                TextField("제목 또는 내용으로 검색..", text: $searchText)
            }
            .padding()
            .background(.white)
            .shadow(radius: 1)
            
            /**
             검색 결과
             */
            ScrollViewReader { sp in
                ScrollView {
                    VStack(spacing: 0) { // 스크롤 뷰 안에 자동으로 수직 수택(spacing: 8)이 생성되는 듯.
                        Spacer()
                            .frame(height: 16)
                        
                        if diaryList.isEmpty {
                            getEmptyView(message: "검색으로 다이어리를 찾아보세요.")
                                .padding(.horizontal)
                        } else {
                            ForEach(Array(diaryList.enumerated()), id: \.element.id) { (index, diary) in
                                GeometryReader { geo in
                                    HStack {
                                        getDayStringWith3Lines(date: diary.date)
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                            .font(.system(size: 22, weight: .bold))
                                        
                                        ZStack {
                                            let wiDList = wiDService.selectWiDsByDate(date: diary.date)
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
                                
                                NavigationLink(destination: DiaryView(date: diary.date)) {
                                    VStack(spacing: 0) {
                                        Text(diary.title)
                                            .bodyMedium()
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding()
                                        
                                        Divider()
                                        
                                        Text(diary.content)
                                            .labelMedium()
                                            .frame(maxWidth: .infinity, minHeight: 200,  alignment: .topLeading)
                                            .padding()
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                                
                                if index != diaryList.count - 1 {
                                    Rectangle()
                                        .frame(height: 8)
                                        .padding(.vertical)
                                        .foregroundColor(Color("ghost_white"))
                                }
                            }
                            
                            Spacer()
                                .frame(height: 16)
                        }
                    }
                }
                .onAppear {
                    // 삭제 후 돌아오면 삭제된 WiD가 남아서 표시되니까 다시 WiD 리스트를 가져옴.
//                    self.wiDList = wiDService.selectWiDsByDetail(detail: searchText)
                    
                    self.diaryList = diaryService.selectDiaryByTitleOrContent(searchText: searchText)
                }
                .onChange(of: searchText) { newValue in
                    withAnimation {
//                        wiDList = wiDService.selectWiDsByDetail(detail: newValue)
                        
                        diaryList = diaryService.selectDiaryByTitleOrContent(searchText: searchText)
                    }
                }
            }
        }
        .background(.white)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
