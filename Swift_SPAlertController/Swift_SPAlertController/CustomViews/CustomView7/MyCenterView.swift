//
//  MyCenterView.swift
//  Swift_SPAlertController
//
//  Created by lidongxi on 2020/1/13.
//  Copyright © 2020 lidongxi. All rights reserved.
//

import UIKit

class MyCenterView: UIView, UITableViewDataSource {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(tableView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        tableView.frame = self.bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "myCell")
        if cell == nil {
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: "myCell")
        }
        cell!.textLabel!.text = "第\(indexPath.row)行"
        cell!.textLabel!.font = UIFont.systemFont(ofSize: 14)
        cell!.detailTextLabel!.text = "这是自定义tableView"
        cell!.detailTextLabel!.font = UIFont.systemFont(ofSize: 12)
        return cell!
    }
    
    lazy var tableView: UITableView = {
        let tableV = UITableView.init(frame: .zero, style: .plain)
        tableV.dataSource = self
        tableV.showsVerticalScrollIndicator = false
        return tableV
    }()
}
