//
//  NewMomentViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/29.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

class NewMomentViewController: UIViewController {

    private var tableView: UITableView!
    
    private var dataSource: [NewMomentModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NewMomentActionTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(NewMomentActionTableViewCell.self))
        view.addSubview(tableView)
    }
}

extension NewMomentViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}

enum NewMomentModel {
    case text
    case images
    case location
    case mention
    case shareTo
}

class NewMomentActionTableViewCell: UITableViewCell {
    
}
