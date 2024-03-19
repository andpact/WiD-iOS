//
//  WiDReadView.swift
//  WiD
//
//  Created by jjkim on 2023/07/08.
//

import SwiftUI

struct DayWiDView: View {
    // 뷰 모델
    @EnvironmentObject var dayWiDViewModel: DayWiDViewModel
    
    // 날짜
    private let today = Date()
    private let calendar = Calendar.current
    @State private var expandDatePicker: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) { // spacing: 0일 때, 상단 바에 그림자를 적용시키면 컨텐츠가 상단 바의 그림자를 덮어서 가림. (상단 바가 렌더링 된 후, 컨텐츠가 렌더링되기 때문)
                // 상단 탭
                HStack(spacing: 24) {
                    Button(action: {
                        expandDatePicker = true
                    }) {
                        getDateStringView(date: dayWiDViewModel.currentDate)
                            .titleLarge()
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        let newDate = calendar.date(byAdding: .day, value: -1, to: dayWiDViewModel.currentDate)!
                        dayWiDViewModel.setCurrentDate(to: newDate)
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 24))
                            .frame(width: 24, height: 24)
                    }

                    Button(action: {
                        let newDate = calendar.date(byAdding: .day, value: 1, to: dayWiDViewModel.currentDate)!
                        dayWiDViewModel.setCurrentDate(to: newDate)
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 24))
                            .frame(width: 24, height: 24)
                    }
                    .disabled(calendar.isDateInToday(dayWiDViewModel.currentDate))
                }
                .frame(maxHeight: 44)
                .padding(.horizontal)
                
                /**
                 컨텐츠
                 */
                
                VStack(spacing: 0) {
                    // 합계 기록
                    if dayWiDViewModel.wiDList.isEmpty {
                        Text("표시할 기록이 없습니다.")
                            .bodyLarge()
                    } else {
                        ScrollView {
                            DatePieChartView(wiDList: dayWiDViewModel.wiDList)
                                .aspectRatio(contentMode: .fit)
                                .padding()
                            
                            ForEach(Array(dayWiDViewModel.totalDurationDictionary), id: \.key) { title, duration in
                                HStack(spacing: 8) {
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
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
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
                    DatePicker("", selection: $dayWiDViewModel.currentDate, in: ...today, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .padding()
                        .background(Color("LightGray-Gray"))
                        .cornerRadius(8)
                        .padding() // 바깥 패딩
                        .shadow(color: Color("Black-White"), radius: 1)
                        .onChange(of: dayWiDViewModel.currentDate) { newDate in
                            dayWiDViewModel.setCurrentDate(to: dayWiDViewModel.currentDate)
                        }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .tint(Color("Black-White"))
        .background(Color("White-Black"))
//        .navigationBarHidden(true)
        .onAppear {
            print("DayWiDView appeared")
            
            dayWiDViewModel.setCurrentDate(to: dayWiDViewModel.currentDate)
        }
        .onDisappear {
            print("DayWiDView disappeared")
        }
    }
}

struct DateBasedView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DayWiDView()
                .environmentObject(DayWiDViewModel())
                .environment(\.colorScheme, .light)
            
            DayWiDView()
                .environmentObject(DayWiDViewModel())
                .environment(\.colorScheme, .dark)
        }
    }
}
