//
//  WiDCreateManualView.swift
//  WiD
//
//  Created by jjkim on 2023/09/19.
//

import SwiftUI

struct WiDCreateManualView: View {
    private let screen = UIScreen.main.bounds.size
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
    @State private var duration: TimeInterval = 0
    @State private var detail: String = ""
    
    @State private var isStartOverlap: Bool = false
    @State private var isStartOverCurrentTime: Bool = false

    @State private var isFinishOverlap: Bool = false
    @State private var isFinishOverCurrentTime: Bool = false

    @State private var isDurationUnderMin: Bool = false
    
    init() {
        self._wiDList = State(initialValue: wiDService.selectWiDsByDate(date: date))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 4) {
                Text("\(formatDate(date, format: "yyyy년 M월 d일")) WiD 리스트")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack {
                    ZStack {
                        Image(systemName: "arrowtriangle.down")
                            .foregroundColor(isStartOverlap || isStartOverCurrentTime || isDurationUnderMin ? .red : .none)
                            .offset(x: CGFloat(startMinutes) / (24 * 60) * screen.width * 0.8 - screen.width * 0.8 / 2)
                        
                        Image(systemName: "arrowtriangle.down.fill")
                            .foregroundColor(isFinishOverlap || isFinishOverCurrentTime || isDurationUnderMin ? .red : .none)
                            .offset(x: CGFloat(finishMinutes) / (24 * 60) * screen.width * 0.8 - screen.width * 0.8 / 2)
                    }
                    
                    HorizontalBarChartView(wiDList: wiDList)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 5)
                    .stroke(.black, lineWidth: 1)
                )
                .background(.white)
                .cornerRadius(5)
            }
            
            VStack(spacing: 4) {
                Text("New WiD")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("날짜")
                        
                        HStack {
                            Image(systemName: "calendar")
                                .frame(width: 20)
                                .padding()
                            
                            DatePicker("", selection: $date, in: ...today, displayedComponents: .date)
                                .labelsHidden()
                                .padding(.trailing)
                            
                            Spacer()
                        }
                        .background(RoundedRectangle(cornerRadius: 5)
                            .stroke(.black, lineWidth: 1)
                        )
                        .background(.white)
                        .cornerRadius(5)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("제목")
                        
                        HStack {
                            Image(systemName: "character.textbox.ko")
                                .frame(width: 20)
                                .padding()
                            
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
                                .padding(.trailing)
                        }
                        .background(RoundedRectangle(cornerRadius: 5)
                            .stroke(.black, lineWidth: 1)
                        )
                        .background(.white)
                        .cornerRadius(5)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("시작")
                        
                        HStack {
                            Image(systemName: "play")
                                .frame(width: 20)
                                .padding()
                            
                            DatePicker("", selection: $start, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                            
                            Spacer()
                        }
                        .background(RoundedRectangle(cornerRadius: 5)
                            .stroke(.black, lineWidth: 1)
                        )
                        .background(.white)
                        .cornerRadius(5)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("종료")
                        
                        HStack {
                            Image(systemName: "play.fill")
                                .frame(width: 20)
                                .padding()
                            
                            DatePicker("", selection: $finish, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                            
                            Spacer()
                        }
                        .background(RoundedRectangle(cornerRadius: 5)
                            .stroke(.black, lineWidth: 1)
                        )
                        .background(.white)
                        .cornerRadius(5)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("경과")
                        
                        HStack {
                            Image(systemName: "hourglass")
                                .frame(width: 20)
                                .padding()

                            Text(formatDuration(duration, mode: 3))
                                .padding(.trailing)
                            
                            Spacer()
                        }
                        .background(RoundedRectangle(cornerRadius: 5)
                            .stroke(.black, lineWidth: 1)
                        )
                        .background(.white)
                        .cornerRadius(5)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("설명")
                        
                        HStack {
                            Image(systemName: "text.bubble")
                                .frame(width: 20)
                                .padding()
                            
                            TextEditor(text: $detail)
                                .padding(1)
                            
                            Spacer()
                        }
                        .background(RoundedRectangle(cornerRadius: 5)
                            .stroke(.black, lineWidth: 1)
                        )
                        .background(.white)
                        .cornerRadius(5)
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 5)
                    .stroke(.black, lineWidth: 1)
                )
                .background(Color("light_gray"))
                .cornerRadius(5)
            }
            
            HStack(spacing: 8) {
                Spacer()
                    .frame(maxWidth: .infinity)
                
                Button(action: {
                    let wiD = WiD(id: 0, date: date, title: title.rawValue, start: start, finish: finish, duration: duration, detail: detail)
                    wiDService.insertWiD(wid: wiD)

                    wiDList = wiDService.selectWiDsByDate(date: date)
                    
                    checkWiDOverlap()
                }) {
                    Image(systemName: "plus.square")
                        .foregroundColor(.white)
                    
                    Text("등록")
                        .foregroundColor(.white)
                }
                .padding(.vertical)
                .frame(maxWidth: .infinity)
                .disabled(isStartOverlap || isStartOverCurrentTime || isFinishOverlap || isFinishOverCurrentTime || isDurationUnderMin || duration == 0)

                .background(isStartOverlap || isStartOverCurrentTime || isFinishOverlap || isFinishOverCurrentTime || isDurationUnderMin || duration == 0 ? Color("light_gray") : .blue)
                .cornerRadius(5)
//                    .background(RoundedRectangle(cornerRadius: 5)
//                        .stroke(.black, lineWidth: 1)
//                    )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
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
    
    func checkWiDOverlap() {
        duration = finish.timeIntervalSince(start)
        
        withAnimation {
            isDurationUnderMin = duration <= 0
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

struct WiDCreateManualView_Previews: PreviewProvider {
    static var previews: some View {
        WiDCreateManualView()
    }
}
