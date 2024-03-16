//
//  RandomDiaryViewModel.swift
//  WiD
//
//  Created by jjkim on 2024/03/11.
//

import Foundation

/**
 다이어리 테이블에서 dateList를 만들고, dateList속 date를 사용해서 다이어리와 wiDList를 불러오도록 동작함.
 배열[]은 순서를 유지하고, 딕셔너리[:]는 순서를 유지하지 않는다.?
 */
//class RandomDiaryViewModel: ObservableObject {
//    // 날짜
//    @Published var dateList: [Date] = []
//    
//    // WiD
//    private let wiDService = WiDService()
//    @Published var wiDList: [Date: [WiD]] = [:]
//    
//    // 다이어리
//    private let diaryService = DiaryService()
//    var totalDiaryCounts: Int = 0
////    var diaryList: [Date: Diary] = [:]
//    @Published var diaryList: [DiaryInfo] = []
//    
//    init() {
//        totalDiaryCounts = diaryService.readTotalDiaryCount()
//        
////        addRandomDiaries()
//    }
//    
//    func addRandomDiaries() {
////        dateList = diaryService.addRandomDate(dateList: dateList)
////        diaryService.addRandomDate(dateList: &dateList)
//        
////        for date in dateList {
////            let wiDs = wiDService.readWiDListByDate(date: date)
////            wiDList[date] = wiDs
////            
////            let diary = diaryService.readDiaryByDate(date: date)
////            diaryList[date] = diary
////        }
//        
//        diaryService.addRandomDiaries(diaryInfoList: &diaryList)
//        
//        for diaryInfo in diaryList {
//            let wiDs = wiDService.readWiDListByDate(date: diaryInfo.date)
//            wiDList[diaryInfo.date] = wiDs
//        }
//        
//        // diaryList의 키인 Date를 순회하여 dateList에 할당
////        dateList = Array(diaryList.keys)
//        
////        for date in dateList {
////            let wiDs = wiDService.readWiDListByDate(date: date)
////
////            wiDList[date] = wiDs
////
//////            if !wiDs.isEmpty {
//////                // 해당 날짜에 WiD가 있는 경우에만 wiDList에 추가
//////                wiDList[date] = wiDs
//////            }
////        }
//    }
//}
//
//// 날짜와 다이어리를 담는 구조체
//struct DiaryInfo {
//    var date: Date
//    var diary: Diary
//}
