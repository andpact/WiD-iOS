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
    @State private var isExpanded: Bool = false
    
    @State private var beforeDelete: Bool = false
    @State private var deleteTimer: Timer?
    
    @State private var padding: CGFloat = 16
    
    var inputTextCount: String {
        let count = inputText.count
        return "\(count)/200"
    }
    
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
                            .font(.custom("Acme-Regular", size: 30))
                        
                        Spacer()

                        Circle()
                            .foregroundColor(Color(clickedWiD?.title ?? "STUDY"))
                            .frame(width: 20, height: 20)
                    }
                    .padding(.horizontal)
                    .padding(.top, padding)
                    
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
                    .padding(.bottom, padding)

                    HStack {
                        Image(systemName: "text.book.closed")
                            .imageScale(.large)
                            .frame(width: 25)
                        
                        Text("제목")
                            .font(.system(size: 25))

                        Text(titleDictionary[clickedWiD?.title ?? ""] ?? "")
                            .font(.system(size: 25))
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, padding)

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
                    .padding(.bottom, padding)

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
                    .padding(.bottom, padding)

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
                    .padding(.bottom, padding)
                    
                    if isExpanded {
                        VStack {
                            HStack(alignment: .center) {
                                Image(systemName: "text.bubble")
                                    .imageScale(.large)
                                    .frame(width: 25)
                                
                                Text("설명")
                                    .font(.system(size: 25))
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                Button(action: {
                                    if isEditing && inputText.count <= 200 {
                                        wiDService.updateWiD(withID: clickedWiDId, detail: inputText)
                                    }
                                    isEditing.toggle()
                                }) {
                                    Image(systemName: isEditing ? "checkmark.square" : "square.and.pencil")
                                        .padding(.trailing, -4)
                                    
                                    Text(isEditing ? "완료" : "수정")
                                        .font(.system(size: 20))
                                }
                                .disabled(isEditing && 200 < inputText.count)
                            }
                            
                            if !isEditing {
                                ScrollView {
                                    Text(inputText == "" ? "설명 추가.." : inputText) // 디테일 텍스트 뷰
                                        .padding(5)
                                        .padding(.top, 4)
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                }
                                .frame(maxHeight: 150)
                                .border(.gray)
                            } else {
                                TextEditor(text: $inputText) // 디테일 텍스트 에디터
                                    .frame(maxWidth: .infinity, maxHeight: 150,  alignment: .topLeading)
                                    .border(.gray)
                            }
                            
                            Text(inputTextCount)
                                .foregroundColor(inputText.count > 200 ? .red : .gray)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.top, -5)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, padding)
                    }
                    
                    Button(action: {
                        withAnimation {
                            isExpanded.toggle()
                            padding = isExpanded ? 2 : 16
                        }
                        
                        if (isEditing) {
                            inputText = clickedWiD?.detail ?? ""
                        }
                        
                        isEditing = false
                    }) {
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .renderingMode(.original)
                            .imageScale(.large)
                    }
                    .padding(.bottom)
                    .accentColor(.black)
                }
                .background(Color("light_gray"))
                .cornerRadius(5)
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)

                HStack {
//                    Button(action: { // 스크린 샷 버튼
//                        
//                    }) {
//                        Image(systemName: "photo.on.rectangle")
//                            .renderingMode(.original)
//                            .imageScale(.large)
//                    }
//                    .frame(maxWidth: .infinity)

                    Button(action: {
                        if beforeDelete {
                            wiDService.deleteWiD(withID: clickedWiDId)
                            presentationMode.wrappedValue.dismiss() // 뒤로 가기
                        }
                        beforeDelete.toggle()
                        
                        // Reset beforeDelete back to false after 3 seconds
                        if beforeDelete {
                            deleteTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
                                beforeDelete = false
                                deleteTimer?.invalidate()
                                deleteTimer = nil
                            }
                        } else {
                            // Invalidate the timer if the button is tapped before 3 seconds
                            deleteTimer?.invalidate()
                            deleteTimer = nil
                        }
                    }) {
                        if beforeDelete {
                            Text("한번 더 눌러 삭제")
                                .foregroundColor(.red)
                        } else {
                            Image(systemName: "trash")
                                .imageScale(.large)
                        }
                    }
                    .frame(maxWidth: .infinity)

                    Button(action: {
                        presentationMode.wrappedValue.dismiss() // 뒤로 가기
                    }) {
                        Image(systemName: "arrow.left")
                            .imageScale(.large)
                    }
                    .frame(maxWidth: .infinity)
                    .accentColor(.black)
                }
                .frame(maxHeight: 20)
                .padding()
            }
            .frame(maxWidth: 300)
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
