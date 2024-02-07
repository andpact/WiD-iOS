//
//  WiDListView.swift
//  WiD
//
//  Created by jjkim on 2024/02/06.
//

import SwiftUI

struct WiDListView: View {
    // WiD
    private let wiDService = WiDService()
    @State private var wiDList: [WiD] = []
    
    // 날짜
    private let today = Date()
    private let calendar = Calendar.current
    @State private var currentDate: Date = Date()
    @State private var expandDatePicker: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                getDateStringView(date: currentDate)
                    .titleLarge()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            
                if wiDList.isEmpty {
                    VStack {
                        Text("표시할 WiD가 없습니다.")
                        
                        Button(action: {
                            // WiDDetailView로 이동
                        }) {
                            Text("WiD 새로 만들기")
                                .bodyMedium()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 16))
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
//                        .background(Color("AppIndigo"))
//                        .foregroundColor(Color("White"))
//                        .cornerRadius(8)
//                        .background(
//                            RoundedRectangle(cornerRadius: 8)
//                                .stroke(Color("Black-White"), lineWidth: 1)
//                        )
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        VStack(spacing: 8) {
                            ForEach(Array(wiDList), id: \.id) { wiD in
                                HStack(spacing: 8) {
                                    Rectangle()
                                        .fill(Color(wiD.title))
                                        .frame(maxWidth: 8)
                                    
                                    NavigationLink(destination: WiDDetailView(clickedWiDId: wiD.id)) {
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
                }
            }
            
            /**
             하단 바
             */
            HStack(spacing: 16) {
//                Button(action: {
//                    withAnimation {
//                        expandDatePicker.toggle()
//                    }
//                }) {
//                    Image(systemName: "calendar")
//                        .font(.system(size: 20))
//
//                    Text("날짜 선택")
//                        .bodyMedium()
//                }
//                .padding(.horizontal)
//                .padding(.vertical, 8)
//                .background(Color("AppIndigo"))
//                .foregroundColor(Color("White"))
//                .cornerRadius(8)
//
//                Spacer()
//
//                Button(action: {
//                    withAnimation {
//                        currentDate = Date()
//                    }
//                }) {
//                    Image(systemName: "arrow.clockwise")
//                        .font(.system(size: 24))
//                        .frame(width: 30, height: 30)
//                }
//                .disabled(calendar.isDateInToday(currentDate))
                
                Button(action: {
                    withAnimation {
                        currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
                    }
                }) {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 24))
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .background(Color("AppYellow-AppIndigo")) // 클릭 용 배경
                        .cornerRadius(8)
//                        .padding()
                }
                
                Button(action: {
                    withAnimation {
                        currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
                    }
                }) {
                    Image(systemName: "chevron.forward")
                        .font(.system(size: 24))
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .background(calendar.isDateInToday(currentDate) ? Color("DarkGray") : Color("AppYellow-AppIndigo")) // 클릭 용 배경
                        .cornerRadius(8)
//                        .padding()
                }
                .disabled(calendar.isDateInToday(currentDate))
            }
            .tint(Color("Black-White"))
            .padding()
            
//            if expandDatePicker {
//                ZStack {
//                    Color("Black-White")
//                        .opacity(0.3)
//                        .onTapGesture {
//                            expandDatePicker = false
//                        }
//
//                    VStack(spacing: 0) {
//                        ZStack {
//                            Button(action: {
//                                expandDatePicker = false
//                            }) {
//                                Text("확인")
//                                    .bodyMedium()
//                            }
//                            .frame(maxWidth: .infinity, alignment: .trailing)
//                            .tint(Color("Black-White"))
//
//                            Text("날짜 선택")
//                                .titleMedium()
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
//                .edgesIgnoringSafeArea(.all)
//            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarHidden(true)
        .onAppear {
            self.wiDList = wiDService.readWiDListByDate(date: currentDate)
        }
        .onChange(of: currentDate) { newDate in
            withAnimation {
                wiDList = wiDService.readWiDListByDate(date: newDate)
            }
        }
    }
}

struct WiDListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WiDListView()
                .environment(\.colorScheme, .light)
            
            WiDListView()
                .environment(\.colorScheme, .dark)
        }
    }
}
