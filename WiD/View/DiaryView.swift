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
                ZStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.backward")
                        
                        Text("뒤로 가기")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.blue)
                    
                    Text("다이어리")
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .center)
                    
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
                        Image(systemName: "checkmark")
                        
                        Text("완료")
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .foregroundColor(diaryTitle.isEmpty || diaryContent.isEmpty ? .gray : .blue)
                    .disabled(diaryTitle.isEmpty || diaryContent.isEmpty)
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                
                getDayString(date: date)
                    .font(.custom("BlackHanSans-Regular", size: 25))
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                TextField("제목을 입력해 주세요.", text: $diaryTitle)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .font(Font.body.bold())
                
                Divider()
                    .padding(.horizontal)
                
                ZStack {
                    // Place holder
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
        .navigationBarHidden(true)
    }
}

struct DiaryView_Previews: PreviewProvider {
    static var previews: some View {
        DiaryView(date: Date())
    }
}
