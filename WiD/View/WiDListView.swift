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
    
    // 날짜
    private let today = Date()
    private let calendar = Calendar.current
    @State private var datePickerExpanded: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack(spacing: 24) {
                    Button(action: {
                        datePickerExpanded = true
                    }) {
                        getDateStringView(date: wiDListViewModel.currentDate)
                            .titleLarge()
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        let newDate = calendar.date(byAdding: .day, value: -1, to: wiDListViewModel.currentDate)!
                        wiDListViewModel.setCurrentDate(to: newDate)
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 24))
                            .frame(width: 24, height: 24)
                    }

                    Button(action: {
                        let newDate = calendar.date(byAdding: .day, value: 1, to: wiDListViewModel.currentDate)!
                        wiDListViewModel.setCurrentDate(to: newDate)
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 24))
                            .frame(width: 24, height: 24)
                    }
                    .disabled(calendar.isDateInToday(wiDListViewModel.currentDate))
                }
                .frame(maxHeight: 44)
                .padding(.horizontal)
            
                if wiDListViewModel.fullWiDList.isEmpty {
                    VStack(spacing: 16) {
                        Text("표시할 WiD가 없습니다.")
                            .bodyLarge()
                        
                        NavigationLink(destination: NewWiDView(date: calendar.startOfDay(for: wiDListViewModel.currentDate))) {
                            Text("새로운 WiD 만들기")
                                .bodyMedium()
                            
                            Image(systemName: "plus.app")
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
                                        NavigationLink(destination: NewWiDView(date: wiDListViewModel.currentDate, start: wiD.start, finish: wiD.finish, duration: wiD.finish.timeIntervalSince(wiD.start))) {
                                            HStack(spacing: 8) {
                                                Image(systemName: "textformat")
                                                    .font(.system(size: 24))
                                                    .frame(maxWidth: 15, maxHeight: 15)
                                                    .padding()
                                                    .background(Color("White-Black"))
                                                    .clipShape(Circle())
                                                
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
                    Color("Transparent")
                        .contentShape(Rectangle())
                        .onTapGesture {
                            datePickerExpanded = false
                        }

                    DatePicker("", selection: $wiDListViewModel.currentDate, in: ...today, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .padding()
                        .background(Color("LightGray-Gray"))
                        .cornerRadius(8)
                        .padding() // 바깥 패딩
                        .shadow(color: Color("Black-White"), radius: 1)
                        .onChange(of: wiDListViewModel.currentDate) { newDate in
                            wiDListViewModel.setCurrentDate(to: wiDListViewModel.currentDate)
                        }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("White-Black"))
        .tint(Color("Black-White"))
        .navigationBarHidden(true)
        .onAppear {
            print("WiDListView appeared")
            
            // WiD 생성 혹은 삭제 후 돌아왔을 때, WiDList가 갱신되도록.
            wiDListViewModel.setCurrentDate(to: wiDListViewModel.currentDate)
        }
        .onDisappear {
            print("WiDListView disappeared")
        }
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
