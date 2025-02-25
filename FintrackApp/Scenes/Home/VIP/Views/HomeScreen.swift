//
//  HomeScreen.swift
//  FintrackApp
//
//  Created by Edgar Arlindo on 21/02/25.
//

import UIKit

final class HomeScreen: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var balanceHeader: BalanceHeaderView = {
        let header = BalanceHeaderView()
        header.translatesAutoresizingMaskIntoConstraints = false
        header.backgroundColor = Colors.lightBackground
        return header
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = Colors.lightBackground
        tableView.register(TransactionCell.self, forCellReuseIdentifier: TransactionCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func setupTableViewProtocols(delegate: UITableViewDelegate, dataSource: UITableViewDataSource, headerDelegate: BalanceHeaderViewDelegate) {
        tableView.delegate = delegate
        tableView.dataSource = dataSource
        balanceHeader.delegate = headerDelegate
    }
}

extension HomeScreen: CodeView {
    func buildViewHierarchy() {
        addSubview(balanceHeader)
        addSubview(tableView)
    }
    
    func setupConstrains() {
        balanceHeader.fillConstraints(
            top: safeAreaLayoutGuide.topAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            bottom: nil,
            padding: .init(top: 0, left: 0, bottom: 16, right: 0),
            size: .init(width: 0, height: 300)
        )
        
        tableView.fillConstraints(
            top: balanceHeader.bottomAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            bottom: bottomAnchor
        )
    }
}

