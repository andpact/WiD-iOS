//
//  HomeViewModel.swift
//  WiD
//
//  Created by jjkim on 2024/03/16.
//

import Foundation

/**
 최근 생성한 WiD와 다이어리를 보여주자.
 */
class HomeViewModel: ObservableObject {
    
    // WiD
    private let wiDService = WiDService()
    var wiD: WiD = WiD(id: -1, date: Date(), title: "", start: Date(), finish: Date(), duration: TimeInterval.zero)
    var wiDList: [WiD] = []
    
    // 다이어리
    private let diaryService = DiaryService()
    var diary: Diary = Diary(id: -1, date: Date(), title: "", content: "")
    
    init() { // 뷰 모델이 생성될 떄
        print("HomeViewModel initialized")
    }
    
    deinit { // 뷰 모델이 제거될 떄
        print("HomeViewModel deinitialized")
    }
    
    // 가장 최근의 WiD를 wiD에 할당하는 메서드
    func fetchMostRecentWiD() {
        if let mostRecentWiD = wiDService.fetchMostRecentWiD() {
            wiD = mostRecentWiD
        } else {
            print("Failed to fetch the most recent WiD")
        }
    }
    
    // 가장 최근의 다이어리를 diary에 할당하는 메서드
    func fetchMostRecentDiary() {
        if let mostRecentDiary = diaryService.fetchMostRecentDiary() {
            diary = mostRecentDiary
            wiDList = wiDService.readWiDListByDate(date: mostRecentDiary.date)
        } else {
            print("Failed to fetch the most recent diary")
        }
    }
}
