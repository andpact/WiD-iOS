//
//  WiDCreateManualView.swift
//  WiD
//
//  Created by jjkim on 2023/09/19.
//

import SwiftUI

struct NewWiDView: View {
    // 화면
    @Environment(\.presentationMode) var presentationMode
    private let screenHeight = UIScreen.main.bounds.height
    
    // WiD
    private let wiDService = WiDService()
    @State private var wiDList: [WiD] = []
    
    // 날짜
    private let calendar = Calendar.current
    private let today = Date()
    private let date: Date
    private let currentTime = Calendar.current.date(bySetting: .second, value: 0, of: Date()) ?? Date()

    // 제목
    @State private var title: Title = .STUDY
    @State private var expandTitleMenu: Bool = false
    
    // 시작 시간
    @State private var start: Date
    @State private var isStartOverlap: Bool = false
    @State private var isStartOverCurrentTime: Bool = false
    @State private var expandStartPicker: Bool = false
    
    // 종료 시간
    @State private var finish: Date
    @State private var isFinishOverlap: Bool = false
    @State private var isFinishOverCurrentTime: Bool = false
    @State private var expandFinishPicker: Bool = false
    
    // 소요 시간
    @State private var duration: TimeInterval
    @State private var durationExist: Bool = false
    
    // 시작, 종료 시간이 안 정해진 WiD(날짜에 WiD가 전혀 없는 경우)
    init(date: Date) {
        self.date = date
        self._start = State(initialValue: calendar.startOfDay(for: date))
        self._finish = State(initialValue: calendar.startOfDay(for: date))
        self._duration = State(initialValue: 0)
    }
    
    // 시작, 종료 시간이 정해진 WiD(날짜의 빈 시간에 해당)
    init(date: Date, start: Date, finish: Date, duration: TimeInterval) {
        self.date = date
        self._start = State(initialValue: start)
        self._finish = State(initialValue: finish)
        self._duration = State(initialValue: duration)
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                /**
                 상단 바
                 */
                ZStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.backward")
                            .font(.system(size: 24))
                    }
                    .tint(Color("Black-White"))
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Text("새로운 WiD")
                        .titleLarge()
                }
                .frame(maxWidth: .infinity, maxHeight: 44)
                .padding(.horizontal)
                
                Spacer()
                
                VStack(spacing: 0) {
                    // 날짜 선택
                    HStack(spacing: 0) {
                        Image(systemName: "calendar")
                            .font(.system(size: 24))
                            .frame(width: 30, height: 30)
                            .padding()
                        
                        Divider()
                            .background(Color("Black-White"))
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("날짜")
                                .labelMedium()
                            
                            getDateStringView(date: date)
                                .bodyMedium()
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                    .background(Color("White-Black"))

                    Divider()
                        .background(Color("Black-White"))
                    
                    // 제목 선택
                    HStack(spacing: 0) {
                        Image(systemName: titleImageDictionary[title.rawValue] ?? "")
                            .font(.system(size: 24))
                            .frame(width: 30, height: 30)
                            .padding()
                        
                        Divider()
                            .background(Color("Black-White"))
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("제목")
                                .labelMedium()
                            
                            Text(title.koreanValue)
                                .bodyMedium()
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                        
                        Image(systemName: expandTitleMenu ? "chevron.up" : "chevron.down")
                            .font(.system(size: 16))
                            .padding(.horizontal)
                    }
                    .background(Color("White-Black"))
                    .onTapGesture {
                        expandTitleMenu.toggle()
                    }
                    
                    Divider()
                        .background(Color("Black-White"))
                    
                    // 시작 시간 선택
                    HStack(spacing: 0) {
                        Image(systemName: "clock")
                            .font(.system(size: 24))
                            .frame(width: 30, height: 30)
                            .padding()
                        
                        Divider()
                            .background(Color("Black-White"))
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("시작")
                                .labelMedium()
                            
                            Text(getTimeString(start))
                                .bodyMedium()
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                        
                        Image(systemName: expandStartPicker ? "chevron.up" : "chevron.down")
                            .font(.system(size: 16))
                            .padding(.horizontal)
                    }
                    .background(Color("White-Black"))
                    .onTapGesture {
                        expandStartPicker.toggle()
                    }
                       
                    Divider()
                        .background(Color("Black-White"))
                    
                    // 종료 시간 선택
                    HStack(spacing: 0) {
                        Image(systemName: "clock.badge.checkmark")
                            .font(.system(size: 24))
                            .frame(width: 30, height: 30)
                            .padding()
                        
                        Divider()
                            .background(Color("Black-White"))
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("종료")
                                .labelMedium()
                            
                            Text(getTimeString(finish))
                                .bodyMedium()
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                        
                        Image(systemName: expandFinishPicker ? "chevron.up" : "chevron.down")
                            .font(.system(size: 16))
                            .padding(.horizontal)
                    }
                    .background(Color("White-Black"))
                    .onTapGesture {
                        expandFinishPicker.toggle()
                    }
                        
                    Divider()
                        .background(Color("Black-White"))
                    
                    // 소요 시간
                    HStack(spacing: 0) {
                        Image(systemName: "hourglass")
                            .font(.system(size: 24))
                            .frame(width: 30, height: 30)
                            .padding()
                        
                        Divider()
                            .background(Color("Black-White"))
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("소요")
                                .labelMedium()

                            Text(getDurationString(duration, mode: 3))
                                .bodyMedium()
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                    .background(Color("White-Black"))
                }
                .fixedSize(horizontal: false, vertical: true)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color("Black-White"), lineWidth: 0.5)
                )
                .padding(.horizontal)
                
                Button(action: {
                    let newWiD = WiD(id: 0, date: date, title: title.rawValue, start: start, finish: finish, duration: duration)
                    wiDService.createWiD(wid: newWiD)

                    wiDList = wiDService.readWiDListByDate(date: date)

                    checkWiDAvailableByStartAndFinish()
                    
                    // 생성 후 뒤로가기
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("등록")
                        .bodyMedium()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(isStartOverlap || isStartOverCurrentTime || isFinishOverlap || isFinishOverCurrentTime || !durationExist ? Color("DarkGray") : Color("DeepSkyBlue"))
                .foregroundColor(Color("White"))
                .cornerRadius(8)
                .padding(.horizontal)
                .disabled(isStartOverlap || isStartOverCurrentTime || isFinishOverlap || isFinishOverCurrentTime || !durationExist)
                
                Spacer()
            }
            
            /**
             대화 상자
             */
            if expandTitleMenu || expandStartPicker || expandFinishPicker {
                ZStack {
                    Color("Black-White")
                        .opacity(0.3)
                        .onTapGesture {
                            expandTitleMenu = false
                            expandStartPicker = false
                            expandFinishPicker = false
                        }
                    
                    // 제목 선택
                    if expandTitleMenu {
                        ScrollView {
                            VStack(spacing: 0) {
                                ForEach(Title.allCases) { menuTitle in
                                    Button(action: {
                                        title = menuTitle
                                        expandTitleMenu = false
                                    }) {
                                        Image(systemName: titleImageDictionary[menuTitle.rawValue] ?? "")
                                            .font(.system(size: 25))
                                            .frame(maxWidth: 40, maxHeight: 40)
                                        
                                        Spacer()
                                            .frame(maxWidth: 20)
                                        
                                        Text(menuTitle.koreanValue)
                                            .labelMedium()
                                        
                                        Spacer()
                                        
                                        if title == menuTitle {
                                            Image(systemName: "checkmark.circle.fill")
                                                   .font(.system(size: 20))
                                                   .frame(width: 20, height: 20)
                                        } else {
                                            Image(systemName: "circle")
                                                   .font(.system(size: 20))
                                                   .frame(width: 20, height: 20)
                                        }
                                    }
                                    .padding()
                                }
                            }
                        }
                        .tint(Color("Black-White"))
                        .frame(maxWidth: .infinity, maxHeight: screenHeight / 3)
                        .background(Color("White-Black"))
                        .cornerRadius(8)
                        .padding()
                        .shadow(color: Color("Black-White"), radius: 1)
                    }
                    
                    // 시작 시간 선택
                    if expandStartPicker {
                        DatePicker("", selection: $start, displayedComponents: .hourAndMinute)
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                            .padding() // 안쪽 패딩
                            .background(Color("White-Black"))
                            .cornerRadius(8)
                            .padding() // 바깥쪽 패딩
                            .shadow(color: Color("Black-White"), radius: 1)
                    }
                    
                    if expandFinishPicker {
                        DatePicker("", selection: $finish, displayedComponents: .hourAndMinute)
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                            .padding()
                            .background(Color("White-Black"))
                            .cornerRadius(8)
                            .padding()
                            .shadow(color: Color("Black-White"), radius: 1)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarHidden(true)
        .background(Color("White-Black"))
        .onAppear {
            print("NewWiDView appeared")
            
            self.wiDList = wiDService.readWiDListByDate(date: date)
        }
        .onDisappear {
            print("NewWiDView disappeared")
        }
        .onChange(of: start) { newStart in
//            print("new Start : \(formatTime(start, format: "yyyy-MM-dd a h:mm:ss"))")
//            print("new Finish : \(formatTime(finish, format: "yyyy-MM-dd a h:mm:ss"))")
            
            checkWiDAvailableByStartAndFinish()
        }
        .onChange(of: finish) { newFinish in
//            print("new Start : \(formatTime(start, format: "yyyy-MM-dd a h:mm:ss"))")
//            print("new Finish : \(formatTime(finish, format: "yyyy-MM-dd a h:mm:ss"))")

            checkWiDAvailableByStartAndFinish()
        }
    }
    
    func checkWiDAvailableByStartAndFinish() {
        duration = finish.timeIntervalSince(start)
        
        durationExist = 0 < duration
        
        if calendar.isDate(date, inSameDayAs: today) {
            isStartOverCurrentTime = currentTime < start
            isFinishOverCurrentTime = currentTime < finish
        } else {
            isStartOverCurrentTime = false
            isFinishOverCurrentTime = false
        }
        
        if wiDList.isEmpty {
            print("wiDList is empty")
            isStartOverlap = false
            isFinishOverlap = false
        } else {
            for existingWiD in wiDList {
                let existingStartComponents = calendar.dateComponents([.hour, .minute, .second], from: existingWiD.start)
                let existingStart = calendar.date(bySettingHour: existingStartComponents.hour!, minute: existingStartComponents.minute!, second: existingStartComponents.second!, of: date)!
//                print("existingStart : \(formatTime(existingStart, format: "yyyy-MM-dd a h:mm:ss"))")
                
                let existingFinishComponents = calendar.dateComponents([.hour, .minute, .second], from: existingWiD.finish)
                let existingFinish = calendar.date(bySettingHour: existingFinishComponents.hour!, minute: existingFinishComponents.minute!, second: existingFinishComponents.second!, of: date)!
//                print("existingFinish : \(formatTime(existingFinish, format: "yyyy-MM-dd a h:mm:ss"))")

                if existingStart < start && start < existingFinish {
                    isStartOverlap = true
                    break
                } else {
                    isStartOverlap = false
                }
            }

            for existingWiD in wiDList {
                let existingStartComponents = calendar.dateComponents([.hour, .minute, .second], from: existingWiD.start)
                let existingStart = calendar.date(bySettingHour: existingStartComponents.hour!, minute: existingStartComponents.minute!, second: existingStartComponents.second!, of: date)!
                
                let existingFinishComponents = calendar.dateComponents([.hour, .minute, .second], from: existingWiD.finish)
                let existingFinish = calendar.date(bySettingHour: existingFinishComponents.hour!, minute: existingFinishComponents.minute!, second: existingFinishComponents.second!, of: date)!

                if existingStart < finish && finish < existingFinish {
                    isFinishOverlap = true
                    break
                } else {
                    isFinishOverlap = false
                }
            }

            for existingWiD in wiDList {
                let existingStartComponents = calendar.dateComponents([.hour, .minute, .second], from: existingWiD.start)
                let existingStart = calendar.date(bySettingHour: existingStartComponents.hour!, minute: existingStartComponents.minute!, second: existingStartComponents.second!, of: date)!
                
                let existingFinishComponents = calendar.dateComponents([.hour, .minute, .second], from: existingWiD.finish)
                let existingFinish = calendar.date(bySettingHour: existingFinishComponents.hour!, minute: existingFinishComponents.minute!, second: existingFinishComponents.second!, of: date)!

                if start <= existingStart && existingFinish <= finish {
                    isStartOverlap = true
                    isFinishOverlap = true
                    break
                }
            }
        }
    }
}

struct NewWiDView_Previews: PreviewProvider {
    static var previews: some View {
        let today = Date()
        
        Group {
            NewWiDView(date: today)
                .environment(\.colorScheme, .light)
            
            NewWiDView(date: today)
                .environment(\.colorScheme, .dark)
        }
    }
}
