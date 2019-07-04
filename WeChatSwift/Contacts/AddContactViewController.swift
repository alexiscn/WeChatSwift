//
//  AddContactViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/4.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

class AddContactViewController: UIViewController {
    
    private var tableView: UITableView!
    
    private var dataSource: [AddContactSource] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = Colors.backgroundColor
        navigationItem.title = "添加朋友"
        
        setupTableView()
        setupDataSource()
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AddContactViewCell.self, forCellReuseIdentifier: NSStringFromClass(AddContactViewCell.self))
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 56, bottom: 0, right: 0)
        view.addSubview(tableView)
    }
    
    private func setupDataSource() {
        dataSource = [.radar, .faceToFaceGroup, .scan, .phoneContacts, .officialAccounts, .enterpriseContacts]
    }
    
}

extension AddContactViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(AddContactViewCell.self), for: indexPath) as! AddContactViewCell
        //cell.selectionStyle = .none
        let source = dataSource[indexPath.row]
        cell.update(source)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
