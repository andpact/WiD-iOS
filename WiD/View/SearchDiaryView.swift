//
//  WiDSearchView.swift
//  WiD
//
//  Created by jjkim on 2023/07/14.
//

import SwiftUI

struct SearchDiaryView: View {
    // 화면
    @Environment(\.presentationMode) var presentationMode
    
    // WiD
    private let wiDService = WiDService()
//    @State private var wiDList: [WiD] = []
    
    // 다이어리
    private let diaryService = DiaryService()
    @State private var diaryList: [Diary] = []
    @State private var searchText: String = ""
    @State private var searchComplete: Bool = false
    
    // 날짜
//    private let calendar = Calendar.current
    
    var body: some View {
        VStack(spacing: 0) {
            /**
             검색 창
             */
            HStack(spacing: 16) {
//                Button(action: {
//                    presentationMode.wrappedValue.dismiss()
//                }) {
//                    Image(systemName: "arrow.backward")
//                        .font(.system(size: 24)) // large - 22, medium(기본) - 17, small - 14(정확하지 않음)
//                }
                
                TextField("제목 또는 내용으로 검색..", text: $searchText)
                    .bodyMedium()
                    .padding(8)
                    .background(Color("White-Black"))
                    .cornerRadius(80)
                    .shadow(color: Color("Black-White"), radius: 1)
                
                Button(action: {
                    withAnimation {
                        diaryList = diaryService.readDiaryByTitleOrContent(searchText: searchText)
                        
                        searchComplete = true
                    }
                }) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 24))
                        .frame(maxWidth: 24, maxHeight: 24)
                }
            }
            .frame(maxHeight: 44)
            .padding()
            
            /**
             검색 결과
             */
            if diaryList.isEmpty {
                VStack {
                    if searchComplete {
//                        getEmptyView(message: "검색 결과가 없습니다.")
                        
                        Text("검색 결과가 없습니다.")
                    } else {
                        Text("과거의 다이어리를 통해\n당신의 성장과 여정을\n다시 살펴보세요.")
                            .bodyLarge()
                            .multilineTextAlignment(.center)
                            .lineSpacing(10)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
//                HStack(spacing: 8) {
//                    PeriodPieChartView(date: Date(), wiDList: getRandomWiDList(days: 1))
//                        .frame(maxWidth: 60)
//
//                    VStack(alignment: .leading, spacing: 4) {
//                        Text("제목")
//                            .bodyMedium()
//                            .lineLimit(1)
//
//                        Text("내용")
//                            .bodyMedium()
//                            .lineLimit(1)
//                    }
//                    .frame(maxWidth: .infinity, alignment: .leading)
//
//                    Image(systemName: "chevron.forward")
//                        .font(.system(size: 16))
//                        .padding(.horizontal, 8)
//                }
//                .padding(8)
//                .background(Color("White-Gray"))
//                .cornerRadius(8)
//                .background(
//                    RoundedRectangle(cornerRadius: 8)
//                        .stroke(Color("Black-White"), lineWidth: 0.5)
//                )
//                .padding(.horizontal)
            } else {
                ScrollView {
                    VStack(spacing: 8) { // 스크롤 뷰 안에 자동으로 수직 수택(spacing: 8)이 생성되는 듯.
                        ForEach(Array(diaryList), id: \.id) { diary in
                            VStack(spacing: 0) {
                                getDateStringView(date: diary.date)
                                    .titleMedium()
                                
                                NavigationLink(destination: DiaryDetailView(date: diary.date)) {
                                    HStack(spacing: 8) {
                                        let wiDList = wiDService.readWiDListByDate(date: diary.date)
                                        
                                        PeriodPieChartView(date: diary.date, wiDList: wiDList)
                                            .frame(maxWidth: 60)
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(diary.title)
                                                .bodyMedium()
                                                .lineLimit(1)
                                            
                                            Text(diary.content)
                                                .bodyMedium()
                                                .lineLimit(1)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Image(systemName: "chevron.forward")
                                            .font(.system(size: 16))
                                            .padding(.horizontal, 8)
                                    }
                                    .padding(8)
                                    .background(Color("White-Gray"))
                                    .cornerRadius(8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color("Black-White"), lineWidth: 0.5)
                                    )
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                }
            }
        }
        .tint(Color("Black-White"))
        .navigationBarHidden(true)
        .background(Color("White-Gray"))
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchDiaryView()
            
            SearchDiaryView()
                .environment(\.colorScheme, .dark)
        }
    }
}
