//
//  HeaderSectionView.swift
//  FintrackApp
//
//  Created by Edgar Arlindo on 23/02/25.
//


import UIKit

final class HeaderSectionView: UITableViewHeaderFooterView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Recent Transactions"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
}

extension HeaderSectionView: CodeView {
    func buildViewHierarchy() {
        contentView.addSubview(titleLabel)
    }
    
    func setupConstrains() {
        titleLabel.fillConstraints(
            top: contentView.topAnchor,
            leading: contentView.leadingAnchor,
            trailing: contentView.trailingAnchor,
            bottom: contentView.bottomAnchor,
            padding: .init(top: 8, left: 16, bottom: 8, right: 16)
        )
    }
    
    func setupAdditionalConfiguration() {
        contentView.backgroundColor = .clear
    }
}
