//
//  WiDReadView.swift
//  WiD
//
//  Created by jjkim on 2023/07/08.
//

import SwiftUI

struct WiDReadDayView: View {
    @State private var wiDs: [WiD] = []
    private let wiDService = WiDService()
    
    @State private var currentDate: Date = Date()
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    HStack {
                        Text(formatDate(currentDate, format: "yyyy.MM.dd"))
                        
                        Text(formatWeekday(currentDate))
                    }
                    .frame(maxWidth: .infinity)
                    
                    Button(action: {
                        
                    }) {
                        Text("현재")
                    }
                    
                    Button(action: {
                        currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
                        fetchWiDs()
                    }) {
                        Image(systemName: "chevron.left")
                    }
                    
                    Button(action: {
                        currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
                        fetchWiDs()
                    }) {
                        Image(systemName: "chevron.right")
                    }
                    .disabled(Calendar.current.isDateInToday(currentDate))
                }
                .border(Color.black)
                
                PieChartView(data: fetchChartData())
                    .border(Color.red)
                
    //            VStack {
    //                HStack {
    //                    Text("제목")
    //                        .frame(maxWidth: .infinity)
    //                    Text("총합")
    //                        .frame(maxWidth: .infinity)
    //                }
    //            }
    //            .border(Color.black)
                
                VStack {
                    HStack {
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
                        Text("자세히")
                            .frame(maxWidth: .infinity)
                    }

                    ForEach(Array(wiDs.enumerated()), id: \.element.id) { (index, wid) in
                        NavigationLink(destination: WiDView(clickedWiDId: wid.id)) {
                            HStack {
                                Text("\(index + 1)")
                                    .frame(maxWidth: .infinity)
                                Text(wid.title)
                                    .frame(maxWidth: .infinity)
                                Text(formatTime(wid.start, format: "HH:mm"))
                                    .frame(maxWidth: .infinity)
                                Text(formatTime(wid.finish, format: "HH:mm"))
                                    .frame(maxWidth: .infinity)
                                Text(formatDuration(wid.duration, isClickedWiD: false))
                                    .frame(maxWidth: .infinity)
                                Text("(\(wid.detail.count))")
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    }
                }
                .frame(maxHeight: .infinity)
                .border(Color.black)
            }
            .frame(maxHeight: .infinity)
            .border(Color.black)
            .padding(.horizontal)
            .onAppear {
                fetchWiDs()
            }
        }
    }

    func fetchWiDs() {
        wiDs = wiDService.selectWiDsByDate(date: currentDate)
    }
    
    func fetchChartData() -> [ChartData] {

        let totalMinutes: TimeInterval = 60.0 * 24.0 // 24시간(1440분)으로 표현함. 원래 TimeInterval 단위는 초(second)

        var startMinutes: Int = 0
        var chartDataArray: [ChartData] = []

        // 비어 있는 시간대에 대한 ChartData 생성
        if wiDs.isEmpty {
            let noDataChartData = ChartData(value: .degrees(360.0), color: .gray) // 색상은 필요에 따라 변경 가능
            chartDataArray.append(noDataChartData)
        } else {
            for wid in wiDs {
                let startMinutesComponents = Calendar.current.dateComponents([.hour, .minute], from: wid.start)
                let startMinutesValue = (startMinutesComponents.hour ?? 0) * 60 + (startMinutesComponents.minute ?? 0)

                // 비어 있는 시간대의 엔트리 추가
                if startMinutesValue > startMinutes {
                    let emptyMinutes = startMinutesValue - startMinutes
                    let emptyChartData = ChartData(value: .degrees(Double(emptyMinutes) / totalMinutes * 360.0), color: .gray)
                    chartDataArray.append(emptyChartData)
                }

                // 엔트리 셋에 해당 WiD 객체의 시간대를 추가
                let durationMinutes = Int(wid.duration / 60)
                let widChartData = ChartData(value: .degrees(Double(durationMinutes) / totalMinutes * 360.0), color: Color(wid.title))
                chartDataArray.append(widChartData)

                // 시작 시간 업데이트
                startMinutes = startMinutesValue + durationMinutes
            }
        }

        // 마지막 WiD 객체 이후의 비어 있는 시간대의 엔트리 추가
        if startMinutes < 24 * 60 {
            let emptyMinutes = 24 * 60 - startMinutes
            let emptyChartData = ChartData(value: .degrees(Double(emptyMinutes) / totalMinutes * 360.0), color: .gray)
            chartDataArray.append(emptyChartData)
        }

        return chartDataArray
    }
}

struct PieChartView: View {
    var data: [ChartData]

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 원형 차트
                ForEach(0..<data.count, id: \.self) { index in
                    PieSlice(startAngle: getStartAngle(for: index), endAngle: getEndAngle(for: index))
                        .foregroundColor(data[index].color)
                }

                // 중앙에 원
                Circle()
                    .frame(width: geometry.size.width * 0.3, height: geometry.size.width * 0.3)
                    .foregroundColor(.white)
                
                // 숫자 텍스트
                ForEach(1...24, id: \.self) { number in
                    let angle = getAngle(for: number)
                    let radius = geometry.size.width * 0.4 / 2 // 원의 반지름
                    
                    let x = cos(angle.radians) * radius
                    let y = sin(angle.radians) * radius
                    
                    Text("\(number)")
                        .position(x: geometry.size.width / 4 + x, y: geometry.size.width / 4 + y)
                }
            }
            .border(Color.blue)
            .frame(width: geometry.size.width * 0.5, height: geometry.size.width * 0.5)
        }
    }

    func getStartAngle(for index: Int) -> Angle {
        var startAngle: Angle = .degrees(-90)
        for i in 0..<index {
            startAngle += data[i].value
        }
        return startAngle
    }

    func getEndAngle(for index: Int) -> Angle {
        var endAngle: Angle = .degrees(-90)
        for i in 0...index {
            endAngle += data[i].value
        }
        return endAngle
    }
    
    func getAngle(for number: Int) -> Angle {
        let degreesPerNumber = 360.0 / 24
        let angle = degreesPerNumber * Double(number) - 90
        return .degrees(angle)
    }
}

struct ChartData {
    var value: Angle
    var color: Color
}

struct PieSlice: Shape {
    var startAngle: Angle
    var endAngle: Angle

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2

        path.move(to: center)
        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        path.closeSubpath()

        return path
    }
}

func formatDate(_ date: Date, format: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: date)
}

func formatWeekday(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "E"
    return dateFormatter.string(from: date)
}

func formatTime(_ date: Date, format: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: date)
}

func formatDuration(_ interval: TimeInterval, isClickedWiD: Bool) -> String {
    let seconds = Int(interval) % 60
    let minutes = (Int(interval) / 60) % 60
    let hours = Int(interval) / (60 * 60)

    var formattedDuration = ""

    if isClickedWiD {
        if 0 < hours {
            if 0 == minutes && 0 == seconds {
                formattedDuration = String(format: "%d시간", hours)
            } else if 0 < minutes && 0 == seconds {
                formattedDuration = String(format: "%d시간 %d분", hours, minutes)
            } else if 0 < hours && 0 == minutes && 0 < seconds {
                formattedDuration = String(format: "%d시간 %d초", hours, seconds)
            } else {
                formattedDuration = String(format: "%d시간 %d분 %d초", hours, minutes, seconds)
            }
        } else if 0 < minutes {
            if 0 == seconds {
                formattedDuration = String(format: "%d분", minutes)
            } else {
                formattedDuration = String(format: "%d분 %d초", minutes, seconds)
            }
        } else {
            formattedDuration = String(format: "%d초", seconds)
        }
    } else {
        if 0 < hours {
            if 0 == minutes && 0 == seconds {
                formattedDuration = String(format: "%d시간", hours)
            } else if 0 < minutes && 0 == seconds {
                formattedDuration = String(format: "%d시간 %d분", hours, minutes)
            } else if 0 < hours && 0 == minutes && 0 < seconds {
                formattedDuration = String(format: "%d시간 %d초", hours, seconds)
            } else {
                formattedDuration = String(format: "%d시간 %d분", hours, minutes)
            }
        } else if 0 < minutes {
            if 0 == seconds {
                formattedDuration = String(format: "%d분", minutes)
            } else {
                formattedDuration = String(format: "%d분 %d초", minutes, seconds)
            }
        } else {
            formattedDuration = String(format: "%d초", seconds)
        }
    }

    return formattedDuration
}

struct WiDView: View {
    @Environment(\.presentationMode) var presentationMode
    private let wiDService = WiDService()
    
    @State private var inputText: String = ""
    @State private var isExpanded: Bool = false
    
    @State private var isEditing: Bool = false
    
    private let clickedWiDId: Int
    private let clickedWiD: WiD?

    init(clickedWiDId: Int) {
        self.clickedWiDId = clickedWiDId
        self.clickedWiD = wiDService.selectWiDByID(id: clickedWiDId)
    }

    var body: some View {
        NavigationView { // NavigationView 추가
            VStack {
                VStack {
                    HStack {
                        Text("WiD")
                            .font(.system(size: 30))

                        Circle()
                            .foregroundColor(Color(clickedWiD?.title ?? "STUDY"))
                            .frame(width: 20, height: 20)
                    }
                    HStack {
                        Image(systemName: "calendar")
                            .imageScale(.large)
                        Text("날짜")
                            .font(.system(size: 30))

                        HStack {
                            Text(formatDate(clickedWiD?.date ?? Date(), format: "yyyy.MM.dd"))
                                .font(.system(size: 30))

                            Text(formatWeekday(clickedWiD?.date ?? Date()))
                                .font(.system(size: 30))
                        }
                    }

                    HStack {
                        Image(systemName: "doc.text.magnifyingglass")
                            .imageScale(.large)
                        Text("제목")
                            .font(.system(size: 30))

                        Text(clickedWiD?.title ?? "")
                            .font(.system(size: 30))
                    }

                    HStack {
                        Image(systemName: "clock")
                            .imageScale(.large)
                        Text("시작")
                            .font(.system(size: 30))

                        Text(formatTime(clickedWiD?.start ?? Date(), format: "HH:mm:ss"))
                            .font(.system(size: 30))
                    }

                    HStack {
                        Image(systemName: "stopwatch")
                            .imageScale(.large)
                        Text("종료")
                            .font(.system(size: 30))

                        Text(formatTime(clickedWiD?.finish ?? Date(), format: "HH:mm:ss"))
                            .font(.system(size: 30))
                    }

                    HStack {
                        Image(systemName: "hourglass")
                            .imageScale(.large)
                        Text("소요")
                            .font(.system(size: 30))

                        Text(formatDuration(clickedWiD?.duration ?? 0, isClickedWiD: true))
                            .font(.system(size: 30))
                    }
                    
                    if isExpanded {
                        if isEditing {
                            VStack {
                                HStack {
                                    Text("세부 사항")
                                        .font(.system(size: 30))
                                        .foregroundColor(.black)
                                    
                                    Button(action: {
                                        isEditing.toggle()
                                        wiDService.updateWiD(withID: clickedWiDId, detail: inputText)
                                    }) {
                                        Text("완료")
                                            .font(.system(size: 30))
                                    }
                                }
                                
                                TextField("세부 사항 입력..", text: $inputText)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding()
                            }
                        } else {
                            VStack {
                                HStack {
                                    Text("세부 사항")
                                        .font(.system(size: 30))
                                        .foregroundColor(.black)
                                    
                                    Button(action: {
                                        isEditing.toggle()
                                    }) {
                                        Text("수정")
                                            .font(.system(size: 30))
                                    }
                                }

                                Text(clickedWiD?.detail == "" ? "세부 사항 입력.." : clickedWiD?.detail ?? "")
                            }
                        }
                    }
                    
                    Button(action: {
                        isExpanded.toggle()
                        isEditing = false
                    }) {
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .renderingMode(.original)
                            .imageScale(.large)
                    }
                }
                .border(Color.black)

                HStack {
                    Button(action: {
                        // "다운로드" 버튼이 클릭되었을 때 실행될 동작
                    }) {
                        Image(systemName: "arrow.down.to.line")
                            .renderingMode(.original)
                            .imageScale(.large)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)

                    Button(action: {
                        wiDService.deleteWiD(withID: clickedWiDId)
                        presentationMode.wrappedValue.dismiss() // 뒤로 가기
                    }) {
                        Image(systemName: "trash")
                            .renderingMode(.original)
                            .imageScale(.large)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)

                    Button(action: {
                        presentationMode.wrappedValue.dismiss() // 뒤로 가기
                    }) {
                        Image(systemName: "arrow.left.circle")
                            .renderingMode(.original)
                            .imageScale(.large)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .frame(maxHeight: .infinity)
            .border(Color.black)
            .padding(.horizontal)
        }
        .navigationBarBackButtonHidden()
    }
}

struct WiDReadView_Previews: PreviewProvider {
    static var previews: some View {
        WiDReadDayView()
    }
}
