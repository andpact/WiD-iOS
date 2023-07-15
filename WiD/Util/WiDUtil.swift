//
//  WiDUtil.swift
//  WiD
//
//  Created by jjkim on 2023/07/15.
//

import SwiftUI

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
        NavigationView { // NavigationView 추가
            VStack {
                VStack {
                    HStack {
                        Text("WiD")
                            .font(.system(size: 30))

                        Circle()
                            .foregroundColor(Color(clickedWiD?.title ?? "STUDY"))
                            .frame(width: 20, height: 20)
                    }
                    HStack {
                        Image(systemName: "calendar")
                            .imageScale(.large)
                        Text("날짜")
                            .font(.system(size: 30))

                        HStack {
                            Text(formatDate(clickedWiD?.date ?? Date(), format: "yyyy.MM.dd"))
                                .font(.system(size: 30))

                            Text(formatWeekday(clickedWiD?.date ?? Date()))
                                .font(.system(size: 30))
                        }
                    }

                    HStack {
                        Image(systemName: "doc.text.magnifyingglass")
                            .imageScale(.large)
                        Text("제목")
                            .font(.system(size: 30))

                        Text(clickedWiD?.title ?? "")
                            .font(.system(size: 30))
                    }

                    HStack {
                        Image(systemName: "clock")
                            .imageScale(.large)
                        Text("시작")
                            .font(.system(size: 30))

                        Text(formatTime(clickedWiD?.start ?? Date(), format: "HH:mm:ss"))
                            .font(.system(size: 30))
                    }

                    HStack {
                        Image(systemName: "stopwatch")
                            .imageScale(.large)
                        Text("종료")
                            .font(.system(size: 30))

                        Text(formatTime(clickedWiD?.finish ?? Date(), format: "HH:mm:ss"))
                            .font(.system(size: 30))
                    }

                    HStack {
                        Image(systemName: "hourglass")
                            .imageScale(.large)
                        Text("소요")
                            .font(.system(size: 30))

                        Text(formatDuration(clickedWiD?.duration ?? 0, isClickedWiD: true))
                            .font(.system(size: 30))
                    }
                    
                    if isExpanded {
                        VStack {
                            HStack {
                                Text("세부 사항")
                                    .font(.system(size: 30))
                                    .foregroundColor(.black)
                                
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
                            } else {
                                TextField("세부 사항 입력..", text: $inputText) // 디테일 텍스트 필드
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding()
                            }
                        }
                    }
                    
                    Button(action: {
                        isExpanded.toggle()
                        isEditing = false
                    }) {
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .renderingMode(.original)
                            .imageScale(.large)
                    }
                }
                .border(Color.black)

                HStack {
                    Button(action: {
                        // "다운로드" 버튼이 클릭되었을 때 실행될 동작
                    }) {
                        Image(systemName: "arrow.down.to.line")
                            .renderingMode(.original)
                            .imageScale(.large)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)

                    Button(action: {
                        wiDService.deleteWiD(withID: clickedWiDId)
                        presentationMode.wrappedValue.dismiss() // 뒤로 가기
                    }) {
                        Image(systemName: "trash")
                            .renderingMode(.original)
                            .imageScale(.large)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)

                    Button(action: {
                        presentationMode.wrappedValue.dismiss() // 뒤로 가기
                    }) {
                        Image(systemName: "arrow.left.circle")
                            .renderingMode(.original)
                            .imageScale(.large)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .frame(maxHeight: .infinity)
            .border(Color.black)
            .padding(.horizontal)
        }
        .navigationBarBackButtonHidden()
    }
}
