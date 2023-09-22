//
//  WiDCreateManualView.swift
//  WiD
//
//  Created by jjkim on 2023/09/19.
//

import SwiftUI

struct WiDCreateManualView: View {
    private let wiDService = WiDService()
    @State private var wiDs: [WiD] = []
    
    @State private var date = Date()
    @State private var title: Title = .STUDY
    @State private var start = Date()
    @State private var finish = Date()
    @State private var duration: TimeInterval = 0.0
    @State private var detail: String = ""
    
    @State private var currentDate = Date()
    
    @State private var isStartOverlap: Bool = false
    @State private var isFinishOverlap: Bool = false
    
    @State private var isOver12Hours: Bool = false

    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("WiD")
                        .font(.custom("Acme-Regular", size: 30))
                    
                    Spacer()
                    
                    Text(isStartOverlap || isFinishOverlap ? "겹침 /" : "안겹침 /")
                    
                    Text("\(wiDs.count)")
                    
                    Spacer()

                    Circle()
                        .foregroundColor(Color(title.rawValue))
                        .frame(width: 20, height: 20)
                }
                .padding(.horizontal)
                .padding(.top, 4)
                
                HStack {
                    Image(systemName: "calendar")
                        .imageScale(.large)
                        .frame(width: 25)
                    
                    Text("날짜")
                        .font(.system(size: 25))
                    
                    ZStack {
                        HStack {
                            Text(formatDate(date, format: "yyyy.MM.dd"))
                                .font(.system(size: 25))

                            Text(formatWeekday(date))
                                .foregroundColor(Calendar.current.component(.weekday, from: date) == 1 ? .red : (Calendar.current.component(.weekday, from: date) == 7 ? .blue : .black))
                                .font(.system(size: 25))
                        }
                        
                        DatePicker("", selection: $date, in: ...currentDate, displayedComponents: .date)
                            .labelsHidden()
                            .opacity(0.02)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)
                .padding(.bottom, 4)

                HStack {
                    Image(systemName: "text.book.closed")
                        .imageScale(.large)
                        .frame(width: 25)
                    
                    Text("제목")
                        .font(.system(size: 25))
                    
                    ZStack {
                        Text(titleDictionary[title.rawValue]!)
                            .font(.system(size: 25))
                            .frame(maxWidth: .infinity)
                        
                        Picker("", selection: $title) {
                            ForEach(Array(Title.allCases), id: \.self) { title in
                                Text(titleDictionary[title.rawValue]!)
                            }
                        }
                        .opacity(0.02)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)
                .padding(.bottom, 4)

                HStack {
                    Image(systemName: "clock")
                        .imageScale(.large)
                        .frame(width: 25)
                    
                    Text("시작")
                        .font(.system(size: 25))
                    
                    ZStack {
                        Text(formatTime(start, format: "a h:mm"))
                            .font(.system(size: 25))
                        
                        DatePicker("", selection: $start, in: ...currentDate, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .opacity(0.02)
                        
                        if isStartOverlap {
                            HStack {
                                Spacer()
                                
                                Image(systemName: "exclamationmark.square")
                                    .foregroundColor(.red)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)
                .padding(.bottom, 4)

                HStack {
                    Image(systemName: "stopwatch")
                        .imageScale(.large)
                        .frame(width: 25)
                    
                    Text("종료")
                        .font(.system(size: 25))
                    
                    ZStack {
                        Text(formatTime(finish, format: "a h:mm"))
                            .font(.system(size: 25))
                        
                        DatePicker("", selection: $finish, in: ...currentDate, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .opacity(0.02)
                        
                        if isFinishOverlap {
                            HStack {
                                Spacer()
                                
                                Image(systemName: "exclamationmark.square")
                                    .foregroundColor(.red)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)
                .padding(.bottom, 4)

                HStack {
                    Image(systemName: "hourglass")
                        .imageScale(.large)
                        .frame(width: 25)
                    
                    Text("소요")
                        .font(.system(size: 25))
                    
                    ZStack {
                        Text(formatDuration(duration, mode: 3))
                            .font(.system(size: 25))
                            .frame(maxWidth: .infinity)
                        
                        if isOver12Hours {
                            HStack {
                                Spacer()
                                
                                Image(systemName: "exclamationmark.square")
                                    .foregroundColor(.red)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 4)
                
                VStack {
                    HStack(alignment: .center) {
                        Image(systemName: "text.bubble")
                            .imageScale(.large)
                            .frame(width: 25)
                        
                        Text("설명")
                            .font(.system(size: 25))
                            .foregroundColor(.black)
                        
                        Spacer()
                    }
                    
                    TextEditor(text: $detail)
                        .frame(maxWidth: .infinity, maxHeight: 150, alignment: .topLeading)
                        .border(.gray)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .background(Color("light_gray"))
            .cornerRadius(5)

            HStack {
                Button(action: {
                    // start, finish 현재 날짜로 맞춰야 함.
//                    let calendar = Calendar.current
//                    let adjustedStart = calendar.date(bySettingHour: calendar.component(.hour, from: start), minute: calendar.component(.minute, from: start), second: calendar.component(.second, from: start), of: date)!
//                    let adjustedFinish = calendar.date(bySettingHour: calendar.component(.hour, from: finish), minute: calendar.component(.minute, from: finish), second: calendar.component(.second, from: finish), of: date)!
                    
                    let wiD = WiD(id: 0, date: date, title: title.rawValue, start: start, finish: finish, duration: duration, detail: detail)
                    wiDService.insertWiD(wid: wiD)
                }) {
                    Text("등록")
                }
                .frame(maxWidth: .infinity)
                .disabled(isStartOverlap || isFinishOverlap || isOver12Hours)

                Button(action: {
                    date = Date()
                    title = .STUDY
                    start = Calendar.current.date(bySetting: .second, value: 0, of: Date()) ?? Date()
                    finish = Calendar.current.date(bySetting: .second, value: 0, of: Date()) ?? Date()
                    duration = 0.0
                    detail = ""
                }) {
                    Text("초기화")
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal)
        .onAppear() {
            wiDs = wiDService.selectWiDsByDate(date: date)

            start = Calendar.current.date(bySetting: .second, value: 0, of: start) ?? start
            finish = Calendar.current.date(bySetting: .second, value: 0, of: finish) ?? finish
        }
        .onChange(of: date) { newValue in
            wiDs = wiDService.selectWiDsByDate(date: newValue)
        }
        .onChange(of: [date, start, finish]) { values in
            let newDate = values[0]
            let newStart = values[1]
            print("newStart : \(formatTime(newStart, format: "yyyy-MM-dd HH:mm:ss"))")
            let newFinish = values[2]
            print("newFinish : \(formatTime(newFinish, format: "yyyy-MM-dd HH:mm:ss"))")
            duration = newFinish.timeIntervalSince(newStart)
            
            if duration > 12 * 60 * 60 {
                withAnimation {
                    isOver12Hours = true
                }
            } else {
                withAnimation {
                    isOver12Hours = false
                }
            }
            
            let calendar = Calendar.current
            
            for existingWiD in wiDs {
                let existingStart = calendar.date(bySettingHour: calendar.component(.hour, from: existingWiD.start), minute: calendar.component(.minute, from: existingWiD.start), second: calendar.component(.second, from: existingWiD.start), of: newDate)!
                print("existingStart : \(formatTime(existingStart, format: "yyyy-MM-dd HH:mm:ss"))")
                print("existingWiD.start : \(formatTime(existingWiD.start, format: "yyyy-MM-dd HH:mm:ss"))")
                let existingFinish = calendar.date(bySettingHour: calendar.component(.hour, from: existingWiD.finish), minute: calendar.component(.minute, from: existingWiD.finish), second: calendar.component(.second, from: existingWiD.finish), of: newDate)!
                print("existingFinish : \(formatTime(existingFinish, format: "yyyy-MM-dd HH:mm:ss"))")
                print("existingWiD.finish : \(formatTime(existingWiD.finish, format: "yyyy-MM-dd HH:mm:ss"))")
                
                if (newStart >= existingStart && newStart <= existingFinish) {
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
            
            for existingWiD in wiDs {
                let existingStart = calendar.date(bySettingHour: calendar.component(.hour, from: existingWiD.start), minute: calendar.component(.minute, from: existingWiD.start), second: calendar.component(.second, from: existingWiD.start), of: newDate)!
                let existingFinish = calendar.date(bySettingHour: calendar.component(.hour, from: existingWiD.finish), minute: calendar.component(.minute, from: existingWiD.finish), second: calendar.component(.second, from: existingWiD.finish), of: newDate)!

                if (newFinish >= existingStart && newFinish <= existingFinish) {
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
        
            for existingWiD in wiDs {
                let existingStart = calendar.date(bySettingHour: calendar.component(.hour, from: existingWiD.start), minute: calendar.component(.minute, from: existingWiD.start), second: calendar.component(.second, from: existingWiD.start), of: newDate)!
                let existingFinish = calendar.date(bySettingHour: calendar.component(.hour, from: existingWiD.finish), minute: calendar.component(.minute, from: existingWiD.finish), second: calendar.component(.second, from: existingWiD.finish), of: newDate)!

                if (newStart <= existingStart && newFinish >= existingFinish) {
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
