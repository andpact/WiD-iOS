//
//  WiDCreateManualView.swift
//  WiD
//
//  Created by jjkim on 2023/09/19.
//

import SwiftUI

struct WiDCreateManualView: View {
    private let wiDService = WiDService()
    @State private var wiDList: [WiD] = []
    
    @State private var date = Date()
    @State private var title: Title = .STUDY
    @State private var start = Date()
    @State private var finish = Date()
    @State private var duration: TimeInterval = 0.0
    @State private var detail: String = ""
    
    private let today = Date()
    private let currenTime = Calendar.current.date(bySetting: .second, value: 0, of: Date())
    
    @State private var isStartOverlap: Bool = false
    @State private var isStartOverCurrentTime: Bool = false
    
    @State private var isFinishOverlap: Bool = false
    @State private var isFinishOverCurrentTime: Bool = false
    
    @State private var isDurationUnderMin: Bool = false
    @State private var isDurationOverMax: Bool = false
    

    var body: some View {
        VStack {
            VStack() {
                Rectangle()
                    .fill(Color(title.rawValue))
                    .frame(height: 10)
                
                VStack(spacing: 0) {
                    HStack {
                        Text("날짜")
                            .bold()
                        
                        Spacer()
                    }
                    
                    ZStack {
                        HStack {
                            Image(systemName: "calendar")
                                .frame(width: 20)
                                .padding()
                            
                            HStack {
                                Text(formatDate(date, format: "yyyy년 M월 d일"))

                                HStack(spacing: 0) {
                                    Text("(")
                                    
                                    Text(formatWeekday(date))
                                        .foregroundColor(Calendar.current.component(.weekday, from: date) == 1 ? .red : (Calendar.current.component(.weekday, from: date) == 7 ? .blue : .black))
                                    
                                    Text(")")
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Image(systemName: "chevron.down")
                                .padding()
                        }
                        .background(RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 1)
                            .background(Color.white)
                        )
                        
                        HStack {
                            Spacer()
                            
                            DatePicker("", selection: $date, in: ...today, displayedComponents: .date)
                                .labelsHidden()
                                .opacity(0.02)
                        }
                    }
                }
                .padding(.horizontal)
                
                VStack(spacing: 0) {
                    HStack {
                        Text("제목")
                            .bold()
                        
                        Spacer()
                    }
                    ZStack {
                        HStack {
                            Image(systemName: "text.book.closed")
                                .frame(width: 20)
                                .padding()
                            
                            Text(titleDictionary[title.rawValue]!)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Image(systemName: "chevron.down")
                                .padding()
                        }
                        .background(RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 1)
                            .background(Color.white)
                        )
                        
                        HStack {
                            Spacer()
                            
                            Picker("", selection: $title) {
                                ForEach(Array(Title.allCases), id: \.self) { title in
                                    Text(titleDictionary[title.rawValue]!)
                                }
                            }
                            .opacity(0.02)
                        }
                    }
                }
                .padding(.horizontal)
                
                VStack(spacing: 0) {
                    HStack {
                        Text("시작")
                            .bold()
                        
                        Spacer()
                        
                        if isStartOverlap {
                            Text("이미 등록된 시간입니다.")
                                .foregroundColor(.red)
                                .font(.system(size: 12))
                        } else if isStartOverCurrentTime {
                            Text("\(formatTime(currenTime ?? Date(), format: "a h:mm:ss")) 이전 시간이 필요합니다.")
                                .foregroundColor(.red)
                                .font(.system(size: 12))
                        }
                    }
                    
                    ZStack {
                        HStack {
                            Image(systemName: "clock")
                                .frame(width: 20)
                                .padding()
                            
                            Text(formatTime(start, format: "a h:mm:ss"))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                            Image(systemName: "chevron.down")
                                .padding()
                        }
                        .background(RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 1)
                            .background(Color.white)
                        )
                        
                        HStack {
                            Spacer()
                            
                            DatePicker("", selection: $start, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .opacity(0.02)
                        }
                    }
                }
                .padding(.horizontal)
                
                VStack(spacing: 0) {
                    HStack {
                        Text("종료")
                            .bold()
                        
                        Spacer()
                        
                        if isFinishOverlap {
                            Text("이미 등록된 시간입니다.")
                                .foregroundColor(.red)
                                .font(.system(size: 12))
                        } else if isFinishOverCurrentTime {
                            Text("\(formatTime(currenTime ?? Date(), format: "a h:mm:ss")) 이전 시간이 필요합니다.")
                                .foregroundColor(.red)
                                .font(.system(size: 12))
                        }
                    }
                    
                    ZStack {
                        HStack {
                            Image(systemName: "stopwatch")
                                .frame(width: 20)
                                .padding()
                            
                            Text(formatTime(finish, format: "a h:mm:ss"))
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Image(systemName: "chevron.down")
                                .padding()
                        }
                        .background(RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 1)
                            .background(Color.white)
                        )
                        
                        HStack {
                            Spacer()
                            
                            DatePicker("", selection: $finish, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .opacity(0.02)
                        }
                    }
                }
                .padding(.horizontal)

                VStack(spacing: 0) {
                    HStack {
                        Text("경과")
                            .bold()
                        
                        Spacer()
                        
                        if isDurationUnderMin {
                            Text("1분 이상의 시간이 필요합니다.")
                                .foregroundColor(.red)
                                .font(.system(size: 12))
                        } else if isDurationOverMax {
                            Text("12시간 이하의 시간이 필요합니다.")
                                .foregroundColor(.red)
                                .font(.system(size: 12))
                        }
                    }
                
                    HStack {
                        Image(systemName: "hourglass")
                            .frame(width: 20)
                            .padding()
                        
                        Text(formatDuration(duration, mode: 3))
                        
                        Spacer()
                    }
                    .background(RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1)
                        .background(Color.white)
                    )
                }
                .padding(.horizontal)
                
                VStack(spacing: 0) {
                    HStack() {
                        Text("설명")
                            .bold()
                        
                        Spacer()
                    }
                    
                    HStack {
                        Image(systemName: "text.bubble")
                            .frame(width: 20)
                            .padding()
                        
                        TextEditor(text: $detail)
                            .frame(maxWidth: .infinity, maxHeight: 100)
                            .padding(.vertical, 2)
                            .padding(.trailing, 2)
                    }
                    .background(RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1)
                        .background(Color.white)
                    )
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .background(Color("light_gray"))
            .cornerRadius(5)

            HStack {
                Button(action: {
                    date = today
                    title = .STUDY
                    start = currenTime ?? Date()
                    finish = currenTime ?? Date()
                    duration = 0.0
                    detail = ""
                    
                }) {
                    Text("초기화")
                }
                .frame(maxWidth: .infinity)
                
                Button(action: {
                    let wiD = WiD(id: 0, date: date, title: title.rawValue, start: start, finish: finish, duration: duration, detail: detail)
                    wiDService.insertWiD(wid: wiD)
                    
                    wiDList = wiDService.selectWiDsByDate(date: date)
                    
                    let calendar = Calendar.current
                    
                    for existingWiD in wiDList {
                        let existingStart = calendar.date(bySettingHour: calendar.component(.hour, from: existingWiD.start), minute: calendar.component(.minute, from: existingWiD.start), second: calendar.component(.second, from: existingWiD.start), of: date)!
                        let existingFinish = calendar.date(bySettingHour: calendar.component(.hour, from: existingWiD.finish), minute: calendar.component(.minute, from: existingWiD.finish), second: calendar.component(.second, from: existingWiD.finish), of: date)!
                        
                        if start >= existingStart && start <= existingFinish {
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
                        let existingStart = calendar.date(bySettingHour: calendar.component(.hour, from: existingWiD.start), minute: calendar.component(.minute, from: existingWiD.start), second: calendar.component(.second, from: existingWiD.start), of: date)!
                        let existingFinish = calendar.date(bySettingHour: calendar.component(.hour, from: existingWiD.finish), minute: calendar.component(.minute, from: existingWiD.finish), second: calendar.component(.second, from: existingWiD.finish), of: date)!
                        
                        if finish >= existingStart && finish <= existingFinish {
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
                        let existingStart = calendar.date(bySettingHour: calendar.component(.hour, from: existingWiD.start), minute: calendar.component(.minute, from: existingWiD.start), second: calendar.component(.second, from: existingWiD.start), of: date)!
                        let existingFinish = calendar.date(bySettingHour: calendar.component(.hour, from: existingWiD.finish), minute: calendar.component(.minute, from: existingWiD.finish), second: calendar.component(.second, from: existingWiD.finish), of: date)!
                        
                        if start <= existingStart && finish >= existingFinish {
                            withAnimation {
                                isStartOverlap = true
                                isFinishOverlap = true
                            }
                            break
                        }
                    }
                }) {
                    Text("등록")
                        .foregroundColor(isStartOverlap || isStartOverCurrentTime || isFinishOverlap || isFinishOverCurrentTime || isDurationUnderMin || isDurationOverMax || duration == 0 ? nil : .green)
                }
                .frame(maxWidth: .infinity)
                .disabled(isStartOverlap || isStartOverCurrentTime || isFinishOverlap || isFinishOverCurrentTime || isDurationUnderMin || isDurationOverMax || duration == 0)
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal)
        .onAppear() {
            wiDList = wiDService.selectWiDsByDate(date: date)
            print("manual view onAppear")
            print("최초 날짜 : \(date)")
            
            let calendar = Calendar.current

            start = calendar.date(bySetting: .second, value: 0, of: start) ?? start
            finish = calendar.date(bySetting: .second, value: 0, of: finish) ?? finish
            
            print("최초 시작 시간 : \(start)")
            print("최초 종료 시간 : \(finish)")
        }
        .onChange(of: date) { newDate in
            print("manual view onChange")
            print("변경된 날짜 : \(newDate)")
            
            wiDList = wiDService.selectWiDsByDate(date: newDate)
            
            let calendar = Calendar.current
            
            if calendar.isDate(newDate, inSameDayAs: today) {
                if start > currenTime! {
                    withAnimation {
                        isStartOverCurrentTime = true
                    }
                } else {
                    withAnimation {
                        isStartOverCurrentTime = false
                    }
                }
            }
            
            if calendar.isDate(newDate, inSameDayAs: today) {
                if finish > currenTime! {
                    withAnimation {
                        isFinishOverCurrentTime = true
                    }
                } else {
                    withAnimation {
                        isFinishOverCurrentTime = false
                    }
                }
            }
            
            if wiDList.isEmpty {
                withAnimation {
                    isStartOverlap = false
                    isFinishOverlap = false
                }
            } else {
                for existingWiD in wiDList {
                    let existingStart = calendar.date(bySettingHour: calendar.component(.hour, from: existingWiD.start), minute: calendar.component(.minute, from: existingWiD.start), second: calendar.component(.second, from: existingWiD.start), of: newDate)!
                    let existingFinish = calendar.date(bySettingHour: calendar.component(.hour, from: existingWiD.finish), minute: calendar.component(.minute, from: existingWiD.finish), second: calendar.component(.second, from: existingWiD.finish), of: newDate)!
                    
                    if start >= existingStart && start <= existingFinish {
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
                    let existingStart = calendar.date(bySettingHour: calendar.component(.hour, from: existingWiD.start), minute: calendar.component(.minute, from: existingWiD.start), second: calendar.component(.second, from: existingWiD.start), of: newDate)!
                    let existingFinish = calendar.date(bySettingHour: calendar.component(.hour, from: existingWiD.finish), minute: calendar.component(.minute, from: existingWiD.finish), second: calendar.component(.second, from: existingWiD.finish), of: newDate)!
                    
                    if finish >= existingStart && finish <= existingFinish {
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
                    let existingStart = calendar.date(bySettingHour: calendar.component(.hour, from: existingWiD.start), minute: calendar.component(.minute, from: existingWiD.start), second: calendar.component(.second, from: existingWiD.start), of: newDate)!
                    let existingFinish = calendar.date(bySettingHour: calendar.component(.hour, from: existingWiD.finish), minute: calendar.component(.minute, from: existingWiD.finish), second: calendar.component(.second, from: existingWiD.finish), of: newDate)!
                    
                    if start <= existingStart && finish >= existingFinish {
                        withAnimation {
                            isStartOverlap = true
                            isFinishOverlap = true
                        }
                        break
                    }
                }
            }
        }
        .onChange(of: start) { newStart in
            print("manual view onChange")
            print("변경된 시작 시간 : \(newStart)")
            
            duration = finish.timeIntervalSince(newStart)
            
            let calendar = Calendar.current
            
            if calendar.isDate(date, inSameDayAs: today) {
                if newStart > currenTime! {
                    withAnimation {
                        isStartOverCurrentTime = true
                    }
                } else {
                    withAnimation {
                        isStartOverCurrentTime = false
                    }
                }
            }
            
            for existingWiD in wiDList {
                let existingStart = calendar.date(bySettingHour: calendar.component(.hour, from: existingWiD.start), minute: calendar.component(.minute, from: existingWiD.start), second: calendar.component(.second, from: existingWiD.start), of: date)!
                let existingFinish = calendar.date(bySettingHour: calendar.component(.hour, from: existingWiD.finish), minute: calendar.component(.minute, from: existingWiD.finish), second: calendar.component(.second, from: existingWiD.finish), of: date)!
                
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
            
            for existingWiD in wiDList {
                let existingStart = calendar.date(bySettingHour: calendar.component(.hour, from: existingWiD.start), minute: calendar.component(.minute, from: existingWiD.start), second: calendar.component(.second, from: existingWiD.start), of: date)!
                let existingFinish = calendar.date(bySettingHour: calendar.component(.hour, from: existingWiD.finish), minute: calendar.component(.minute, from: existingWiD.finish), second: calendar.component(.second, from: existingWiD.finish), of: date)!
    
                if finish >= existingStart && finish <= existingFinish {
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
                let existingStart = calendar.date(bySettingHour: calendar.component(.hour, from: existingWiD.start), minute: calendar.component(.minute, from: existingWiD.start), second: calendar.component(.second, from: existingWiD.start), of: date)!
                let existingFinish = calendar.date(bySettingHour: calendar.component(.hour, from: existingWiD.finish), minute: calendar.component(.minute, from: existingWiD.finish), second: calendar.component(.second, from: existingWiD.finish), of: date)!
                
                if newStart <= existingStart && finish >= existingFinish {
                    withAnimation {
                        isStartOverlap = true
                        isFinishOverlap = true
                    }
                    break
                }
            }
        }
        .onChange(of: finish) { newFinish in
            print("manual view onChange")
            print("변경된 종료 시간 : \(newFinish)")
            
            duration = newFinish.timeIntervalSince(start)
            
            let calendar = Calendar.current
            
            if calendar.isDate(date, inSameDayAs: today) {
                if newFinish > currenTime! {
                    withAnimation {
                        isFinishOverCurrentTime = true
                    }
                } else {
                    withAnimation {
                        isFinishOverCurrentTime = false
                    }
                }
            }
            
            for existingWiD in wiDList {
                let existingStart = calendar.date(bySettingHour: calendar.component(.hour, from: existingWiD.start), minute: calendar.component(.minute, from: existingWiD.start), second: calendar.component(.second, from: existingWiD.start), of: date)!
                let existingFinish = calendar.date(bySettingHour: calendar.component(.hour, from: existingWiD.finish), minute: calendar.component(.minute, from: existingWiD.finish), second: calendar.component(.second, from: existingWiD.finish), of: date)!
    
                if start >= existingStart && start <= existingFinish {
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
                let existingStart = calendar.date(bySettingHour: calendar.component(.hour, from: existingWiD.start), minute: calendar.component(.minute, from: existingWiD.start), second: calendar.component(.second, from: existingWiD.start), of: date)!
                let existingFinish = calendar.date(bySettingHour: calendar.component(.hour, from: existingWiD.finish), minute: calendar.component(.minute, from: existingWiD.finish), second: calendar.component(.second, from: existingWiD.finish), of: date)!
                
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
            
            for existingWiD in wiDList {
                let existingStart = calendar.date(bySettingHour: calendar.component(.hour, from: existingWiD.start), minute: calendar.component(.minute, from: existingWiD.start), second: calendar.component(.second, from: existingWiD.start), of: date)!
                let existingFinish = calendar.date(bySettingHour: calendar.component(.hour, from: existingWiD.finish), minute: calendar.component(.minute, from: existingWiD.finish), second: calendar.component(.second, from: existingWiD.finish), of: date)!
                
                if start <= existingStart && newFinish >= existingFinish {
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
