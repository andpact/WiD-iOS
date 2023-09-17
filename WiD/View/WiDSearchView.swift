//
//  WiDSearchView.swift
//  WiD
//
//  Created by jjkim on 2023/07/14.
//

import SwiftUI

struct WiDSearchView: View {
    private let wiDService = WiDService()
    @State private var wiDs: [WiD] = []
    @State private var searchText: String = ""
    
    private var sortedWiDs: [WiD] {
        return wiDs.sorted(by: {
            if $0.date != $1.date {
                return $0.date > $1.date
            } else {
                return $0.start < $1.start
            }
        })
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                SearchBar(text: $searchText, onEditingChanged: searchTextDidChange)
                
                if wiDs.isEmpty {
//                    HStack(spacing: 0) {
//                        Rectangle()
//                            .fill(.red)
//                            .frame(width: geo.size.width * 0.02, height: 60)
//
//                        VStack(spacing: 5) {
//                            HStack(spacing: 0) {
//                                Text("99")
//                                    .frame(width: geo.size.width * 0.11)
//                                
//                                Text("공부")
//                                    .frame(width: geo.size.width * 0.11)
//
//                                Text("99:99")
//                                    .frame(width: geo.size.width * 0.22)
//
//                                Text("99:99")
//                                    .frame(width: geo.size.width * 0.22)
//
//                                Text("99시간 99분")
//                                    .frame(width: geo.size.width * 0.32)
//                            }
//                            
//                            Divider()
//                                .padding(.horizontal, 8)
//
//                            HStack(spacing: 0) {
//                                Text("설명")
//                                    .frame(width: geo.size.width * 0.13)
//
//                                Text("detail")
//                                    .frame(width: geo.size.width * 0.85, alignment: .leading)
//                                    .lineLimit(1)
//                                    .truncationMode(.tail)
//                            }
//                        }
//                    }
//                    .background(Color("light_gray"))
//                    .cornerRadius(5)
                    
                    Text("설명으로 WiD를 검색해 보세요.")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .foregroundColor(.gray)
                } else {
                    ScrollView {
                        ForEach(Array(sortedWiDs.enumerated()), id: \.element.id) { (index, wiD) in
                            if index == 0 || !Calendar.current.isDate(wiD.date, inSameDayAs: sortedWiDs[index - 1].date) {
                                HStack(spacing: 0) {
                                    if Calendar.current.isDateInToday(wiD.date) {
                                        Text("오늘")
                                    } else if Calendar.current.isDateInYesterday(wiD.date) {
                                        Text("어제")
                                    } else {
                                        Text(formatDate(wiD.date, format: "yyyy년 M월 d일 "))
                                        
                                        Text("(")
                                        
                                        Text(formatWeekday(wiD.date))
                                            .foregroundColor(Calendar.current.component(.weekday, from: wiD.date) == 1 ? .red : (Calendar.current.component(.weekday, from: wiD.date) == 7 ? .blue : .black))
                                        
                                        Text(")")
                                    }
                                    Spacer()
                                }
                                .padding(.top, 6)
                            }
                            NavigationLink(destination: WiDView(clickedWiDId: wiD.id)) {
                                HStack(spacing: 0) {
                                    Rectangle()
                                        .fill(Color(wiD.title))
                                        .frame(width: geo.size.width * 0.02, height: 60)
                                    
                                    VStack(spacing: 5) {
                                        HStack(spacing: 0) {
                                            Text("\(index + 1)")
                                                .frame(width: geo.size.width * 0.11)
                                            
                                            Text(titleDictionary[wiD.title] ?? "")
                                                .frame(width: geo.size.width * 0.11)
                                            
                                            Text(formatTime(wiD.start, format: "HH:mm"))
                                                .frame(width: geo.size.width * 0.22)
                                            
                                            Text(formatTime(wiD.finish, format: "HH:mm"))
                                                .frame(width: geo.size.width * 0.22)
                                            
                                            Text(formatDuration(wiD.duration, mode: 2))
                                                .frame(width: geo.size.width * 0.32)
                                        }
                                        
                                        Divider()
                                            .padding(.horizontal, 8)
                                        
                                        HStack(spacing: 0) {
                                            Text("설명")
                                                .frame(width: geo.size.width * 0.13)
                                            
                                            Text(wiD.detail)
                                                .frame(width: geo.size.width * 0.85, alignment: .leading)
                                                .lineLimit(1)
                                                .truncationMode(.tail)
                                        }
                                    }
                                }
                                .foregroundColor(.black)
                                .background(Color("light_gray"))
                                .cornerRadius(5)
                            }
                        }
                    }
                    Spacer()
                }
            }
            .onAppear() {
                withAnimation {
                    wiDs = wiDService.selectWiDsByDetail(detail: searchText) // 삭제 후 돌아오면 삭제된 WiD가 표시되니까 다시 WiD 리스트를 가져옴.
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification)) { _ in
                withAnimation {
                    wiDs = wiDService.selectWiDsByDetail(detail: searchText)
                }
            }
        }
        .padding(.horizontal)
    }
    
    private func searchTextDidChange(isEditing: Bool) {
        wiDs = wiDService.selectWiDsByDetail(detail: searchText)
    }
}

struct SearchBar: View {
    @Binding var text: String
    var onEditingChanged: (Bool) -> Void

    var body: some View {
        HStack {
            TextField("설명으로 검색..", text: $text, onEditingChanged: onEditingChanged)
                .padding(8)
                .background(Color(.systemGray5))
                .cornerRadius(5)
        }
    }
}

struct WiDSearchView_Previews: PreviewProvider {
    static var previews: some View {
        WiDSearchView()
    }
}
