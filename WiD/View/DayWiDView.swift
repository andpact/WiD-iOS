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
                HStack(spacing: 16) {
                    Button(action: {
                        expandDatePicker = true
                    }) {
                        getDateStringView(date: currentDate)
                            .titleLarge()
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        self.currentDate = calendar.date(byAdding: .day, value: -1, to: self.currentDate)!
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 24))
                            .frame(width: 24, height: 24)
                    }

                    Button(action: {
                        self.currentDate = calendar.date(byAdding: .day, value: 1, to: self.currentDate)!
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 24))
                            .frame(width: 24, height: 24)
                    }
                    .disabled(calendar.isDateInToday(currentDate))
                }
                .frame(maxHeight: 44)
                .padding()
                
                /**
                 컨텐츠
                 */
                
                VStack(spacing: 0) {
                    // 합계 기록
                    if wiDList.isEmpty {
//                        getEmptyView(message: "표시할 기록이 없습니다.")

                        Text("표시할\n기록이\n없습니다.")
                            .bodyLarge()
                            .lineSpacing(10)
                            .multilineTextAlignment(.center)
                    } else {
                        ScrollView {
//                            DatePieChartView(wiDList: wiDList)
//                                .padding()
                            
                            GeometryReader { geo in
//                                LargePieGraphView(wiDList: wiDList)
                                DatePieChartView(wiDList: wiDList)
//                                LargePieGraphView(wiDList: getRandomWiDList(days: 1))
                                
//                                ForEach(1...24, id: \.self) { number in
//                                    let adjustedNumber = (number - 1) % 12 + 1
//                                    let numberTextangle = getAngle(for: number)
//                                    let numberTextRadius = geo.size.width * 0.41 // 텍스트가 표시되는 원의 반지름
//
//                                    let x = cos(numberTextangle.radians) * numberTextRadius
//                                    let y = sin(numberTextangle.radians) * numberTextRadius
//
//                                    Text("\(adjustedNumber)")
//                                        .font(.system(size: geo.size.width / 15, weight: .medium))
//                                        .position(x: geo.size.width / 2 + x, y: geo.size.width / 2 + y)
////                                        .foregroundColor(Color("Black-White"))
//                                }
                                
//                                Circle()
//                                    .stroke(Color("Black-White"), lineWidth: 1.5) // 원의 테두리 색상과 두께 설정
//                                    .frame(width: geo.size.width * 0.91, height: geo.size.width * 0.91) // 원의 크기 설정
//                                    .position(x: geo.size.width / 2, y: geo.size.height / 2) // 원의 위치 설정
//                                
//                                Circle()
//                                    .stroke(Color("Black-White"), lineWidth: 1.5) // 원의 테두리 색상과 두께 설정
//                                    .frame(width: geo.size.width * 0.73, height: geo.size.width * 0.73) // 원의 크기 설정
//                                    .position(x: geo.size.width / 2, y: geo.size.height / 2) // 원의 위치 설정
                            }
                            .aspectRatio(contentMode: .fit)
                            .padding(.horizontal, 32)
                            .padding()
                            
                            ForEach(Array(totalDurationDictionary), id: \.key) { title, duration in
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
                    Color("Black-White")
                        .opacity(0.3)
                        .onTapGesture {
                            expandDatePicker = false
                        }

                    // 날짜 선택
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
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .tint(Color("Black-White"))
//        .background(Color("White-Gray"))
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
