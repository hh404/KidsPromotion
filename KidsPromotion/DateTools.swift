//
//  DateTools.swift
//  KidsPromotion
//
//  Created by huangjianwu on 2020/9/6.
//  Copyright © 2020 huangjianwu. All rights reserved.
//

import Foundation
import DateToolsSwift

class DateTools {
    class func getupTime() -> (Date,Date) {
        let date = Date()
        //"2018-12-10T09:00:00+03:00"
        let start = String(format: "%d-%d-%dT08:00:00+08:00", date.year,date.year,date.day)
        let sevenAM = self.formatter(date: start)
        var chunk = TimeChunk()
        chunk.minutes = 15
        let end = sevenAM.add(chunk)
        return (sevenAM,end)
    }
    
    class func formatter(date: String) -> Date {
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
           return formatter.date(from: date) ?? Date()
       }
}
