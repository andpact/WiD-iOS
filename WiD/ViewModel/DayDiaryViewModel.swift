//
//  DayDiaryViewModel.swift
//  WiD
//
//  Created by jjkim on 2024/03/11.
//

import Foundation

class DayDiaryViewModel: ObservableObject {
    // WiD
    private let wiDService = WiDService()
    var wiDList: [WiD] = []
    
    // 다이어리
    private let diaryService = DiaryService()
    var diary: Diary = Diary(id: -1, date: Date(), title: "", content: "")
    
    // 날짜
    @Published var currentDate: Date = Date()
    
    init() {
        self.wiDList = wiDService.readWiDListByDate(date: currentDate)
        self.diary = diaryService.readDiaryByDate(date: currentDate) ?? Diary(id: -1, date: Date(), title: "", content: "")
    }
    
    func setCurrentDate(to date: Date) {
        self.currentDate = date
        
        self.wiDList = wiDService.readWiDListByDate(date: date)
        self.diary = diaryService.readDiaryByDate(date: date) ?? Diary(id: -1, date: Date(), title: "", content: "")
    }
}
