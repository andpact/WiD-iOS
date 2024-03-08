//
//  DayDiaryView.swift
//  WiD
//
//  Created by jjkim on 2024/02/06.
//

import SwiftUI

struct DayDiaryView: View {
    // WiD
    private let wiDService = WiDService()
    @State private var wiDList: [WiD] = []
    
    // 다이어리
    private let diaryService = DiaryService()
    @State private var diary: Diary = Diary(id: -1, date: Date(), title: "", content: "")
//    @State private var expandDiary: Bool = false
//    @State private var diaryTitleOverflow: Bool = false
//    @State private var diaryContentOverflow: Bool = false
    
    // 날짜
    private let today = Date()
    private let calendar = Calendar.current
    @State private var currentDate: Date = Date()
    @State private var expandDatePicker: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack(spacing: 16) {
                    NavigationLink(destination: DiaryDetailView(date: currentDate)) { // 네비게이션 링크안에 HStack(spacing: 8)이 포함되어 있음.
                        HStack {
                            Image(systemName: "square.and.pencil")
                                .font(.system(size: 20))
                                .frame(maxWidth: 20, maxHeight: 20)
                            
                            Text("다이어리 수정")
                                .bodyMedium()
                        }
                        .foregroundColor(Color("White-Black"))
                        .padding(8)
                    }
                    .background(Color("AppIndigo-AppYellow"))
                    .cornerRadius(8)
                    
                    Spacer()
                    
                    Button(action: {
                        self.currentDate = calendar.date(byAdding: .day, value: -1, to: self.currentDate)!
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 24))
                            .frame(maxWidth: 24, maxHeight: 24)
                    }

                    Button(action: {
                        self.currentDate = calendar.date(byAdding: .day, value: 1, to: self.currentDate)!
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 24))
                            .frame(maxWidth: 24, maxHeight: 24)
                    }
                    .disabled(calendar.isDateInToday(currentDate))
                }
                .frame(maxHeight: 44)
                .padding(.horizontal)
                
                ScrollView {
                    VStack(spacing: 16) {
//                        GeometryReader { geo in
                            HStack {
                                getDateStringViewWith3Lines(date: currentDate)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .font(.system(size: 22, weight: .bold))
                                    .onTapGesture {
                                        expandDatePicker = true
                                    }

                                ZStack {
                                    if wiDList.isEmpty {
                                        getEmptyViewWithMultipleLines(message: "표시할\n타임라인이\n없습니다.")
                                    } else {
                                        DiaryPieChartView(wiDList: wiDList)
                                    }
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                            .padding(.horizontal)
                            .aspectRatio(2.5 / 1, contentMode: .fit)
//                        }
                        
                        
//                        Rectangle()
//                            .frame(maxHeight: 1)
//                            .foregroundColor(Color("Black-White"))
//                            .padding(.horizontal)

                        VStack(spacing: 16) {
                            if diary.id < 0 { // 다이어리가 없을 때
//                                VStack(spacing: 0) {
                                    Text("당신이 이 날 무엇을 하고,\n그 속에서 어떤 생각과 감정을 느꼈는지\n주체적으로 기록해보세요.")
                                        .bodyMedium()
                                        .multilineTextAlignment(.center)
                                        .lineSpacing(10)
                                        .padding(.vertical, 80)
                                    
//                                    Image(systemName: "arrow.down")
//                                        .font(.system(size: 16))
//                                }
//                                .frame(maxWidth: .infinity, minHeight: 252) // 제목 높이(20) + 제목 패딩(16) + 내용 높이(200) + 내용 패딩(16)
//                                .frame(maxWidth: .infinity, minHeight: .infinity)
//                                .padding()
                            } else {
                                Text(diary.title)
                                    .bodyLarge()
                                    .frame(maxWidth: .infinity, alignment: .leading)
//                                    .frame(maxWidth: .infinity, minHeight: 20, maxHeight: expandDiary ? nil : 20, alignment: .topLeading)
//                                    .padding(.horizontal)
//                                    .onTapGesture {
//                                        if expandDiary == false {
//                                            expandDiary = true
//                                        }
//                                    }

                                Text(diary.content)
                                    .bodyMedium()
                                    .frame(maxWidth: .infinity, alignment: .leading)
//                                    .frame(maxWidth: .infinity, minHeight: 200, maxHeight: expandDiary ? nil : 200, alignment: .topLeading)
//                                    .padding(.horizontal)
//                                    .onTapGesture {
//                                        if expandDiary == false {
//                                            expandDiary = true
//                                        }
//                                    }
                            }
                        }
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                        .background(Color("White-Gray"))
//                        .cornerRadius(8)
//                        .shadow(color: Color("Black-White"), radius: 1)
                        .padding(.horizontal)
                    }
                }
                
//                Spacer()
                
                /**
                 하단 바
                 */
//                HStack(spacing: 16) {
//                    Button(action: {
//                        withAnimation {
//                            expandDatePicker.toggle()
//                        }
//                    }) {
//                        Image(systemName: "calendar")
//                            .font(.system(size: 20))
//
//                        Text("날짜 선택")
//                            .bodyMedium()
//                    }
//                    .padding(.horizontal)
//                    .padding(.vertical, 8)
//                    .background(Color("AppIndigo"))
//                    .foregroundColor(Color("White"))
//                    .cornerRadius(8)
//
//                    Spacer()
//
//                    Button(action: {
//                        withAnimation {
//                            currentDate = Date()
//                        }
//                    }) {
//                        Image(systemName: "arrow.clockwise")
//                            .font(.system(size: 24))
//                            .frame(width: 24, height: 24)
//                    }
//                    .disabled(calendar.isDateInToday(currentDate))
                    
//                    Button(action: {
//                        withAnimation {
//                            currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
//                        }
//                    }) {
//                        Image(systemName: "chevron.backward")
//                            .font(.system(size: 24))
//                            .frame(width: 24, height: 24)
//                    }
//                    .frame(maxWidth: .infinity)
//                    .padding(.vertical, 8)
//                    .background(Color("AppYellow-AppIndigo"))
//                    .cornerRadius(8)
//
//                    Button(action: {
//                        withAnimation {
//                            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
//                        }
//                    }) {
//                        Image(systemName: "chevron.forward")
//                            .font(.system(size: 24))
//                            .frame(width: 24, height: 24)
//                    }
//                    .frame(maxWidth: .infinity)
//                    .disabled(calendar.isDateInToday(currentDate))
//                    .padding(.vertical, 8)
//                    .background(Color("AppYellow-AppIndigo"))
//                    .cornerRadius(8)
//                }
//                .padding()
            }
    
            /**
             대화 상자
             */
            if expandDatePicker {
                ZStack {
                    Color("Black-White")
                        .opacity(0.3)
                        .onTapGesture {
                            expandDatePicker = false
                        }

                    // 날짜 선택
                    if expandDatePicker {
                        VStack(spacing: 0) {
                            ZStack {
                                Text("날짜 선택")
                                    .titleMedium()

                                Button(action: {
                                    expandDatePicker = false
                                }) {
                                    Text("확인")
                                        .bodyMedium()
                                }
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .tint(Color("Black-White"))
                            }
                            .padding()

                            Divider()
                                .background(Color("Black-White"))

                            DatePicker("", selection: $currentDate, in: ...today, displayedComponents: .date)
                                .datePickerStyle(.graphical)
                                .padding()
                        }
                        .background(Color("White-Black"))
                        .cornerRadius(8)
                        .padding() // 바깥 패딩
                        .shadow(color: Color("Black-White"), radius: 1)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarHidden(true)
        .tint(Color("Black-White"))
        .background(Color("White-Black"))
        .onAppear {
            self.wiDList = wiDService.readWiDListByDate(date: currentDate)
            self.diary = diaryService.readDiaryByDate(date: currentDate) ?? Diary(id: -1, date: Date(), title: "", content: "")
        }
        .onChange(of: currentDate) { newDate in
            withAnimation {
                self.wiDList = wiDService.readWiDListByDate(date: newDate)
                self.diary = diaryService.readDiaryByDate(date: newDate) ?? Diary(id: -1, date: Date(), title: "", content: "")
            }
        }
    }
}

struct DayDiaryView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DayDiaryView()
                .environment(\.colorScheme, .light)
            
            DayDiaryView()
                .environment(\.colorScheme, .dark)
        }
    }
}
