//
//  WiDCreateManualView.swift
//  WiD
//
//  Created by jjkim on 2023/09/19.
//

import SwiftUI

struct WiDCreateManualView: View {
    @State private var date = Date()
    @State private var title: Title = .STUDY
    @State private var start = Date()
    @State private var finish = Date()
    @State private var duration: TimeInterval = 0.0
    @State private var detail = ""
    
    @State private var currentDate = Date()
    
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
        VStack(alignment: .leading) {
            DatePicker("", selection: $date, in: ...currentDate, displayedComponents: .date)
                .labelsHidden()
//                .background(Color("light_gray"))
            
            HStack {
                Rectangle()
//                    .fill(Color("light_gray"))
                    .fill(.red)
                    .frame(width: 10, height: 25)
                
                Text("순서")
                    .frame(maxWidth: .infinity)
                
                Text("제목")
                    .frame(maxWidth: .infinity)
                
                Text("시작")
                    .frame(maxWidth: .infinity)
                
                Text("종료")
                    .frame(maxWidth: .infinity)
                
                Text("경과")
                    .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .background(Color("light_gray"))
            .cornerRadius(5)
            
            HStack {
                Rectangle()
//                    .fill(Color("light_gray"))
                    .fill(.red)
                    .frame(width: 10, height: 60)
                
                VStack {
                    HStack(spacing: 0) {
                        Text("1")
                        
                        Picker("", selection: $title) {
                            ForEach(Array(Title.allCases), id: \.self) { title in
                                Text(titleDictionary[title.rawValue]!)
                            }
                        }
                        .border(.black)
                        
                        DatePicker("", selection: $start, in: ...currentDate, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .border(.black)
                        
                        DatePicker("", selection: $finish, in: ...currentDate, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .border(.black)
                        
                        Text(formatDuration(duration, mode: 2))
                            .frame(maxWidth: .infinity)
                            .border(.black)
                    }
                    
                    HStack {
                        Text("설명")
                        
                        Text("입력...")
                        
                        Spacer()
                    }
                }
            }
            .background(Color("light_gray"))
            .cornerRadius(5)
            
            Button(action: {
                
            }) {
                Text("등록")
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onChange(of: [start, finish]) { values in
            let newStart = values[0]
            let newFinish = values[1]
            duration = newFinish.timeIntervalSince(newStart)
        }
    }
}

struct WiDCreateManualView_Previews: PreviewProvider {
    static var previews: some View {
        WiDCreateManualView()
    }
}
