//
//  RandomDiaryView.swift
//  WiD
//
//  Created by jjkim on 2024/02/06.
//

import SwiftUI

//struct RandomDiaryView: View {
//    // 뷰 모델
//    @EnvironmentObject var randomDiaryViewModel: RandomDiaryViewModel
//    
//    // WiD
////    private let wiDService = WiDService()
////    @State private var wiDList: [WiD] = []
//    
//    // 다이어리
////    private let diaryService = DiaryService()
////    private let totalDiaryCounts: Int
////    @State private var diaryList: [Diary] = []
//    
////    init() {
////        self.totalDiaryCounts = diaryService.readTotalDiaryCount()
////    }
//    
//    var body: some View {
//        VStack(spacing: 0) {
//            if randomDiaryViewModel.dateList.isEmpty {
//                Button(action: {
////                    diaryService.addRandomDiaries(diaryList: &diaryList)
//                    
//                    randomDiaryViewModel.addRandomDiaries()
//                }) {
//                    HStack(spacing: 8) {
//                        Text("다이어리 불러오기")
//                            .bodyMedium()
//                        
//                        Image(systemName: "plus.square")
//                            .font(.system(size: 16))
//                    }
//                }
//            } else {
//                HStack(spacing: 8) {
//                    Text("다이어리 수")
//                        .bodyMedium()
//                    
//                    Text("\(randomDiaryViewModel.dateList.count) / \(randomDiaryViewModel.totalDiaryCounts)")
//                        .bodyMedium()
//                    
//                    Spacer()
//                    
//                    Button(action: {
////                        diaryService.addRandomDiaries(diaryList: &diaryList)
//                        
//                        randomDiaryViewModel.addRandomDiaries()
//                    }) {
//                        HStack(spacing: 8) {
//                            Image(systemName: "plus.square")
//                                .font(.system(size: 16))
//                            
//                            Text("다이어리 추가")
//                                .bodyMedium()
//                        }
//                        .padding(8)
//                        .background(randomDiaryViewModel.totalDiaryCounts <= randomDiaryViewModel.dateList.count ? Color("DarkGray") : Color("AppIndigo-AppYellow"))
//                        .cornerRadius(8)
//                    }
//                    .disabled(randomDiaryViewModel.totalDiaryCounts <= randomDiaryViewModel.dateList.count)
//                    .tint(randomDiaryViewModel.totalDiaryCounts <= randomDiaryViewModel.dateList.count ? Color("White") : Color("White-Black"))
//                }
//                .frame(height: 44)
//                .padding(.horizontal)
//                
//                ScrollView {
//                    VStack(spacing: 8) {
////                        ForEach(diaryList, id: \.id) { diary in
//                        ForEach(randomDiaryViewModel.dateList, id: \.self) { date in
////                            let date = randomDiaryViewModel.dateList[index]
//                            
//                            VStack(alignment: .leading, spacing: 16) {
//                                HStack(spacing: 0) {
////                                    getDateStringViewWith3Lines(date: diary.date)
//                                    getDateStringViewWith3Lines(date: date)
//                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                                        .font(.system(size: 22, weight: .bold))
//
//                                    ZStack {
////                                        let wiDList = wiDService.readWiDListByDate(date: diary.date)
//                                        let wiDList = randomDiaryViewModel.wiDList[date]
//                                                                                   
//                                        if wiDList?.isEmpty == true {
//                                            getEmptyViewWithMultipleLines(message: "표시할\n타임라인이\n없습니다.")
//                                        } else {
//                                            DiaryPieChartView(wiDList: wiDList ?? [])
//                                        }
//                                    }
//                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                                }
//                                .aspectRatio(2.5 / 1, contentMode: .fit)
//                                
////                                Text(randomDiaryViewModel.diaryList[date]?.title ?? "")
////                                    .bodyMedium()
////                                
////                                Text(randomDiaryViewModel.diaryList[date]?.content ?? "")
////                                    .bodyMedium()
//                                
//                                Text(randomDiaryViewModel.diaryList.first { $0.date == date }?.diary.title ?? "")
//                                    .bodyMedium()
//
//                                Text(randomDiaryViewModel.diaryList.first { $0.date == date }?.diary.content ?? "")
//                                    .bodyMedium()
//
//                            }
//                            .padding()
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                            .background(
//                                RoundedRectangle(cornerRadius: 8)
//                                    .stroke(Color("Black-White"), lineWidth: 0.5)
//                            )
//                            .padding(.horizontal)
//                        }
//                    }
//                    .padding(.bottom, 32)
//                }
//            }
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .navigationBarHidden(true)
//        .background(Color("White-Black"))
//    }
//}
//
//struct RandomDiaryView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            RandomDiaryView()
//                .environment(\.colorScheme, .light)
//            
//            RandomDiaryView()
//                .environment(\.colorScheme, .dark)
//        }
//    }
//}
