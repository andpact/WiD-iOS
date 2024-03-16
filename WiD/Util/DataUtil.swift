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
    
//    var example: String {
//        switch self {
//        case .STUDY:
//            return "중간 및 기말고사, 자격증, 공시, 승진시험"
//        case .WORK:
//            return "직장, 부업, 알바"
//        case .EXERCISE:
//            return "헬스, 홈트, 요가, 필라테스, 런닝, 조깅"
//        case .HOBBY:
//            return "유튜브, 영화, 드라마 시청, 독서"
//        case .PLAY:
//            return "친구 만남, 데이트"
//        case .MEAL:
//            return "아침, 점심, 저녁"
//        case .SHOWER:
//            return "세안, 샤워, 목욕"
//        case .TRAVEL:
//            return "등하교, 출퇴근, 버스, 지하철, 도보"
//        case .SLEEP:
//            return "낮잠"
//        case .ETC:
//            return "그 외 기타 활동"
//        }
//    }
    
    var imageName: String {
        switch self {
        case .STUDY:
            return "book"
        case .WORK:
            return "hammer"
        case .EXERCISE:
            return "dumbbell"
        case .HOBBY:
            return "paintbrush"
        case .PLAY:
            return "gamecontroller"
        case .MEAL:
            return "fork.knife"
        case .SHOWER:
            return "shower.handheld"
        case .TRAVEL:
            return "car.side"
        case .SLEEP:
            return "zzz"
        case .ETC:
            return "ellipsis"
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

// 제목 - 이미지
let titleImageDictionary: [String: String] = [
    TitleWithALL.ALL.rawValue : "textformat",
    Title.STUDY.rawValue: Title.STUDY.imageName,
    Title.WORK.rawValue: Title.WORK.imageName,
    Title.EXERCISE.rawValue: Title.EXERCISE.imageName,
    Title.HOBBY.rawValue: Title.HOBBY.imageName,
    Title.PLAY.rawValue: Title.PLAY.imageName,
    Title.MEAL.rawValue: Title.MEAL.imageName,
    Title.SHOWER.rawValue: Title.SHOWER.imageName,
    Title.TRAVEL.rawValue: Title.TRAVEL.imageName,
    Title.SLEEP.rawValue: Title.SLEEP.imageName,
    Title.ETC.rawValue: Title.ETC.imageName
]

//struct Year: Identifiable {
//    var id: String
//}

enum Period: String, CaseIterable, Identifiable {
    case WEEK
    case MONTH
    
    var id: Self { self }
    
    var koreanValue: String {
        switch self {
        case .WEEK:
            return "일주일"
        case .MONTH:
            return "한 달"
        }
    }
}

enum DurationDictionary: String, CaseIterable, Identifiable {
    case TOTAL
    case AVERAGE
    case MIN
    case MAX
    
    var id: Self { self }
    
    var koreanValue: String {
        switch self {
        case .TOTAL:
            return "합계"
        case .AVERAGE:
            return "평균"
        case .MIN:
            return "최소"
        case .MAX:
            return "최고"
        }
    }
}

enum PlayerState {
    case STARTED
    case PAUSED
    case STOPPED
}

enum SearchFilter: String, CaseIterable, Identifiable {
    case BYTITLEORCONTENT
    case BYTITLE
    case BYCONTENT
    
    var id: Self { self }
    
    var koreanValue: String {
        switch self {
        case .BYTITLEORCONTENT:
            return "제목 및 내용"
        case .BYTITLE:
            return "제목"
        case .BYCONTENT:
            return "내용"
        }
    }
}
