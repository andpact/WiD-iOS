//
//  Title.swift
//  WiD
//
//  Created by jjkim on 2023/07/12.
//

import Foundation

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
            return "취침"
        case .ETC:
            return "기타"
        }
    }
}

let titleArray: [String] = [
    Title.STUDY.rawValue,
    Title.WORK.rawValue,
    Title.EXERCISE.rawValue,
    Title.HOBBY.rawValue,
    Title.PLAY.rawValue,
    Title.MEAL.rawValue,
    Title.SHOWER.rawValue,
    Title.TRAVEL.rawValue,
    Title.SLEEP.rawValue,
    Title.ETC.rawValue
]

let titleDictionary: [String: String] = [
    "ALL": "전부",
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

enum Title2: String, CaseIterable, Identifiable {
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
            return "취침"
        case .ETC:
            return "기타"
        }
    }
}
