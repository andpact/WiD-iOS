//
//  WiDUtil.swift
//  WiD
//
//  Created by jjkim on 2023/07/15.
//

import SwiftUI

struct WiD {
    var id: Int
    var date: Date
    var title: String
    var start: Date
    var finish: Date
    var duration: TimeInterval
    var detail: String
}

struct WiDView: View {
    @Environment(\.presentationMode) var presentationMode
    private let wiDService = WiDService()
    
    @State private var inputText: String = ""
    
    @State private var beforeDelete: Bool = false
    @State private var deleteTimer: Timer?
    
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
                VStack(spacing: 8) {
                    HStack {
                        Text("WiD")
                            .font(.custom("Acme-Regular", size: 30))
                        
                        Spacer()

                        Circle()
                            .foregroundColor(Color(clickedWiD?.title ?? "STUDY"))
                            .frame(width: 20, height: 20)
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    HStack {
                        Image(systemName: "calendar")
                            .imageScale(.large)
                            .frame(width: 25)
                        
                        Text("날짜")
                            .font(.system(size: 25))
                            .padding(.vertical, 4)

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

                    HStack {
                        Image(systemName: "text.book.closed")
                            .imageScale(.large)
                            .frame(width: 25)
                        
                        Text("제목")
                            .font(.system(size: 25))
                            .padding(.vertical, 4)

                        Text(titleDictionary[clickedWiD?.title ?? ""] ?? "STUDY")
                            .font(.system(size: 25))
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal)

                    HStack {
                        Image(systemName: "clock")
                            .imageScale(.large)
                            .frame(width: 25)
                        
                        Text("시작")
                            .font(.system(size: 25))
                            .padding(.vertical, 4)

                        Text(formatTime(clickedWiD?.start ?? Date(), format: "a HH:mm:ss"))
                            .font(.system(size: 25))
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal)

                    HStack {
                        Image(systemName: "stopwatch")
                            .imageScale(.large)
                            .frame(width: 25)
                        
                        Text("종료")
                            .font(.system(size: 25))
                            .padding(.vertical, 4)

                        Text(formatTime(clickedWiD?.finish ?? Date(), format: "a HH:mm:ss"))
                            .font(.system(size: 25))
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal)

                    HStack {
                        Image(systemName: "hourglass")
                            .imageScale(.large)
                            .frame(width: 25)
                        
                        Text("소요")
                            .font(.system(size: 25))
                            .padding(.vertical, 4)

                        Text(formatDuration(clickedWiD?.duration ?? 0, mode: 3))
                            .font(.system(size: 25))
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal)
                    
                    HStack(alignment: .center) {
                        Image(systemName: "text.bubble")
                            .imageScale(.large)
                            .frame(width: 25)
                        
                        Text("설명")
                            .font(.system(size: 25))
                            .padding(.vertical, 4)
                        
                        Spacer()
                        
                        Button(action: {
                            if isEditing {
                                wiDService.updateWiD(withID: clickedWiDId, detail: inputText)
                            }
                            isEditing.toggle()
                        }) {
                            Image(systemName: isEditing ? "checkmark.square" : "square.and.pencil")
                                .padding(.trailing, -4)
                            
                            Text(isEditing ? "완료" : "수정")
                                .font(.system(size: 20))
                        }
                    }
                    .padding(.horizontal)
                    
                    if !isEditing {
                        ScrollView {
                            Text(inputText == "" ? "설명 추가.." : inputText)
                                .padding(5)
                                .padding(.top, 4)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                        }
                        .frame(maxHeight: 150)
                        .border(.gray)
                        .padding(.horizontal)
                        .padding(.bottom)
                    } else {
                        TextEditor(text: $inputText)
                            .frame(maxWidth: .infinity, maxHeight: 150, alignment: .topLeading)
                            .border(.gray)
                            .padding(.horizontal)
                            .padding(.bottom)
                    }
                }
                .background(Color("light_gray"))
                .cornerRadius(5)

                HStack {
                    Button(action: {
                        if beforeDelete {
                            wiDService.deleteWiD(withID: clickedWiDId)
                            presentationMode.wrappedValue.dismiss() // 뒤로 가기
                        }
                        beforeDelete.toggle()
                        
                        if beforeDelete {
                            deleteTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
                                beforeDelete = false
                                deleteTimer?.invalidate()
                                deleteTimer = nil
                            }
                        } else {
                            deleteTimer?.invalidate()
                            deleteTimer = nil
                        }
                    }) {
                        if beforeDelete {
                            Text("한번 더 눌러 삭제")
                                .foregroundColor(.red)
                        } else {
                            Text("삭제")
                        }
                    }
                    .frame(maxWidth: .infinity)

                    Button(action: {
                        presentationMode.wrappedValue.dismiss() // 뒤로 가기
                    }) {
                        Text("뒤로 가기")
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding()
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .accentColor(.black)
        }
        .navigationBarBackButtonHidden()
    }
}

struct WiDView_Previews: PreviewProvider {
    static var previews: some View {
        WiDView(clickedWiDId: 0)
    }
}
