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
    
    var body: some View {
        VStack {
            SearchBar(text: $searchText, onEditingChanged: searchTextDidChange)
            
            if wiDs.isEmpty {
//                Text("검색된 WiD가 없습니다.")
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .foregroundColor(.gray)
                
                HStack {
                    Rectangle()
                        .fill(.red)
                        .frame(width: 7, height: 45)
                    
                    VStack(spacing: 5) {
                        HStack {
                            Text("공부")
                                .frame(minWidth: 30, maxWidth: 40)
                                .border(.black)
                            
                            Text("99:99")
                                .frame(minWidth: 30, maxWidth: .infinity)
                                .border(.black)
                            
                            Text("99:99")
                                .frame(minWidth: 60, maxWidth: .infinity)
                                .border(.black)
                            
                            Text("99시간 99분")
                                .frame(minWidth: 130, maxWidth: .infinity)
                                .border(.black)
                        }
                        
                        HStack {
                            Text("설명")
                                .frame(minWidth: 30, maxWidth: 40)
                            
                            Text(" : ")
                            
                            Text("detail")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .border(.blue)
                        }
                    }
                }
                .foregroundColor(.black)
                .background(Color("light_gray"))
                .cornerRadius(5)
            } else {
                ZStack(alignment: .topTrailing) {
                    ScrollView {
                        ForEach(Array(wiDs.enumerated().reversed()), id: \.element.id) { (index, wiD) in
                            if index == wiDs.count - 1 || !Calendar.current.isDate(wiD.date, inSameDayAs: wiDs[index + 1].date) {
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
                                HStack {
                                    Rectangle()
                                        .fill(Color(wiD.title))
                                        .frame(width: 7, height: 45)
                                    
                                    VStack(spacing: 5) {
                                        HStack {
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
                                            Text("설명")
                                                .frame(width: 30)
                                            
                                            Text(" : ")
                                            
                                            Text(wiD.detail)
                                                .lineLimit(1)
                                            
                                            Spacer()
                                        }
                                    }
                                }
                                .foregroundColor(.black)
                                .background(Color("light_gray"))
                                .cornerRadius(5)
                            }
                        }
                    }
                    
                    Text("검색된 WiD \(wiDs.count)개")
                        .font(.caption)
                        .padding(4)
                        .foregroundColor(.white)
                        .background(Color.black)
                        .cornerRadius(5)
                        .padding(.top, 4)
                }
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal)
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
    
    private func searchTextDidChange(isEditing: Bool) {
        wiDs = wiDService.selectWiDsByDetail(detail: searchText)
    }
}

struct SearchBar: View {
    @Binding var text: String
    var onEditingChanged: (Bool) -> Void // Callback to inform when editing changes

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
