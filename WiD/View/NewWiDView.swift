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
                    .foregroundColor(.blue)

                    Text("새로운 WiD")
                        .titleLarge()
                    
                    Button(action: {
                        let newWiD = WiD(id: 0, date: date, title: title.rawValue, start: start, finish: finish, duration: duration)
                        wiDService.insertWiD(wid: newWiD)

                        wiDList = wiDService.selectWiDsByDate(date: date)
                        
                        emptyWiDList = getEmptyWiDListFromWiDList(date: date, currentTime: currentTime, wiDList: wiDList)
                        
                        checkWiDAvailableByStartAndFinish()
                    }) {
                        Text("등록")
                            .bodyMedium()
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(isStartOverlap || isStartOverCurrentTime || isFinishOverlap || isFinishOverCurrentTime || !DurationExist ? .gray : .blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .disabled(isStartOverlap || isStartOverCurrentTime || isFinishOverlap || isFinishOverCurrentTime || !DurationExist)
                }
                .frame(maxWidth: .infinity, maxHeight: 44)
                .padding(.horizontal)
                .background(.white)
                
                Divider()
                
                /**
                 컨텐츠
                 */
                ScrollView {
                    VStack(spacing: 16) {
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
                                        .background(Color("light_gray"))
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
                                .background(.white)
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

                            // 제목 선택
                            VStack(spacing: 0) { // 더미 스택
                                HStack(spacing: 16) {
                                    Image(systemName: "character.ko")
                                        .imageScale(.large)
                                        .foregroundColor(Color(title.rawValue))
                                        .frame(width: 30, height: 30)
                                        .padding()
                                        .background(Color("light_gray"))
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
                                .background(.white)
                                .onTapGesture {
                                    withAnimation {
                                        expandTitleMenu.toggle()
                                    }
                                }
                                
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
                            
                            // 시작 시간 선택
                            VStack(spacing: 0) { // 더미 스택
                                HStack(spacing: 16) {
                                    Image(systemName: "clock")
                                        .imageScale(.large)
                                        .frame(width: 30, height: 30)
                                        .padding()
                                        .background(Color("light_gray"))
                                        .cornerRadius(8)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("시작")
                                            .labelMedium()
                                        
                                        Text(formatTime(start, format: "a h:mm:ss"))
                                            .bodyMedium()
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: expandStartPicker ? "chevron.up" : "chevron.down")
                                }
                                .padding(.horizontal)
                                .background(.white)
                                .onTapGesture {
                                    withAnimation {
                                        expandStartPicker.toggle()
                                    }
                                }
                                
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
                                
                            // 종료 시간 선택
                            VStack(spacing: 0) { // 더미 스택
                                HStack(spacing: 16) {
                                    Image(systemName: "clock.badge.checkmark")
                                        .imageScale(.large)
                                        .frame(width: 30, height: 30)
                                        .padding()
                                        .background(Color("light_gray"))
                                        .cornerRadius(8)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("종료")
                                            .labelMedium()
                                        
                                        Text(formatTime(finish, format: "a h:mm:ss"))
                                            .bodyMedium()
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: expandFinishPicker ? "chevron.up" : "chevron.down")
                                }
                                .padding(.horizontal)
                                .background(.white)
                                .onTapGesture {
                                    withAnimation {
                                        expandFinishPicker.toggle()
                                    }
                                }
                                
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
                                
                            HStack(spacing: 16) {
                                Image(systemName: "clock.fill")
                                    .imageScale(.large)
                                    .frame(width: 30, height: 30)
                                    .padding()
                                    .background(Color("light_gray"))
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
                        .background(.white)
                        
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
//                                getEmptyView(message: "표시할 시간대가 없습니다.")
                                
                                Button(action: {
                                    start = Date()
                                    finish = Date()
                                }) {
                                    HStack {
                                        VStack {
                                            Text("10시간 10분 10초")
                                                .titleMedium()
                                            
                                            Text("오전 10:10:00")
                                                .font(.custom("ChivoMono-Regular", size: 17))
                                        
                                            Text("오전 10:11:11")
                                                .font(.custom("ChivoMono-Regular", size: 17))
                                        }
                                        
                                        Spacer()
                                    }

                                    Image(systemName: "square.and.arrow.down")
                                }
                                .padding()
                                .background(Color("light_gray"))
                                .cornerRadius(8)
                                .padding(.horizontal)
                                
                                Button(action: {
                                    start = Date()
                                    finish = Date()
                                }) {
                                    VStack(spacing: 8) {
                                        HStack {
                                            Rectangle()
                                                .fill(.black)
                                                .frame(width: 5)
                                            
                                            Text("제목 없음")
                                                .bodyMedium()
                                            
                                            Spacer()
                                            
                                            Image(systemName: "square.and.arrow.down")
                                        }
                                        
                                        HStack {
                                            VStack(alignment: .leading) {
                                                HStack {
                                                    Text(formatTime(Date(), format: "a"))
                                                        .bodyMedium()
                                                    
                                                    Text(formatTime(Date(), format: "hh:mm:ss"))
                                                        .font(.custom("ChivoMono-Regular", size: 17))
                                                }
                                            
                                                HStack {
                                                    Text(formatTime(Date(), format: "a"))
                                                        .bodyMedium()
                                                    
                                                    Text(formatTime(Date(), format: "hh:mm:ss"))
                                                        .font(.custom("ChivoMono-Regular", size: 17))
                                                }
                                            }
                                            
                                            Spacer()
                                            
                                            Text(formatDuration(Date().timeIntervalSinceNow, mode: 3))
                                                .font(.custom("PyeongChangPeace-Bold", size: 20))
                                        }
                                    }
                                }
                                .padding()
                                .background(Color("light_gray"))
                                .cornerRadius(8)
                                .padding(.horizontal)
                            } else {
                                ForEach(Array(emptyWiDList.enumerated()), id: \.element.id) { (index, emptyWiD) in
                                    Button(action: {
                                        start = emptyWiD.start
                                        finish = emptyWiD.finish
                                    }) {
                                        VStack(spacing: 8) {
                                            HStack {
                                                Rectangle()
                                                    .fill(.black)
                                                    .frame(width: 5)
                                                
                                                Text("제목 없음")
                                                    .bodyMedium()
                                                
                                                Spacer()
                                                
                                                Image(systemName: "square.and.arrow.down")
                                            }
                                            
                                            HStack {
                                                VStack(alignment: .leading) {
                                                    HStack {
                                                        Text(formatTime(emptyWiD.start, format: "a"))
                                                            .bodyMedium()
                                                        
                                                        Text(formatTime(emptyWiD.start, format: "hh:mm:ss"))
                                                            .font(.custom("ChivoMono-Regular", size: 17))
                                                    }
                                                
                                                    HStack {
                                                        Text(formatTime(emptyWiD.finish, format: "a"))
                                                            .bodyMedium()
                                                        
                                                        Text(formatTime(emptyWiD.finish, format: "hh:mm:ss"))
                                                            .font(.custom("ChivoMono-Regular", size: 17))
                                                    }
                                                }
                                                
                                                Spacer()
                                                
                                                Text(formatDuration(emptyWiD.duration, mode: 3))
                                                    .font(.custom("PyeongChangPeace-Bold", size: 20))
                                            }
                                        }
                                    }
                                    .padding()
                                    
                                    if index != emptyWiDList.count - 1 {
                                        Divider()
                                            .padding(.horizontal)
                                    }
                                }
                            }
                        }
                        .padding(.vertical)
                        .background(.white)
                    }

//                    Spacer()
//                        .frame(height: 16)
                }
                
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
            .tint(.black)
            .background(Color("light_gray"))
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
