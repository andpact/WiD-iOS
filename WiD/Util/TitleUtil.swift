//
//  Title.swift
//  WiD
//
//  Created by jjkim on 2023/07/12.
//

import Foundation

enum Title: String {
    case STUDY
    case WORK
    case READING
    case EXERCISE
    case HOBBY
    case MEAL
    case SHOWER
    case TRAVEL
    case SLEEP
    case OTHER
    
    var koreanValue: String {
        switch self {
        case .STUDY:
            return "공부"
        case .WORK:
            return "일"
        case .READING:
            return "독서"
        case .EXERCISE:
            return "운동"
        case .HOBBY:
            return "취미"
        case .MEAL:
            return "식사"
        case .SHOWER:
            return "샤워"
        case .TRAVEL:
            return "이동"
        case .SLEEP:
            return "잠"
        case .OTHER:
            return "기타"
        }
    }
}

let titleArray: [String] = [
    Title.STUDY.rawValue,
    Title.WORK.rawValue,
    Title.READING.rawValue,
    Title.EXERCISE.rawValue,
    Title.HOBBY.rawValue,
    Title.MEAL.rawValue,
    Title.SHOWER.rawValue,
    Title.TRAVEL.rawValue,
    Title.SLEEP.rawValue,
    Title.OTHER.rawValue
]

let titleDictionary: [String: String] = [
    Title.STUDY.rawValue: Title.STUDY.koreanValue,
    Title.WORK.rawValue: Title.WORK.koreanValue,
    Title.READING.rawValue: Title.READING.koreanValue,
    Title.EXERCISE.rawValue: Title.EXERCISE.koreanValue,
    Title.HOBBY.rawValue: Title.HOBBY.koreanValue,
    Title.MEAL.rawValue: Title.MEAL.koreanValue,
    Title.SHOWER.rawValue: Title.SHOWER.koreanValue,
    Title.TRAVEL.rawValue: Title.TRAVEL.koreanValue,
    Title.SLEEP.rawValue: Title.SLEEP.koreanValue,
    Title.OTHER.rawValue: Title.OTHER.koreanValue
]
