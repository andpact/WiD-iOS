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

    @State private var searchComplete: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            /**
             검색 창
             */
            HStack(spacing: 16) {
                TextField("\(searchDiaryViewModel.searchFilter.koreanValue)으로 검색..", text: $searchDiaryViewModel.searchText)
                    .bodyMedium()
                    .padding(8)
                    .background(Color("White-Black"))
                    .cornerRadius(80)
                    .shadow(color: Color("Black-White"), radius: 1)
                
                Button(action: {
                    searchDiaryViewModel.searchDiary(searchText: searchDiaryViewModel.searchText)
                    
                    searchComplete = true
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
            if searchDiaryViewModel.dateList.isEmpty {
                VStack(spacing: 0) {
                    if searchComplete {
                        Text("검색 결과가 없습니다.")
                            .bodyLarge()
                    } else {
                        Text("과거의 다이어리를 통해\n당신의 성장과 여정을\n다시 살펴보세요.")
                            .bodyLarge()
                            .multilineTextAlignment(.center)
                            .lineSpacing(10)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    VStack(spacing: 8) { // 스크롤 뷰 안에 자동으로 수직 수택(spacing: 8)이 생성되는 듯.
                        ForEach(searchDiaryViewModel.dateList.indices, id: \.self) { index in
                            let date = searchDiaryViewModel.dateList[index]
                            
                            VStack(spacing: 0) {
                                HStack(spacing: 0) {
                                    getDateStringView(date: date)
                                        .titleMedium()
                                    
                                    Spacer()
                                    
                                    // 여기에 아이콘을 추가하고, 네비게이션 링크를 넣는게 나을지도?
                                }
                                .padding(.horizontal)
                            
                                NavigationLink(destination: DiaryDetailView(date: date)) {
                                    HStack(spacing: 8) {
                                        let wiDList = searchDiaryViewModel.wiDList[date]
                                        
                                        SearchPieChartView(date: date, wiDList: wiDList ?? [])
                                            .frame(maxWidth: 60)
                                        
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
        .onAppear {
            print("SearchDiaryView appeared")
        }
        .onDisappear {
            print("SearchDiaryView disappeared")
        }
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
