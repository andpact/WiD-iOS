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
    private let clickedWiDId: Int
    private let clickedWiD: WiD?
    
    // 날짜
    private let calendar = Calendar.current
    private let today = Date()
    private let currentTime = Calendar.current.date(bySetting: .second, value: 0, of: Date()) ?? Date()
    @State private var date = Date()
    
    // 제목
    @State private var title: Title = .STUDY
    @State private var expandTitleMenu: Bool = false
    
    // 시작 시간
    @State private var start = Date()
    @State private var startLimit = Date()
    @State private var isStartOverlap: Bool = false
    @State private var isStartOverCurrentTime: Bool = false
    @State private var expandStartPicker: Bool = false
    
    // 종료 시간
    @State private var finish = Date()
    @State private var finishLimit = Date()
    @State private var isFinishOverlap: Bool = false
    @State private var isFinishOverCurrentTime: Bool = false
    @State private var expandFinishPicker: Bool = false
    
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
                /**
                 상단 바
                 */
                ZStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.backward")
                        
                        Text("뒤로 가기")
                            .bodyMedium()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.blue)

                    Text("WiD")
                        .titleLarge()
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Button(action: {
                        wiDService.updateWiD(withID: clickedWiDId, newTitle: title.rawValue, newStart: start, newFinish: finish, newDuration: duration, newDetail: detail)
                        
                        wiDList = wiDService.selectWiDsByDate(date: date)
                    }) {
                        Image(systemName: "checkmark")
                        
                        Text("완료")
                            .bodyMedium()
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .foregroundColor(isStartOverlap || isStartOverCurrentTime || isFinishOverlap || isFinishOverCurrentTime || !DurationExist ? .gray : .green)
                    .disabled(isStartOverlap || isStartOverCurrentTime || isFinishOverlap || isFinishOverCurrentTime || !DurationExist)
                }
                .padding(.horizontal)
                
                /**
                 컨텐츠
                 */
                ScrollView {
                    VStack(spacing: 0) {
                        Spacer()
                            .frame(height: 16)
                        
                        // 날짜
                        HStack(spacing: 16) {
                            Image(systemName: "calendar")
                                .imageScale(.large)
                                .frame(width: 20)
                                
                            VStack(alignment: .leading) {
                                Text("날짜")
                                    .labelSmall()
                                
                                getDayString(date: date)
                                    .bodyMedium()
                            }
                            
                            Spacer()
                        }
                        .padding()
                        
                        Divider()
                        
                        // 제목
                        VStack(spacing: 0) {
                            HStack(spacing: 16) {
                                Image(systemName: "character.ko")
                                    .imageScale(.large)
                                    .foregroundColor(Color(title.rawValue))
                                    .frame(width: 20)
                                
                                VStack(alignment: .leading) {
                                    Text("제목")
                                        .labelSmall()
                                    
                                    Text(title.koreanValue)
                                        .bodyMedium()
                                }
                                
                                Spacer()
                                
                                Image(systemName: expandTitleMenu ? "chevron.up" : "chevron.down")
                            }
                            .onTapGesture {
                                withAnimation {
                                    expandTitleMenu.toggle()
                                }
                            }
                            .padding()
                            
                            if expandTitleMenu {
                                HStack {
                                    Text("제목을 선택해 주세요.")
                                        .bodyMedium()
                                        .foregroundColor(.blue)
                                    
                                    Spacer()
                                    
                                    Picker("", selection: $title) {
                                        ForEach(Array(Title.allCases), id: \.self) { title in
                                            Text(title.koreanValue)
                                        }
                                    }
                                }
                                .padding()
                            }
                            
                            Divider()
                        }
                        
                        // 시작 시간 선택
                        VStack(spacing: 0) {
                            HStack(spacing: 16) {
                                Image(systemName: "clock")
                                    .imageScale(.large)
                                    .frame(width: 20)
                                
                                VStack(alignment: .leading) {
                                    Text("시작")
                                        .labelSmall()
                                    
                                    Text(formatTime(start, format: "a h:mm:ss"))
                                        .bodyMedium()
                                }
                                
                                Spacer()
                                
                                Image(systemName: expandStartPicker ? "chevron.up" : "chevron.down")
                            }
                            .onTapGesture {
                                withAnimation {
                                    expandStartPicker.toggle()
                                }
                            }
                            .padding()
                            
                            if expandStartPicker {
                                HStack {
                                    Text("시작 시간을 선택해 주세요.")
                                        .bodyMedium()
                                        .foregroundColor(.blue)
                                    
                                    Spacer()
                                    
                                    DatePicker("", selection: $start, displayedComponents: .hourAndMinute)
                                        .labelsHidden()
                                }
                                .padding()
                            }
                            
                            Divider()
                        }
                        
                        // 종료 시간 선택
                        VStack(spacing: 0) {
                            HStack(spacing: 16) {
                                Image(systemName: "clock.badge.checkmark")
                                    .imageScale(.large)
                                    .frame(width: 20)
                                
                                VStack(alignment: .leading) {
                                    Text("종료")
                                        .labelSmall()
                                    
                                    Text(formatTime(finish, format: "a h:mm:ss"))
                                        .bodyMedium()
                                }
                                
                                Spacer()
                                
                                Image(systemName: expandFinishPicker ? "chevron.up" : "chevron.down")
                            }
                            .onTapGesture {
                                withAnimation {
                                    expandFinishPicker.toggle()
                                }
                            }
                            .padding()
                            
                            if expandFinishPicker {
                                HStack {
                                    Text("종료 시간을 선택해 주세요.")
                                        .bodyMedium()
                                        .foregroundColor(.blue)
                                    
                                    Spacer()
                                    
                                    DatePicker("", selection: $finish, displayedComponents: .hourAndMinute)
                                        .labelsHidden()
                                }
                                .padding()
                            }
                            
                            Divider()
                        }
                        
                        // 소요 시간
                        HStack {
                            Image(systemName: "hourglass")
                                .imageScale(.large)
                                .frame(width: 20)

                            VStack(alignment: .leading) {
                                Text("소요")
                                    .labelSmall()
                                
                                Text(formatDuration(duration, mode: 3))
                                    .bodyMedium()
                            }
                            
                            Spacer()
                        }
                        .padding()
                        
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
                            HStack {
                                if isDeleteButtonPressed {
                                    Text("삭제 확인")
                                        .bodyMedium()
                                } else {
                                    Image(systemName: "trash")
                                    
                                    Text("삭제")
                                        .bodyMedium()
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()

                        }
                        .foregroundColor(isDeleteButtonPressed ? .white : .red)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.red, lineWidth: 1)
                                .background(isDeleteButtonPressed ? .red : Color("ghost_white"))
                        )
                        .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    
                    Rectangle()
                        .frame(height: 8)
                        .padding(.vertical)
                        .foregroundColor(.white)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("선택 가능한 시간 범위")
                            .titleMedium()
                        
                        HStack {
                            Text("\(formatTime(startLimit, format: "a hh:mm:ss"))")
                                .titleLarge()
                            
                            Text("~")
                                .labelSmall()
                            
                            Text("\(formatTime(finishLimit, format: "a hh:mm:ss"))")
                                .titleLarge()
                        }
                        
                        Spacer()
                            .frame(height: 16)
                    }
                }
                
                /**
                 하단 바
                 */
                HStack {
                    Text("하단 바 입니다.")
                        .frame(maxWidth: .infinity)
                }
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
                        self.finishLimit = currentTime
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

                isStartOverCurrentTime = calendar.isDate(date, inSameDayAs: today) && currentTime < newStart
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

                isFinishOverCurrentTime = calendar.isDate(date, inSameDayAs: today) && currentTime < newFinish
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

