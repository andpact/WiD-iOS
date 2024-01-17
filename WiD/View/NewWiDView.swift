//
//  WiDCreateManualView.swift
//  WiD
//
//  Created by jjkim on 2023/09/19.
//

import SwiftUI

struct NewWiDView: View {
//    private let screen = UIScreen.main.bounds.size
    
    // 화면
    @Environment(\.presentationMode) var presentationMode
    
    // WiD
    private let wiDService = WiDService()
    @State private var wiDList: [WiD] = []
    @State private var emptyWiDList: [WiD] = []
    
    // 날짜
    private let calendar = Calendar.current
    private let today = Date()
    @State private var date = Date()
    private let currentTime = Calendar.current.date(bySetting: .second, value: 0, of: Date()) ?? Date()
    @State private var expandDatePicker: Bool = false

    // 제목
    @State private var title: Title = .STUDY
    @State private var expandTitleMenu: Bool = false
    
    // 시작 시간
    @State private var start = Calendar.current.date(bySetting: .second, value: 0, of: Date()) ?? Date()
//    private var startMinutes: Int { return Calendar.current.component(.hour, from: start) * 60 + Calendar.current.component(.minute, from: start) }
    @State private var isStartOverlap: Bool = false
    @State private var isStartOverCurrentTime: Bool = false
    @State private var expandStartPicker: Bool = false
    
    // 종료 시간
    @State private var finish = Calendar.current.date(bySetting: .second, value: 0, of: Date()) ?? Date()
//    private var finishMinutes: Int { return Calendar.current.component(.hour, from: finish) * 60 + Calendar.current.component(.minute, from: finish) }
    @State private var isFinishOverlap: Bool = false
    @State private var isFinishOverCurrentTime: Bool = false
    @State private var expandFinishPicker: Bool = false
    
    // 소요 시간
    @State private var duration: TimeInterval = 0
    @State private var DurationExist: Bool = false
    
//    init() {
//        self._wiDList = State(initialValue: wiDService.selectWiDsByDate(date: date))
//        self.emptyWiDList = getEmptyWiDListFromWiDList(wiDList: wiDList)
//    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                /**
                 상단 바
                 */
                ZStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.backward")
                            .imageScale(.large)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .tint(Color("Black-White"))

                    Text("새로운 WiD")
                        .titleLarge()
                    
                    Button(action: {
                        let newWiD = WiD(id: 0, date: date, title: title.rawValue, start: start, finish: finish, duration: duration)
                        wiDService.insertWiD(wid: newWiD)

                        wiDList = wiDService.selectWiDListByDate(date: date)
                        
                        emptyWiDList = getEmptyWiDListFromWiDList(date: date, currentTime: currentTime, wiDList: wiDList)
                        
                        checkWiDAvailableByStartAndFinish()
                    }) {
                        Text("등록")
                            .bodyMedium()
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(isStartOverlap || isStartOverCurrentTime || isFinishOverlap || isFinishOverCurrentTime || !DurationExist ? Color("LightGray-Gray") : Color("DeepSkyBlue"))
                            .foregroundColor(Color("White"))
                            .cornerRadius(8)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .disabled(isStartOverlap || isStartOverCurrentTime || isFinishOverlap || isFinishOverCurrentTime || !DurationExist)
                }
                .frame(maxWidth: .infinity, maxHeight: 44)
                .padding(.horizontal)
                
                Divider()
                    .background(Color("LightGray"))
                
                /**
                 컨텐츠
                 */
                ScrollView {
                    VStack(spacing: 8) {
                        VStack(spacing: 8) {
                            Text("정보 입력")
                                .titleMedium()
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            // 날짜 선택
                            VStack(spacing: 0) { // 더미 스택
                                HStack(spacing: 16) {
                                    Image(systemName: "calendar")
                                        .imageScale(.large)
                                        .frame(width: 30, height: 30)
                                        .padding()
                                        .background(Color("LightGray-Gray"))
                                        .cornerRadius(8)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("날짜")
                                            .labelMedium()
                                        
                                        getDayString(date: date)
                                            .bodyMedium()
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: expandDatePicker ? "chevron.up" : "chevron.down")
                                }
                                .padding(.horizontal)
                                .background(Color("White-Black"))
                                .onTapGesture {
                                    withAnimation {
                                        expandDatePicker.toggle()
                                    }
                                }
                                
                                if expandDatePicker {
                                    HStack {
                                        Text("날짜를 선택해 주세요.")
                                            .bodyMedium()
                                        
                                        Spacer()
                                        
                                        DatePicker("", selection: $date, in: ...today, displayedComponents: .date)
                                            .labelsHidden()
                                            .background(Color("LightGray-Gray"))
                                            .tint(Color("Black-White"))
                                            .cornerRadius(8)
                                    }
                                    .padding()
                                }
                            }

                            // 제목 선택
                            VStack(spacing: 0) { // 더미 스택
                                HStack(spacing: 16) {
                                    Image(systemName: "character.ko")
                                        .imageScale(.large)
                                        .frame(width: 30, height: 30)
                                        .padding()
                                        .background(Color("LightGray-Gray"))
                                        .cornerRadius(8)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("제목")
                                            .labelMedium()
                                        
                                        Text(title.koreanValue)
                                            .bodyMedium()
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: expandTitleMenu ? "chevron.up" : "chevron.down")
                                }
                                .padding(.horizontal)
                                .background(Color("White-Black"))
                                .onTapGesture {
                                    withAnimation {
                                        expandTitleMenu.toggle()
                                    }
                                }
                                
                                if expandTitleMenu {
                                    HStack {
                                        Text("제목을 선택해 주세요.")
                                            .bodyMedium()
                                        
                                        Spacer()
                                        
                                        Picker("", selection: $title) {
                                            ForEach(Array(Title.allCases), id: \.self) { title in
                                                Text(title.koreanValue)
                                                    
                                            }
                                        }
                                        .background(Color("LightGray-Gray"))
                                        .tint(Color("Black-White"))
                                        .cornerRadius(8)
                                    }
                                    .padding()
                                }
                            }
                            
                            // 시작 시간 선택
                            VStack(spacing: 0) { // 더미 스택
                                HStack(spacing: 16) {
                                    Image(systemName: "clock")
                                        .imageScale(.large)
                                        .frame(width: 30, height: 30)
                                        .padding()
                                        .background(Color("LightGray-Gray"))
                                        .cornerRadius(8)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("시작")
                                            .labelMedium()
                                        
                                        Text(formatTime(start))
                                            .bodyMedium()
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: expandStartPicker ? "chevron.up" : "chevron.down")
                                }
                                .padding(.horizontal)
                                .background(Color("White-Black"))
                                .onTapGesture {
                                    withAnimation {
                                        expandStartPicker.toggle()
                                    }
                                }
                                
                                if expandStartPicker {
                                    HStack {
                                        Text("시작 시간을 선택해 주세요.")
                                            .bodyMedium()
                                        
                                        Spacer()
                                        
                                        DatePicker("", selection: $start, displayedComponents: .hourAndMinute)
                                            .labelsHidden()
                                            .background(Color("LightGray-Gray"))
                                            .tint(Color("Black-White"))
                                            .cornerRadius(8)
                                    }
                                    .padding()
                                }
                            }
                                
                            // 종료 시간 선택
                            VStack(spacing: 0) { // 더미 스택
                                HStack(spacing: 16) {
                                    Image(systemName: "clock.badge.checkmark")
                                        .imageScale(.large)
                                        .frame(width: 30, height: 30)
                                        .padding()
                                        .background(Color("LightGray-Gray"))
                                        .cornerRadius(8)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("종료")
                                            .labelMedium()
                                        
                                        Text(formatTime(finish))
                                            .bodyMedium()
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: expandFinishPicker ? "chevron.up" : "chevron.down")
                                }
                                .padding(.horizontal)
                                .background(Color("White-Black"))
                                .onTapGesture {
                                    withAnimation {
                                        expandFinishPicker.toggle()
                                    }
                                }
                                
                                if expandFinishPicker {
                                    HStack {
                                        Text("종료 시간을 선택해 주세요.")
                                            .bodyMedium()
                                        
                                        Spacer()
                                        
                                        DatePicker("", selection: $finish, displayedComponents: .hourAndMinute)
                                            .labelsHidden()
                                            .background(Color("LightGray-Gray"))
                                            .tint(Color("Black-White"))
                                            .cornerRadius(8)
                                    }
                                    .padding()
                                }
                            }
                                
                            // 소요 시간
                            HStack(spacing: 16) {
                                Image(systemName: "hourglass")
                                    .imageScale(.large)
                                    .frame(width: 30, height: 30)
                                    .padding()
                                    .background(Color("LightGray-Gray"))
                                    .cornerRadius(8)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("소요")
                                        .labelMedium()

                                    Text(formatDuration(duration, mode: 3))
                                        .bodyMedium()
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical)
                        .background(Color("White-Black"))
                        
//                        VStack(spacing: 0) {
//                            HStack(spacing: 0) {
//                                getDayString(date: date)
//                                    .titleMedium()
//
//                                Text("의 타임 라인")
//                                    .titleMedium()
//                            }
//                            .padding(.horizontal)
//                            .frame(maxWidth: .infinity, alignment: .leading)
//
//                            if wiDList.isEmpty {
//                                getEmptyView(message: "표시할 타임라인이 없습니다.")
//                            } else {
//    //                            VStack {
//                //                    ZStack {
//                //                        Image(systemName: "arrowtriangle.down")
//                //                            .foregroundColor(isStartOverlap || isStartOverCurrentTime || DurationExist ? .red : .none)
//                //                            .offset(x: CGFloat(startMinutes) / (24 * 60) * screen.width * 0.8 - screen.width * 0.8 / 2)
//                //
//                //                        Image(systemName: "arrowtriangle.down.fill")
//                //                            .foregroundColor(isFinishOverlap || isFinishOverCurrentTime || DurationExist ? .red : .none)
//                //                            .offset(x: CGFloat(finishMinutes) / (24 * 60) * screen.width * 0.8 - screen.width * 0.8 / 2)
//                //                    }
//
//                                    StackedHorizontalBarChartView(wiDList: wiDList)
//    //                            }
//                            }
//                        }
//                        .padding(.vertical)
//                        .background(.white)
                            
                        VStack(spacing: 8) {
                            Text("선택 가능한 시간대")
                                .titleMedium()
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            if wiDList.isEmpty {
                                getEmptyView(message: "표시할 시간대가 없습니다.")
                            } else {
                                ForEach(Array(emptyWiDList), id: \.id) { emptyWiD in
                                    Button(action: {
                                        start = emptyWiD.start
                                        finish = emptyWiD.finish
                                    }) {
                                        HStack(spacing: 16) {
                                            Rectangle()
                                                .fill(Color("DarkGray"))
                                                .frame(maxWidth: 8)

                                            VStack(alignment: .leading, spacing: 4) {
                                                Text("\(formatTime(emptyWiD.start)) ~ \(formatTime(emptyWiD.finish))")
                                                    .bodyMedium()

                                                Text(formatDuration(emptyWiD.duration, mode: 3))
                                                    .labelMedium()
                                            }
                                            .padding(.vertical)

                                            Spacer()

                                            Image(systemName: "square.and.arrow.down")
                                                .padding(.horizontal)
                                        }
                                    }
                                    .tint(Color("Black-White"))
                                    .background(Color("LightGray-Gray"))
                                    .cornerRadius(8)
                                    .padding(.horizontal)
                                }
                            }
                        }
                        .padding(.vertical)
                        .background(Color("White-Black"))
                    }
                }
                .background(Color("LightGray-Gray"))
                
                /**
                 하단 바
                 */
//                HStack {
//                    Text("WiD")
//                        .font(.custom("Acme-Regular", size: 20))
//
//                }
//                .frame(maxWidth: .infinity)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            self.wiDList = wiDService.selectWiDListByDate(date: date)
            self.emptyWiDList = getEmptyWiDListFromWiDList(date: date, currentTime: currentTime, wiDList: wiDList)
        }
        .onChange(of: date) { newDate in
            wiDList = wiDService.selectWiDListByDate(date: newDate)
            print("new Date : \(formatTime(newDate))")
            
            emptyWiDList = getEmptyWiDListFromWiDList(date: newDate, currentTime: currentTime, wiDList: wiDList)
            
            // date를 수정해도 start의 날짜는 그대로이므로 start의 날짜를 date에서 가져옴.
            let newStartComponents = calendar.dateComponents([.hour, .minute, .second], from: start)
            start = calendar.date(bySettingHour: newStartComponents.hour!, minute: newStartComponents.minute!, second: newStartComponents.second!, of: newDate)!
            
            // date를 수정해도 finish의 날짜는 그대로이므로 finish의 날짜를 date에서 가져옴.
            let newFinishComponents = calendar.dateComponents([.hour, .minute, .second], from: finish)
            finish = calendar.date(bySettingHour: newFinishComponents.hour!, minute: newFinishComponents.minute!, second: newFinishComponents.second!, of: newDate)!
            
            checkWiDAvailableByStartAndFinish()
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
        
        withAnimation {
            DurationExist = 0 < duration
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
        Group {
            NewWiDView()
            
            NewWiDView()
                .environment(\.colorScheme, .dark)
        }
    }
}
