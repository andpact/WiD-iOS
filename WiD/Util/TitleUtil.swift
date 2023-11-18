//
//  Title.swift
//  WiD
//
//  Created by jjkim on 2023/07/12.
//

import Foundation

// WiD 생성시 필요한 enum
enum Title: String, CaseIterable, Identifiable {
    case STUDY
    case WORK
    case EXERCISE
    case HOBBY
    case PLAY
    case MEAL
    case SHOWER
    case TRAVEL
    case SLEEP
    case ETC
    
    var id: Self { self }
    
    var koreanValue: String {
        switch self {
        case .STUDY:
            return "공부"
        case .WORK:
            return "노동"
        case .EXERCISE:
            return "운동"
        case .HOBBY:
            return "취미"
        case .PLAY:
            return "놀기"
        case .MEAL:
            return "식사"
        case .SHOWER:
            return "샤워"
        case .TRAVEL:
            return "이동"
        case .SLEEP:
            return "수면"
        case .ETC:
            return "기타"
        }
    }
}

// WiD 조회시 필요한 enum
enum TitleWithALL: String, CaseIterable, Identifiable {
    case ALL
    case STUDY
    case WORK
    case EXERCISE
    case HOBBY
    case PLAY
    case MEAL
    case SHOWER
    case TRAVEL
    case SLEEP
    case ETC
    
    var id: Self { self }
    
    var koreanValue: String {
        switch self {
        case .ALL:
            return "전체"
        case .STUDY:
            return "공부"
        case .WORK:
            return "노동"
        case .EXERCISE:
            return "운동"
        case .HOBBY:
            return "취미"
        case .PLAY:
            return "놀기"
        case .MEAL:
            return "식사"
        case .SHOWER:
            return "샤워"
        case .TRAVEL:
            return "이동"
        case .SLEEP:
            return "수면"
        case .ETC:
            return "기타"
        }
    }
}

// 데이터베이스에서 제목을 불러왔을 때 필요한 딕셔너리
let titleDictionary: [String: String] = [
    Title.STUDY.rawValue: Title.STUDY.koreanValue,
    Title.WORK.rawValue: Title.WORK.koreanValue,
    Title.EXERCISE.rawValue: Title.EXERCISE.koreanValue,
    Title.HOBBY.rawValue: Title.HOBBY.koreanValue,
    Title.PLAY.rawValue: Title.PLAY.koreanValue,
    Title.MEAL.rawValue: Title.MEAL.koreanValue,
    Title.SHOWER.rawValue: Title.SHOWER.koreanValue,
    Title.TRAVEL.rawValue: Title.TRAVEL.koreanValue,
    Title.SLEEP.rawValue: Title.SLEEP.koreanValue,
    Title.ETC.rawValue: Title.ETC.koreanValue
]
