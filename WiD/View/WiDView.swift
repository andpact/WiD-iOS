//
//  WiDView.swift
//  WiD
//
//  Created by jjkim on 2023/12/05.
//

import SwiftUI

struct WiDView: View {
    // 화면
    @Environment(\.presentationMode) var presentationMode
    @State private var isDeleteButtonPressed: Bool = false
    
    // WiD
    private let wiDService = WiDService()
    @State private var wiDList: [WiD] = []
    private let clickedWiDId: Int
    private let clickedWiD: WiD?
    
    // 날짜
    private let calendar = Calendar.current
    private let today = Date()
    private let currentTime = Calendar.current.date(bySetting: .second, value: 0, of: Date()) ?? Date()
    @State private var date = Date()
    
    // 제목
    @State private var title: Title = .STUDY
    @State private var expandTitleMenu: Bool = false
    
    // 시작 시간
    @State private var start = Date()
    @State private var startLimit = Date()
    @State private var isStartOverlap: Bool = false
    @State private var isStartOverCurrentTime: Bool = false
    @State private var expandStartPicker: Bool = false
    
    // 종료 시간
    @State private var finish = Date()
    @State private var finishLimit = Date()
    @State private var isFinishOverlap: Bool = false
    @State private var isFinishOverCurrentTime: Bool = false
    @State private var expandFinishPicker: Bool = false
    
    // 소요 시간
    @State private var duration: TimeInterval = 0.0
    @State private var durationExist: Bool = false

    init(clickedWiDId: Int) {
        self.clickedWiDId = clickedWiDId
        self.clickedWiD = wiDService.selectWiDByID(id: clickedWiDId)
    }
    
    var body: some View {
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

                Text("WiD")
                    .titleLarge()
                
                Button(action: {
                    wiDService.updateWiD(withID: clickedWiDId, newTitle: title.rawValue, newStart: start, newFinish: finish, newDuration: duration)
                    
                    wiDList = wiDService.selectWiDListByDate(date: date)
                    
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("완료")
                        .bodyMedium()
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(isStartOverlap || isStartOverCurrentTime || isFinishOverlap || isFinishOverCurrentTime || !durationExist ? Color("LightGray-Gray") : Color("LimeGreen"))
                        .foregroundColor(Color("White"))
                        .cornerRadius(8)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .disabled(isStartOverlap || isStartOverCurrentTime || isFinishOverlap || isFinishOverCurrentTime || !durationExist)
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
                        Text("WiD 정보")
                            .titleMedium()
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // 날짜
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
                        }
                        .padding(.horizontal)
                        
                        // 제목
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
                                    .tint(Color("Black-White"))
                                    .background(Color("LightGray-Gray"))
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
                        
                        Button(action: {
                            if isDeleteButtonPressed {
                                wiDService.deleteWiD(withID: clickedWiDId)
                                // 삭제 후 뒤로가기
                                presentationMode.wrappedValue.dismiss()
                            } else {
                                isDeleteButtonPressed = true
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    withAnimation {
                                        isDeleteButtonPressed = false
                                    }
                                }
                            }
                        }) {
                            HStack {
                                if isDeleteButtonPressed {
                                    Text("삭제 확인")
                                        .bodyMedium()
                                } else {
                                    Image(systemName: "trash")
                                    
                                    Text("삭제")
                                        .bodyMedium()
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()

                        }
                        .foregroundColor(isDeleteButtonPressed ? Color("White-Black") : Color("OrangeRed"))
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.red, lineWidth: 1)
                                .background(isDeleteButtonPressed ? Color("OrangeRed") : Color("White-Black"))
                        )
                        .cornerRadius(8)
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
//                    .background(Color("White-Black"))
                    
                    Rectangle()
                        .frame(maxWidth: .infinity, maxHeight: 8)
                        .foregroundColor(Color("LightGray-Gray"))
                    
                    VStack(spacing: 8) {
                        Text("선택 가능한 시간 범위")
                            .titleMedium()
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack(spacing: 8) {
                            Rectangle()
                                .fill(Color("Black-White"))
                                .frame(maxWidth: 8)
                            
                            Button(action: {
                                start = startLimit
                                finish = finishLimit
                            }) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("\(formatTime(startLimit)) ~ \(formatTime(finishLimit))")
                                        .bodyMedium()

                                    Text(formatDuration(finishLimit.timeIntervalSince(startLimit), mode: 3))
                                        .bodyMedium()
                                }
                                .padding()

                                Spacer()

                                Image(systemName: "square.and.arrow.down")
                                    .padding()
                            }
                            .tint(Color("Black-White"))
                            .background(Color("White-Black"))
                            .cornerRadius(8)
                            .shadow(color: Color("Black-White"), radius: 1)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
//                    .background(Color("White-Black"))
                }
            }
//            .background(Color("LightGray-Gray"))
            
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
//        .background(Color("White-Black"))
        .onAppear {
            self.date = clickedWiD!.date
            self.title = Title(rawValue: clickedWiD!.title) ?? .STUDY
            
            // date 날짜를 clickedWiD!.start와 clickedWiD!.finish에 적용시킴.
            let clickedWiDStartComponents = calendar.dateComponents([.hour, .minute, .second], from: clickedWiD!.start)
            self.start = calendar.date(bySettingHour: clickedWiDStartComponents.hour!, minute: clickedWiDStartComponents.minute!, second: clickedWiDStartComponents.second!, of: date)!
            
            let clickedWiDFinishComponents = calendar.dateComponents([.hour, .minute, .second], from: clickedWiD!.finish)
            self.finish = calendar.date(bySettingHour: clickedWiDFinishComponents.hour!, minute: clickedWiDFinishComponents.minute!, second: clickedWiDFinishComponents.second!, of: date)!
            
            self.duration = clickedWiD!.duration
            
            self.wiDList = wiDService.selectWiDListByDate(date: date)
            
            if let index = wiDList.firstIndex(where: { $0.id == clickedWiDId }) {
                if 0 < index {
                    let previousWiD = wiDList[index - 1]
                    let previousWiDFinishComponents = calendar.dateComponents([.hour, .minute, .second], from: previousWiD.finish)
                    self.startLimit = calendar.date(bySettingHour: previousWiDFinishComponents.hour!, minute: previousWiDFinishComponents.minute!, second: previousWiDFinishComponents.second!, of: date)!
                } else {
                    self.startLimit = calendar.startOfDay(for: date) // date 날짜의 오전 12:00:00
                }
                
                if index < wiDList.count - 1 {
                    let nextWiD = wiDList[index + 1]
                    let nextWiDStartComponents = calendar.dateComponents([.hour, .minute, .second], from: nextWiD.start)
                    self.finishLimit = calendar.date(bySettingHour: nextWiDStartComponents.hour!, minute: nextWiDStartComponents.minute!, second: nextWiDStartComponents.second!, of: date)!
                } else if calendar.isDate(date, inSameDayAs: today) {
                    self.finishLimit = currentTime
                } else {
                    self.finishLimit = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: date)! // date 날짜의 오후 11:59:59
                }
            }
        }
        .navigationBarHidden(true)
        .onChange(of: start) { newStart in
            duration = finish.timeIntervalSince(newStart)
            // DB의 newStart는 date가 아니라 2000-01-01 날짜를 가진다.
            // 데이터베이스에서 "HH:mm:ss" 형식의 데이터를 가져와서 Date타입으로 변경하면 "2000-01-01 HH:mm:ss" 형식이 된다.
//                print("new Start : \(formatTime(newStart, format: "yyyy-MM-dd a h:mm:ss"))")
            
            withAnimation {
                durationExist = 0 < duration
            }
            
            isStartOverlap = newStart < startLimit
//                print(isStartOverlap ? "start overlap" : "")

            isStartOverCurrentTime = calendar.isDate(date, inSameDayAs: today) && currentTime < newStart
//                print(isStartOverCurrentTime ? "today, start over currentTime" : "")
        }
        .onChange(of: finish) { newFinish in
            duration = newFinish.timeIntervalSince(start)
//                print("new Finish : \(formatTime(newFinish, format: "yyyy-MM-dd a h:mm:ss"))")
            
            withAnimation {
                durationExist = 0 < duration
            }
            
            isFinishOverlap = finishLimit < newFinish
//                print(isFinishOverlap ? "finish overlap" : "")

            isFinishOverCurrentTime = calendar.isDate(date, inSameDayAs: today) && currentTime < newFinish
//                print(isFinishOverCurrentTime ? "today, finish over currentTime" : "")
        }
    }
}

struct WiDView_Previews: PreviewProvider {
    static var previews: some View {
        WiDView(clickedWiDId: 0)
    }
}

