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
    
    // 설명
    @State private var detail: String = ""
    
    @State private var gradientOffset: CGFloat = 0.0
    
//    init() {
//        self._wiDList = State(initialValue: wiDService.selectWiDsByDate(date: date))
//        self.emptyWiDList = getEmptyWiDListFromWiDList(wiDList: wiDList)
//    }
    
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

                    Text("새로운 WiD")
                        .titleLarge()
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Button(action: {
                        let newWiD = WiD(id: 0, date: date, title: title.rawValue, start: start, finish: finish, duration: duration, detail: detail)
                        wiDService.insertWiD(wid: newWiD)

                        wiDList = wiDService.selectWiDsByDate(date: date)
                        
                        emptyWiDList = getEmptyWiDListFromWiDList(date: date, currentTime: currentTime, wiDList: wiDList)
                        
                        checkWiDAvailableByStartAndFinish()
                    }) {
                        Image(systemName: "plus")
                        
                        Text("등록")
                            .bodyMedium()
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .disabled(isStartOverlap || isStartOverCurrentTime || isFinishOverlap || isFinishOverCurrentTime || !DurationExist)
                    .foregroundColor(isStartOverlap || isStartOverCurrentTime || isFinishOverlap || isFinishOverCurrentTime || !DurationExist ? .gray : .blue)
                }
                .padding(.horizontal)
                
                /**
                 컨텐츠
                 */
                ScrollView {
                    VStack(spacing: 0) {
                        Spacer()
                            .frame(height: 16)
                        
                        // 날짜 선택
                        VStack(spacing: 0) {
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
                                
                                Image(systemName: expandDatePicker ? "chevron.up" : "chevron.down")
                            }
                            .padding()
                            .onTapGesture {
                                withAnimation {
                                    expandDatePicker.toggle()
                                }
                            }
                            
                            if expandDatePicker {
                                HStack {
                                    Text("날짜를 선택해 주세요.")
                                        .bodyMedium()
                                        .foregroundColor(.blue)
                                    
                                    Spacer()
                                    
                                    DatePicker("", selection: $date, in: ...today, displayedComponents: .date)
                                        .labelsHidden()
                                }
                                .padding()
                            }
                        }
                        
                        Divider()

                        // 제목 선택
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
                        }
                        
                        Divider()
                        
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
                        }
                        
                        Divider()
                            
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
                        }

                        Divider()
                            
                        HStack(spacing: 16) {
                            Image(systemName: "clock.fill")
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
                    }
                    .padding(.horizontal)
                    
                    Rectangle()
                        .frame(height: 8)
                        .padding(.vertical)
                        .foregroundColor(.white)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 0) {
                            getDayString(date: date)
                                .titleMedium()
                            
                            Text("의 타임 라인")
                                .titleMedium()
                        }
                        
                        if wiDList.isEmpty {
                            getEmptyView(message: "표시할 타임라인이 없습니다.")
                        } else {
                            VStack {
            //                    ZStack {
            //                        Image(systemName: "arrowtriangle.down")
            //                            .foregroundColor(isStartOverlap || isStartOverCurrentTime || DurationExist ? .red : .none)
            //                            .offset(x: CGFloat(startMinutes) / (24 * 60) * screen.width * 0.8 - screen.width * 0.8 / 2)
            //
            //                        Image(systemName: "arrowtriangle.down.fill")
            //                            .foregroundColor(isFinishOverlap || isFinishOverCurrentTime || DurationExist ? .red : .none)
            //                            .offset(x: CGFloat(finishMinutes) / (24 * 60) * screen.width * 0.8 - screen.width * 0.8 / 2)
            //                    }
                                
                                StackedHorizontalBarChartView(wiDList: wiDList)
                            }
                            .padding(.vertical)
                            .frame(maxWidth: .infinity)
                            .background(.white)
                            .cornerRadius(8)
                            .shadow(radius: 1)
                        }
                    }
                    .padding(.horizontal)
                    
                    Rectangle()
                        .frame(height: 8)
                        .padding(.vertical)
                        .foregroundColor(.white)
                        
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("선택 가능한 시간대")
                            .titleMedium()
                        
                        if wiDList.isEmpty {
                            getEmptyView(message: "표시할 시간대가 없습니다.")
                        } else {
                            ForEach(Array(emptyWiDList.enumerated()), id: \.element.id) { (index, emptyWiD) in
                                Button(action: {
                                    start = emptyWiD.start
                                    finish = emptyWiD.finish
                                }) {
                                    VStack(spacing: 0) {
                                        HStack {
                                            Circle()
                                                .fill(.black)
                                                .frame(width: 10)
                                            
                                            Text("제목 없음")
                                                .labelMedium()
                                            
                                            Spacer()
                                            
                                            Image(systemName: "square.and.arrow.down")
                                                .foregroundColor(.blue)
                                        }
                                        .padding(.horizontal)
                                        .padding(.vertical, 8)
                                        .background(Color("light_gray"))
                                        
                                        Divider()
                                        
                                        HStack {
                                            VStack(alignment: .leading) {
                                                Text(formatTime(emptyWiD.start, format: "a h:mm:ss"))
                                                    .bodyMedium()
                                            
                                                Text(formatTime(emptyWiD.finish, format: "a h:mm:ss"))
                                                    .bodyMedium()
                                            }
                                            
                                            Spacer()
                                            
                                            Text(formatDuration(emptyWiD.duration, mode: 3))
                                                .font(.custom("PyeongChangPeace-Bold", size: 20))
                                        }
                                        .padding(.horizontal)
                                        .padding(.vertical, 8)
                                    }
                                    .background(.white)
                                    .cornerRadius(8)
                                    .shadow(radius: 1)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                        .frame(height: 16)
                }
                
                /**
                 하단 바
                 */
//                HStack {
//                    Text("하단 바 입니다.")
//                        .frame(maxWidth: .infinity)
//                }
            }
            .tint(.black)
            .background(Color("ghost_white"))
            .onAppear {
                self.wiDList = wiDService.selectWiDsByDate(date: date)
                self.emptyWiDList = getEmptyWiDListFromWiDList(date: date, currentTime: currentTime, wiDList: wiDList)
            }
            .onChange(of: date) { newDate in
                wiDList = wiDService.selectWiDsByDate(date: newDate)
                print("new Date : \(formatTime(newDate, format: "yyyy-MM-dd a h:mm:ss"))")
                
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
        .navigationBarHidden(true)
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
        NewWiDView()
    }
}
