//
//  WiDListView.swift
//  WiD
//
//  Created by jjkim on 2024/02/06.
//

import SwiftUI

struct WiDListView: View {
    // 뷰 모델
    @EnvironmentObject var wiDListViewModel: WiDListViewModel
    
    // WiD
//    private let wiDService = WiDService()
//    @State private var wiDList: [WiD] = []
//    @State private var fullWiDList: [WiD] = []
    
    // 날짜
//    private let now = Date()
    private let today = Date()
    private let calendar = Calendar.current
//    @State private var currentDate: Date = Date()
    @State private var datePickerExpanded: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack(spacing: 16) {
                    Button(action: {
                        datePickerExpanded = true
                    }) {
                        getDateStringView(date: wiDListViewModel.currentDate)
                            .titleLarge()
                    }
                    
                    Spacer()
                    
                    Button(action: {
//                        self.currentDate = calendar.date(byAdding: .day, value: -1, to: self.currentDate)!
//                        wiDListViewModel.currentDate = calendar.date(byAdding: .day, value: -1, to: wiDListViewModel.currentDate)!
                        let newDate = calendar.date(byAdding: .day, value: -1, to: wiDListViewModel.currentDate)!
                        wiDListViewModel.setCurrentDate(to: newDate)
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 24))
                            .frame(width: 24, height: 24)
                    }

                    Button(action: {
//                        self.currentDate = calendar.date(byAdding: .day, value: 1, to: self.currentDate)!
//                        wiDListViewModel.currentDate = calendar.date(byAdding: .day, value: 1, to: wiDListViewModel.currentDate)!
                        let newDate = calendar.date(byAdding: .day, value: 1, to: wiDListViewModel.currentDate)!
                        wiDListViewModel.setCurrentDate(to: newDate)
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 24))
                            .frame(width: 24, height: 24)
                    }
//                    .disabled(calendar.isDateInToday(currentDate))
                    .disabled(calendar.isDateInToday(wiDListViewModel.currentDate))
                }
                .frame(maxHeight: 44)
                .padding(.horizontal)
            
                if wiDListViewModel.fullWiDList.isEmpty {
                    VStack(spacing: 16) {
                        Text("표시할\nWiD가\n없습니다.")
                            .bodyLarge()
                            .lineSpacing(10)
                            .multilineTextAlignment(.center)
                        
//                        NavigationLink(destination: NewWiDView(date: currentDate)) {
                        NavigationLink(destination: NewWiDView(date: wiDListViewModel.currentDate)) {
                            Text("새로운 WiD 만들기")
                                .bodyMedium()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 16))
                        }
                        .foregroundColor(Color("DeepSkyBlue"))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 8) {
                                Text(getTimeString(wiDListViewModel.fullWiDList.first!.start))
                                    .bodyMedium()
                             
                                Rectangle()
                                    .frame(maxHeight: 1)
                                    .foregroundColor(Color("Black-White"))
                            }
                            .padding(.horizontal)
                            
                            ForEach(Array(wiDListViewModel.fullWiDList), id: \.id) { wiD in
                                VStack(alignment: .leading, spacing: 8) {
                                    if 0 < wiD.id { // WiD
                                        NavigationLink(destination: WiDDetailView(clickedWiDId: wiD.id)) {
                                            HStack(spacing: 8) {
                                                Image(systemName: titleImageDictionary[wiD.title] ?? "")
                                                    .font(.system(size: 24))
                                                    .frame(maxWidth: 15, maxHeight: 15)
                                                    .padding()
                                                    .background(Color("White-Black"))
                                                    .clipShape(Circle())
                                                
                                                VStack(alignment: .leading, spacing: 4) { // 내용물이 앞쪽 정렬됨.
                                                    Text(titleDictionary[wiD.title] ?? "기록 없음")
                                                        .bodyMedium()
                                                    
                                                    Text(getDurationString(wiD.duration, mode: 3))
                                                        .bodyMedium()
                                                }
                                                .frame(maxWidth: .infinity, alignment: .leading) // 프레임의 내용물이 앞쪽부터 채워짐.
                                                
                                                Image(systemName: "chevron.forward")
                                                    .font(.system(size: 16))
                                            }
                                            .padding()
                                            .background(Color(wiD.title))
                                            .cornerRadius(8)
                                            .padding(.horizontal)
                                        }
                                        
                                        HStack(spacing: 8) {
                                            Text(getTimeString(wiD.finish))
                                                .bodyMedium()
                                            
                                            Rectangle()
                                                .frame(maxHeight: 1)
                                                .foregroundColor(Color("Black-White"))
                                        }
                                        .padding(.horizontal)
                                    } else { // Empty WiD
//                                        NavigationLink(destination: NewWiDView(date: currentDate, start: wiD.start, finish: wiD.finish, duration: wiD.finish.timeIntervalSince(wiD.start))) {
                                        NavigationLink(destination: NewWiDView(date: wiDListViewModel.currentDate, start: wiD.start, finish: wiD.finish, duration: wiD.finish.timeIntervalSince(wiD.start))) {
                                            HStack(spacing: 8) {
                                                Image(systemName: "textformat")
                                                    .font(.system(size: 24))
                                                    .frame(maxWidth: 15, maxHeight: 15)
                                                    .padding()
                                                    .background(Color("White-Black"))
                                                    .clipShape(Circle())
//                                                    .background(
//                                                        Circle()
//                                                            .stroke(Color("Black-White"), lineWidth: 0.5)
//                                                    )
                                                
                                                VStack(alignment: .leading, spacing: 4) {
                                                    Text(titleDictionary[wiD.title] ?? "기록 없음")
                                                        .bodyMedium()
                                                    
                                                    Text(getDurationString(wiD.duration, mode: 3))
                                                        .bodyMedium()
                                                }
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                
                                                Image(systemName: "chevron.forward")
                                                    .font(.system(size: 16))
                                            }
                                            .padding()
                                            .background(Color("LightGray-Gray"))
                                            .cornerRadius(8)
//                                            .background(
//                                                RoundedRectangle(cornerRadius: 8)
//                                                    .stroke(Color("Black-White"), lineWidth: 0.5)
//                                            )
                                            .padding(.horizontal)
                                        }
                                        
                                        HStack(spacing: 8) {
                                            Text(getTimeString(wiD.finish))
                                                .bodyMedium()
                                            
                                            Rectangle()
                                                .frame(maxHeight: 1)
                                                .foregroundColor(Color("Black-White"))
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            if datePickerExpanded {
                ZStack {
                    Color("Black-White")
                        .opacity(0.3)
                        .onTapGesture {
                            datePickerExpanded = false
                        }

                    VStack(spacing: 0) {
//                        ZStack {
//                            Button(action: {
//                                datePickerExpanded = false
//                            }) {
//                                Text("확인")
//                                    .bodyMedium()
//                            }
//                            .frame(maxWidth: .infinity, alignment: .trailing)
//
//                            Text("날짜 선택")
//                                .titleMedium()
//                        }
//                        .padding()
//
//                        Divider()
//                            .background(Color("Black-White"))

//                        DatePicker("", selection: $currentDate, in: ...today, displayedComponents: .date)
                        DatePicker("", selection: $wiDListViewModel.currentDate, in: ...today, displayedComponents: .date)
                            .datePickerStyle(.graphical)
                            .padding()
                            .onChange(of: wiDListViewModel.currentDate) { newDate in
                                wiDListViewModel.setCurrentDate(to: wiDListViewModel.currentDate)
                            }
                    }
                    .background(Color("White-Black"))
                    .cornerRadius(8)
                    .padding() // 바깥 패딩
//                    .shadow(color: Color("Black-White"), radius: 1)
                }
                .edgesIgnoringSafeArea(.all)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("White-Black"))
        .tint(Color("Black-White"))
        .navigationBarHidden(true)
//        .onAppear {
//            // WiD 생성 후 돌아왔을 때, WiDList가 갱신되도록.
//            wiDListViewModel.setCurrentDate(to: wiDListViewModel.currentDate)
//        }
    }
}

struct WiDListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WiDListView()
                .environment(\.colorScheme, .light)
                .environmentObject(WiDListViewModel())
            
            WiDListView()
                .environment(\.colorScheme, .dark)
                .environmentObject(WiDListViewModel())
        }
    }
}