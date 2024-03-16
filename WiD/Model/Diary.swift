//
//  DiaryUtil.swift
//  WiD
//
//  Created by jjkim on 2023/12/02.
//

import SwiftUI

/**
 username 프로퍼티 추가해야 할 듯.
 */
struct Diary {
    var id: Int
//    var username: String
    var date: Date
    var title: String
    var content: String
    
    init(id: Int, date: Date, title: String, content: String) {
        self.id = id
        self.date = date
        self.title = title
        self.content = content
    }
}
