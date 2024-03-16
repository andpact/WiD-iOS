//
//  WiDListViewModel.swift
//  WiD
//
//  Created by jjkim on 2024/03/10.
//

import Foundation

/**
 @Published 붙으면 private를 붙일 수 없잖아.
 */
class WiDListViewModel: ObservableObject {
    // 날짜
    private let now = Date()
    @Published var currentDate: Date = Date()
    
    // WiD
    private let wiDService = WiDService()
    private var wiDList: [WiD] = []
    @Published var fullWiDList: [WiD] = []
    
    init() {
        setCurrentDate(to: currentDate)
    }
    
    func setCurrentDate(to date: Date) {
        // currentDate를 새로운 날짜로 설정
        self.currentDate = date
        
        // 새로운 날짜에 따라 wiDList 및 fullWiDList 업데이트
        self.wiDList = wiDService.readWiDListByDate(date: date)
        self.fullWiDList = getFullWiDListFromWiDList(date: date, currentTime: now, wiDList: wiDList)
    }
}
