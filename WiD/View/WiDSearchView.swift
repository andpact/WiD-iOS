//
//  WiDSearchView.swift
//  WiD
//
//  Created by jjkim on 2023/07/14.
//

import SwiftUI

struct WiDSearchView: View {
    private let wiDService = WiDService()
    @State private var searchText: String = ""
    @State private var wiDs: [WiD] = []
    
    var body: some View {
        VStack {
            SearchBar(text: $searchText, onEditingChanged: searchTextDidChange)
            
            if wiDs.isEmpty {
                Text("검색된 내용이 없습니다.")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(.gray)
            } else {
                ScrollView {
                    ForEach(Array(wiDs.enumerated()), id: \.element.id) { (index, wiD) in
                        if index == 0 || !Calendar.current.isDate(wiD.date, inSameDayAs: wiDs[index - 1].date) {
                            HStack {
                                if Calendar.current.isDateInToday(wiD.date) {
                                    Text("오늘")
                                    
                                    Spacer()
                                } else if Calendar.current.isDateInYesterday(wiD.date) {
                                    Text("어제")
                                    
                                    Spacer()
                                } else {
                                    Text(formatDate(wiD.date, format: "yyyy.MM.dd"))
                                    
                                    Text(formatWeekday(wiD.date))
                                        .foregroundColor(Calendar.current.component(.weekday, from: wiD.date) == 1 ? .red : (Calendar.current.component(.weekday, from: wiD.date) == 7 ? .blue : .black))
                                    
                                    Spacer()
                                }
                            }
                        }
                        
                        NavigationLink(destination: WiDView(clickedWiDId: wiD.id)) {
                            VStack {
                                HStack {
                                    Rectangle()
                                        .fill(Color(wiD.title))
                                        .frame(width: 7, height: 20)
                                    
                                    Text(titleDictionary[wiD.title] ?? "")
                                        .frame(width: 30)
                                    
                                    Text(formatTime(wiD.start, format: "HH:mm"))
                                        .frame(maxWidth: .infinity)
                                    
                                    Text(formatTime(wiD.finish, format: "HH:mm"))
                                        .frame(maxWidth: .infinity)
                                    
                                    Text(formatDuration(wiD.duration, isClickedWiD: false))
                                        .frame(maxWidth: .infinity)
                                }
                                
                                HStack {
                                    Text("세부 사항")
                                    
                                    Text(wiD.detail)
                                    
                                    Spacer()
                                }
                            }
                            .foregroundColor(.black)
                            .background(Color("light_gray"))
                            .cornerRadius(5)
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                        }
                    }
                }
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal)
        .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification)) { _ in
            wiDs = wiDService.selectWiDsByDetail(detail: searchText)
        }
    }
    
    private func searchTextDidChange(isEditing: Bool) {
        wiDs = wiDService.selectWiDsByDetail(detail: searchText)
    }
}

struct SearchBar: View {
    @Binding var text: String
    var onEditingChanged: (Bool) -> Void // Callback to inform when editing changes

    var body: some View {
        HStack {
            TextField("세부 사항으로 검색..", text: $text, onEditingChanged: onEditingChanged)
                .padding(8)
                .background(Color(.systemGray5))
                .cornerRadius(8)
        }
        .padding(.top)
    }
}

struct WiDSearchView_Previews: PreviewProvider {
    static var previews: some View {
        WiDSearchView()
    }
}
