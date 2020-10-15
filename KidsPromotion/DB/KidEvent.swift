//
//  KidEvent.swift
//  KidsPromotion
//
//  Created by huangjianwu on 2020/9/10.
//  Copyright © 2020 huangjianwu. All rights reserved.
//

import Foundation
import RealmSwift

class KidEvent: Object {
    @objc dynamic var referenceID = ""
    @objc dynamic var eventName = ""
    @objc dynamic var eventdate: TimeInterval = 0.0
}
