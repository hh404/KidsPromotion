//
//  DBManager.swift
//  KidsPromotion
//
//  Created by huangjianwu on 2020/9/10.
//  Copyright © 2020 huangjianwu. All rights reserved.
//

import Foundation
import RealmSwift

class DBManager: NSObject {
    static let shared = DBManager()
    var realm: Realm?
    
    override init() {
        super.init()
        self.setDefaultRealmForUser(username: "Emily")
//        self.openDB()
    }
    
    func setDefaultRealmForUser(username: String) {
        var config = Realm.Configuration()
        // 使用默认的目录，但是请将文件名替换为用户名
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("\(username).realm")
        // 将该配置设置为默认 Realm 配置
        Realm.Configuration.defaultConfiguration = config
    }
    
    func openDB() -> Void {
        let config = Realm.Configuration(schemaVersion: 1, migrationBlock: { migration, oldSchemaVersion in
            // 可能会进行冗长的数据迁移操作
        })
        Realm.asyncOpen(configuration: config) { realm, error in
            if let realm = realm {
                // 成功打开 Realm 数据库，迁移操作在后台线程中进行
                self.realm = realm
            } else if let error = error {
                // 处理在打开 Realm 数据库期间所出现的错误
            }
        }
        
    }
    
    func test() {
        let kid = KidEvent()
        kid.eventName = "起床"
        kid.referenceID = "0"
        kid.eventdate = 1599749785
        do {
            realm = try! Realm()
            try DBManager.shared.realm?.write {
                DBManager.shared.realm?.add(kid)
            }
        }
        catch {
            print(error)
        }
        let dogs = DBManager.shared.realm?.objects(KidEvent.self)
        print("dd")
    }
}
