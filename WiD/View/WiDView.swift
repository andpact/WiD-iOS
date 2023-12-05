//
//  WiDView.swift
//  WiD
//
//  Created by jjkim on 2023/12/05.
//

import SwiftUI

struct WiDView: View {
    // 화면
    @Environment(\.presentationMode) var presentationMode
    @State private var isDeleteButtonPressed: Bool = false
    @State private var deleteTimer: Timer?
    
    // WiD
    private let wiDService = WiDService()
    @State private var wiDList: [WiD] = []
    @State private var isEditing: Bool = false
    private let clickedWiDId: Int
    private let clickedWiD: WiD?
    
    // 날짜
    private let calendar = Calendar.current
    private let today = Date()
    private let currenTime = Date()
    @State private var date = Date()
    
    // 제목
    @State private var title: String = ""
    
    // 시작 시간
    @State private var start = Date()
    @State private var startLimit = Date()
    @State private var isStartOverlap: Bool = false
    @State private var isStartOverCurrentTime: Bool = false
    
    // 종료 시간
    @State private var finish = Date()
    @State private var finishLimit = Date()
    @State private var isFinishOverlap: Bool = false
    @State private var isFinishOverCurrentTime: Bool = false
    
    // 소요 시간
    @State private var duration: TimeInterval = 0.0
    @State private var DurationExist: Bool = false
    
    // 설명
    @State private var detail: String = ""

    init(clickedWiDId: Int) {
        self.clickedWiDId = clickedWiDId
        self.clickedWiD = wiDService.selectWiDByID(id: clickedWiDId)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // 상단 바
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.backward")
                            .imageScale(.large)
                    }

                    Text("WiD")
                        .bold()
                    
                    Text("-")
                    
                    getDayString(date: date)
                    
                    Spacer()
                    
                    Button(action: {
                        if isEditing {
                            wiDService.updateWiD(withID: clickedWiDId, newTitle: title, newStart: start, newFinish: finish, newDuration: duration, newDetail: detail)
                            
                            wiDList = wiDService.selectWiDsByDate(date: date)
                        }
                        withAnimation {
                            isEditing.toggle()
                        }
                    }) {
                        Text(isEditing ? "완료" : "수정")
                            .foregroundColor(isEditing ? (isStartOverlap || isStartOverCurrentTime || isFinishOverlap || isFinishOverCurrentTime || !DurationExist ? .gray : .green) : .blue)
                    }
                    .disabled(isStartOverlap || isStartOverCurrentTime || isFinishOverlap || isFinishOverCurrentTime || !DurationExist)
                }
                .padding(.horizontal)
                
                // 컨텐츠
                VStack(alignment: .leading, spacing: 8) {
                    Text("클릭된 WiD")
                        .font(.custom("BlackHanSans-Regular", size: 20))
                    
                    // 클릭된 WiD
                    VStack(spacing: 0) {
                        // 날짜
                        HStack {
                            Image(systemName: "calendar")
                                .frame(width: 20)
                                .padding()
                            
                            getDayString(date: date)
                            
                            Spacer()
                        }
                        
                        // 제목
                        HStack {
                            Image(systemName: "character.textbox.ko")
                                .frame(width: 20)
                                .padding()
                            
                            if isEditing {
                                Picker("", selection: $title) {
                                    ForEach(Array(Title.allCases), id: \.self) { title in
                                        Text(title.koreanValue)
                                    }
                                }
                            } else {
                                Text(titleDictionary[title] ?? "공부")
                            }
                            
                            Circle()
                                .fill(Color(title))
                                .frame(width: 10)
                            
                            Spacer()
                        }
                        
                        // 시작 시간
                        HStack {
                            Image(systemName: "play")
                                .frame(width: 20)
                                .padding()
                            
                            if isEditing {
                                DatePicker("", selection: $start, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                            } else {
                                Text(formatTime(start, format: "a h:mm:ss"))
                            }
                            
                            Spacer()
                        }
                        
                        // 종료 시간
                        HStack {
                            Image(systemName: "play.fill")
                                .frame(width: 20)
                                .padding()
                            
                            if isEditing {
                                DatePicker("", selection: $finish, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                            } else {
                                Text(formatTime(finish, format: "a h:mm:ss"))
                            }
                            
                            Spacer()
                        }

                        // 소요 시간
                        HStack {
                            Image(systemName: "hourglass")
                                .frame(width: 20)
                                .padding()

                            Text(formatDuration(duration, mode: 3))
                            
                            Spacer()
                        }
                        
                        // 설명
                        HStack {
                            Image(systemName: "text.bubble")
                                .frame(width: 20)
                                .padding()
                            
                            if isEditing {
                                TextEditor(text: $detail)
                                    .padding(1)
                            } else {
                                Text(detail)
                                    .padding(.vertical, 8)
                            }
                            
                            Spacer()
                        }
                    }
                    .background(.white)
                    .cornerRadius(8)
                    .shadow(radius: 1)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
                
                // 하단 바
                HStack {
                    Text("선택 가능한 시간")
                        .bold()
                    
                    Text("\(formatTime(startLimit, format: "a hh:mm"))")
                    
                    Text("\(formatTime(finishLimit, format: "a hh:mm"))")
                    
                    Spacer()
                    
                    Button(action: {
                        if isDeleteButtonPressed {
                            wiDService.deleteWiD(withID: clickedWiDId)
                            // 삭제 후 뒤로가기
                            presentationMode.wrappedValue.dismiss()
                        }
                        
                        withAnimation {
                            isDeleteButtonPressed.toggle()
                        }
                        
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
                            Text("삭제 확인")
                                .foregroundColor(.red)
                        } else {
                            Text("WiD")
                            
                            Text("삭제")
                                .foregroundColor(.red)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .tint(.black)
            .background(Color("ghost_white"))
            .onAppear {
                self.date = clickedWiD!.date
                self.title = clickedWiD!.title
                // date 날짜를 clickedWiD!.start와 clickedWiD!.finish에 적용시킴.
                self.start = calendar.date(bySettingHour: calendar.component(.hour, from: clickedWiD!.start),
                                           minute: calendar.component(.minute, from: clickedWiD!.start),
                                           second: calendar.component(.second, from: clickedWiD!.start), of: date)!
                self.finish = calendar.date(bySettingHour: calendar.component(.hour, from: clickedWiD!.finish),
                                            minute: calendar.component(.minute, from: clickedWiD!.finish),
                                            second: calendar.component(.second, from: clickedWiD!.finish), of: date)!
                self.duration = clickedWiD!.duration
                self.detail = clickedWiD!.detail
                
                self.wiDList = wiDService.selectWiDsByDate(date: date)
                
                if let index = wiDList.firstIndex(where: { $0.id == clickedWiDId }) {
                    if index > 0 {
                        let previouWiD = wiDList[index - 1]
                        self.startLimit = calendar.date(byAdding: .minute, value: 1, to: calendar.date(bySettingHour: calendar.component(.hour, from: previouWiD.finish),
                                                                                                        minute: calendar.component(.minute, from: previouWiD.finish),
                                                                                                        second: calendar.component(.second, from: previouWiD.finish), of: date)!)!

                    } else {
                        self.startLimit = calendar.startOfDay(for: date)
                    }
                    
                    if index < wiDList.count - 1 {
                        let nextWiD = wiDList[index + 1]
                        self.finishLimit = calendar.date(byAdding: .minute, value: -1, to: calendar.date(bySettingHour: calendar.component(.hour, from: nextWiD.start),
                                                                                                            minute: calendar.component(.minute, from: nextWiD.start),
                                                                                                            second: calendar.component(.second, from: nextWiD.start), of: date)!)!

                    } else if calendar.isDate(date, inSameDayAs: today) {
                        self.finishLimit = currenTime
                    } else {
                        self.finishLimit = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: date)!
                    }
                }
            }
            .onChange(of: start) { newStart in
                duration = finish.timeIntervalSince(newStart)
                // DB의 newStart는 date가 아니라 2000-01-01 날짜를 가진다.
                print("new Start : \(formatTime(newStart, format: "yyyy-MM-dd a h:mm:ss"))")
                
                withAnimation {
                    DurationExist = 0 < duration
                }
                
                isStartOverlap = newStart < startLimit
                print(isStartOverlap ? "start overlap" : "")

                isStartOverCurrentTime = calendar.isDate(date, inSameDayAs: today) && currenTime < newStart
                print(isStartOverCurrentTime ? "today, start over currentTime" : "")
            }
            .onChange(of: finish) { newFinish in
                duration = newFinish.timeIntervalSince(start)
                print("new Finish : \(formatTime(newFinish, format: "yyyy-MM-dd a h:mm:ss"))")
                
                withAnimation {
                    DurationExist = 0 < duration
                }
                
                isFinishOverlap = finishLimit < newFinish
                print(isFinishOverlap ? "finish overlap" : "")

                isFinishOverCurrentTime = calendar.isDate(date, inSameDayAs: today) && currenTime < newFinish
                print(isFinishOverCurrentTime ? "today, finish over currentTime" : "")
            }
        }
        .navigationBarHidden(true)
    }
}

struct WiDView_Previews: PreviewProvider {
    static var previews: some View {
        WiDView(clickedWiDId: 0)
    }
}

