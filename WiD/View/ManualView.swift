//
//  WiDCreateManualView.swift
//  WiD
//
//  Created by jjkim on 2023/09/19.
//

import SwiftUI

struct ManualView: View {
//    private let screen = UIScreen.main.bounds.size
    
    // 화면
    @Environment(\.presentationMode) var presentationMode
    
    // WiD
    private let wiDService = WiDService()
    @State private var wiDList: [WiD] = []
    
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
    
    init() {
        self._wiDList = State(initialValue: wiDService.selectWiDsByDate(date: date))
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

                    Text("직접 입력")
                        .bold()
                    
                    Spacer()
                    
                    Button(action: {
                        let newWiD = WiD(id: 0, date: date, title: title.rawValue, start: start, finish: finish, duration: duration, detail: detail)
                        wiDService.insertWiD(wid: newWiD)

                        wiDList = wiDService.selectWiDsByDate(date: date)
                        
                        checkWiDOverlap()
                    }) {
                        Text("등록")
                            .foregroundColor(isStartOverlap || isStartOverCurrentTime || isFinishOverlap || isFinishOverCurrentTime || !DurationExist ? .gray : .blue)
                    }
                    .disabled(isStartOverlap || isStartOverCurrentTime || isFinishOverlap || isFinishOverCurrentTime || !DurationExist)
                }
                .padding(.horizontal)
                
                // 컨텐츠
                VStack(spacing: 32) {
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("시간 그래프")
                                .font(.custom("BlackHanSans-Regular", size: 20))
                            
                            Spacer()
                            
                            getDayString(date: date)
                        }
                        
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
                            
                            HorizontalBarChartView(wiDList: wiDList)
                        }
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background(.white)
                        .cornerRadius(8)
                        .shadow(radius: 1)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("새로운 WiD")
                            .font(.custom("BlackHanSans-Regular", size: 20))
                        
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
                                        Text(titleDictionary[title.rawValue]!)
                                    }
                                }
                                
                                Spacer()
                                
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color(title.rawValue))
                                    .background(RoundedRectangle(cornerRadius: 5)
                                        .stroke(.black, lineWidth: 1)
                                    )
                                    .frame(width: 5, height: 25)
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
                    .padding(.bottom)
                    
                    Spacer()
                }
            }
            .tint(.black)
            .background(Color("ghost_white"))
            .onChange(of: date) { newDate in
                wiDList = wiDService.selectWiDsByDate(date: newDate)
                print("new Date : \(formatTime(newDate, format: "yyyy-MM-dd a h:mm:ss"))")
                
                // date를 수정해도 start의 날짜는 그대로이므로 start의 날짜를 date에서 가져옴.
                let newStartHour = calendar.component(.hour, from: start)
                let newStartMinute = calendar.component(.minute, from: start)
                let newStartSecond = calendar.component(.second, from: start)
                start = calendar.date(bySettingHour: newStartHour, minute: newStartMinute, second: newStartSecond, of: newDate)!
                
                // date를 수정해도 finish의 날짜는 그대로이므로 finish의 날짜를 date에서 가져옴.
                let newFinishHour = calendar.component(.hour, from: finish)
                let newFinishMinute = calendar.component(.minute, from: finish)
                let newFinishSecond = calendar.component(.second, from: finish)
                finish = calendar.date(bySettingHour: newFinishHour, minute: newFinishMinute, second: newFinishSecond, of: newDate)!
                
                checkWiDOverlap()
            }
            .onChange(of: start) { newStart in
    //            print("new Start : \(formatTime(start, format: "yyyy-MM-dd a h:mm:ss"))")
    //            print("new Finish : \(formatTime(finish, format: "yyyy-MM-dd a h:mm:ss"))")
                
                checkWiDOverlap()
            }
            .onChange(of: finish) { newFinish in
    //            print("new Start : \(formatTime(start, format: "yyyy-MM-dd a h:mm:ss"))")
    //            print("new Finish : \(formatTime(finish, format: "yyyy-MM-dd a h:mm:ss"))")

                checkWiDOverlap()
            }
        }
        .navigationBarHidden(true)
    }
    
    func checkWiDOverlap() {
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
                let existingStartHour = calendar.component(.hour, from: existingWiD.start)
                let existingStartMinute = calendar.component(.minute, from: existingWiD.start)
                let existingStartSecond = calendar.component(.second, from: existingWiD.start)
                let existingStart = calendar.date(bySettingHour: existingStartHour, minute: existingStartMinute, second: existingStartSecond, of: date)!
//                print("existingStart : \(formatTime(existingStart, format: "yyyy-MM-dd a h:mm:ss"))")
                
                let existingFinishHour = calendar.component(.hour, from: existingWiD.finish)
                let existingFinishMinute = calendar.component(.minute, from: existingWiD.finish)
                let existingFinishSecond = calendar.component(.second, from: existingWiD.finish)
                let existingFinish = calendar.date(bySettingHour: existingFinishHour, minute: existingFinishMinute, second: existingFinishSecond, of: date)!
//                print("existingFinish : \(formatTime(existingFinish, format: "yyyy-MM-dd a h:mm:ss"))")

                if existingStart <= start && start <= existingFinish {
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
                let existingStartHour = calendar.component(.hour, from: existingWiD.start)
                let existingStartMinute = calendar.component(.minute, from: existingWiD.start)
                let existingStartSecond = calendar.component(.second, from: existingWiD.start)
                let existingStart = calendar.date(bySettingHour: existingStartHour, minute: existingStartMinute, second: existingStartSecond, of: date)!
                
                let existingFinishHour = calendar.component(.hour, from: existingWiD.finish)
                let existingFinishMinute = calendar.component(.minute, from: existingWiD.finish)
                let existingFinishSecond = calendar.component(.second, from: existingWiD.finish)
                let existingFinish = calendar.date(bySettingHour: existingFinishHour, minute: existingFinishMinute, second: existingFinishSecond, of: date)!

                if existingStart <= finish && finish <= existingFinish {
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
                let existingStartHour = calendar.component(.hour, from: existingWiD.start)
                let existingStartMinute = calendar.component(.minute, from: existingWiD.start)
                let existingStartSecond = calendar.component(.second, from: existingWiD.start)
                let existingStart = calendar.date(bySettingHour: existingStartHour, minute: existingStartMinute, second: existingStartSecond, of: date)!
                
                let existingFinishHour = calendar.component(.hour, from: existingWiD.finish)
                let existingFinishMinute = calendar.component(.minute, from: existingWiD.finish)
                let existingFinishSecond = calendar.component(.second, from: existingWiD.finish)
                let existingFinish = calendar.date(bySettingHour: existingFinishHour, minute: existingFinishMinute, second: existingFinishSecond, of: date)!

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

struct ManualView_Previews: PreviewProvider {
    static var previews: some View {
        ManualView()
    }
}
