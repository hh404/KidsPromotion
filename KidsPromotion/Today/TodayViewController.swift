//
//  TodayViewController.swift
//  KidsPromotion
//
//  Created by huangjianwu on 2020/9/4.
//  Copyright © 2020 huangjianwu. All rights reserved.
//

import UIKit
import ZIKRouter
import ZRouter
import CalendarKit
import DateToolsSwift

enum CalendarEventStatus {
    case d
}

class TodayViewController: DayViewController,ViperView, TodayViewInput {
    
    var routeSource: UIViewController?
    
    var eventHandler: ViperViewEventHandler?
    
    var viewDataSource: Any?
    

      var data = [["Breakfast at Tiffany's",
                   "New York, 5th avenue"],
                  
                  ["Workout",
                   "Tufteparken"],
                  
                  ["Meeting with Alex",
                   "Home",
                   "Oslo, Tjuvholmen"],
                  
                  ["Beach Volleyball",
                   "Ipanema Beach",
                   "Rio De Janeiro"],
                  
                  ["WWDC",
                   "Moscone West Convention Center",
                   "747 Howard St"],
                  
                  ["Google I/O",
                   "Shoreline Amphitheatre",
                   "One Amphitheatre Parkway"],
                  
                  ["✈️️ to Svalbard ❄️️❄️️❄️️❤️️",
                   "Oslo Gardermoen"],
                  
                  ["💻📲 Developing CalendarKit",
                   "🌍 Worldwide"],
                  
                  ["Software Development Lecture",
                   "Mikpoli MB310",
                   "Craig Federighi"],
                  
      ]
      
      var generatedEvents = [EventDescriptor]()
      var alreadyGeneratedSet = Set<Date>()
      
      var colors = [UIColor.blue,
                    UIColor.yellow,
                    UIColor.green,
                    UIColor.red]

      lazy var customCalendar: Calendar = {
        let customNSCalendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
    //    customNSCalendar.timeZone = TimeZone(abbreviation: "CEST")!
        let calendar = customNSCalendar as Calendar
        return calendar
      }()
      
      override func loadView() {
        calendar = customCalendar
        dayView = DayView(calendar: calendar)
        view = dayView
      }
      
      override func viewDidLoad() {
        super.viewDidLoad()
        title = "CalendarKit Demo"
        navigationController?.navigationBar.isTranslucent = false
        dayView.autoScrollToFirstEvent = true
        reloadData()
      }
      
      
      // MARK: EventDataSource
      
      override func eventsForDate(_ date: Date) -> [EventDescriptor] {
//        if !alreadyGeneratedSet.contains(date) {
//          alreadyGeneratedSet.insert(date)
//          generatedEvents.append(contentsOf: generateEventsForDate(date))
//        }
        generatedEvents.append(self.createGetUpEvent())
        generatedEvents.append(self.createGetUp1Event())
        return generatedEvents
      }
    
    func createGetUpEvent() -> Event {
        let today = Date()
        var chunk = TimeChunk()
        chunk.hours = 7
        chunk.minutes = 5
        let startDate = today.add(chunk)
        let event = Event()
        let duration = 40
        let datePeriod = TimePeriod(beginning: startDate,
                                    chunk: TimeChunk.dateComponents(minutes: duration))
        
        event.startDate = datePeriod.beginning!
        event.endDate = datePeriod.end!
        event.color = .green
        event.text = "快起床"
        return event
    }
    
    func createGetUp1Event() -> Event {
        let today = Date()
        var chunk = TimeChunk()
        chunk.hours = 7
        chunk.minutes = 15
        let startDate = today.add(chunk)
        let event = Event()
        let duration = 40
        let datePeriod = TimePeriod(beginning: startDate,
                                    chunk: TimeChunk.dateComponents(minutes: duration))
        
        event.startDate = datePeriod.beginning!
        event.endDate = datePeriod.end!
        event.color = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        event.text = "起床警报"
        return event
    }
      
      private func generateEventsForDate(_ date: Date) -> [EventDescriptor] {
        var workingDate = date.add(TimeChunk.dateComponents(hours: Int(arc4random_uniform(10) + 5)))
        var events = [Event]()
        
//        for i in 0...4 {
//          let event = Event()
//          let duration = Int(arc4random_uniform(160) + 60)
//          let datePeriod = TimePeriod(beginning: workingDate,
//                                      chunk: TimeChunk.dateComponents(minutes: duration))
//
//          event.startDate = datePeriod.beginning!
//          event.endDate = datePeriod.end!
//
//          var info = data[Int(arc4random_uniform(UInt32(data.count)))]
//
//          let timezone = dayView.calendar.timeZone
//          print(timezone)
//          info.append(datePeriod.beginning!.format(with: "dd.MM.YYYY", timeZone: timezone))
//          info.append("\(datePeriod.beginning!.format(with: "HH:mm", timeZone: timezone)) - \(datePeriod.end!.format(with: "HH:mm", timeZone: timezone))")
//          event.text = info.reduce("", {$0 + $1 + "\n"})
//          event.color = colors[Int(arc4random_uniform(UInt32(colors.count)))]
//          event.isAllDay = Int(arc4random_uniform(2)) % 2 == 0
//
//          // Event styles are updated independently from CalendarStyle
//          // hence the need to specify exact colors in case of Dark style
//          if #available(iOS 12.0, *) {
//            if traitCollection.userInterfaceStyle == .dark {
//              event.textColor = textColorForEventInDarkTheme(baseColor: event.color)
//              event.backgroundColor = event.color.withAlphaComponent(0.6)
//            }
//          }
//
//          events.append(event)
//
//          let nextOffset = Int(arc4random_uniform(250) + 40)
//          workingDate = workingDate.add(TimeChunk.dateComponents(minutes: nextOffset))
//          event.userInfo = String(i)
//        }
//
//        print("Events for \(date)")
        return events
      }
      
      private func textColorForEventInDarkTheme(baseColor: UIColor) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        baseColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: s * 0.3, brightness: b, alpha: a)
      }
      
      // MARK: DayViewDelegate
      
      private var createdEvent: EventDescriptor?
      
      override func dayViewDidSelectEventView(_ eventView: EventView) {
        guard let descriptor = eventView.descriptor as? Event else {
          return
        }
        print("Event has been selected: \(descriptor) \(String(describing: descriptor.userInfo))")
      }
      
      override func dayViewDidLongPressEventView(_ eventView: EventView) {
        guard let descriptor = eventView.descriptor as? Event else {
          return
        }
        endEventEditing()
        print("Event has been longPressed: \(descriptor) \(String(describing: descriptor.userInfo))")
        beginEditing(event: descriptor, animated: true)
        print(Date())
      }
      
      override func dayView(dayView: DayView, didTapTimelineAt date: Date) {
        endEventEditing()
        print("Did Tap at date: \(date)")
      }
      
      override func dayViewDidBeginDragging(dayView: DayView) {
        print("DayView did begin dragging")
      }
      
      override func dayView(dayView: DayView, willMoveTo date: Date) {
        print("DayView = \(dayView) will move to: \(date)")
      }
      
      override func dayView(dayView: DayView, didMoveTo date: Date) {
        print("DayView = \(dayView) did move to: \(date)")
      }
      
      override func dayView(dayView: DayView, didLongPressTimelineAt date: Date) {
        print("Did long press timeline at date \(date)")
        // Cancel editing current event and start creating a new one
//        endEventEditing()
//        let event = generateEventNearDate(date)
//        print("Creating a new event")
//        create(event: event, animated: true)
//        createdEvent = event
      }
      
      
      override func dayView(dayView: DayView, didUpdate event: EventDescriptor) {
        print("did finish editing \(event)")
        print("new startDate: \(event.startDate) new endDate: \(event.endDate)")
        
        if let _ = event.editedEvent {
          event.commitEditing()
        }
        
        if let createdEvent = createdEvent {
          createdEvent.editedEvent = nil
          generatedEvents.append(createdEvent)
          self.createdEvent = nil
          endEventEditing()
        }
        
        reloadData()
      }
}

//Declare SwiftSampleViewController is routable
extension TodayViewController: ZIKRoutableView {
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
