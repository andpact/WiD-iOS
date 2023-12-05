//
//  DiaryView.swift
//  WiD
//
//  Created by jjkim on 2023/12/03.
//

import SwiftUI

struct DiaryView: View {
    // 화면
    @Environment(\.presentationMode) var presentationMode
    
    // 다이어리
    private let date: Date
    private let diaryService = DiaryService()
    private let diary: Diary
    @State private var diaryTitle: String = ""
    @State private var diaryContent: String = ""
    @State private var contentPlaceHolder: String = "내용을 입력해 주세요."
    
    init(date: Date) {
        self.date = date
        self.diary = diaryService.selectDiaryByDate(date: date) ?? Diary(id: -1, date: Date(), title: "", content: "")
    }
    
    var body: some View {
        NavigationView {
            // 전체 화면
            VStack {
                // 상단 바
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.backward")
                            .imageScale(.large)
                    }
                    
                    Text("다이어리")
                        .bold()
                    
                    Text("-")
                    
                    getDayString(date: date)
                    
                    Spacer()
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                        
                        let newDiary = Diary(id: 0, date: date, title: diaryTitle, content: diaryContent)
                        
                        if diary.id == -1 { // 다이어리가 데이터베이스에 없을 때
                            print("insertDiary - \(newDiary)")
                            diaryService.insertDiary(diary: newDiary)
                        } else {
                            diaryService.updateDiary(withID: diary.id, newTitle: diaryTitle, newContent: diaryContent)
                        }
                    }) {
                        Text("완료")
                            .foregroundColor(diaryTitle.isEmpty || diaryContent.isEmpty ? .gray : .blue)
                    }
                    .disabled(diaryTitle.isEmpty || diaryContent.isEmpty)
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                
                TextField("제목을 입력해 주세요.", text: $diaryTitle)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .font(Font.body.bold())
                
                Divider()
                    .padding(.horizontal)
                
                ZStack {
                    TextEditor(text: $contentPlaceHolder)
                        .padding(.horizontal)
                        .disabled(true)
                    
                    TextEditor(text: $diaryContent)
                        .padding(.horizontal)
                        .opacity(diaryContent.isEmpty ? 0.75 : 1)
                }
            }
            .tint(.black)
            .onAppear {
                self.diaryTitle = diary.title
                self.diaryContent = diary.content
            }
        }
        .navigationBarBackButtonHidden()
    }
}

struct DiaryView_Previews: PreviewProvider {
    static var previews: some View {
        DiaryView(date: Date())
    }
}
