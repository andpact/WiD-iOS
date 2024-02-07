//
//  WiDReadView.swift
//  WiD
//
//  Created by jjkim on 2023/07/08.
//

import SwiftUI

struct DayWiDView: View {
    // 화면
    @Environment(\.presentationMode) var presentationMode
    
    // WiD
    private let wiDService = WiDService()
    @State private var wiDList: [WiD] = []
    
    // 합계
    @State private var totalDurationDictionary: [String: TimeInterval] = [:]
    
    // 날짜
    private let today = Date()
    private let calendar = Calendar.current
    @State private var currentDate: Date = Date()
    @State private var expandDatePicker: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) { // spacing: 0일 때, 상단 바에 그림자를 적용시키면 컨텐츠가 상단 바의 그림자를 덮어서 가림. (상단 바가 렌더링 된 후, 컨텐츠가 렌더링되기 때문)
                getDateStringView(date: currentDate)
                    .titleLarge()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                /**
                 컨텐츠
                 */
                ScrollView {
                    VStack(spacing: 0) {
                        DatePieChartView(wiDList: wiDList)
                            .padding()
                        
                        // 합계 기록
                        if wiDList.isEmpty {
                            getEmptyView(message: "표시할 기록이 없습니다.")
                        } else {
                            ForEach(Array(totalDurationDictionary), id: \.key) { title, duration in
                                HStack {
                                    Image(systemName: titleImageDictionary[title] ?? "")
                                        .font(.system(size: 24))
                                        .frame(maxWidth: 15, maxHeight: 15)
                                        .padding()
                                        .background(Color("White-Black"))
                                        .clipShape(Circle())

                                    Text(titleDictionary[title] ?? "")
                                        .titleLarge()
                                    
                                    Spacer()
                                    
                                    Text(getDurationString(duration, mode: 3))
                                        .titleLarge()
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(title))
                                .cornerRadius(8)
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                
                /**
                 하단 바
                 */
                HStack(spacing: 16) {
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
                    
                    Button(action: {
                        withAnimation {
                            currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
                        }
                    }) {
                        Image(systemName: "chevron.backward")
                            .font(.system(size: 24))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(Color("AppYellow-AppIndigo"))
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        withAnimation {
                            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
                        }
                    }) {
                        Image(systemName: "chevron.forward")
                            .font(.system(size: 24))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(calendar.isDateInToday(currentDate) ? Color("DarkGray") : Color("AppYellow-AppIndigo"))
                            .cornerRadius(8)
                    }
                    .disabled(calendar.isDateInToday(currentDate))
                }
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            /**
             대화 상자
             */
//            if expandDatePicker {
//                ZStack {
//                    Color("Black-White")
//                        .opacity(0.3)
//                        .onTapGesture {
//                            expandDatePicker = false
//                        }
//
//                    // 날짜 선택
//                    VStack(spacing: 0) {
//                        ZStack {
//                            Text("날짜 선택")
//                                .titleMedium()
//
//                            Button(action: {
//                                expandDatePicker = false
//                            }) {
//                                Text("확인")
//                                    .bodyMedium()
//                            }
//                            .frame(maxWidth: .infinity, alignment: .trailing)
//                            .tint(Color("Black-White"))
//                        }
//                        .padding()
//
//                        Divider()
//                            .background(Color("Black-White"))
//
//                        DatePicker("", selection: $currentDate, in: ...today, displayedComponents: .date)
//                            .datePickerStyle(.graphical)
//                            .padding()
//                    }
//                    .background(Color("White-Black"))
//                    .cornerRadius(8)
//                    .padding() // 바깥 패딩
//                    .shadow(color: Color("Black-White"), radius: 1)
//                }
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .edgesIgnoringSafeArea(.all)
//            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .tint(Color("Black-White"))
        .navigationBarHidden(true)
        .onAppear {
            self.wiDList = wiDService.readWiDListByDate(date: currentDate)
            self.totalDurationDictionary = getTotalDurationDictionaryByTitle(wiDList: wiDList)
        }
        .onChange(of: currentDate) { newDate in
            withAnimation {
                wiDList = wiDService.readWiDListByDate(date: newDate)
                totalDurationDictionary = getTotalDurationDictionaryByTitle(wiDList: wiDList)
            }
        }
    }
}

struct DateBasedView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DayWiDView()
            
            DayWiDView()
                .environment(\.colorScheme, .dark)
        }
    }
}
