//
//  WiDUtil.swift
//  WiD
//
//  Created by jjkim on 2023/07/15.
//

import SwiftUI

struct WiD {
    var id: Int
    var date: Date
    var title: String
    var start: Date
    var finish: Date
    var duration: TimeInterval
    var detail: String
    
    init(id: Int, date: Date, title: String, start: Date, finish: Date, duration: TimeInterval, detail: String) {
        self.id = id
        self.date = date
        self.title = title
        self.start = start
        self.finish = finish
        self.duration = duration
        self.detail = detail
    }
}

struct WiDView: View {
    @Environment(\.presentationMode) var presentationMode
    private let screen = UIScreen.main.bounds.size
    private let wiDService = WiDService()
    @State private var wiDList: [WiD] = []
    
    private let calendar = Calendar.current
    private let today = Date()
    private let currenTime = Date()
    
    @State private var date = Date()
    @State private var title: String = ""
    @State private var start = Date()
    private var startMinutes: Int { return calendar.component(.hour, from: start) * 60 + calendar.component(.minute, from: start) }
    @State private var finish = Date()
    private var finishMinutes: Int { return calendar.component(.hour, from: finish) * 60 + calendar.component(.minute, from: finish) }
    @State private var duration: TimeInterval = 0.0
    @State private var detail: String = ""
    
    @State private var isStartOverlap: Bool = false
    @State private var isStartOverCurrentTime: Bool = false

    @State private var isFinishOverlap: Bool = false
    @State private var isFinishOverCurrentTime: Bool = false
    
    @State private var isDurationUnderMin: Bool = false
    
    @State private var isDeleteButtonPressed: Bool = false
    @State private var deleteTimer: Timer?
    
    @State private var isEditing: Bool = false
    
    private let clickedWiDId: Int
    private let clickedWiD: WiD?

    init(clickedWiDId: Int) {
        self.clickedWiDId = clickedWiDId
        self.clickedWiD = wiDService.selectWiDByID(id: clickedWiDId)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                if isEditing {
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
                }

                VStack {
                    VStack(spacing: 4) {
                        Text("WiD No.\(clickedWiDId)")
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("날짜")
                                
                                HStack {
                                    Image(systemName: "calendar")
                                        .frame(width: 20)
                                        .padding()
                                    
                                    HStack {
                                        Text(formatDate(date, format: "yyyy년 M월 d일"))
                                        
                                        HStack(spacing: 0) {
                                            Text("(")

                                            Text(formatWeekday(date))
                                                .foregroundColor(calendar.component(.weekday, from: date) == 1 ? .red : (calendar.component(.weekday, from: date) == 7 ? .blue : .black))

                                            Text(")")
                                        }
                                        
                                    }
                                    
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
                                    
                                    if isEditing {
                                        Picker("", selection: $title) {
                                            ForEach(titleArray, id: \.self) { title in
                                                Text(titleDictionary[title]!)
                                            }
                                        }
                                    } else {
                                        Text(titleDictionary[title] ?? "공부")
                                    }
                                    
                                    Spacer()
                                    
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(Color(title))
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
                                    
                                    if isEditing {
                                        DatePicker("", selection: $start, displayedComponents: .hourAndMinute)
                                            .labelsHidden()
                                    } else {
                                        Text(formatTime(start, format: "a h:mm:ss"))
                                    }

                                    
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
                                    
                                    if isEditing {
                                        DatePicker("", selection: $finish, displayedComponents: .hourAndMinute)
                                            .labelsHidden()
                                    } else {
                                        Text(formatTime(finish, format: "a h:mm:ss"))
                                    }

                                    
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
                    
                    HStack {
                        Button(action: {
                            if isEditing {
                                title = clickedWiD?.title ?? "STUDY"
                                start = clickedWiD?.start ?? Date()
                                finish = clickedWiD?.finish ?? Date()
                                
                                withAnimation {
                                    isEditing.toggle()
                                }
                            } else {
                                if isDeleteButtonPressed {
                                    wiDService.deleteWiD(withID: clickedWiDId)
                                    // 삭제 후 뒤로가기
                                    presentationMode.wrappedValue.dismiss()
                                }
                                
                                withAnimation {
                                    isDeleteButtonPressed.toggle()
                                }
                                if isDeleteButtonPressed {
                                    deleteTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
                                        isDeleteButtonPressed = false
                                        deleteTimer?.invalidate()
                                        deleteTimer = nil
                                    }
                                } else {
                                    deleteTimer?.invalidate()
                                    deleteTimer = nil
                                }
                            }
                        }) {
                            if isEditing {
                                Image(systemName: "clear")
                                    .foregroundColor(.blue)
                                
                                Text("취소")
                            } else {
                                if isDeleteButtonPressed {
                                    Image(systemName: "trash.fill")
                                        .foregroundColor(.white)
                                    
                                    Text("한번 더 눌러 삭제")
                                        .foregroundColor(.white)
                                        
                                } else {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                    
                                    Text("삭제")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background(isDeleteButtonPressed ? .red : .clear)
                        .cornerRadius(isDeleteButtonPressed ? 5 : 0)
                        .background(RoundedRectangle(cornerRadius: 5)
                            .stroke(isEditing ? .blue : .red, lineWidth: 1)
                        )
                        
                        Button(action: {
                            if isEditing {
                                wiDService.updateWiD(withID: clickedWiDId, newTitle: title, newStart: start, newFinish: finish, newDuration: duration, newDetail: detail)
                                
                                // wiDList를 갱신하여 수평 막대 차트를 갱신함.
                                wiDList = wiDService.selectWiDsByDate(date: date)
                            }
                            withAnimation {
                                isEditing.toggle()
                            }
                        }) {
                            Image(systemName: isEditing ? "checkmark.square" : "square.and.pencil")
                                .foregroundColor(.white)
                            
                            Text(isEditing ? "완료" : "수정")
                                .foregroundColor(.white)
                        }
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background(isEditing ?
                            (isStartOverlap || isStartOverCurrentTime || isFinishOverlap || isFinishOverCurrentTime || isDurationUnderMin || duration == 0 ? Color("light_gray") : .green) :
                            .blue)
                        .cornerRadius(5)
                        .disabled(isStartOverlap || isFinishOverlap || isDurationUnderMin)
                    }
                }
            }
            .padding()
            .onAppear() {
                date = clickedWiD!.date

                title = clickedWiD!.title
                start = clickedWiD!.start
                finish = clickedWiD!.finish
                duration = clickedWiD!.duration
                detail = clickedWiD!.detail
                
                wiDList = wiDService.selectWiDsByDate(date: date)
            }
            .onChange(of: start) { newStart in
                duration = finish.timeIntervalSince(newStart)
                // DB의 newStart는 date가 아니라 2000-01-01 날짜를 가진다.
                print("new Start : \(formatTime(newStart, format: "yyyy-MM-dd a h:mm:ss"))")
                
                withAnimation {
                    isDurationUnderMin = duration < 0
                }
                
                if calendar.isDate(date, inSameDayAs: today), currenTime <= newStart {
                    isStartOverlap = true
                    print("today, start over currentTime")
                } else if let currentIndex = wiDList.firstIndex(where: { $0.id == clickedWiDId }), 0 < currentIndex {
                    let previousWiD = wiDList[currentIndex - 1]
                    // clickedWiD와 wiDList 모두 DB에서 가져온 것이기 때문에, newStart와 previousWiD.finish 모두 2000-01-01 날짜를 가진다.
                    if newStart <= previousWiD.finish {
                        isStartOverlap = true
                        print("start overlap")
                    } else {
                        isStartOverlap = false
                        print("start not overlap")
                    }
                }
            }
            .onChange(of: finish) { newFinish in
                duration = newFinish.timeIntervalSince(start)
                print("new Finish : \(formatTime(newFinish, format: "yyyy-MM-dd a h:mm:ss"))")
                
                withAnimation {
                    isDurationUnderMin = duration < 0
                }
                
                if calendar.isDate(date, inSameDayAs: today), currenTime <= newFinish {
                    isFinishOverlap = true
                    print("today, finish over currentTime")
                } else if let currentIndex = wiDList.firstIndex(where: { $0.id == clickedWiDId }), currentIndex < wiDList.count - 1 {
                    let nextWiD = wiDList[currentIndex + 1]
                    if nextWiD.start <= newFinish {
                        isFinishOverlap = true
                        print("finish overlap")
                    } else {
                        isFinishOverlap = false
                        print("finish not overlap")
                    }
                }
            }
        }
    }
}

struct WiDView_Previews: PreviewProvider {
    static var previews: some View {
        WiDView(clickedWiDId: 0)
    }
}
