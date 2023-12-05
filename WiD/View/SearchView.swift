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
    @State private var wiDList: [WiD] = []
    
    // 다이어리
    private let diaryService = DiaryService()
    @State private var diaryList: [Diary] = []
    
    // 날짜
    private let calendar = Calendar.current
    
    // 검색
    @State private var searchText: String = ""
    
    var body: some View {
        VStack {
            // 검색 창
            HStack {
                Image(systemName: "magnifyingglass")
                
                TextField("제목 또는 내용으로 검색..", text: $searchText)
            }
            .padding()
            .background(.white)
            .shadow(radius: 1)
            
            ScrollViewReader { sp in
                ScrollView {
                    // 스크롤 뷰 안에 자동으로 수직 수택(spacing: 8)이 생성되는 듯.
                    VStack(alignment: .leading, spacing: 8) {
//                        LazyVGrid(columns: Array(repeating: GridItem(), count: 3)) {
//                            ForEach(0..<4) { _ in
//                                VStack(alignment: .leading) {
//                                    VStack(alignment: .leading, spacing: 8) {
//                                        Text("diary.dd")
//                                            .bold()
//                                            .frame(maxWidth: .infinity, alignment: .leading)
//                                            .lineLimit(1)
//
//                                        Text("diary.ddddc")
//                                            .frame(maxWidth: .infinity, alignment: .leading)
//                                    }
//                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
//                                    .padding(8)
//                                    .background(.white)
//                                    .cornerRadius(8)
//                                    .shadow(radius: 1)
//
//                                    getDayStringWith2Lines(date: Date())
//                                }
//                                .aspectRatio(1.0 / 1.8, contentMode: .fit)
//                            }
//                        }
                        
                        if diaryList.isEmpty {
                            HStack {
                                Image(systemName: "text.bubble")
                                    .foregroundColor(.gray)

                                Text("검색으로 다이어리를 찾아보세요.")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .padding(.vertical)
                            .frame(maxWidth: .infinity)
                        } else {
                            LazyVGrid(columns: Array(repeating: GridItem(), count: 3)) {
                                ForEach(Array(diaryList.enumerated()), id: \.element.id) { (index, diary) in
                                    NavigationLink(destination: DiaryView(date: diary.date)) {
                                        VStack(alignment: .leading) {
                                            VStack(alignment: .leading, spacing: 8) {
                                                Text(diary.title)
                                                    .bold()
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .lineLimit(1)
                                                
                                                Text(diary.content)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                            }
                                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                                            .padding(8)
                                            .background(.white)
                                            .cornerRadius(8)
                                            .shadow(radius: 1)
                                            
                                            getDayStringWith2Lines(date: diary.date)
                                        }
                                        .aspectRatio(1.0 / 1.8, contentMode: .fit)
                                    }
                                }
                            }
                        }
                        
//                        if wiDList.isEmpty {
//                            HStack {
//                                Image(systemName: "text.bubble")
//                                    .foregroundColor(.gray)
//
//                                Text("설명으로 WiD를 검색해 보세요.")
//                                    .foregroundColor(.gray)
//                            }
//                            .padding()
//                            .padding(.vertical)
//                            .frame(maxWidth: .infinity)
//                        } else {
//                            ForEach(Array(wiDList.enumerated()), id: \.element.id) { (index, wiD) in
//                                if index == 0 || !calendar.isDate(wiD.date, inSameDayAs: wiDList[index - 1].date) {
//                                    HStack {
//                                        if calendar.isDateInToday(wiD.date) {
//                                            Text("오늘")
//                                                .bold()
//                                        } else if calendar.isDateInYesterday(wiD.date) {
//                                            Text("어제")
//                                                .bold()
//                                        } else {
//                                            getDayString(date: wiD.date)
//                                        }
//                                    }
//                                }
//
//                                NavigationLink(destination: WiDView(clickedWiDId: wiD.id)) {
//                                    VStack(spacing: 8) {
//                                        HStack {
//                                            HStack {
//                                                Image(systemName: "character.textbox.ko")
//                                                    .frame(width: 20)
//
//                                                Text("제목")
//                                                    .bold()
//
//                                                Text(titleDictionary[wiD.title] ?? "")
//
//                                                Circle()
//                                                    .fill(Color(wiD.title))
//                                                    .frame(width: 10)
//                                            }
//                                            .frame(maxWidth: .infinity, alignment: .leading)
//
//                                            HStack {
//                                                Image(systemName: "hourglass")
//                                                    .frame(width: 20)
//
//                                                Text("소요")
//                                                    .bold()
//
//                                                Text(formatDuration(wiD.duration, mode: 1))
//                                            }
//                                            .frame(maxWidth: .infinity, alignment: .leading)
//                                        }
//
//                                        HStack {
//                                            HStack {
//                                                Image(systemName: "play")
//                                                    .frame(width: 20)
//
//                                                Text("시작")
//                                                    .bold()
//
//                                                Text(formatTime(wiD.start, format: "a h:mm"))
//                                            }
//                                            .frame(maxWidth: .infinity, alignment: .leading)
//
//                                            HStack {
//                                                Image(systemName: "play.fill")
//                                                    .frame(width: 20)
//
//                                                Text("종료")
//                                                    .bold()
//
//                                                Text(formatTime(wiD.finish, format: "a h:mm"))
//                                            }
//                                            .frame(maxWidth: .infinity, alignment: .leading)
//                                        }
//
//                                        HStack {
//                                            Image(systemName: "text.bubble")
//                                                .frame(width: 20)
//
//                                            Text("설명")
//                                                .bold()
//
//                                            Text(wiD.detail)
//                                                .frame(maxWidth: .infinity, alignment: .leading)
//                                                .lineLimit(1)
//                                                .truncationMode(.tail)
//                                        }
//                                    }
//                                    .padding()
//                                    .background(.white)
//                                    .cornerRadius(8)
//                                    .shadow(radius: 1)
//                                }
//                            }
//                        }
                    }
                    .padding(.horizontal)
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
        .background(Color("ghost_white"))
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
