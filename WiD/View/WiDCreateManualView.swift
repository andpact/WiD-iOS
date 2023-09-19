//
//  WiDCreateManualView.swift
//  WiD
//
//  Created by jjkim on 2023/09/19.
//

import SwiftUI

struct WiDCreateManualView: View {
    @State private var date = Date()
    @State private var title = ""
    @State private var start = Date()
    @State private var finish = Date()
    @State private var duration = TimeInterval()
    @State private var detail = ""
    
    var body: some View {
        VStack {
            Text("수동 WiD 추가")
            
            // Date
            DatePicker("Date", selection: $date, in: ...Date(), displayedComponents: .date)
                .border(Color.gray, width: 1)
            
            // Title
            TextField("Title", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .border(Color.gray, width: 1)
            
            // Start Time
            DatePicker("Start Time", selection: $start, in: ...Date(), displayedComponents: .hourAndMinute)
                .border(Color.gray, width: 1)
            
            // Finish Time
            DatePicker("Finish Time", selection: $finish, in: ...Date(), displayedComponents: .hourAndMinute)
                .border(Color.gray, width: 1)
            
            // Duration
            TextField("Duration", value: $duration, formatter: NumberFormatter())
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .border(Color.gray, width: 1)
            
            // Detail
            TextEditor(text: $detail)
                .border(Color.gray, width: 1)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct WiDCreateManualView_Previews: PreviewProvider {
    static var previews: some View {
        WiDCreateManualView()
    }
}
