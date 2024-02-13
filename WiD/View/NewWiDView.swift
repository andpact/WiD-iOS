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
//    @State private var emptyWiDList: [WiD] = []
    
    // 날짜
    private let calendar = Calendar.current
    private let today = Date()
//    @State private var date = Date()
    private let date: Date
    private let currentTime = Calendar.current.date(bySetting: .second, value: 0, of: Date()) ?? Date()
//    private let currentTime = Date()
//    @State private var expandDatePicker: Bool = false

    // 제목
    @State private var title: Title = .STUDY
    @State private var expandTitleMenu: Bool = false
    
    // 시작 시간
//    @State private var start = Calendar.current.date(bySetting: .second, value: 0, of: Date()) ?? Date()
    @State private var start: Date
    @State private var isStartOverlap: Bool = false
    @State private var isStartOverCurrentTime: Bool = false
    @State private var expandStartPicker: Bool = false
    
    // 종료 시간
//    @State private var finish = Calendar.current.date(bySetting: .second, value: 0, of: Date()) ?? Date()
    @State private var finish: Date
    @State private var isFinishOverlap: Bool = false
    @State private var isFinishOverCurrentTime: Bool = false
    @State private var expandFinishPicker: Bool = false
    
    // 소요 시간
//    @State private var duration: TimeInterval = 0
    @State private var duration: TimeInterval
    @State private var durationExist: Bool = false
    
    // 시작, 종료 시간이 안 정해진 WiD
    init(date: Date) {
        self.date = date
        self._start = State(initialValue: calendar.date(bySetting: .second, value: 0, of: Date()) ?? Date())
        self._finish = State(initialValue: calendar.date(bySetting: .second, value: 0, of: Date()) ?? Date())
        self._duration = State(initialValue: 0)
    }
    
    // 시작, 종료 시간이 정해진 WiD
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
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.backward")
                            .font(.system(size: 24))
                    }
                    .tint(Color("Black-White"))

                    Text("새로운 WiD")
                        .titleLarge()
                    
                    Spacer()
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
                        
//                        Image(systemName: expandDatePicker ? "chevron.up" : "chevron.down")
//                            .font(.system(size: 16))
//                            .padding(.horizontal)
                    }
                    .background(Color("White-Gray"))
//                    .onTapGesture {
//                        withAnimation {
//                            expandDatePicker.toggle()
//                        }
//                    }

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
                            .font(.system(size: 16))
                            .padding(.horizontal)
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
                            .font(.system(size: 16))
                            .padding(.horizontal)
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
                
                Button(action: {
                    let newWiD = WiD(id: 0, date: date, title: title.rawValue, start: start, finish: finish, duration: duration)
                    wiDService.createWiD(wid: newWiD)

                    wiDList = wiDService.readWiDListByDate(date: date)

//                    emptyWiDList = getEmptyWiDListFromWiDList(date: date, currentTime: currentTime, wiDList: wiDList)

                    checkWiDAvailableByStartAndFinish()
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
//            if expandDatePicker || expandTitleMenu || expandStartPicker || expandFinishPicker {
            if expandTitleMenu || expandStartPicker || expandFinishPicker {
                ZStack {
                    Color("Black-White")
                        .opacity(0.3)
                        .onTapGesture {
//                            expandDatePicker = false
                            expandTitleMenu = false
                            expandStartPicker = false
                            expandFinishPicker = false
                        }
                    
                    // 날짜 선택
//                    if expandDatePicker {
//                        VStack(spacing: 0) {
//                            ZStack {
//                                Button(action: {
//                                    expandDatePicker = false
//                                }) {
//                                    Text("확인")
//                                        .bodyMedium()
//                                }
//                                .frame(maxWidth: .infinity, alignment: .trailing)
//                                .tint(Color("Black-White"))
//
//                                Text("날짜 선택")
//                                    .titleMedium()
//                            }
//                            .padding()
//
//                            Divider()
//                                .background(Color("Black-White"))
//
//                            DatePicker("", selection: $date, in: ...today, displayedComponents: .date)
//                                .datePickerStyle(.graphical)
//                                .padding()
//                        }
//                        .background(Color("White-Black"))
//                        .cornerRadius(8)
//                        .padding() // 바깥 패딩
//                        .shadow(color: Color("Black-White"), radius: 1)
//                    }
                    
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
            self.wiDList = wiDService.readWiDListByDate(date: date)
//            self.emptyWiDList = getEmptyWiDListFromWiDList(date: date, currentTime: currentTime, wiDList: wiDList)
        }
//        .onChange(of: date) { newDate in
//            wiDList = wiDService.readWiDListByDate(date: newDate)
//            print("new Date : \(getTimeString(newDate))")
//
////            emptyWiDList = getEmptyWiDListFromWiDList(date: newDate, currentTime: currentTime, wiDList: wiDList)
//
//            // date를 수정해도 start의 날짜는 그대로이므로 start의 날짜를 date에서 가져옴.
//            let newStartComponents = calendar.dateComponents([.hour, .minute, .second], from: start)
//            start = calendar.date(bySettingHour: newStartComponents.hour!, minute: newStartComponents.minute!, second: newStartComponents.second!, of: newDate)!
//
//            // date를 수정해도 finish의 날짜는 그대로이므로 finish의 날짜를 date에서 가져옴.
//            let newFinishComponents = calendar.dateComponents([.hour, .minute, .second], from: finish)
//            finish = calendar.date(bySettingHour: newFinishComponents.hour!, minute: newFinishComponents.minute!, second: newFinishComponents.second!, of: newDate)!
//
//            checkWiDAvailableByStartAndFinish()
//        }
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
        
        withAnimation {
            durationExist = 0 < duration
        }
        
        if calendar.isDate(date, inSameDayAs: today) {
            withAnimation {
                isStartOverCurrentTime = currentTime < start
                isFinishOverCurrentTime = currentTime < finish
            }
        } else {
            withAnimation {
                isStartOverCurrentTime = false
                isFinishOverCurrentTime = false
            }
        }
        
        if wiDList.isEmpty {
            print("wiDList is empty")
            withAnimation {
                isStartOverlap = false
                isFinishOverlap = false
            }
        } else {
            for existingWiD in wiDList {
                let existingStartComponents = calendar.dateComponents([.hour, .minute, .second], from: existingWiD.start)
                let existingStart = calendar.date(bySettingHour: existingStartComponents.hour!, minute: existingStartComponents.minute!, second: existingStartComponents.second!, of: date)!
//                print("existingStart : \(formatTime(existingStart, format: "yyyy-MM-dd a h:mm:ss"))")
                
                let existingFinishComponents = calendar.dateComponents([.hour, .minute, .second], from: existingWiD.finish)
                let existingFinish = calendar.date(bySettingHour: existingFinishComponents.hour!, minute: existingFinishComponents.minute!, second: existingFinishComponents.second!, of: date)!
//                print("existingFinish : \(formatTime(existingFinish, format: "yyyy-MM-dd a h:mm:ss"))")

                if existingStart < start && start < existingFinish {
                    withAnimation {
                        isStartOverlap = true
                    }
                    break
                } else {
                    withAnimation {
                        isStartOverlap = false
                    }
                }
            }

            for existingWiD in wiDList {
                let existingStartComponents = calendar.dateComponents([.hour, .minute, .second], from: existingWiD.start)
                let existingStart = calendar.date(bySettingHour: existingStartComponents.hour!, minute: existingStartComponents.minute!, second: existingStartComponents.second!, of: date)!
                
                let existingFinishComponents = calendar.dateComponents([.hour, .minute, .second], from: existingWiD.finish)
                let existingFinish = calendar.date(bySettingHour: existingFinishComponents.hour!, minute: existingFinishComponents.minute!, second: existingFinishComponents.second!, of: date)!

                if existingStart < finish && finish < existingFinish {
                    withAnimation {
                        isFinishOverlap = true
                    }
                    break
                } else {
                    withAnimation {
                        isFinishOverlap = false
                    }
                }
            }

            for existingWiD in wiDList {
                let existingStartComponents = calendar.dateComponents([.hour, .minute, .second], from: existingWiD.start)
                let existingStart = calendar.date(bySettingHour: existingStartComponents.hour!, minute: existingStartComponents.minute!, second: existingStartComponents.second!, of: date)!
                
                let existingFinishComponents = calendar.dateComponents([.hour, .minute, .second], from: existingWiD.finish)
                let existingFinish = calendar.date(bySettingHour: existingFinishComponents.hour!, minute: existingFinishComponents.minute!, second: existingFinishComponents.second!, of: date)!

                if start <= existingStart && existingFinish <= finish {
                    withAnimation {
                        isStartOverlap = true
                        isFinishOverlap = true
                    }
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
            
            NewWiDView(date: today)
                .environment(\.colorScheme, .dark)
        }
    }
}
