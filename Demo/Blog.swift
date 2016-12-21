//
//  Blog.swift
//  Demo
//
//  Created by Suguru Kishimoto on 12/20/16.
//
//

import Foundation
import Realm
import RealmSwift

final class Blog: Object {
    dynamic var id = 0
    dynamic var title = ""
    dynamic var body = ""
    dynamic var author = ""
    dynamic var createdAt = Date()
    dynamic var updatedAt = Date()
    
    convenience init(title: String, body: String, author: String) {
        self.init()
        self.id = AutoIncrementableID.incremented(for: type(of: self))
        self.title = title
        self.body = body
        self.author = author
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
