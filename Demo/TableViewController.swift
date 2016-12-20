//
//  TableViewController.swift
//  Demo
//
//  Created by Suguru Kishimoto on 12/20/16.
//
//

import UIKit
import Realm
import RealmSwift

class TableViewController: UITableViewController {
    
    private lazy var realm = try! Realm()
    
    private lazy var formatter: DateFormatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/d"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = makeInsertButton()
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realm.objects(Blog.self).count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let blog = realm.objects(Blog.self).sorted(byProperty: "createdAt", ascending: false)[indexPath.row]
        cell.textLabel?.text = "(\(blog.id))\(blog.title): \(formatter.string(from: blog.updatedAt))\n👤\(blog.author)\n\(blog.body)"
        cell.textLabel?.numberOfLines = 0
    
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try! realm.write {
                let blog = realm.objects(Blog.self).sorted(byProperty: "createdAt", ascending: false)[indexPath.row]
                realm.delete(blog)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    private func makeInsertButton() -> UIBarButtonItem {
        let button = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(insertBlog(_:)))
        return button
    }
    
    @objc func insertBlog(_: UIBarButtonItem) {
        try! realm.write {
            let blog = DataGenerator.generateBlog()
            realm.add(blog)
        }
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
}
