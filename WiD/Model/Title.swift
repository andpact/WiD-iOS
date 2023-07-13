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
    
    var stringValue: String {
        return self.rawValue
    }
}
