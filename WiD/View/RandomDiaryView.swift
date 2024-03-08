//
//  RandomDiaryView.swift
//  WiD
//
//  Created by jjkim on 2024/02/06.
//

import SwiftUI

struct RandomDiaryView: View {
    private let wiDService = WiDService()
//    @State private var wiDList: [WiD] = []
    
    // 다이어리
    private let diaryService = DiaryService()
    private let totalDiaryCounts: Int
    @State private var diaryList: [Diary] = []
    
    init() {
        self.totalDiaryCounts = diaryService.readTotalDiaryCount()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if diaryList.isEmpty {
                Button(action: {
                    diaryService.addRandomDiaries(diaryList: &diaryList)
                }) {
                    HStack(spacing: 8) {
                        Text("다이어리 불러오기")
                            .bodyMedium()
                        
                        Image(systemName: "plus.square")
                            .font(.system(size: 16))
                    }
                }
                
//                VStack(alignment: .leading, spacing: 16) {
//                    HStack(spacing: 0) {
//                        getDateStringViewWith3Lines(date: Date())
//                            .frame(maxWidth: .infinity, maxHeight: .infinity)
//                            .font(.system(size: 22, weight: .bold))
//
//                        ZStack {
//                            if diaryList.isEmpty {
//                                getEmptyViewWithMultipleLines(message: "표시할\n타임라인이\n없습니다.")
//                            } else {
//                                DiaryPieChartView(wiDList: getRandomWiDList(days: 1))
//                            }
//                        }
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    }
//                    .aspectRatio(2.5 / 1, contentMode: .fit)
//
//                    Text("제목")
//                        .bodyMedium()
//
//                    Text("내용")
//                        .bodyMedium()
//                }
//                .padding()
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .background(
//                    RoundedRectangle(cornerRadius: 8)
//                        .stroke(Color("Black-White"), lineWidth: 0.5)
//                )
//                .padding(.horizontal)
            } else {
                HStack(spacing: 8) {
                    Text("다이어리 수")
                        .bodyMedium()
                    
                    Text("\(diaryList.count) / \(totalDiaryCounts)")
                        .bodyMedium()
                    
                    Spacer()
                    
                    Button(action: {
                        diaryService.addRandomDiaries(diaryList: &diaryList)
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "plus.square")
                                .font(.system(size: 16))
                            
                            Text("다이어리 추가")
                                .bodyMedium()
                        }
                        .padding(8)
                        .background(totalDiaryCounts <= diaryList.count ? Color("DarkGray") : Color("AppIndigo-AppYellow"))
                        .cornerRadius(8)
                    }
                    .disabled(totalDiaryCounts <= diaryList.count)
                    .tint(totalDiaryCounts <= diaryList.count ? Color("White") : Color("White-Black"))
                }
                .frame(height: 44)
                .padding(.horizontal)
                
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(diaryList, id: \.id) { diary in
                            VStack(alignment: .leading, spacing: 16) {
                                HStack(spacing: 0) {
                                    getDateStringViewWith3Lines(date: diary.date)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .font(.system(size: 22, weight: .bold))

                                    ZStack {
                                        let wiDList = wiDService.readWiDListByDate(date: diary.date)
                                                                                   
                                        if wiDList.isEmpty {
                                            getEmptyViewWithMultipleLines(message: "표시할\n타임라인이\n없습니다.")
                                        } else {
                                            DiaryPieChartView(wiDList: wiDList)
                                        }
                                    }
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                }
                                .aspectRatio(2.5 / 1, contentMode: .fit)
                                
                                Text(diary.title)
                                    .bodyMedium()
                                
                                Text(diary.content)
                                    .bodyMedium()
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color("Black-White"), lineWidth: 0.5)
                            )
                            .padding(.horizontal)
                        }
                    }
                    .padding(.bottom, 32)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarHidden(true)
        .background(Color("White-Black"))
    }
}

struct RandomDiaryView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RandomDiaryView()
                .environment(\.colorScheme, .light)
            
            RandomDiaryView()
                .environment(\.colorScheme, .dark)
        }
    }
}
