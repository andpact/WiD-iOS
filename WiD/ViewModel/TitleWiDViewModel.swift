//
//  TitleWiDViewModel.swift
//  WiD
//
//  Created by jjkim on 2024/03/11.
//

import Foundation

class TitleWiDViewModel: ObservableObject {
    // WiD
    private let wiDService = WiDService()
    var wiDList: [WiD] = []
    var filteredWiDListByTitle: [WiD] = []
    
    // 제목
    @Published var selectedTitle: Title = .STUDY
    
    // 기간
    @Published var selectedPeriod: Period = Period.WEEK
    
    // 날짜
    private let today: Date = Calendar.current.startOfDay(for: Date()) // 시간을 오전 12:00:00으로 설정함.
    @Published var startDate: Date = Date()
    @Published var finishDate: Date = Date()
    
    // 합계
    var totalDurationDictionary: [String: TimeInterval] = [:]
    
    // 평균
    var averageDurationDictionary: [String: TimeInterval] = [:]
    
    // 최저
    var minDurationDictionary: [String: TimeInterval] = [:]
    
    // 최고
    var maxDurationDictionary: [String: TimeInterval] = [:]
    
    init() {
        print("MonthWiDViewModel initialized")
        
        self.startDate = getFirstDateOfWeek(for: today)
        self.finishDate = getLastDateOfWeek(for: today)
    }
    
    deinit {
        print("MonthWiDViewModel deinitialized")
    }
    
    func setTitle(to newTitle: Title) {
        self.selectedTitle = newTitle
        
        self.filteredWiDListByTitle = wiDList.filter { wiD in
            return wiD.title == newTitle.rawValue
        }
    }
    
    func setPeriod(to newPeriod: Period) {
        self.selectedPeriod = newPeriod
        
        if (newPeriod == Period.WEEK) {
            let newStartDate = getFirstDateOfWeek(for: today)
            let newFinishDate = getLastDateOfWeek(for: today)
            
            setDates(startDate: newStartDate, finishDate: newFinishDate)
        } else if (newPeriod == Period.MONTH) {
            let newStartDate = getFirstDateOfMonth(for: today)
            let newFinishDate = getLastDateOfMonth(for: today)
            
            setDates(startDate: newStartDate, finishDate: newFinishDate)
        }
    }
    
    func setDates(startDate: Date, finishDate: Date) {
        self.startDate = startDate
        self.finishDate = finishDate
        
        self.wiDList = wiDService.readWiDListBetweenDates(startDate: startDate, finishDate: finishDate)
        self.filteredWiDListByTitle = wiDList.filter { wiD in
            return wiD.title == selectedTitle.rawValue
        }
        
        self.totalDurationDictionary = getTotalDurationDictionaryByTitle(wiDList: wiDList)
        self.averageDurationDictionary = getAverageDurationDictionaryByTitle(wiDList: wiDList)
        self.maxDurationDictionary = getMaxDurationDictionaryByTitle(wiDList: wiDList)
        self.minDurationDictionary = getMinDurationDictionaryByTitle(wiDList: wiDList)
    }
}
