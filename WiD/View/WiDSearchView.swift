//
//  WiDSearchView.swift
//  WiD
//
//  Created by jjkim on 2023/07/14.
//

import SwiftUI

struct WiDSearchView: View {
    private let wiDService = WiDService()
    private let calendar = Calendar.current
    
    @State private var wiDList: [WiD] = []
    @State private var searchText: String = ""
    
    var body: some View {
        VStack {
            SearchBar(text: $searchText, onEditingChanged: searchTextDidChange)
            
            ScrollViewReader { sp in
                ScrollView {
                    // 스크롤 뷰 안에 자동으로 수직 수택(spacing: 8)이 생성되는 듯.
                    VStack(spacing: 8) {
                        if wiDList.isEmpty {
                            HStack {
                                Image(systemName: "text.bubble")
                                    .foregroundColor(.gray)
                                
                                Text("설명으로 WiD를 검색해 보세요.")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .padding(.vertical)
                            .frame(maxWidth: .infinity)
                        } else {
                            ForEach(Array(wiDList.enumerated()), id: \.element.id) { (index, wiD) in
                                if index == 0 || !calendar.isDate(wiD.date, inSameDayAs: wiDList[index - 1].date) {
                                    HStack {
                                        if calendar.isDateInToday(wiD.date) {
                                            Text("오늘")
                                                .bold()
                                                .padding(.leading, 8)
                                        } else if calendar.isDateInYesterday(wiD.date) {
                                            Text("어제")
                                                .bold()
                                                .padding(.leading, 8)
                                        } else {
                                            Text(formatDate(wiD.date, format: "yyyy년 M월 d일"))
                                                .bold()
                                                .padding(.leading, 8)
                                          
                                            HStack(spacing: 0) {
                                                Text("(")
                                                    .bold()
                                                
                                                Text(formatWeekday(wiD.date))
                                                    .foregroundColor(calendar.component(.weekday, from: wiD.date) == 1 ? .red : (calendar.component(.weekday, from: wiD.date) == 7 ? .blue : .black))
                                                    .bold()
                                                
                                                Text(")")
                                                    .bold()
                                            }
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                
                                NavigationLink(destination: WiDView(clickedWiDId: wiD.id)) {
                                    VStack(spacing: 8) {
                                        HStack {
                                            HStack {
                                                Image(systemName: "character.textbox.ko")
                                                    .frame(width: 20)
                                                
                                                Text("제목")
                                                    .bold()
                                                
                                                Text(titleDictionary[wiD.title] ?? "")
                                                
                                                RoundedRectangle(cornerRadius: 5)
                                                    .fill(Color(wiD.title))
                                                    .background(RoundedRectangle(cornerRadius: 5)
                                                        .stroke(.black, lineWidth: 1)
                                                    )
                                                    .frame(width: 5, height: 20)
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                            HStack {
                                                Image(systemName: "hourglass")
                                                    .frame(width: 20)
                                                
                                                Text("소요")
                                                    .bold()
                                                
                                                Text(formatDuration(wiD.duration, mode: 1))
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                        
                                        HStack {
                                            HStack {
                                                Image(systemName: "play")
                                                    .frame(width: 20)
                                                
                                                Text("시작")
                                                    .bold()
                                                
                                                Text(formatTime(wiD.start, format: "a h:mm"))
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                            HStack {
                                                Image(systemName: "play.fill")
                                                    .frame(width: 20)
                                                
                                                Text("종료")
                                                    .bold()
                                                
                                                Text(formatTime(wiD.finish, format: "a h:mm"))
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                        
                                        HStack {
                                            Image(systemName: "text.bubble")
                                                .frame(width: 20)
                                            
                                            Text("설명")
                                                .bold()
                                            
                                            Text(wiD.detail)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .lineLimit(1)
                                                .truncationMode(.tail)
                                        }
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(RoundedRectangle(cornerRadius: 5)
                                        .stroke(.black, lineWidth: 1)
                                    )
                                    .background(Color("light_gray"))
                                    .cornerRadius(5)
                                }
                            }
                        }
                    }
                }
                .onAppear {
                    // 삭제 후 돌아오면 삭제된 WiD가 남아서 표시되니까 다시 WiD 리스트를 가져옴.
                    wiDList = wiDService.selectWiDsByDetail(detail: searchText)
                }
                .onChange(of: searchText) { newValue in
                    withAnimation {
                        wiDList = wiDService.selectWiDsByDetail(detail: newValue)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
    
    private func searchTextDidChange(isEditing: Bool) {
        wiDList = wiDService.selectWiDsByDetail(detail: searchText)
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
