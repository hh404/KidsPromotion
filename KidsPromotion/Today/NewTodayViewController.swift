//
//  NewTodayViewController.swift
//  KidsPromotion
//
//  Created by huangjianwu on 2020/9/6.
//  Copyright © 2020 huangjianwu. All rights reserved.
//

import UIKit
import KVKCalendar
import ZRouter
import ZIKRouter.Internal
//import DateToolsSwift

class NewTodayViewController: UIViewController, ViperView, TodayViewInput  {
    var viewDataSource: ViperViewInput?
    
    var routeSource: UIViewController?
    
    var eventHandler: ViperViewEventHandler?
    
    
    private var events = [Event]()
        
        private var selectDate: Date = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            return formatter.date(from: "14.12.2018") ?? Date()
        }()
        
        private lazy var todayButton: UIBarButtonItem = {
            let button = UIBarButtonItem(title: "Today", style: .done, target: self, action: #selector(today))
            button.tintColor = .systemRed
            return button
        }()
        
        private lazy var style: Style = {
            var style = Style()
            if UIDevice.current.userInterfaceIdiom == .phone {
                style.timeline.widthTime = 40
                style.timeline.currentLineHourWidth = 45
                style.timeline.offsetTimeX = 2
                style.timeline.offsetLineLeft = 2
            } else {
                style.timeline.widthEventViewer = 500
            }
            style.timeline.startFromFirstEvent = false
            style.followInSystemTheme = true
            style.timeline.offsetTimeY = 80
            style.timeline.offsetEvent = 3
            style.allDay.isPinned = true
            style.startWeekDay = .sunday
            style.timeHourSystem = .twelveHour
            style.event.isEnableMoveEvent = true
            return style
        }()
        
        private lazy var calendarView: CalendarView = {
            let calendar = CalendarView(frame: view.frame, date: selectDate, style: style)
            calendar.delegate = self
            calendar.dataSource = self
            return calendar
        }()
        
        private lazy var segmentedControl: UISegmentedControl = {
            let array = CalendarType.allCases
            let control = UISegmentedControl(items: array.map({ $0.rawValue.capitalized }))
            control.tintColor = .systemRed
            control.selectedSegmentIndex = 0
            control.addTarget(self, action: #selector(switchCalendar), for: .valueChanged)
            return control
        }()
        
        private lazy var eventViewer: EventViewer = {
            let view = EventViewer(frame: CGRect(x: 0, y: 0, width: 500, height: calendarView.frame.height))
            return view
        }()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            if #available(iOS 13.0, *) {
                view.backgroundColor = .systemBackground
            } else {
                view.backgroundColor = .white
            }
            view.addSubview(calendarView)
            navigationItem.titleView = segmentedControl
            navigationItem.rightBarButtonItem = todayButton
            
            calendarView.addEventViewToDay(view: eventViewer)
            self.addCommonRepeatEvents()
//            loadEvents { [weak self] (events) in
//                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                    self?.events = events
//                    self?.calendarView.reloadData()
//                }
//            }
        }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
                calendarView.scrollTo(Date())
    }
        
        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            var frame = view.frame
            frame.origin.y = 0
            calendarView.reloadFrame(frame)
        }
        
        @objc func today(sender: UIBarButtonItem) {
            calendarView.scrollTo(Date())
        }
        
        @objc func switchCalendar(sender: UISegmentedControl) {
            let type = CalendarType.allCases[sender.selectedSegmentIndex]
            calendarView.set(type: type, date: selectDate)
        }
        
        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//            loadEvents { [weak self] (events) in
//                self?.events = events
//                self?.calendarView.reloadData()
//            }
        }
    }

    extension NewTodayViewController: CalendarDelegate {
        func didChangeEvent(_ event: Event, start: Date?, end: Date?) {
            var eventTemp = event
            guard let startTemp = start, let endTemp = end else { return }
            
            let startTime = timeFormatter(date: startTemp)
            let endTime = timeFormatter(date: endTemp)
            eventTemp.start = startTemp
            eventTemp.end = endTemp
            eventTemp.text = "\(startTime) - \(endTime)\n new time"
            
            if let idx = events.firstIndex(where: { $0.compare(eventTemp) }) {
                events.remove(at: idx)
                events.append(eventTemp)
                calendarView.reloadData()
            }
        }
        
        func didSelectDate(_ date: Date?, type: CalendarType, frame: CGRect?) {
            selectDate = date ?? Date()
            calendarView.reloadData()
        }
        
        func didSelectEvent(_ event: Event, type: CalendarType, frame: CGRect?) {
            print(type, event)
            switch type {
            case .day:
                eventViewer.text = event.text
            default:
                break
            }
        }
        
        func didSelectMore(_ date: Date, frame: CGRect?) {
            print(date)
        }
        
        func eventViewerFrame(_ frame: CGRect) {
            eventViewer.reloadFrame(frame: frame)
        }
        
        func didAddNewEvent(_ event: Event, _ date: Date?) {
            var newEvent = event
            
            guard let start = date, let end = Calendar.current.date(byAdding: .minute, value: 30, to: start) else { return }

            let startTime = timeFormatter(date: start)
            let endTime = timeFormatter(date: end)
            newEvent.start = start
            newEvent.end = end
            newEvent.ID = "\(events.count + 1)"
            newEvent.text = "\(startTime) - \(endTime)\n new event"
            events.append(newEvent)
            calendarView.reloadData()
        }
    }

    extension NewTodayViewController: CalendarDataSource {
        func eventsForCalendar() -> [Event] {
            return events
        }
        
        private var dates: [Date] {
            return Array(0...10).compactMap({ Calendar.current.date(byAdding: .day, value: $0, to: Date()) })
        }
        
        func willDisplayDate(_ date: KVKCalendar.Date?, events: [Event]) -> DateStyle? {
            guard dates.first(where: { $0.year == date?.year && $0.month == date?.month && $0.day == date?.day }) != nil else { return nil }
            
            return DateStyle(backgroundColor: .orange, textColor: .black, dotBackgroundColor: .red)
        }
        
        func willDisplayEventView(_ event: Event, frame: CGRect, date: Date?) -> EventViewGeneral? {
            guard event.ID == "2" else { return nil }
            
            return CustomViewEvent(style: style, event: event, frame: frame)
        }
    }

    extension NewTodayViewController {
        func loadEvents(completion: ([Event]) -> Void) {
            let decoder = JSONDecoder()
                    
            guard let path = Bundle.main.path(forResource: "events", ofType: "json"),
                let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe),
                let result = try? decoder.decode(ItemData.self, from: data) else { return }
            
            let events = result.data.compactMap({ (item) -> Event in
                let startDate = self.formatter(date: item.start)
                let endDate = self.formatter(date: item.end)
                let startTime = self.timeFormatter(date: startDate)
                let endTime = self.timeFormatter(date: endDate)
                
                var event = Event()
                event.ID = item.id
                event.start = startDate
                event.end = endDate
                event.color = EventColor(item.color)
                event.isAllDay = item.allDay
                event.isContainsFile = !item.files.isEmpty
                event.textForMonth = item.title
                
                if item.allDay {
                    event.text = "\(item.title)"
                } else {
                    event.text = "\(startTime) - \(endTime)\n\(item.title)"
                }
                
                if item.id == "14" {
                    event.recurringType = .everyWeek
                }
                if item.id == "40" {
                    event.recurringType = .everyDay
                }
                return event
            })
            completion(events)
        }
        
        func addCommonRepeatEvents() {
            //getup
//            let today = Date
//            let todayZero = today.startOfDay
//            let tc = todayZero?.addingTimeInterval(8*3600)
//            today1.startOfDay?.add(<#T##chunk: TimeChunk##TimeChunk#>)
            let getup = DateTools.getupTime()
            var event = Event()
            event.ID = "1"
            event.start = getup.0
            event.end = getup.1
            event.color = EventColor(UIColor.green)
            event.isAllDay = false
            event.isContainsFile = false
            event.textForMonth = "dddddd"
            self.events.append(event)
        }
        
        func timeFormatter(date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = style.timeHourSystem.format
            return formatter.string(from: date)
        }
        
        func formatter(date: String) -> Date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            return formatter.date(from: date) ?? Date()
        }
    }

    extension NewTodayViewController: UIPopoverPresentationControllerDelegate { }

    struct ItemData: Decodable {
        let data: [Item]
        
        enum CodingKeys: String, CodingKey {
            case data
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            data = try container.decode([Item].self, forKey: CodingKeys.data)
        }
    }

    struct Item: Decodable {
        let id: String, title: String, start: String, end: String
        let color: UIColor, colorText: UIColor
        let files: [String]
        let allDay: Bool
        
        enum CodingKeys: String, CodingKey {
            case id, title, start, end, color, files
            case colorText = "text_color"
            case allDay = "all_day"
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(String.self, forKey: CodingKeys.id)
            title = try container.decode(String.self, forKey: CodingKeys.title)
            start = try container.decode(String.self, forKey: CodingKeys.start)
            end = try container.decode(String.self, forKey: CodingKeys.end)
            allDay = try container.decode(Int.self, forKey: CodingKeys.allDay) != 0
            files = try container.decode([String].self, forKey: CodingKeys.files)
            let strColor = try container.decode(String.self, forKey: CodingKeys.color)
            color = UIColor.hexStringToColor(hex: strColor)
            let strColorText = try container.decode(String.self, forKey: CodingKeys.colorText)
            colorText = UIColor.hexStringToColor(hex: strColorText)
        }
    }

    extension UIColor {
        static func hexStringToColor(hex: String) -> UIColor {
            var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
            
            if cString.hasPrefix("#") {
                cString.remove(at: cString.startIndex)
            }
            
            if cString.count != 6 {
                return .gray
            }
            var rgbValue: UInt32 = 0
            Scanner(string: cString).scanHexInt32(&rgbValue)
            
            return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                           green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                           blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                           alpha: 1.0)
        }
    }

    final class CustomViewEvent: EventViewGeneral {
        override init(style: Style, event: Event, frame: CGRect) {
            super.init(style: style, event: event, frame: frame)
            
            let imageView = UIImageView(image: UIImage(named: "ic_stub"))
            imageView.frame = CGRect(origin: CGPoint(x: 3, y: 1), size: CGSize(width: frame.width - 6, height: frame.height - 2))
            imageView.contentMode = .scaleAspectFit
            addSubview(imageView)
            backgroundColor = event.backgroundColor
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }


final class EventViewer: UIView {
    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Select event to view the description"
        return label
    }()
    
    var text: String? {
        didSet {
            textLabel.text = text
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if #available(iOS 13.0, *) {
            backgroundColor = .systemBackground
        } else {
            backgroundColor = .white
        }
        addSubview(textLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadFrame(frame: CGRect) {
        textLabel.frame = frame
    }
}

//Declare PureSwiftSampleViewInput is routable
extension RoutableView where Protocol == TodayViewInput {
    init() { self.init(declaredProtocol: Protocol.self) }
}
//Declare SwiftSampleViewConfig is routable
extension RoutableViewModule where Protocol == TodayViewModuleInput {
    init() { self.init(declaredProtocol: Protocol.self) }
}

extension NewTodayViewController: ZIKRoutableView {
}
