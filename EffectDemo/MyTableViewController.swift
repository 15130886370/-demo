//
//  MyTableViewController.swift
//  EffectDemo
//
//  Created by ittmomWang on 16/6/13.
//  Copyright © 2016年 ittmomWang. All rights reserved.
//

import UIKit

class MyTableViewController: UITableViewController {

    let identifier: String = "identifierCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        navigationController?.navigationBar.isTranslucent = false
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.textLabel?.text = "\(self.title!)-\(indexPath.row)"
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
}
