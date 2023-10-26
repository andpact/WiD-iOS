//
//  ManualViewTmp.swift
//  WiD
//
//  Created by jjkim on 2023/10/25.
//

import SwiftUI

struct ManualViewTmp: View {
    private let wiDService = WiDService()
    @State private var wiDList: [WiD] = []
    
    private let calendar = Calendar.current
    private let today = Date()
    private let currenTime = Calendar.current.date(bySetting: .second, value: 0, of: Date())

    @State private var date = Date()
    @State private var title: Title = .STUDY
    @State private var start = Calendar.current.date(bySetting: .second, value: 0, of: Date()) ?? Date()
    private var startMinutes: Int { return Calendar.current.component(.hour, from: start) * 60 + Calendar.current.component(.minute, from: start) }
    @State private var finish = Calendar.current.date(bySetting: .second, value: 0, of: Date()) ?? Date()
    private var finishMinutes: Int { return Calendar.current.component(.hour, from: finish) * 60 + Calendar.current.component(.minute, from: finish) }
    @State private var duration: TimeInterval = 0.0
    private let detail: String = ""
    
    @State private var isStartOverlap: Bool = false
    @State private var isStartOverCurrentTime: Bool = false

    @State private var isFinishOverlap: Bool = false
    @State private var isFinishOverCurrentTime: Bool = false

    @State private var isDurationUnderMin: Bool = false
    @State private var isDurationOverMax: Bool = false

    init() {
        self._wiDList = State(initialValue: wiDService.selectWiDsByDate(date: date))
    }

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            VStack(spacing: 8) {
                Text(formatDate(date, format: "yyyy년 M월 d일"))
                    .bold()
                
                HStack {
                    ZStack {
                        Image(systemName: isStartOverlap || isStartOverCurrentTime ? "play.slash" : "play")
                            .foregroundColor(isStartOverlap || isStartOverCurrentTime ? .red : .none)
                            .offset(y: CGFloat(startMinutes) / (24 * 60) * UIScreen.main.bounds.size.height * 0.6 - UIScreen.main.bounds.size.height * 0.6 / 2)
                        
                        Image(systemName: isFinishOverlap || isFinishOverCurrentTime ? "play.slash.fill" : "play.fill")
                            .foregroundColor(isFinishOverlap || isFinishOverCurrentTime ? .red : .none)
                            .offset(y: CGFloat(finishMinutes) / (24 * 60) * UIScreen.main.bounds.size.height * 0.6 - UIScreen.main.bounds.size.height * 0.6 / 2)
                    }

                    BarChartView(wiDList: wiDList)
                }
                .frame(maxWidth: UIScreen.main.bounds.size.width * 0.4)
                .background(RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray, lineWidth: 1)
                    .background(.white)
                )
            }
            
            VStack(spacing: 8) {
                HStack {
                    Text("New WiD")
                        .bold()
                    
//                    Spacer()
                }
//                .padding(.trailing)
                
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("날짜")
                        
                        HStack {
                            Image(systemName: "calendar")
                                .frame(width: 20)
                                .padding()
                            
                            Spacer()
                            
                            DatePicker("날짜", selection: $date, in: ...Date(), displayedComponents: .date)
                                .labelsHidden()
                                .padding(.trailing)
                        }
                        .background(RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 1)
                            .background(.white)
                        )
                    }

                    VStack(alignment: .leading, spacing: 0) {
                        Text("제목")
                        
                        HStack {
                            Image(systemName: "character.textbox.ko")
                                .frame(width: 20)
                                .padding()
                            
                            Spacer()
                            
                            Picker("", selection: $title) {
                                ForEach(Array(Title.allCases), id: \.self) { title in
                                    Text(titleDictionary[title.rawValue]!)
                                }
                            }
                            
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 1)
                                .background(Color(title.rawValue))
                                .frame(maxWidth: 5, maxHeight: 25)
                                .padding(.trailing)
                        }
                        .background(RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 1)
                            .background(.white)
                        )
                    }
                    VStack(alignment: .leading, spacing: 0) {
                        Text("시작")
                        
                        HStack {
                            Image(systemName: "play")
                                .frame(width: 20)
                                .padding()
                            
                            Spacer()
                            
                            DatePicker("시작", selection: $start, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .padding(.trailing)
                        }
                        .background(RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 1)
                            .background(.white)
                        )
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("종료")
                        
                        HStack {
                            Image(systemName: "play.fill")
                                .frame(width: 20)
                                .padding()
                            
                            Spacer()
                            
                            DatePicker("종료", selection: $finish, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .padding(.trailing)
                        }
                        .background(RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 1)
                            .background(.white)
                        )
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("경과")
                        
                        HStack {
                            Image(systemName: "hourglass")
                                .frame(width: 20)
                                .padding()
                            
                            Spacer()

                            Text(formatDuration(duration, mode: 3))
                                .padding(.trailing)
                        }
                        .background(RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 1)
                            .background(.white)
                        )
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray, lineWidth: 1)
                    .background(Color("light_gray"))
                )
//                .padding(.trailing)
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        let wiD = WiD(id: 0, date: date, title: title.rawValue, start: start, finish: finish, duration: duration, detail: detail)
                        wiDService.insertWiD(wid: wiD)
    
                        wiDList = wiDService.selectWiDsByDate(date: date)
                        
                        checkWiDOverlap()
                    }) {
                        Text("등록")
                    }
                    .padding(12)
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 5)
                        .fill(.blue).opacity(0.8)
                    )
//                    .padding(.horizontal)
                }
            }
//            .frame(maxWidth: UIScreen.main.bounds.size.width * 0.6, maxHeight: .infinity)
//            .frame(maxHeight: .infinity)
//            .border(.blue)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .onChange(of: date) { newDate in
            wiDList = wiDService.selectWiDsByDate(date: newDate)
            
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
            duration = finish.timeIntervalSince(newStart)
            
            print("new Start : \(formatTime(start, format: "yyyy-MM-dd a h:mm:ss"))")
            print("new Finish : \(formatTime(finish, format: "yyyy-MM-dd a h:mm:ss"))")
            
            checkWiDOverlap()
        }
        .onChange(of: finish) { newFinish in
            duration = newFinish.timeIntervalSince(start)

            print("new Start : \(formatTime(start, format: "yyyy-MM-dd a h:mm:ss"))")
            print("new Finish : \(formatTime(finish, format: "yyyy-MM-dd a h:mm:ss"))")

            checkWiDOverlap()
        }
    }
    
    func checkWiDOverlap() {
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
                print("existingStart : \(formatTime(existingStart, format: "yyyy-MM-dd a h:mm:ss"))")
                
                let existingFinishHour = calendar.component(.hour, from: existingWiD.finish)
                let existingFinishMinute = calendar.component(.minute, from: existingWiD.finish)
                let existingFinishSecond = calendar.component(.second, from: existingWiD.finish)
                let existingFinish = calendar.date(bySettingHour: existingFinishHour, minute: existingFinishMinute, second: existingFinishSecond, of: date)!
                print("existingFinish : \(formatTime(existingFinish, format: "yyyy-MM-dd a h:mm:ss"))")

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

struct ManualViewTmp_Previews: PreviewProvider {
    static var previews: some View {
        ManualViewTmp()
    }
}
