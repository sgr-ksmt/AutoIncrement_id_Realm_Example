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

final class AutoIncrementableID {
    private static let serialQueue: DispatchQueue = DispatchQueue(label: "AutoIncrementableID serial queue")
    
    private static func autoIncrementIdkey<T: Object>(of type: T.Type) -> String {
        return "auto_increment_id_\(String(describing: type))"
    }
    
    static func id<T: Object>(of type: T.Type) -> Int {
        return serialQueue.sync {
            let key = autoIncrementIdkey(of: type)
            let next = (UserDefaults.standard.object(forKey: key) as? Int).map { $0 + 1 } ?? 0
            save(id: next, key: key)
            return next
        }
    }
    
    private static func save(id: Int, key: String) {
        UserDefaults.standard.set(id, forKey: key)
        UserDefaults.standard.synchronize()
    }
}
