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
            VStack(spacing: 0) { // spacing: 0일 때, 상단 바에 그림자를 적용시키면 컨텐츠가 상단 바의 그림자를 덮어서 가림. (상단 바가 렌더링 된 후, 컨텐츠가 렌더링되기 때문)
                /**
                 상단 바
                 */
                ZStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.backward")
                            .imageScale(.large)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .tint(Color("Black-White"))

                    Text("날짜 별 조회")
                        .titleLarge()
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity, maxHeight: 44)
                .background(Color("White-Black"))
                
                Divider()
                    .background(Color("LightGray"))
                
                /**
                 컨텐츠
                 */
                ScrollView {
                    VStack(spacing: 8) {
                        // 다이어리 및 타임라인
                        VStack(spacing: 0) {
                            GeometryReader { geo in
                                HStack {
                                    getDayStringWith3Lines(date: currentDate)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .font(.system(size: 22, weight: .bold))

                                    ZStack {
                                        if wiDList.isEmpty {
                                            getEmptyViewWithMultipleLines(message: "표시할\n타임라인이\n없습니다.")
                                        } else {
                                            DayPieChartView(wiDList: wiDList)
                                        }
                                    }
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                }
                            }
                            .aspectRatio(2 / 1, contentMode: .fit)

                            Divider()
                                .background(Color("LightGray"))
                                .padding(.horizontal)
                                

                            VStack(spacing: 16) {
                                Text((diary.id < 0 ? "제목을 입력해 주세요." : diary.title))
                                    .bodyMedium()
                                    .frame(maxWidth: .infinity, minHeight: 20, maxHeight: expandDiary ? nil : 20, alignment: .topLeading)
                                    .onTapGesture {
                                        if expandDiary == false {
                                            expandDiary = true
                                        }
                                    }

                                Divider()
                                    .background(Color("LightGray"))

                                Text(diary.id < 0 ? "내용을 입력해 주세요." : diary.content)
                                    .bodyMedium()
                                    .frame(maxWidth: .infinity, minHeight: 200, maxHeight: expandDiary ? nil : 200, alignment: .topLeading)
                                    .onTapGesture {
                                        if expandDiary == false {
                                            expandDiary = true
                                        }
                                    }
                            }
                            .padding()

                            Button(action: {

                            }) {
                                NavigationLink(destination: DiaryView(date: currentDate)) {
                                    Text("다이어리 수정")
                                        .bodyMedium()
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                }
                            }
                            .background(Color("DeepSkyBlue"))
                            .cornerRadius(8)
                            .padding()
                        }
                        .background(Color("White-Black"))
                        
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
                                                    .frame(maxWidth: 15, maxHeight: 15)
                                                    .padding(8)
                                                    .background(Color(title).overlay(.white.opacity(0.9)))
                                                    .foregroundColor(Color(title))
                                                    .clipShape(Circle())
                                                
                                                Text(titleDictionary[title] ?? "")
                                                    .font(.system(size: 24, weight: .bold))
                                            }
                                            .frame(maxWidth: .infinity)
                                            
                                            Text(formatDuration(duration, mode: 3))
                                                .bodyMedium()
                                                .frame(maxWidth: .infinity)
                                        }
                                        .padding(.vertical)
                                        .frame(maxWidth: .infinity)
                                        .background(Color("LightGray-Gray"))
                                        .cornerRadius(8)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.vertical)
                        .background(Color("White-Black"))
                        
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
                                    NavigationLink(destination: WiDView(clickedWiDId: wiD.id)) {
                                        HStack(spacing: 16) {
                                            Rectangle()
                                                .fill(Color(wiD.title))
                                                .frame(maxWidth: 8)
                                            
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text("\(titleDictionary[wiD.title] ?? "") • \(formatDuration(wiD.duration, mode: 3))")
                                                    .bodyMedium()
                                                
                                                Text("\(formatTime(wiD.start)) ~ \(formatTime(wiD.finish))")
                                                    .labelMedium()
                                            }
                                            .padding(.vertical)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.forward")
                                                .padding(.horizontal)
                                        }
                                        .background(Color("LightGray-Gray"))
                                        .tint(Color("Black-White")) // 네비게이션 링크 때문에 전경색이 바뀌어서, 틴트 색상 명시적으로 설명해줌.
                                        .cornerRadius(8)
                                        .padding(.horizontal)
                                    }
                                }
                            }
                        }
                        .padding(.vertical)
                        .background(Color("White-Black")) // 부모 뷰에 배경을 지정했기 때문에, 기본 적용되는 "White-Black"을 명시적으로 적용함.
                    }
                }
                .background(Color("LightGray-Gray"))
                
                Divider()
                    .background(Color("LightGray"))
                
                /**
                 하단 바
                 */
                VStack(spacing: 8) {
                    if expandDatePicker {
                        HStack {
                            Text("날짜를 선택해 주세요.")
                                .bodyMedium()
                            
                            Spacer()
                            
                            DatePicker("", selection: $currentDate, in: ...today, displayedComponents: .date)
                                .labelsHidden()
                                .tint(Color("Black"))
                        }
                        .padding(8)
                    }
                    
                    HStack {
                        Button(action: {
                            withAnimation {
                                expandDatePicker.toggle()
                            }
                        }) {
                            Image(systemName: "calendar")
                                .imageScale(.large)
                        }
                        .frame(maxWidth: .infinity)
                        .tint(Color("Black-White"))
                        
                        Spacer()
                            .frame(maxWidth: .infinity)
                        
                        Button(action: {
                            withAnimation {
                                currentDate = Date()
                            }
                        }) {
                            Image(systemName: "arrow.clockwise")
                                .imageScale(.large)
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
                                .imageScale(.large)
                        }
                        .frame(maxWidth: .infinity)
                        .tint(Color("Black-White"))
                        
                        Button(action: {
                            withAnimation {
                                currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
                            }
                        }) {
                            Image(systemName: "chevron.forward")
                                .imageScale(.large)
                        }
                        .frame(maxWidth: .infinity)
                        .tint(Color("Black-White"))
                        .disabled(calendar.isDateInToday(currentDate))
                    }
                }
                .padding()
                .background(Color("White-Black"))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                self.wiDList = wiDService.selectWiDListByDate(date: currentDate)
                self.totalDurationDictionary = getTotalDurationDictionaryByTitle(wiDList: wiDList)
                self.diary = diaryService.selectDiaryByDate(date: currentDate) ?? Diary(id: -1, date: Date(), title: "", content: "")
            }
            .onChange(of: currentDate) { newDate in
                withAnimation {
                    wiDList = wiDService.selectWiDListByDate(date: newDate)
                    totalDurationDictionary = getTotalDurationDictionaryByTitle(wiDList: wiDList)
                    diary = diaryService.selectDiaryByDate(date: newDate) ?? Diary(id: -1, date: Date(), title: "", content: "")
                }
            }
        }
        .navigationBarHidden(true)
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
