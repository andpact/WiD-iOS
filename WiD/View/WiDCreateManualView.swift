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
    
    @State private var today = Date()
    @State private var currenTime = Calendar.current.date(bySetting: .second, value: 0, of: Date())
    
    @State private var isStartOverlap: Bool = false
    @State private var isFinishOverlap: Bool = false
    @State private var isDurationMinOrMax: Bool = false

    var body: some View {
        VStack {
            VStack(spacing: 8) {
                HStack {
                    Text("WiD")
                        .font(.custom("Acme-Regular", size: 30))
                    
                    Spacer()

                    Circle()
                        .foregroundColor(Color(title.rawValue))
                        .frame(width: 20, height: 20)
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                HStack {
                    Image(systemName: "calendar")
                        .imageScale(.large)
                        .frame(width: 25)
                    
                    Text("날짜")
                        .font(.system(size: 25))
                        .padding(.vertical, 4)
                    
                    ZStack {
                        HStack {
                            Text(formatDate(date, format: "yyyy.MM.dd"))
                                .font(.system(size: 25))

                            Text(formatWeekday(date))
                                .foregroundColor(Calendar.current.component(.weekday, from: date) == 1 ? .red : (Calendar.current.component(.weekday, from: date) == 7 ? .blue : .black))
                                .font(.system(size: 25))
                        }
                        
                        DatePicker("", selection: $date, in: ...today, displayedComponents: .date)
                            .labelsHidden()
                            .opacity(0.02)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)

                HStack {
                    Image(systemName: "text.book.closed")
                        .imageScale(.large)
                        .frame(width: 25)
                    
                    Text("제목")
                        .font(.system(size: 25))
                        .padding(.vertical, 4)
                    
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

                HStack {
                    Image(systemName: "clock")
                        .imageScale(.large)
                        .frame(width: 25)
                    
                    Text("시작")
                        .font(.system(size: 25))
                        .padding(.vertical, 4)
                    
                    ZStack {
                        Text(formatTime(start, format: "a h:mm:ss"))
                            .font(.system(size: 25))
                        
                        DatePicker("", selection: $start, displayedComponents: .hourAndMinute)
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

                HStack {
                    Image(systemName: "stopwatch")
                        .imageScale(.large)
                        .frame(width: 25)
                    
                    Text("종료")
                        .font(.system(size: 25))
                        .padding(.vertical, 4)
                    
                    ZStack {
                        Text(formatTime(finish, format: "a h:mm:ss"))
                            .font(.system(size: 25))
                        
                        DatePicker("", selection: $finish, displayedComponents: .hourAndMinute)
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

                HStack {
                    Image(systemName: "hourglass")
                        .imageScale(.large)
                        .frame(width: 25)
                    
                    Text("경과")
                        .font(.system(size: 25))
                        .padding(.vertical, 4)
                    
                    ZStack {
                        Text(formatDuration(duration, mode: 3))
                            .font(.system(size: 25))
                            .frame(maxWidth: .infinity)
                        
                        if isDurationMinOrMax {
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
                
                HStack(alignment: .center) {
                    Image(systemName: "text.bubble")
                        .imageScale(.large)
                        .frame(width: 25)
                    
                    Text("설명")
                        .font(.system(size: 25))
                        .foregroundColor(.black)
                        .padding(.vertical, 4)
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                TextEditor(text: $detail)
                    .frame(maxWidth: .infinity, maxHeight: 150, alignment: .topLeading)
                    .border(.gray)
                    .padding(.horizontal)
                    .padding(.bottom)
            }
            .background(Color("light_gray"))
            .cornerRadius(5)

            HStack {
                Button(action: {
                    let wiD = WiD(id: 0, date: date, title: title.rawValue, start: start, finish: finish, duration: duration, detail: detail)
                    wiDService.insertWiD(wid: wiD)
                    
                    updateWiDsAndOverlapFlags(newDate: date, newStart: start, newFinish: finish)
                }) {
                    Text("등록")
                        .foregroundColor(isStartOverlap || isFinishOverlap || isDurationMinOrMax ? nil : .green)
                }
                .frame(maxWidth: .infinity)
                .disabled(isStartOverlap || isFinishOverlap || isDurationMinOrMax)

                Button(action: {
                    date = today
                    title = .STUDY
                    start = currenTime ?? Date()
                    finish = currenTime ?? Date()
                    duration = 0.0
                    detail = ""
                    
                    updateWiDsAndOverlapFlags(newDate: date, newStart: start, newFinish: finish)
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
            
            let calendar = Calendar.current

            start = calendar.date(bySetting: .second, value: 0, of: start) ?? start
            finish = calendar.date(bySetting: .second, value: 0, of: finish) ?? finish
            
            updateWiDsAndOverlapFlags(newDate: date, newStart: start, newFinish: finish)
            print("manual view onAppear")
        }
        .onChange(of: date) { newDate in
            updateWiDsAndOverlapFlags(newDate: newDate, newStart: start, newFinish: finish)
        }
        .onChange(of: start) { newStart in
            if finish < newStart {
                finish = newStart
            }
            
            if Calendar.current.isDate(date, inSameDayAs: today) {
                if newStart > currenTime! {
                    start = currenTime!
                }
            }
            
            updateWiDsAndOverlapFlags(newDate: date, newStart: newStart, newFinish: finish)
        }
        .onChange(of: finish) { newFinish in
            if newFinish <  start {
                start = newFinish
            }
            
            if Calendar.current.isDate(date, inSameDayAs: today) {
                if newFinish > currenTime! {
                    finish = currenTime!
                }
            }
            
            updateWiDsAndOverlapFlags(newDate: date, newStart: start, newFinish: newFinish)
        }
    }
    
    func updateWiDsAndOverlapFlags(newDate: Date, newStart: Date, newFinish: Date) {
        let calendar = Calendar.current
        
        wiDs = wiDService.selectWiDsByDate(date: newDate)
        
        duration = newFinish.timeIntervalSince(newStart)
        
        withAnimation {
            isDurationMinOrMax = duration > 12 * 60 * 60 || duration <= 0
        }
        
        for existingWiD in wiDs {
            let existingStart = calendar.date(bySettingHour: calendar.component(.hour, from: existingWiD.start), minute: calendar.component(.minute, from: existingWiD.start), second: calendar.component(.second, from: existingWiD.start), of: newDate)!
            let existingFinish = calendar.date(bySettingHour: calendar.component(.hour, from: existingWiD.finish), minute: calendar.component(.minute, from: existingWiD.finish), second: calendar.component(.second, from: existingWiD.finish), of: newDate)!
            
            if newStart >= existingStart && newStart <= existingFinish {
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
            
            if newFinish >= existingStart && newFinish <= existingFinish {
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
            
            if newStart <= existingStart && newFinish >= existingFinish {
                withAnimation {
                    isStartOverlap = true
                    isFinishOverlap = true
                }
                break
            }
        }
    }
}

struct WiDCreateManualView_Previews: PreviewProvider {
    static var previews: some View {
        WiDCreateManualView()
    }
}
