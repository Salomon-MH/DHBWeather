//
//  MyDataSource.swift
//  DHBWeather
//
//  Created by Daniel Salomon on 13.10.17.
//  Copyright © 2017 Daniel Salomon. All rights reserved.
//

import UIKit

class MyDataSource : NSObject, UITableViewDataSource {
    override init() {
        super.init()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MyTableViewCell.identifier, for: indexPath) as! MyTableViewCell
        
        cell.textLabel?.text = String(describing: indexPath.row)
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.lightGray
        } else {
            cell.backgroundColor = UIColor.gray
        }
        
        return cell
    }
    
    
    
}
