//
//  DayWiDViewModel.swift
//  WiD
//
//  Created by jjkim on 2024/03/10.
//

import Foundation

class DayWiDViewModel: ObservableObject {
    // 날짜
    @Published var currentDate: Date = Date()
    
    // WiD
    private let wiDService = WiDService()
//    @Published var wiDList: [WiD] = []
    var wiDList: [WiD] = []
    
    // 합계
    @Published var totalDurationDictionary: [String: TimeInterval] = [:]
    
    init() {
        print("DayWiDViewModel initialized")
    }
    
    deinit {
        print("DayWiDViewModel deinitialized")
    }
    
    func setCurrentDate(to date: Date) {
        // currentDate를 새로운 날짜로 설정
        self.currentDate = date
        
        // 새로운 날짜에 따라 wiDList 및 fullWiDList 업데이트
        self.wiDList = wiDService.readWiDListByDate(date: date)
        self.totalDurationDictionary = getTotalDurationDictionaryByTitle(wiDList: wiDList)
    }
}
