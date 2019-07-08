//
//  MomentsViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/4.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

class MomentsViewController: UIViewController {

    private var tableView: UITableView!
    private var dataSource: [Moment] = []
    private var statusBarStyle: UIStatusBarStyle = .lightContent
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Colors.white
        setupTableView()
        setupDataSource()
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MomentTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(MomentTableViewCell.self))
        view.addSubview(tableView)
    }
    
    private func setupDataSource() {
        let users = MockFactory.shared.users
        var moments: [Moment] = []
        for user in users {
            let moment = Moment()
            moment.userID = user.identifier
            moments.append(moment)
        }
        dataSource = moments
        tableView.reloadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
}

extension MomentsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(MomentTableViewCell.self), for: indexPath) as! MomentTableViewCell
        cell.selectionStyle = .none
        
        let moment = dataSource[indexPath.row]
        cell.update(moment: moment)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}
