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
    private let currenTime = Calendar.current.date(bySetting: .second, value: 0, of: Date())

    // 제목
    @State private var title: Title = .STUDY
    
    // 시작 시간
    @State private var start = Calendar.current.date(bySetting: .second, value: 0, of: Date()) ?? Date()
//    private var startMinutes: Int { return Calendar.current.component(.hour, from: start) * 60 + Calendar.current.component(.minute, from: start) }
    @State private var isStartOverlap: Bool = false
    @State private var isStartOverCurrentTime: Bool = false
    
    // 종료 시간
    @State private var finish = Calendar.current.date(bySetting: .second, value: 0, of: Date()) ?? Date()
//    private var finishMinutes: Int { return Calendar.current.component(.hour, from: finish) * 60 + Calendar.current.component(.minute, from: finish) }
    @State private var isFinishOverlap: Bool = false
    @State private var isFinishOverCurrentTime: Bool = false
    
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

                    Text("새로운 WiD")
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Button(action: {
                        let newWiD = WiD(id: 0, date: date, title: title.rawValue, start: start, finish: finish, duration: duration, detail: detail)
                        wiDService.insertWiD(wid: newWiD)

                        wiDList = wiDService.selectWiDsByDate(date: date)
                        
                        emptyWiDList = getEmptyWiDListFromWiDList(date: date, wiDList: wiDList)
                        
                        checkWiDAvailableByStartAndFinish()
                    }) {
                        Image(systemName: "plus")
                        
                        Text("등록")
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .disabled(isStartOverlap || isStartOverCurrentTime || isFinishOverlap || isFinishOverCurrentTime || !DurationExist)
                    .foregroundColor(isStartOverlap || isStartOverCurrentTime || isFinishOverlap || isFinishOverCurrentTime || !DurationExist ? .gray : .blue)
                }
                .padding(.horizontal)
                
                // 컨텐츠
                ScrollView {
                    VStack(spacing: 32) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("시간 그래프")
                                    .bold()
                                
                                Spacer()
                                
                                getDayString(date: date)
                            }
                            
                            if wiDList.isEmpty {
                                getEmptyView(message: "표시할 그래프가 없습니다.")
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
                                    
                                    MyHorizontalBarChartView(wiDList: wiDList)
                                }
                                .padding(.vertical)
                                .frame(maxWidth: .infinity)
                                .background(.white)
                                .cornerRadius(8)
                                .shadow(radius: 1)
                            }
                        }
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("새로운 WiD")
                                .bold()
                            
                            VStack {
                                HStack(spacing: 16) {
                                    Image(systemName: "calendar")
                                        .frame(width: 20)
                                    
                                    Text("날짜")
                                        .padding(.vertical)
                                    
                                    DatePicker("", selection: $date, in: ...today, displayedComponents: .date)
                                        .labelsHidden()
                                    
                                    Spacer()
                                }

                                HStack(spacing: 16) {
                                    Image(systemName: "character.textbox.ko")
                                        .frame(width: 20)
                                    
                                    Text("제목")
                                        .padding(.vertical)
                                    
                                    Picker("", selection: $title) {
                                        ForEach(Array(Title.allCases), id: \.self) { title in
                                            Text(title.koreanValue)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    Circle()
                                        .fill(Color(title.rawValue))
                                        .frame(width: 10)
                                }
                                
                                HStack(spacing: 16) {
                                    Image(systemName: "play")
                                        .frame(width: 20)
                                    
                                    Text("시작")
                                        .padding(.vertical)
                                    
                                    DatePicker("", selection: $start, displayedComponents: .hourAndMinute)
                                        .labelsHidden()
                                    
                                    Spacer()
                                }
                                    
                                HStack(spacing: 16) {
                                    Image(systemName: "play.fill")
                                        .frame(width: 20)
                                    
                                    Text("종료")
                                        .padding(.vertical)
                                    
                                    DatePicker("", selection: $finish, displayedComponents: .hourAndMinute)
                                        .labelsHidden()
                                    
                                    Spacer()
                                }
                                    
                                HStack(spacing: 16) {
                                    Image(systemName: "hourglass")
                                        .frame(width: 20)
                                    
                                    Text("소요")
                                        .padding(.vertical)

                                    Text(formatDuration(duration, mode: 3))
                                        .padding(.trailing)
                                    
                                    Spacer()
                                }
                                
    //                                HStack {
    //                                    Image(systemName: "text.bubble")
    //                                        .frame(width: 20)
    //                                        .padding()
    //
    //                                    Text("설명")
    //
    //                                    TextEditor(text: $detail)
    //                                        .padding(1)
    //
    //                                    Spacer()
    //                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 6)
                            .frame(maxWidth: .infinity)
                            .background(.white)
                            .cornerRadius(8)
                            .shadow(radius: 1)
                        }
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("선택 가능한 시간대")
                                .bold()
                            
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
                                                
                                                Spacer()
                                                
                                                Image(systemName: "square.and.arrow.down")
                                                    .foregroundColor(.blue)
                                            }
                                            .padding(.horizontal)
                                            .padding(.vertical, 8)
                                            .background(Color("light_gray"))
                                            
                                            Divider()
                                            
                                            HStack {
                                                VStack(alignment: .leading, spacing: 8) {
                                                    HStack(spacing: 0) {
                                                        Text(formatTime(emptyWiD.start, format: "a h:mm:ss"))
                                                            .bold()
                                                        
                                                        Text("부터")
                                                    }
                                                    
                                                    HStack(spacing: 0) {
                                                        Text(formatTime(emptyWiD.finish, format: "a h:mm:ss"))
                                                            .bold()
                                                        
                                                        Text("까지")
                                                    }
                                                }
                                                
                                                Spacer()
                                                
                                                Text(formatDuration(emptyWiD.duration, mode: 3))
                                                    .font(.custom("BlackHanSans-Regular", size: 25))
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
                    }
                    .padding(.vertical)
                }
                
                // 하단 바
                HStack {
                    Text("하단 바 입니다.")
                        .frame(maxWidth: .infinity)
                }
            }
            .tint(.black)
            .background(Color("ghost_white"))
            .onAppear {
                self.wiDList = wiDService.selectWiDsByDate(date: date)
                self.emptyWiDList = getEmptyWiDListFromWiDList(date: date, wiDList: wiDList)
            }
            .onChange(of: date) { newDate in
                wiDList = wiDService.selectWiDsByDate(date: newDate)
                print("new Date : \(formatTime(newDate, format: "yyyy-MM-dd a h:mm:ss"))")
                
                emptyWiDList = getEmptyWiDListFromWiDList(date: newDate, wiDList: wiDList)
                
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
                isStartOverCurrentTime = currenTime! < start
                isFinishOverCurrentTime = currenTime! < finish
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

                if start < existingStart && existingFinish < finish {
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
