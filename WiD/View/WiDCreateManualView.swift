//
//  WiDCreateManualView.swift
//  WiD
//
//  Created by jjkim on 2023/09/19.
//

import SwiftUI

struct WiDCreateManualView: View {
    private let wiDService = WiDService()
    
    @State private var date = Date()
    @State private var title: Title = .STUDY
    @State private var start = Date()
    @State private var finish = Date()
    @State private var duration: TimeInterval = 0.0
    @State private var detail: String = ""
    
    @State private var currentDate = Date()
    
    @State private var isDone: Bool = false
    
    enum Title: String, CaseIterable, Identifiable {
        case STUDY
        case WORK
        case READING
        case EXERCISE
        case HOBBY
        case TRAVEL
        case SLEEP
        
        var id: Self { self }
    }

    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("WiD")
                        .font(.custom("Acme-Regular", size: 30))
                    
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
//                        HStack {
//                            Text(formatDate(date, format: "yyyy.MM.dd"))
//                                .font(.system(size: 25))
//
//                            Text(formatWeekday(date))
//                                .foregroundColor(Calendar.current.component(.weekday, from: date) == 1 ? .red : (Calendar.current.component(.weekday, from: date) == 7 ? .blue : .black))
//                                .font(.system(size: 25))
//                        }
                        
                        DatePicker("", selection: $date, in: ...currentDate, displayedComponents: .date)
                            .labelsHidden()
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
//                        Text(titleDictionary[title.rawValue]!)
//                            .font(.system(size: 25))
//                            .frame(maxWidth: .infinity)
                        
                        Picker("", selection: $title) {
                            ForEach(Array(Title.allCases), id: \.self) { title in
                                Text(titleDictionary[title.rawValue]!)
                            }
                        }
//                        .accentColor(Color("light_gray"))
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
//                        Text(formatTime(start, format: "a HH:mm:ss"))
//                            .font(.system(size: 25))
                        
                        DatePicker("", selection: $start, in: ...finish, displayedComponents: .hourAndMinute)
                            .labelsHidden()
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
//                        Text(formatTime(finish, format: "a HH:mm:ss"))
//                            .font(.system(size: 25))
                        
                        DatePicker("", selection: $finish, in: ...currentDate, displayedComponents: .hourAndMinute)
                            .labelsHidden()
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

                    Text(formatDuration(duration, mode: 3))
                        .font(.system(size: 25))
                        .frame(maxWidth: .infinity)
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
                    let wiD = WiD(id: 0, date: date, title: title.rawValue, start: start, finish: finish, duration: duration, detail: detail)
                    wiDService.insertWiD(wid: wiD)
                }) {
                    Text("등록")
                }
                .frame(maxWidth: .infinity)

                Button(action: {

                }) {
                    Text("초기화")
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        .onChange(of: [start, finish]) { values in
            let newStart = values[0]
            let newFinish = values[1]
            duration = newFinish.timeIntervalSince(newStart)
        }
        .onAppear() {
            start = Calendar.current.date(bySetting: .second, value: 0, of: start) ?? start
            finish = Calendar.current.date(bySetting: .second, value: 0, of: finish) ?? finish
        }
    }
}

struct WiDCreateManualView_Previews: PreviewProvider {
    static var previews: some View {
        WiDCreateManualView()
    }
}
