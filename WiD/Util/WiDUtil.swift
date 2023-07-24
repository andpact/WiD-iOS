//
//  WiDUtil.swift
//  WiD
//
//  Created by jjkim on 2023/07/15.
//

import SwiftUI

struct WiD {
    var id: Int
    var title: String
    var detail: String
    var date: Date
    var start: Date
    var finish: Date
    var duration: TimeInterval
}

struct WiDView: View {
    @Environment(\.presentationMode) var presentationMode
    private let wiDService = WiDService()
    
    @State private var inputText: String = ""
    @State private var isExpanded: Bool = false
    
    @State private var isEditing: Bool = false
    
    private let clickedWiDId: Int
    private let clickedWiD: WiD?

    init(clickedWiDId: Int) {
        self.clickedWiDId = clickedWiDId
        self.clickedWiD = wiDService.selectWiDByID(id: clickedWiDId)
        self._inputText = State(initialValue: clickedWiD?.detail ?? "")
    }

    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    HStack {
                        Text("WiD")
                            .font(.system(size: 30))
                        
                        Spacer()

                        Circle()
                            .foregroundColor(Color(clickedWiD?.title ?? "STUDY"))
                            .frame(width: 20, height: 20)
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Image(systemName: "calendar")
                            .imageScale(.large)
                            .frame(width: 25)
                        
                        Text("날짜")
                            .font(.system(size: 25))

                        HStack {
                            Text(formatDate(clickedWiD?.date ?? Date(), format: "yyyy.MM.dd"))
                                .font(.system(size: 25))

                            Text(formatWeekday(clickedWiD?.date ?? Date()))
                                .foregroundColor(Calendar.current.component(.weekday, from: clickedWiD?.date ?? Date()) == 1 ? .red : (Calendar.current.component(.weekday, from: clickedWiD?.date ?? Date()) == 7 ? .blue : .black))
                                .font(.system(size: 25))
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)

                    HStack {
                        Image(systemName: "doc.text.magnifyingglass")
                            .imageScale(.large)
                            .frame(width: 25)
                        
                        Text("제목")
                            .font(.system(size: 25))

                        Text(titleDictionary[clickedWiD?.title ?? ""] ?? "")
                            .font(.system(size: 25))
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)

                    HStack {
                        Image(systemName: "clock")
                            .imageScale(.large)
                            .frame(width: 25)
                        
                        Text("시작")
                            .font(.system(size: 25))

                        Text(formatTime(clickedWiD?.start ?? Date(), format: "HH:mm:ss"))
                            .font(.system(size: 25))
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)

                    HStack {
                        Image(systemName: "stopwatch")
                            .imageScale(.large)
                            .frame(width: 25)
                        
                        Text("종료")
                            .font(.system(size: 25))

                        Text(formatTime(clickedWiD?.finish ?? Date(), format: "HH:mm:ss"))
                            .font(.system(size: 25))
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)

                    HStack {
                        Image(systemName: "hourglass")
                            .imageScale(.large)
                            .frame(width: 25)
                        
                        Text("소요")
                            .font(.system(size: 25))

                        Text(formatDuration(clickedWiD?.duration ?? 0, isClickedWiD: true))
                            .font(.system(size: 25))
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    
                    if isExpanded {
                        VStack {
                            HStack {
                                Image(systemName: "doc.text.magnifyingglass")
                                    .imageScale(.large)
                                    .frame(width: 25)
                                
                                Text("세부 사항")
                                    .font(.system(size: 25))
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                Button(action: {
                                    if isEditing {
                                        wiDService.updateWiD(withID: clickedWiDId, detail: inputText)
                                    }
                                    isEditing.toggle()
                                }) {
                                    Text(isEditing ? "완료" : "수정")
                                        .font(.system(size: 20))
                                }
                            }
                            
                            if !isEditing {
                                Text(inputText == "" ? "세부 사항 입력.." : inputText) // 디테일 텍스트 뷰
                                    .frame(maxWidth: .infinity)
                                    .border(Color.gray)
                            } else {
                                TextField("세부 사항 입력..", text: $inputText) // 디테일 텍스트 필드
                                    .border(Color.gray)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                    
                    Button(action: {
                        isExpanded.toggle()
                        isEditing = false
                    }) {
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .renderingMode(.original)
                            .imageScale(.large)
                    }
                    .padding(.bottom)
                }
                .background(Color("light_purple"))
                .cornerRadius(10)
                .padding(.horizontal)


                HStack {
                    Button(action: {
                        // "다운로드" 버튼이 클릭되었을 때 실행될 동작
                    }) {
                        Image(systemName: "arrow.down.to.line")
                            .renderingMode(.original)
                            .imageScale(.large)
                    }
                    .frame(maxWidth: .infinity)

                    Button(action: {
                        wiDService.deleteWiD(withID: clickedWiDId)
                        presentationMode.wrappedValue.dismiss() // 뒤로 가기
                    }) {
                        Image(systemName: "trash")
                            .renderingMode(.original)
                            .imageScale(.large)
                    }
                    .frame(maxWidth: .infinity)

                    Button(action: {
                        presentationMode.wrappedValue.dismiss() // 뒤로 가기
                    }) {
                        Image(systemName: "arrow.left.circle")
                            .renderingMode(.original)
                            .imageScale(.large)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)
            }
            .frame(maxHeight: .infinity)
            .padding(.horizontal)
        }
        .navigationBarBackButtonHidden()
    }
}

struct WiDView_Previews: PreviewProvider {
    static var previews: some View {
        WiDView(clickedWiDId: 0)
    }
}
