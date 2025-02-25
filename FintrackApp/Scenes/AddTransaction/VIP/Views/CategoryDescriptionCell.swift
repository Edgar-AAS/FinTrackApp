//
//  CategoryDescriptionCell.swift
//  FinTrack
//
//  Created by Edgar Arlindo on 11/02/25.
//

import UIKit

final class CategoryDescriptionCell: UITableViewCell {
    static let reuseIdentifier = String(describing: CategoryDescriptionCell.self)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Description"
        textField.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        textField.textColor = .black
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .none
        return textField
    }()
}

extension CategoryDescriptionCell: CodeView {
    func buildViewHierarchy() {
        contentView.addSubview(textField)
    }
    
    func setupConstrains() {
        textField.fillSuperview(padding: .init(top: 16, left: 16, bottom: 16, right: 16))
    }
    
    func setupAdditionalConfiguration() {
        backgroundColor = .black.withAlphaComponent(0.1)
    }
}
