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
    @State private var title: Title = .STUDY
    
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
                ZStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.backward")
                        
                        Text("뒤로 가기")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.blue)

                    Text("WiD")
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Button(action: {
                        if isEditing {
                            wiDService.updateWiD(withID: clickedWiDId, newTitle: title.rawValue, newStart: start, newFinish: finish, newDuration: duration, newDetail: detail)
                            
                            wiDList = wiDService.selectWiDsByDate(date: date)
                        }
                        withAnimation {
                            isEditing.toggle()
                        }
                    }) {
                        Image(systemName: isEditing ? "checkmark" : "pencil")
                        
                        Text(isEditing ? "완료" : "수정")
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .foregroundColor(isEditing ? (isStartOverlap || isStartOverCurrentTime || isFinishOverlap || isFinishOverCurrentTime || !DurationExist ? .gray : .green) : .blue)
                    .disabled(isEditing && (isStartOverlap || isStartOverCurrentTime || isFinishOverlap || isFinishOverCurrentTime || !DurationExist))
                }
                .padding(.horizontal)
                
                // 컨텐츠
                VStack(alignment: .leading, spacing: 8) {
                    Text("클릭된 WiD")
                        .bold()
                    
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
                                Text(titleDictionary[title.rawValue] ?? "공부")
                            }
                            
                            Circle()
                                .fill(Color(title.rawValue))
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
//                        HStack {
//                            Image(systemName: "text.bubble")
//                                .frame(width: 20)
//                                .padding()
//                            
//                            if isEditing {
//                                TextEditor(text: $detail)
//                                    .padding(1)
//                            } else {
//                                Text(detail)
//                                    .padding(.vertical, 8)
//                            }
//                            
//                            Spacer()
//                        }
                    }
                    .background(.white)
                    .cornerRadius(8)
                    .shadow(radius: 1)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
                
                // 하단 바
                HStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            Text("선택 가능")
                                .bold()
                            
                            Text("\(formatTime(startLimit, format: "a hh:mm:ss"))")
                            
                            Text("~")
                            
                            Text("\(formatTime(finishLimit, format: "a hh:mm:ss"))")
                        }
                    }

                    Button(action: {
                        if isDeleteButtonPressed {
                            wiDService.deleteWiD(withID: clickedWiDId)
                            // 삭제 후 뒤로가기
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            isDeleteButtonPressed = true
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                withAnimation {
                                    isDeleteButtonPressed = false
                                }
                            }
                        }
                    }) {
                        if isDeleteButtonPressed {
                            Text("삭제 확인")
                        } else {
                            Image(systemName: "trash")
                            
                            Text("삭제")
                        }
                    }
                    .foregroundColor(.red)
                }
                .padding(.horizontal)
            }
            .tint(.black)
            .background(Color("ghost_white"))
            .onAppear {
                self.date = clickedWiD!.date
                self.title = Title(rawValue: clickedWiD!.title) ?? .STUDY
                
                // date 날짜를 clickedWiD!.start와 clickedWiD!.finish에 적용시킴.
                let clickedWiDStartComponents = calendar.dateComponents([.hour, .minute, .second], from: clickedWiD!.start)
                self.start = calendar.date(bySettingHour: clickedWiDStartComponents.hour!, minute: clickedWiDStartComponents.minute!, second: clickedWiDStartComponents.second!, of: date)!
                
                let clickedWiDFinishComponents = calendar.dateComponents([.hour, .minute, .second], from: clickedWiD!.finish)
                self.finish = calendar.date(bySettingHour: clickedWiDFinishComponents.hour!, minute: clickedWiDFinishComponents.minute!, second: clickedWiDFinishComponents.second!, of: date)!
                
                self.duration = clickedWiD!.duration
                self.detail = clickedWiD!.detail
                
                self.wiDList = wiDService.selectWiDsByDate(date: date)
                
                if let index = wiDList.firstIndex(where: { $0.id == clickedWiDId }) {
                    if 0 < index {
                        let previousWiD = wiDList[index - 1]
                        let previousWiDFinishComponents = calendar.dateComponents([.hour, .minute, .second], from: previousWiD.finish)
                        self.startLimit = calendar.date(bySettingHour: previousWiDFinishComponents.hour!, minute: previousWiDFinishComponents.minute!, second: previousWiDFinishComponents.second!, of: date)!
                    } else {
                        self.startLimit = calendar.startOfDay(for: date) // date 날짜의 오전 12:00:00
                    }
                    
                    if index < wiDList.count - 1 {
                        let nextWiD = wiDList[index + 1]
                        let nextWiDStartComponents = calendar.dateComponents([.hour, .minute, .second], from: nextWiD.start)
                        self.finishLimit = calendar.date(bySettingHour: nextWiDStartComponents.hour!, minute: nextWiDStartComponents.minute!, second: nextWiDStartComponents.second!, of: date)!
                    } else if calendar.isDate(date, inSameDayAs: today) {
                        self.finishLimit = currenTime
                    } else {
                        self.finishLimit = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: date)! // date 날짜의 오후 11:59:59
                    }
                }
            }
            .onChange(of: start) { newStart in
                duration = finish.timeIntervalSince(newStart)
                // DB의 newStart는 date가 아니라 2000-01-01 날짜를 가진다.
                // 데이터베이스에서 "HH:mm:ss" 형식의 데이터를 가져와서 Date타입으로 변경하면 "2000-01-01 HH:mm:ss" 형식이 된다.
//                print("new Start : \(formatTime(newStart, format: "yyyy-MM-dd a h:mm:ss"))")
                
                withAnimation {
                    DurationExist = 0 < duration
                }
                
                isStartOverlap = newStart < startLimit
//                print(isStartOverlap ? "start overlap" : "")

                isStartOverCurrentTime = calendar.isDate(date, inSameDayAs: today) && currenTime < newStart
//                print(isStartOverCurrentTime ? "today, start over currentTime" : "")
            }
            .onChange(of: finish) { newFinish in
                duration = newFinish.timeIntervalSince(start)
//                print("new Finish : \(formatTime(newFinish, format: "yyyy-MM-dd a h:mm:ss"))")
                
                withAnimation {
                    DurationExist = 0 < duration
                }
                
                isFinishOverlap = finishLimit < newFinish
//                print(isFinishOverlap ? "finish overlap" : "")

                isFinishOverCurrentTime = calendar.isDate(date, inSameDayAs: today) && currenTime < newFinish
//                print(isFinishOverCurrentTime ? "today, finish over currentTime" : "")
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

