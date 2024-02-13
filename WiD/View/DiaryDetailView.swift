//
//  DiaryView.swift
//  WiD
//
//  Created by jjkim on 2023/12/03.
//

import SwiftUI

struct DiaryDetailView: View {
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
        UITextView.appearance().backgroundColor = .clear
        
        self.wiDList = wiDService.readWiDListByDate(date: date)
        
        self.date = date
        self.diary = diaryService.readDiaryByDate(date: date) ?? Diary(id: -1, date: Date(), title: "", content: "")
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                /**
                 상단 바
                 */
                ZStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.backward")
                            .font(.system(size: 24))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("다이어리")
                        .titleLarge()
                    
                    Button(action: {
                        let newDiary = Diary(id: 0, date: date, title: diaryTitle, content: diaryContent)
                        
                        if diary.id == -1 { // 다이어리가 데이터베이스에 없을 때
//                            print("insertDiary - \(newDiary)")
                            diaryService.createDiary(diary: newDiary)
                        } else {
                            diaryService.updateDiary(withID: diary.id, newTitle: diaryTitle, newContent: diaryContent)
                        }
                        
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("저장")
                            .bodyMedium()
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(diaryTitle.isEmpty || diaryContent.isEmpty ? Color("DarkGray") : Color("DeepSkyBlue"))
                            .foregroundColor(Color("White"))
                            .cornerRadius(8)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .disabled(diaryTitle.isEmpty || diaryContent.isEmpty)
                }
                .frame(maxWidth: .infinity, maxHeight: 44)
                .padding(.horizontal)
                .background(Color("LightGray-Black"))
                
                GeometryReader { geo in
                    HStack {
                        getDateStringViewWith3Lines(date: date)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .font(.system(size: 22, weight: .bold))

                        ZStack {
                            if wiDList.isEmpty {
                                getEmptyViewWithMultipleLines(message: "표시할\n타임라인이\n없습니다.")
                            } else {
                                DatePieChartView(wiDList: wiDList)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .padding(.horizontal)
                }
                .aspectRatio(2 / 1, contentMode: .fit)
                
                ZStack {
                    // Title Place holder
                    TextEditor(text: $titlePlaceHolder)
                        .bodyLarge()
                        .cornerRadius(8)
//                        .cornerRadius(radius: 16, corners: [.topLeft, .topRight])
                        .padding(.horizontal)
                        .disabled(true)
                        .frame(minHeight: 40)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    TextEditor(text: $diaryTitle)
                        .bodyLarge()
                        .cornerRadius(8)
//                        .cornerRadius(radius: 16, corners: [.topLeft, .topRight])
                        .padding(.horizontal)
                        .opacity(diaryTitle.isEmpty ? 0.5 : 1)
                        .frame(minHeight: 40)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                ZStack {
                    // Content Place holder
                    TextEditor(text: $contentPlaceHolder)
                        .bodyMedium()
                        .cornerRadius(8)
//                        .cornerRadius(radius: 16, corners: [.bottomLeft, .bottomRight])
                        .padding(.horizontal)
                        .disabled(true)
                        
                    
                    TextEditor(text: $diaryContent)
                        .bodyMedium()
                        .cornerRadius(8)
//                        .cornerRadius(radius: 16, corners: [.bottomLeft, .bottomRight])
                        .padding(.horizontal)
                        .opacity(diaryContent.isEmpty ? 0.5 : 1)
                }
            }
            .tint(Color("Black-White"))
            .background(Color("White-Gray"))
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
        Group {
            DiaryDetailView(date: Date())
            
            DiaryDetailView(date: Date())
                .environment(\.colorScheme, .dark)
        }
    }
}
