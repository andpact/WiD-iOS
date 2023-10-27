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
    
    init(id: Int, date: Date, title: String, start: Date, finish: Date, duration: TimeInterval, detail: String) {
        self.id = id
        self.date = date
        self.title = title
        self.start = start
        self.finish = finish
        self.duration = duration
        self.detail = detail
    }
}

struct WiDView: View {
    @Environment(\.presentationMode) var presentationMode
    private let wiDService = WiDService()
    @State private var wiDs: [WiD] = []
    
    private let today = Date()
    private let currenTime = Date()
    
    @State private var date = Date()
    @State private var title: String = ""
    @State private var start = Date()
    @State private var finish = Date()
    @State private var duration: TimeInterval = 0.0
    @State private var detail: String = ""
    
    @State private var isStartOverlap: Bool = false
    @State private var isFinishOverlap: Bool = false
    @State private var isDurationMinOrMax: Bool = false
    
    @State private var isDeleteButtonPressed: Bool = false
    @State private var deleteTimer: Timer?
    
    @State private var isEditing: Bool = false
    
    private let clickedWiDId: Int
    private let clickedWiD: WiD?

    init(clickedWiDId: Int) {
        self.clickedWiDId = clickedWiDId
        self.clickedWiD = wiDService.selectWiDByID(id: clickedWiDId)
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
                            .foregroundColor(Color(title))
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
                            Text(formatDate(date, format: "yyyy.MM.dd"))
                                .font(.system(size: 25))

                            Text(formatWeekday(date))
                                .foregroundColor(Calendar.current.component(.weekday, from: date) == 1 ? .red : (Calendar.current.component(.weekday, from: date) == 7 ? .blue : .black))
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

                        ZStack {
                            Text(titleDictionary[title] ?? "공부")
                                .font(.system(size: 25))
                                .frame(maxWidth: .infinity)
                            
                            Picker("", selection: $title) {
                                ForEach(titleArray, id: \.self) { title in
                                    Text(titleDictionary[title]!)
                                }
                            }
                            .opacity(0.02)
                            .disabled(!isEditing)
                        }
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

                        ZStack {
                            Text(formatTime(start, format: "a h:mm:ss"))
                                .font(.system(size: 25))
                            
                            DatePicker("", selection: $start, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .opacity(0.02)
                                .disabled(!isEditing)
                            
                            if isStartOverlap {
                                HStack {
                                    Spacer()
                                    
                                    Image(systemName: "exclamationmark.square")
                                        .foregroundColor(.red)
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
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

                        ZStack {
                            Text(formatTime(finish, format: "a h:mm:ss"))
                                .font(.system(size: 25))
                            
                            DatePicker("", selection: $finish, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .opacity(0.02)
                                .disabled(!isEditing)
                            
                            if isFinishOverlap {
                                HStack {
                                    Spacer()
                                    
                                    Image(systemName: "exclamationmark.square")
                                        .foregroundColor(.red)
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal)

                    HStack {
                        Image(systemName: "hourglass")
                            .imageScale(.large)
                            .frame(width: 25)
                        
                        Text("경과")
                            .font(.system(size: 25))
                            .padding(.vertical, 4)

                        ZStack {
                            Text(formatDuration(duration, mode: 3))
                                .font(.system(size: 25))
                                .frame(maxWidth: .infinity)
                            
                            if isDurationMinOrMax {
                                HStack {
                                    Spacer()
                                    
                                    Image(systemName: "exclamationmark.square")
                                        .foregroundColor(.red)
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
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
                    }
                    .padding(.horizontal)
                    
                    if !isEditing {
                        ScrollView {
                            Text(detail == "" ? "설명 추가.." : detail)
                                .padding(5)
                                .padding(.top, 4)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                        }
                        .frame(maxHeight: 150)
                        .border(.gray)
                        .padding(.horizontal)
                        .padding(.bottom)
                    } else {
                        TextEditor(text: $detail)
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
                        if isEditing {
                            wiDService.updateWiD(withID: clickedWiDId, newTitle: title, newStart: start, newFinish: finish, newDuration: duration, newDetail: detail)
                        }
                        isEditing.toggle()
                    }) {
                        Text(isEditing ? "완료" : "수정")
                            .foregroundColor({
                                if !isEditing {
                                    return Color.blue
                                } else if isEditing && !(isStartOverlap || isFinishOverlap || isDurationMinOrMax) {
                                    return Color.green
                                } else {
                                    return nil
                                }
                            }())
                    }
                    .frame(maxWidth: .infinity)
                    .disabled(isStartOverlap || isFinishOverlap || isDurationMinOrMax)
                    
                    Button(action: {
                        if isDeleteButtonPressed {
                            wiDService.deleteWiD(withID: clickedWiDId)
                            presentationMode.wrappedValue.dismiss() // 뒤로 가기
                        }
                        isDeleteButtonPressed.toggle()
                        
                        if isDeleteButtonPressed {
                            deleteTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
                                isDeleteButtonPressed = false
                                deleteTimer?.invalidate()
                                deleteTimer = nil
                            }
                        } else {
                            deleteTimer?.invalidate()
                            deleteTimer = nil
                        }
                    }) {
                        if isDeleteButtonPressed {
                            Text("한번 더 눌러 삭제")
                                .foregroundColor(.red)
                        } else {
                            Text("삭제")
                        }
                    }
                    .frame(maxWidth: .infinity)

//                    Button(action: {
//                        presentationMode.wrappedValue.dismiss() // 뒤로 가기
//                    }) {
//                        Text("뒤로 가기")
//                    }
//                    .frame(maxWidth: .infinity)
                }
                .padding()
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .accentColor(.black)
        }
//        .navigationBarBackButtonHidden()
        .onAppear() {
            date = clickedWiD!.date
            print("date onAppear : \(date)")
            title = clickedWiD!.title
            start = clickedWiD!.start
            finish = clickedWiD!.finish
            duration = clickedWiD!.duration
            detail = clickedWiD!.detail
            
            wiDs = wiDService.selectWiDsByDate(date: date)
        }
        .onChange(of: start) { newStart in
            duration = finish.timeIntervalSince(newStart)
            print("start changed")
            
            withAnimation {
                isDurationMinOrMax = 12 * 60 * 60 < duration || duration <= 0
            }
            
            if Calendar.current.isDate(date, inSameDayAs: today), currenTime <= newStart {
                isStartOverlap = true
                print("today, start over currentTime")
            } else if let currentIndex = wiDs.firstIndex(where: { $0.id == clickedWiDId }), 0 < currentIndex {
                let previousWiD = wiDs[currentIndex - 1]
                if newStart <= previousWiD.finish {
                    isStartOverlap = true
                    print("start overlap")
                } else {
                    isStartOverlap = false
                    print("start not overlap")
                }
            }
        }
        .onChange(of: finish) { newFinish in
            duration = newFinish.timeIntervalSince(start)
            print("finish changed")
            
            withAnimation {
                isDurationMinOrMax = 12 * 60 * 60 < duration || duration <= 0
            }
            
            print("date onChange finish : \(date)")
            print("today : \(today)")
            
            if Calendar.current.isDate(date, inSameDayAs: today) {
                if currenTime <= newFinish {
                    isFinishOverlap = true
                    print("today, finish over currentTime")
                }
            } else if let currentIndex = wiDs.firstIndex(where: { $0.id == clickedWiDId }), currentIndex < wiDs.count - 1 {
                let nextWiD = wiDs[currentIndex + 1]
                if nextWiD.start <= newFinish {
                    isFinishOverlap = true
                    print("finish overlap")
                } else {
                    isFinishOverlap = false
                    print("finish not overlap")
                }
            }
        }
    }
}

struct WiDView_Previews: PreviewProvider {
    static var previews: some View {
        WiDView(clickedWiDId: 0)
    }
}
