//
//  Title.swift
//  WiD
//
//  Created by jjkim on 2023/07/12.
//

import Foundation

enum Title {
    case study
    case work
    case reading
    case exercise
    case hobby
    case meal
    case shower
    case travel
    case sleep
    case other
    
    var stringValue: String {
        switch self {
        case .study: return "STUDY"
        case .work: return "WORK"
        case .reading: return "READING"
        case .exercise: return "EXERCISE"
        case .hobby: return "HOBBY"
        case .meal: return "MEAL"
        case .shower: return "SHOWER"
        case .travel: return "TRAVEL"
        case .sleep: return "SLEEP"
        case .other: return "OTHER"
        }
    }
}
