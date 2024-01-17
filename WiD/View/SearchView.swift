//
//  WiDSearchView.swift
//  WiD
//
//  Created by jjkim on 2023/07/14.
//

import SwiftUI

struct SearchView: View {
    // 화면
    @Environment(\.presentationMode) var presentationMode
    
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
            HStack(spacing: 16) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.backward")
                        .imageScale(.large)
                }
                
                TextField("제목 또는 내용으로 검색..", text: $searchText)
                    .padding(8)
                    .background(Color("LightGray-Gray"))
                    .cornerRadius(8)
                
                Button(action: {
                    withAnimation {
                        diaryList = diaryService.selectDiaryByTitleOrContent(searchText: searchText)
                    }
                }) {
                    Image(systemName: "magnifyingglass")
                        .imageScale(.large)
                }
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, maxHeight: 44)
            
            /**
             검색 결과
             */
            ScrollView {
                VStack(spacing: 8) { // 스크롤 뷰 안에 자동으로 수직 수택(spacing: 8)이 생성되는 듯.
                    if diaryList.isEmpty {
                        getEmptyView(message: "검색으로 다이어리를 찾아보세요.")
                    } else {
                        ForEach(Array(diaryList), id: \.id) { diary in
                            NavigationLink(destination: DiaryView(date: diary.date)) {
                                HStack(spacing: 16) {
                                    let wiDList = wiDService.selectWiDListByDate(date: diary.date)
                                    
                                    CalendarPieChartView(date: diary.date, wiDList: wiDList)
                                        .frame(maxWidth: 70)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        getDayString(date: diary.date)
                                            .titleMedium()
                                        
                                        Text(diary.title)
                                            .bodyMedium()
                                            .lineLimit(1)
                                        
                                        Text(diary.content)
                                            .bodyMedium()
                                            .lineLimit(1)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.forward")
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
        }
        .tint(Color("Black-White"))
        .background(Color("White-Black"))
        .navigationBarHidden(true)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchView()
            
            SearchView()
                .environment(\.colorScheme, .dark)
        }
    }
}
