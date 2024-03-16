//
//  SearchDiaryViewModel.swift
//  WiD
//
//  Created by jjkim on 2024/03/11.
//

import Foundation

class SearchDiaryViewModel: ObservableObject {
    // 날짜
    @Published var dateList: [Date] = []
    
    // WiD
    private let wiDService = WiDService()
    var wiDList: [Date: [WiD]] = [:]
    
    // 다이어리
    private let diaryService = DiaryService()
    var totalDiaryCounts: Int = 0
    var diaryList: [Date: Diary] = [:]
    var searchText: String = ""
    @Published var searchFilter: SearchFilter = .BYTITLEORCONTENT
    
    init() {
        totalDiaryCounts = diaryService.readTotalDiaryCount()
        
        addDiaries()
    }
    
    func addDiaries() {
        if searchFilter == SearchFilter.BYTITLEORCONTENT { // 제목 및 내용으로 검색
            self.diaryList = diaryService.readDiaryByTitleOrContent(searchText: searchText)
        } else if searchFilter == SearchFilter.BYTITLE { // 제목으로 검색
            self.diaryList = diaryService.readDiaryByTitle(searchText: searchText)
        } else { // 내용으로 검색
            self.diaryList = diaryService.readDiaryByContent(searchText: searchText)
        }
        
//        diaryService.addRandomDiaries(diaryList: &diaryList)
        
        // diaryList의 키인 Date를 순회하여 dateList에 할당
        dateList = Array(diaryList.keys)
        
        for date in dateList {
            let wiDs = wiDService.readWiDListByDate(date: date)
            
            wiDList[date] = wiDs
            
//            if !wiDs.isEmpty {
//                // 해당 날짜에 WiD가 있는 경우에만 wiDList에 추가
//                wiDList[date] = wiDs
//            }
        }
    }
    
    func changeSearchFilter(to filter: SearchFilter) {
        searchFilter = filter
    }
}
