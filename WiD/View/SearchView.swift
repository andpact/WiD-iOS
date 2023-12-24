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
                TextField("제목 또는 내용으로 검색..", text: $searchText)
                
                Button(action: {
                    withAnimation {
                        diaryList = diaryService.selectDiaryByTitleOrContent(searchText: searchText)
                    }
                }) {
                    Image(systemName: "magnifyingglass")
                }
            }
            .padding()
            .background(.white) // 배경색이 있어야 그림자가 적용됨
            .shadow(radius: 1)
            
            /**
             검색 결과
             */
            ScrollViewReader { sp in
                ScrollView {
                    VStack(spacing: 16) { // 스크롤 뷰 안에 자동으로 수직 수택(spacing: 8)이 생성되는 듯.
                        if diaryList.isEmpty {
                            getEmptyView(message: "검색으로 다이어리를 찾아보세요.")
                                .padding(.horizontal)
                        } else {
                            ForEach(Array(diaryList.enumerated()), id: \.element.id) { (index, diary) in
                                VStack(spacing: 0) {
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
                                                .padding(.horizontal)
                                            
                                            Text(diary.content)
                                                .labelMedium()
                                                .frame(maxWidth: .infinity, minHeight: 200,  alignment: .topLeading)
                                                .padding()
                                        }
                                        .frame(maxWidth: .infinity)
                                    }
                                }
                                .padding(.vertical)
                                .background(.white)
                            }
                        }
                    }
                }
            }
        }
        .background(Color("ghost_white"))
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
