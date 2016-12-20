//
//  DataGenerator.swift
//  Demo
//
//  Created by Suguru Kishimoto on 12/20/16.
//
//

import Foundation

fileprivate extension Array {
    func random() -> Element {
        return self[Int(arc4random_uniform(UInt32(self.count)))]
    }
}

final class DataGenerator {
    private static let titles: [String] = [
        "今日のカフェラテ",
        "今日の焼肉",
        "今日の朝ごはん",
        "今日のランチ"
    ]

    static var title: String {
        return titles.random()
    }
    
    static var body: String {
        return "今日はとても楽しい1日だった\n早く寝てまた明日からお仕事頑張ろう"
    }

    static func generateBlog() -> Blog {
        return Blog(title: title, body: body, author: "sgr-ksmt")
    }
}
