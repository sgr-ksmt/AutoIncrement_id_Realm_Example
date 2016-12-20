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
    
    private let key: String
    
    init<T: Object>(for type: T.Type) {
        self.key = "auto_increment_id_\(String(describing: type))"
    }
    
    func incremented() -> Int {
        return type(of: self).serialQueue.sync {
            let next = loadId().map { $0 + 1 } ?? 0
            save(id: next)
            return next
        }
    }
    
    private func loadId() -> Int? {
        return UserDefaults.standard.object(forKey: key) as? Int
    }
    
    private func save(id: Int) {
        UserDefaults.standard.set(id, forKey: key)
        UserDefaults.standard.synchronize()
    }
}
