//
//  AutoIncrementableID.swift
//  Demo
//
//  Created by Suguru Kishimoto on 12/20/16.
//
//

import Foundation
import Realm
import RealmSwift

class AutoIncrementableID: Object {
    dynamic var typename: String = ""
    dynamic var id: Int = 0
    
    private convenience init<T: Object>(for type: T.Type) {
        self.init()
        self.typename = String(describing: type)
    }

    private static let internalSerialQueue = DispatchQueue(label: "internal AutoIncrementableID serial queue")
    private static var serialQueues: [String: DispatchQueue] = [:]
    
    static func incremented<T: Object>(for type: T.Type) -> Int {
        return serialQueue(for: type).sync {
            let realm = try! Realm()

            var nextId: Int = 0

            let execute = { () -> Int in
                if let autoIncrementableID = realm.objects(AutoIncrementableID.self).filter({ $0.typename == String(describing: type) }).first {
                    let nextId = autoIncrementableID.id + 1
                    autoIncrementableID.id = nextId
                    return nextId
                } else {
                    realm.add(AutoIncrementableID(for: type))
                    return 0
                }
            }
            
            if !realm.isInWriteTransaction {
                realm.beginWrite()
                nextId = execute()
                try! realm.commitWrite()
            } else {
                nextId = execute()
            }
            print(type, "next", nextId)
            return nextId
        }
    }
        
    private static func serialQueue<T: Object>(for type: T.Type) -> DispatchQueue {
        return internalSerialQueue.sync {
            let key = String(describing: type)
            guard let queue = serialQueues[key] else{
                let newQueue = DispatchQueue(label: "AutoIncrementableID serial queue \(key)")
                serialQueues[key] = newQueue
                return newQueue
            }
            return queue
        }
    }
}
