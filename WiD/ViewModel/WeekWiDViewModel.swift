//
//  WeekWiDViewModel.swift
//  WiD
//
//  Created by jjkim on 2024/03/10.
//

import Foundation

class WeekWiDViewModel: ObservableObject {    
    // WiD
    private let wiDService = WiDService()
    var wiDList: [WiD] = []
    
    // 날짜
    private let today: Date = Calendar.current.startOfDay(for: Date()) // 시간을 오전 12:00:00으로 설정함.
    @Published var startDate: Date = Date()
    @Published var finishDate: Date = Date()
    
    // 합계
    private var totalDurationDictionary: [String: TimeInterval] = [:]
    
    // 평균
    private var averageDurationDictionary: [String: TimeInterval] = [:]
    
    // 최저
    private var minDurationDictionary: [String: TimeInterval] = [:]
    
    // 최고
    private var maxDurationDictionary: [String: TimeInterval] = [:]
    
    // 딕셔너리
    @Published var seletedDictionary: [String: TimeInterval] = [:]
    @Published var seletedDictionaryType: DurationDictionary = .TOTAL
    
    init() {
//        self.startDate = getFirstDateOfWeek(for: today)
//        self.finishDate = getLastDateOfWeek(for: today)
//
//        self.wiDList = wiDService.readWiDListBetweenDates(startDate: startDate, finishDate: finishDate)
//
//        self.totalDurationDictionary = getTotalDurationDictionaryByTitle(wiDList: wiDList)
//        self.averageDurationDictionary = getAverageDurationDictionaryByTitle(wiDList: wiDList)
//        self.maxDurationDictionary = getMaxDurationDictionaryByTitle(wiDList: wiDList)
//        self.minDurationDictionary = getMinDurationDictionaryByTitle(wiDList: wiDList)
//
//        self.seletedDictionary = totalDurationDictionary

        let startDate = getFirstDateOfWeek(for: today)
        let finishDate = getLastDateOfWeek(for: today)
        
        setDates(startDate: startDate, finishDate: finishDate)
    }
    
    func setDates(startDate: Date, finishDate: Date) {
        self.startDate = startDate
        self.finishDate = finishDate
        
        self.wiDList = wiDService.readWiDListBetweenDates(startDate: startDate, finishDate: finishDate)
        
        self.totalDurationDictionary = getTotalDurationDictionaryByTitle(wiDList: wiDList)
        self.averageDurationDictionary = getAverageDurationDictionaryByTitle(wiDList: wiDList)
        self.maxDurationDictionary = getMaxDurationDictionaryByTitle(wiDList: wiDList)
        self.minDurationDictionary = getMinDurationDictionaryByTitle(wiDList: wiDList)
        
        self.seletedDictionary = totalDurationDictionary
    }
    
    func setDictionaryType(newDictionaryType: DurationDictionary) {
        switch newDictionaryType {
        case .TOTAL:
            self.seletedDictionary = totalDurationDictionary
        case .AVERAGE:
            self.seletedDictionary = averageDurationDictionary
        case .MIN:
            self.seletedDictionary = minDurationDictionary
        case .MAX:
            self.seletedDictionary = maxDurationDictionary
        }
    }
}
