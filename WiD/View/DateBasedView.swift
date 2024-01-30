//
//  WiDReadView.swift
//  WiD
//
//  Created by jjkim on 2023/07/08.
//

import SwiftUI

struct DateBasedView: View {
    // 화면
    @Environment(\.presentationMode) var presentationMode
    
    // WiD
    private let wiDService = WiDService()
    @State private var wiDList: [WiD] = []
    
    // 다이어리
    private let diaryService = DiaryService()
    @State private var diary: Diary = Diary(id: -1, date: Date(), title: "", content: "")
    @State private var expandDiary: Bool = false
    @State private var diaryTitleOverflow: Bool = false
    @State private var diaryContentOverflow: Bool = false
    
    // 합계
    @State private var totalDurationDictionary: [String: TimeInterval] = [:]
    
    // 날짜
    private let today = Date()
    private let calendar = Calendar.current
    @State private var currentDate: Date = Date()
    @State private var expandDatePicker: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 0) { // spacing: 0일 때, 상단 바에 그림자를 적용시키면 컨텐츠가 상단 바의 그림자를 덮어서 가림. (상단 바가 렌더링 된 후, 컨텐츠가 렌더링되기 때문)
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
                        .tint(Color("Black-White"))

                        Text("날짜 조회")
                            .titleLarge()
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, maxHeight: 44)
                    
                    Divider()
                        .background(Color("Black-White"))
                    
                    /**
                     컨텐츠
                     */
                    ScrollView {
                        VStack(spacing: 0) {
                            // 다이어리 및 타임라인
                            VStack(spacing: 0) {
                                GeometryReader { geo in
                                    HStack {
                                        getDateStringViewWith3Lines(date: currentDate)
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
                                

                                VStack(spacing: 0) {
                                    if diary.id < 0 {
                                        VStack(spacing: 64) {
                                            Text("당신이 이 날 무엇을 하고, 그 속에서 어떤 생각과 감정을 느꼈는지 주체적으로 기록해보세요.")
                                                .labelSmall()
                                                .multilineTextAlignment(.center)
                                                .lineSpacing(10)
                                            
                                            Image(systemName: "arrow.down")
                                                .font(.system(size: 16))
                                        }
                                        .frame(maxWidth: .infinity, minHeight: 252) // 제목 높이(20) + 제목 패딩(16) + 내용 높이(200) + 내용 패딩(16)
                                        .padding()
                                    } else {
                                        Text(diary.title)
                                            .bodyLarge()
                                            .frame(maxWidth: .infinity, minHeight: 20, maxHeight: expandDiary ? nil : 20, alignment: .topLeading)
                                            .padding()
                                            .onTapGesture {
                                                if expandDiary == false {
                                                    expandDiary = true
                                                }
                                            }

                                        Text(diary.content)
                                            .bodyMedium()
                                            .frame(maxWidth: .infinity, minHeight: 200, maxHeight: expandDiary ? nil : 200, alignment: .topLeading)
                                            .padding()
                                            .onTapGesture {
                                                if expandDiary == false {
                                                    expandDiary = true
                                                }
                                            }
                                    }
                                }
                                .background(Color("White-Black"))
                                .cornerRadius(8)
                                .shadow(color: Color("Black-White"), radius: 1)
                                .padding(.horizontal)

                                
                                NavigationLink(destination: DiaryView(date: currentDate)) { // 네비게이션 링크안에 HStack(spacing: 8)이 포함되어 있음.
                                    Text("다이어리 수정")
                                        .bodyMedium()
                                        .foregroundColor(Color("AppIndigo"))
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                }
                                .background(Color("AppYellow"))
                                .cornerRadius(80)
                                .padding()
                            }
                            
                            Rectangle()
                                .frame(maxWidth: .infinity, maxHeight: 8)
                                .foregroundColor(Color("LightGray-Gray"))
                            
                            // 합계 기록
                            VStack(spacing: 8) {
                                Text("합계 기록")
                                    .titleMedium()
                                    .padding(.horizontal)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                if wiDList.isEmpty {
                                    getEmptyView(message: "표시할 기록이 없습니다.")
                                } else {
                                    LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
                                        ForEach(Array(totalDurationDictionary), id: \.key) { title, duration in
                                            VStack(spacing: 16) {
                                                HStack {
                                                    Image(systemName: titleImageDictionary[title] ?? "")
                                                        .font(.system(size: 16))
                                                        .frame(maxWidth: 15, maxHeight: 15)
                                                        .padding(8)
                                                        .background(Color(title).overlay(.white.opacity(0.9)))
                                                        .foregroundColor(Color(title))
                                                        .clipShape(Circle())
                                                    
                                                    Text(titleDictionary[title] ?? "")
                                                        .font(.system(size: 24, weight: .bold))
                                                }
                                                .frame(maxWidth: .infinity)
                                                
                                                Text(getDurationString(duration, mode: 3))
                                                    .bodyMedium()
                                                    .frame(maxWidth: .infinity)
                                            }
                                            .padding(.vertical)
                                            .frame(maxWidth: .infinity)
                                            .background(Color("White-Black"))
                                            .cornerRadius(8)
                                            .shadow(color: Color("Black-White"), radius: 1)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            .padding(.vertical)
                            
                            Rectangle()
                                .frame(maxWidth: .infinity, maxHeight: 8)
                                .foregroundColor(Color("LightGray-Gray"))
                            
                            // WiD 리스트
                            VStack(spacing: 8) {
                                Text("WiD 리스트")
                                    .titleMedium()
                                    .padding(.horizontal)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                if wiDList.isEmpty {
                                    getEmptyView(message: "표시할 WiD가 없습니다.")
                                } else {
                                    ForEach(Array(wiDList), id: \.id) { wiD in
                                        HStack(spacing: 8) {
                                            Rectangle()
                                                .fill(Color(wiD.title))
                                                .frame(maxWidth: 8)
                                            
                                            NavigationLink(destination: WiDView(clickedWiDId: wiD.id)) {
                                                VStack(alignment: .leading, spacing: 4) {
                                                    Text("\(getTimeString(wiD.start)) ~ \(getTimeString(wiD.finish))")
                                                        .bodyMedium()
                                                    
                                                    Text("\(titleDictionary[wiD.title] ?? "") • \(getDurationString(wiD.duration, mode: 3))")
                                                        .bodyMedium()
                                                }
                                                .padding()
                                                
                                                Spacer()
                                                
                                                Image(systemName: "chevron.forward")
                                                    .font(.system(size: 16))
                                                    .padding()
                                            }
                                            .tint(Color("Black-White")) // 네비게이션 링크 때문에 전경색이 바뀌어서, 틴트 색상 명시적으로 설명해줌.
                                            .background(Color("White-Black"))
                                            .cornerRadius(8)
                                            .shadow(color: Color("Black-White"), radius: 1)
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                            }
                            .padding(.vertical)
                        }
                    }
                    
                    Divider()
                        .background(Color("Black-White"))
                    
                    /**
                     하단 바
                     */
                    HStack(spacing: 0) {
                        Button(action: {
                            withAnimation {
                                expandDatePicker.toggle()
                            }
                        }) {
                            Image(systemName: "calendar")
                                .font(.system(size: 24))
                                .frame(width: 30, height: 30)
                        }
                        .frame(maxWidth: .infinity)
                        .tint(Color("Black-White"))
                        
                        Button(action: {
                        }) {
                            Image(systemName: titleImageDictionary[TitleWithALL.ALL.rawValue] ?? "")
                                .font(.system(size: 24))
                                .frame(width: 30, height: 30)
                        }
                        .frame(maxWidth: .infinity)
                        .disabled(true)
                        
                        Button(action: {
                            withAnimation {
                                currentDate = Date()
                            }
                        }) {
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 24))
                                .frame(width: 30, height: 30)
                        }
                        .frame(maxWidth: .infinity)
                        .tint(Color("Black-White"))
                        .disabled(calendar.isDateInToday(currentDate))
                        
                        Button(action: {
                            withAnimation {
                                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
                            }
                        }) {
                            Image(systemName: "chevron.backward")
                                .font(.system(size: 24))
                                .frame(width: 30, height: 30)
                        }
                        .frame(maxWidth: .infinity)
                        .tint(Color("Black-White"))
                        
                        Button(action: {
                            withAnimation {
                                currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
                            }
                        }) {
                            Image(systemName: "chevron.forward")
                                .font(.system(size: 24))
                                .frame(width: 30, height: 30)
                        }
                        .frame(maxWidth: .infinity)
                        .tint(Color("Black-White"))
                        .disabled(calendar.isDateInToday(currentDate))
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
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
        }
        .navigationBarHidden(true)
        .onAppear {
            self.wiDList = wiDService.readWiDListByDate(date: currentDate)
            self.totalDurationDictionary = getTotalDurationDictionaryByTitle(wiDList: wiDList)
            self.diary = diaryService.readDiaryByDate(date: currentDate) ?? Diary(id: -1, date: Date(), title: "", content: "")
        }
        .onChange(of: currentDate) { newDate in
            withAnimation {
                wiDList = wiDService.readWiDListByDate(date: newDate)
                totalDurationDictionary = getTotalDurationDictionaryByTitle(wiDList: wiDList)
                diary = diaryService.readDiaryByDate(date: newDate) ?? Diary(id: -1, date: Date(), title: "", content: "")
            }
        }
    }
}

struct DateBasedView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DateBasedView()
            
            DateBasedView()
                .environment(\.colorScheme, .dark)
        }
    }
}
