//
//  WiDView.swift
//  WiD
//
//  Created by jjkim on 2023/12/05.
//

import SwiftUI

struct WiDDetailView: View {
    // 화면
    @Environment(\.presentationMode) var presentationMode
    @State private var isDeleteButtonPressed: Bool = false
    private let screenHeight = UIScreen.main.bounds.height
    
    // WiD
    private let wiDService = WiDService()
    @State private var wiDList: [WiD] = []
    private let clickedWiDId: Int
    private let clickedWiD: WiD?
    
    // 도구
//    @EnvironmentObject var stopwatchPlayer: StopwatchPlayer
//    @EnvironmentObject var timerPlayer: TimerPlayer
    
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
    @State private var durationExist: Bool = false

    init(clickedWiDId: Int) {
        self.clickedWiDId = clickedWiDId
        self.clickedWiD = wiDService.readWiDByID(id: clickedWiDId)
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

//                    if stopwatchPlayer.stopwatchState != PlayerState.STOPPED && !stopwatchPlayer.inStopwatchView {
//                        HStack {
//                            Text(stopwatchPlayer.title.koreanValue)
//                                .bodyMedium()
//
//                            getHorizontalTimeView(stopwatchPlayer.elapsedTime)
//                                .font(.custom("ChivoMono-Regular", size: 18))
//                        }
//                        .padding(.horizontal, 8)
//                        .padding(.vertical, 4)
//                        .background(Color(stopwatchPlayer.stopwatchState == PlayerState.STARTED ? "LimeGreen" : "OrangeRed"))
//                        .foregroundColor(Color("White"))
//                        .cornerRadius(8)
//                    } else if timerPlayer.timerState != PlayerState.STOPPED && !timerPlayer.inTimerView {
//                        HStack {
//                            Text(timerPlayer.title.koreanValue)
//                                .bodyMedium()
//
//                            getHorizontalTimeView(timerPlayer.remainingTime)
//                                .font(.custom("ChivoMono-Regular", size: 18))
//                        }
//                        .padding(.horizontal, 8)
//                        .padding(.vertical, 4)
//                        .background(Color(timerPlayer.timerState == PlayerState.STARTED ? "LimeGreen" : "OrangeRed"))
//                        .foregroundColor(Color("White"))
//                        .cornerRadius(8)
//                    } else {
                        Text("WiD")
                            .titleLarge()
//                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 44)
                .padding(.horizontal)
                    
                Spacer()
                
                VStack(spacing: 0) {
                    // 날짜
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
                    .background(Color("White-Gray"))
                    
                    Divider()
                        .background(Color("Black-White"))
                    
                    // 제목
                    HStack(spacing: 0) {
                        Image(systemName: "character.ko")
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
                            .padding(.horizontal)
                            .font(.system(size: 16))
                    }
                    .background(Color("White-Gray"))
                    .onTapGesture {
                        withAnimation {
                            expandTitleMenu.toggle()
                        }
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
                            .padding(.horizontal)
                            .font(.system(size: 16))
                    }
                    .background(Color("White-Gray"))
                    .onTapGesture {
                        withAnimation {
                            expandStartPicker.toggle()
                        }
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
                            .padding(.horizontal)
                            .font(.system(size: 16))
                    }
                    .background(Color("White-Gray"))
                    .onTapGesture {
                        withAnimation {
                            expandFinishPicker.toggle()
                        }
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
                    .background(Color("White-Gray"))
                }
                .fixedSize(horizontal: false, vertical: true)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color("Black-White"), lineWidth: 0.5)
                )
                .padding(.horizontal)

                HStack(spacing: 16) {
                    // 삭제 버튼
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
                    .foregroundColor(isDeleteButtonPressed ? Color("White-Black") : Color("OrangeRed"))
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.red, lineWidth: 1)
                            .background(isDeleteButtonPressed ? Color("OrangeRed") : Color("White-Black"))
                    )
                    .cornerRadius(8)
                    
                    // 완료 버튼
                    Button(action: {
                        wiDService.updateWiD(withID: clickedWiDId, newTitle: title.rawValue, newStart: start, newFinish: finish, newDuration: duration)
                        
                        wiDList = wiDService.readWiDListByDate(date: date)
                        
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("완료")
                            .bodyMedium()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isStartOverlap || isStartOverCurrentTime || isFinishOverlap || isFinishOverCurrentTime || !durationExist ? Color("DarkGray") : Color("LimeGreen"))
                            .foregroundColor(Color("White"))
                            .cornerRadius(8)
                    }
                    .disabled(isStartOverlap || isStartOverCurrentTime || isFinishOverlap || isFinishOverCurrentTime || !durationExist)
                }
                .padding(.horizontal)
                
                Spacer()
                
                /**
                 컨텐츠
                 */
//                ScrollView {
//                    VStack(spacing: 8) {
//                        VStack(spacing: 8) {
//                            Text("WiD 정보")
//                                .titleMedium()
//                                .padding(.horizontal)
//                                .frame(maxWidth: .infinity, alignment: .leading)
//                            
//                            VStack(spacing: 0) {
//                                // 날짜
//                                HStack(spacing: 0) {
//                                    Image(systemName: "calendar")
//                                        .font(.system(size: 24))
//                                        .frame(width: 30, height: 30)
//                                        .padding()
//                                    
//                                    Divider()
//                                        .background(Color("Black-White"))
//                                    
//                                    VStack(alignment: .leading, spacing: 4) {
//                                        Text("날짜")
//                                            .labelMedium()
//                                        
//                                        getDateStringView(date: date)
//                                            .bodyMedium()
//                                    }
//                                    .padding(.horizontal)
//                                    
//                                    Spacer()
//                                }
//                                
//                                Divider()
//                                    .background(Color("Black-White"))
//                                
//                                // 제목
//                                HStack(spacing: 0) {
//                                    Image(systemName: "character.ko")
//                                        .font(.system(size: 24))
//                                        .frame(width: 30, height: 30)
//                                        .padding()
//                                    
//                                    Divider()
//                                        .background(Color("Black-White"))
//                                    
//                                    VStack(alignment: .leading, spacing: 4) {
//                                        Text("제목")
//                                            .labelMedium()
//                                        
//                                        Text(title.koreanValue)
//                                            .bodyMedium()
//                                    }
//                                    .padding(.horizontal)
//                                    
//                                    Spacer()
//                                    
//                                    Image(systemName: expandTitleMenu ? "chevron.up" : "chevron.down")
//                                        .padding(.horizontal)
//                                        .font(.system(size: 16))
//                                }
//                                .background(Color("White-Black"))
//                                .onTapGesture {
//                                    withAnimation {
//                                        expandTitleMenu.toggle()
//                                    }
//                                }
//                                
//                                Divider()
//                                    .background(Color("Black-White"))
//                                
//                                // 시작 시간 선택
//                                HStack(spacing: 0) {
//                                    Image(systemName: "clock")
//                                        .font(.system(size: 24))
//                                        .frame(width: 30, height: 30)
//                                        .padding()
//
//                                    Divider()
//                                        .background(Color("Black-White"))
//                                    
//                                    VStack(alignment: .leading, spacing: 4) {
//                                        Text("시작")
//                                            .labelMedium()
//                                        
//                                        Text(getTimeString(start))
//                                            .bodyMedium()
//                                    }
//                                    .padding(.horizontal)
//                                    
//                                    Spacer()
//                                    
//                                    Image(systemName: expandStartPicker ? "chevron.up" : "chevron.down")
//                                        .padding(.horizontal)
//                                        .font(.system(size: 16))
//                                }
//                                .background(Color("White-Black"))
//                                .onTapGesture {
//                                    withAnimation {
//                                        expandStartPicker.toggle()
//                                    }
//                                }
//                                
//                                Divider()
//                                    .background(Color("Black-White"))
//                                
//                                // 종료 시간 선택
//                                HStack(spacing: 0) {
//                                    Image(systemName: "clock.badge.checkmark")
//                                        .font(.system(size: 24))
//                                        .frame(width: 30, height: 30)
//                                        .padding()
//                                    
//                                    Divider()
//                                        .background(Color("Black-White"))
//                                    
//                                    VStack(alignment: .leading, spacing: 4) {
//                                        Text("종료")
//                                            .labelMedium()
//                                        
//                                        Text(getTimeString(finish))
//                                            .bodyMedium()
//                                    }
//                                    .padding(.horizontal)
//                                    
//                                    Spacer()
//                                    
//                                    Image(systemName: expandFinishPicker ? "chevron.up" : "chevron.down")
//                                        .padding(.horizontal)
//                                        .font(.system(size: 16))
//                                }
//                                .background(Color("White-Black"))
//                                .onTapGesture {
//                                    withAnimation {
//                                        expandFinishPicker.toggle()
//                                    }
//                                }
//                                
//                                Divider()
//                                    .background(Color("Black-White"))
//                                
//                                // 소요 시간
//                                HStack(spacing: 0) {
//                                    Image(systemName: "hourglass")
//                                        .font(.system(size: 24))
//                                        .frame(width: 30, height: 30)
//                                        .padding()
//                                    
//                                    Divider()
//                                        .background(Color("Black-White"))
//                                    
//                                    VStack(alignment: .leading, spacing: 4) {
//                                        Text("소요")
//                                            .labelMedium()
//
//                                        Text(getDurationString(duration, mode: 3))
//                                            .bodyMedium()
//                                    }
//                                    .padding(.horizontal)
//                                    
//                                    Spacer()
//                                }
//                            }
//                            .background(Color("White-Black"))
//                            .cornerRadius(8)
//                            .shadow(color: Color("Black-White"), radius: 1)
//                            .padding(.horizontal)
//                            
//                            Button(action: {
//                                if isDeleteButtonPressed {
//                                    wiDService.deleteWiD(withID: clickedWiDId)
//                                    // 삭제 후 뒤로가기
//                                    presentationMode.wrappedValue.dismiss()
//                                } else {
//                                    isDeleteButtonPressed = true
//                                    
//                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                                        withAnimation {
//                                            isDeleteButtonPressed = false
//                                        }
//                                    }
//                                }
//                            }) {
//                                HStack {
//                                    if isDeleteButtonPressed {
//                                        Text("삭제 확인")
//                                            .bodyMedium()
//                                    } else {
//                                        Image(systemName: "trash")
//                                        
//                                        Text("삭제")
//                                            .bodyMedium()
//                                    }
//                                }
//                                .frame(maxWidth: .infinity)
//                                .padding()
//
//                            }
//                            .foregroundColor(isDeleteButtonPressed ? Color("White-Black") : Color("OrangeRed"))
//                            .background(
//                                RoundedRectangle(cornerRadius: 8)
//                                    .stroke(Color.red, lineWidth: 1)
//                                    .background(isDeleteButtonPressed ? Color("OrangeRed") : Color("White-Black"))
//                            )
//                            .cornerRadius(8)
//                            .padding(.horizontal)
//                        }
//                        .padding(.vertical)
//                        
//                        Rectangle()
//                            .frame(maxWidth: .infinity, maxHeight: 8)
//                            .foregroundColor(Color("LightGray-Gray"))
//
//                        VStack(spacing: 8) {
//                            Text("선택 가능한 시간 범위")
//                                .titleMedium()
//                                .padding(.horizontal)
//                                .frame(maxWidth: .infinity, alignment: .leading)
//
//                            HStack(spacing: 8) {
//                                Rectangle()
//                                    .fill(Color("Black-White"))
//                                    .frame(maxWidth: 8)
//
//                                Button(action: {
//                                    start = startLimit
//                                    finish = finishLimit
//                                }) {
//                                    VStack(alignment: .leading, spacing: 4) {
//                                        Text("\(getTimeString(startLimit)) ~ \(getTimeString(finishLimit))")
//                                            .bodyMedium()
//
//                                        Text(getDurationString(finishLimit.timeIntervalSince(startLimit), mode: 3))
//                                            .bodyMedium()
//                                    }
//                                    .padding()
//
//                                    Spacer()
//
//                                    Image(systemName: "square.and.arrow.down")
//                                        .font(.system(size: 16))
//                                        .padding()
//                                }
//                                .tint(Color("Black-White"))
//                                .background(Color("White-Black"))
//                                .cornerRadius(8)
//                                .shadow(color: Color("Black-White"), radius: 1)
//                            }
//                            .padding(.horizontal)
//                        }
//                        .padding(.vertical)
//                    }
//                }
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
                        VStack(spacing: 0) {
                            ZStack {
                                Text("제목 선택")
                                    .titleMedium()
                                
                                Button(action: {
                                    expandTitleMenu = false
                                }) {
                                    Text("확인")
                                        .bodyMedium()
                                }
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                            .padding()
                            
                            Divider()
                                .background(Color("Black-White"))
                            
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
                                                Text("선택됨")
                                                    .bodyMedium()
                                            }
                                        }
                                        .padding()
                                    }
                                }
                            }
                        }
                        .tint(Color("Black-White"))
                        .frame(maxWidth: .infinity, maxHeight: screenHeight / 2)
                        .background(Color("White-Black"))
                        .cornerRadius(8)
                        .padding()
                        .shadow(color: Color("Black-White"), radius: 1)
                    }
                    
                    // 시작 시간 선택
                    if expandStartPicker {
                        VStack(spacing: 0) {
                            ZStack {
                                Button(action: {
                                    expandStartPicker = false
                                }) {
                                    Text("확인")
                                        .bodyMedium()
                                }
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .tint(Color("Black-White"))
                                
                                Text("시작 시간 선택")
                                    .titleMedium()
                            }
                            .padding()
                            
                            Divider()
                                .background(Color("Black-White"))
                            
                            DatePicker("", selection: $start, displayedComponents: .hourAndMinute)
                                .datePickerStyle(.wheel)
                                .labelsHidden()
                        }
                        .background(Color("White-Black"))
                        .cornerRadius(8)
                        .padding()
                        .shadow(color: Color("Black-White"), radius: 1)
                    }
                    
                    if expandFinishPicker {
                        VStack(spacing: 0) {
                            ZStack {
                                Button(action: {
                                    expandFinishPicker = false
                                }) {
                                    Text("확인")
                                        .bodyMedium()
                                }
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .tint(Color("Black-White"))
                                
                                Text("종료 시간 선택")
                                    .titleMedium()
                            }
                            .padding()
                            
                            Divider()
                                .background(Color("Black-White"))
                            
                            DatePicker("", selection: $finish, displayedComponents: .hourAndMinute)
                                .datePickerStyle(.wheel)
                                .labelsHidden()
                        }
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
        .background(Color("LightGray-Black"))
        .onAppear {
            self.date = clickedWiD!.date
            self.title = Title(rawValue: clickedWiD!.title) ?? .STUDY
            
            // date 날짜를 clickedWiD!.start와 clickedWiD!.finish에 적용시킴.
            let clickedWiDStartComponents = calendar.dateComponents([.hour, .minute, .second], from: clickedWiD!.start)
            self.start = calendar.date(bySettingHour: clickedWiDStartComponents.hour!, minute: clickedWiDStartComponents.minute!, second: clickedWiDStartComponents.second!, of: date)!
            
            let clickedWiDFinishComponents = calendar.dateComponents([.hour, .minute, .second], from: clickedWiD!.finish)
            self.finish = calendar.date(bySettingHour: clickedWiDFinishComponents.hour!, minute: clickedWiDFinishComponents.minute!, second: clickedWiDFinishComponents.second!, of: date)!
            
            self.duration = clickedWiD!.duration
            
            self.wiDList = wiDService.readWiDListByDate(date: date)
            
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
                durationExist = 0 < duration
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
                durationExist = 0 < duration
            }
            
            isFinishOverlap = finishLimit < newFinish
//                print(isFinishOverlap ? "finish overlap" : "")

            isFinishOverCurrentTime = calendar.isDate(date, inSameDayAs: today) && currentTime < newFinish
//                print(isFinishOverCurrentTime ? "today, finish over currentTime" : "")
        }
    }
}

struct WiDView_Previews: PreviewProvider {
    static var previews: some View {
        WiDDetailView(clickedWiDId: 0)
    }
}

