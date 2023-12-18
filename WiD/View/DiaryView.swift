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
    
    // WiD
    private let wiDService = WiDService()
    private let wiDList: [WiD]
    
    // 다이어리
    private let date: Date
    private let diaryService = DiaryService()
    private let diary: Diary
    @State private var diaryTitle: String = ""
    @State private var titlePlaceHolder: String = "제목을 입력해 주세요."
    @State private var diaryContent: String = ""
    @State private var contentPlaceHolder: String = "내용을 입력해 주세요."
    
    init(date: Date) {
        self.wiDList = wiDService.selectWiDsByDate(date: date)
        
        self.date = date
        self.diary = diaryService.selectDiaryByDate(date: date) ?? Diary(id: -1, date: Date(), title: "", content: "")
    }
    
    var body: some View {
        NavigationView {
            /**
             전체 화면
             */
            VStack {
                /**
                 상단 바
                 */
                ZStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.backward")
                        
                        Text("뒤로 가기")
                            .font(.system(size: 18, weight: .medium))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.blue)
                    
                    Text("다이어리")
                        .font(.system(size: 20, weight: .bold))
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
                            .font(.system(size: 18, weight: .medium))
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .foregroundColor(diaryTitle.isEmpty || diaryContent.isEmpty ? .gray : .blue)
                    .disabled(diaryTitle.isEmpty || diaryContent.isEmpty)
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                
                HStack {
                    GeometryReader { geo in
                        getDayStringWith3Lines(date: date)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .font(.system(size: 22, weight: .bold))
                    }
                    .aspectRatio(contentMode: .fit)
                    
                    GeometryReader { geo in
                        ZStack {
                            if wiDList.isEmpty {
                                getEmptyViewWithMultipleLines(message: "표시할\n타임라인이\n없습니다.")
                            } else {
                                DayPieChartView(wiDList: wiDList)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .aspectRatio(contentMode: .fit)
                }
                
                Divider()
                    .padding(.horizontal)
                
                ZStack {
                    // Place holder
                    TextEditor(text: $titlePlaceHolder)
                        .padding(.horizontal)
                        .disabled(true)
                        .frame(minHeight: 40)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    TextEditor(text: $diaryTitle)
                        .padding(.horizontal)
                        .opacity(diaryTitle.isEmpty ? 0.75 : 1)
                        .frame(minHeight: 40)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
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
