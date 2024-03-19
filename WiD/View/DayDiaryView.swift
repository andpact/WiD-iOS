//
//  DayDiaryView.swift
//  WiD
//
//  Created by jjkim on 2024/02/06.
//

import SwiftUI

struct DayDiaryView: View {
    // 뷰 모델
    @EnvironmentObject var dayDiaryViewModel: DayDiaryViewModel
    
    // 날짜
    private let today = Date()
    private let calendar = Calendar.current
    @State private var expandDatePicker: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack(spacing: 16) {
                    NavigationLink(destination: DiaryDetailView(date: dayDiaryViewModel.currentDate)) { // 네비게이션 링크안에 HStack(spacing: 8)이 포함되어 있음.
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
                        let newDate = calendar.date(byAdding: .day, value: -1, to: dayDiaryViewModel.currentDate)!
                        
                        dayDiaryViewModel.setCurrentDate(to: newDate)
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 24))
                            .frame(maxWidth: 24, maxHeight: 24)
                    }

                    Button(action: {
                        let newDate = calendar.date(byAdding: .day, value: 1, to: dayDiaryViewModel.currentDate)!
                        
                        dayDiaryViewModel.setCurrentDate(to: newDate)
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 24))
                            .frame(maxWidth: 24, maxHeight: 24)
                    }
                    .disabled(calendar.isDateInToday(dayDiaryViewModel.currentDate))
                }
                .frame(maxHeight: 44)
                .padding(.horizontal)
                
                ScrollView {
                    VStack(spacing: 16) {
                        HStack(spacing: 0) {
                            getDateStringViewWith3Lines(date: dayDiaryViewModel.currentDate)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .font(.system(size: 22, weight: .bold))
                                .onTapGesture {
                                    expandDatePicker = true
                                }

                            ZStack {
                                    if dayDiaryViewModel.wiDList.isEmpty {
                                        getEmptyViewWithMultipleLines(message: "표시할\n타임라인이\n없습니다.")
                                    } else {
                                        DiaryPieChartView(wiDList: dayDiaryViewModel.wiDList)
                                    }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        .aspectRatio(2.5 / 1, contentMode: .fit)
                        .padding(.horizontal)
                        
                        
//                        Rectangle()
//                            .frame(maxHeight: 1)
//                            .foregroundColor(Color("Black-White"))
//                            .padding(.horizontal)

                        VStack(spacing: 16) {
                            if dayDiaryViewModel.diary.id < 0 { // 다이어리가 없을 때
                                Text("당신이 이 날 무엇을 하고,\n그 속에서 어떤 생각과 감정을 느꼈는지\n주체적으로 기록해보세요.")
                                    .bodyMedium()
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(10)
                                    .padding(.vertical, 80)
                            } else {
                                Text(dayDiaryViewModel.diary.title)
                                    .bodyLarge()
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                Text(dayDiaryViewModel.diary.content)
                                    .bodyLarge()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
    
            /**
             대화 상자
             */
            if expandDatePicker {
                ZStack {
                    Color("Transparent")
                        .contentShape(Rectangle())
                        .onTapGesture {
                            expandDatePicker = false
                        }

                    // 날짜 선택
                    if expandDatePicker {
                        DatePicker("", selection: $dayDiaryViewModel.currentDate, in: ...today, displayedComponents: .date)
                            .datePickerStyle(.graphical)
                            .padding() // 안쪽 패딩
                            .background(Color("LightGray-Gray"))
                            .cornerRadius(8)
                            .padding() // 바깥 패딩
                            .shadow(color: Color("Black-White"), radius: 1)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarHidden(true)
        .tint(Color("Black-White"))
        .background(Color("White-Black"))
        .onAppear {
            print("DayDiaryView appeared")
            
            // 다이어리 수정이 화면에 반영되도록.
            dayDiaryViewModel.setCurrentDate(to: dayDiaryViewModel.currentDate)
        }
        .onDisappear {
            print("DayDiaryView disappeared")
        }
    }
}

struct DayDiaryView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DayDiaryView()
                .environment(\.colorScheme, .light)
                .environmentObject(DayDiaryViewModel())
            
            DayDiaryView()
                .environment(\.colorScheme, .dark)
                .environmentObject(DayDiaryViewModel())
        }
    }
}
