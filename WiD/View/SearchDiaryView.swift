//
//  WiDSearchView.swift
//  WiD
//
//  Created by jjkim on 2023/07/14.
//

import SwiftUI

struct SearchDiaryView: View {
    // 뷰 모델
    @EnvironmentObject var searchDiaryViewModel: SearchDiaryViewModel
    
    // 화면
//    @Environment(\.presentationMode) var presentationMode
    
    // WiD
//    private let wiDService = WiDService()
//    @State private var wiDList: [WiD] = []
    
    // 다이어리
//    private let diaryService = DiaryService()
//    @State private var diaryList: [Diary] = []
//    @State private var searchText: String = ""
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
                
                TextField("\(searchDiaryViewModel.searchFilter.koreanValue)으로 검색..", text: $searchDiaryViewModel.searchText)
                    .bodyMedium()
                    .padding(8)
                    .background(Color("White-Black"))
                    .cornerRadius(80)
                    .shadow(color: Color("Black-White"), radius: 1)
                
                Button(action: {
                    withAnimation {
//                        diaryList = diaryService.readDiaryByTitleOrContent(searchText: searchText)
                        
                        searchDiaryViewModel.addDiaries()
                        
                        searchComplete = true
                    }
                }) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 24))
                        .frame(maxWidth: 24, maxHeight: 24)
                }
            }
            .frame(maxHeight: 44)
            .padding(.horizontal)
            
            /**
             검색 결과
             */
//            if diaryList.isEmpty {
            if searchDiaryViewModel.dateList.isEmpty {
                VStack(spacing: 0) {
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
//                        ForEach(Array(diaryList), id: \.id) { diary in
                            ForEach(searchDiaryViewModel.dateList.indices, id: \.self) { index in
                                let date = searchDiaryViewModel.dateList[index]
                                
                                VStack(spacing: 0) {
                                    HStack(spacing: 0) {
                                        getDateStringView(date: date)
                                            .titleMedium()
                                        
                                        Spacer()
                                    }
                                    .padding(.horizontal)
                                
                                NavigationLink(destination: DiaryDetailView(date: date)) {
                                    HStack(spacing: 8) {
//                                        let wiDList = wiDService.readWiDListByDate(date: diary.date)
                                        let wiDList = searchDiaryViewModel.wiDList[date]
                                        
//                                        if wiDList?.isEmpty == true {
//                                            getEmptyViewWithMultipleLines(message: "표시할\n타임라인이\n없습니다.")
//                                        } else {
                                            PeriodPieChartView(date: date, wiDList: wiDList ?? [])
                                                .frame(maxWidth: 60)
//                                        }
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(searchDiaryViewModel.diaryList[date]?.title ?? "")
                                                .bodyMedium()
                                                .lineLimit(1)
                                            
                                            Text(searchDiaryViewModel.diaryList[date]?.content ?? "")
                                                .bodyMedium()
                                                .lineLimit(1)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Image(systemName: "chevron.forward")
                                            .font(.system(size: 16))
                                            .padding(.horizontal, 8)
                                    }
                                    .padding(8)
//                                    .background(Color("White-Gray"))
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
        .background(Color("White-Black"))
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