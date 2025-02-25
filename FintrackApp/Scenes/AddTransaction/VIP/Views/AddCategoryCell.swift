//
//  AddCategoryCell.swift
//  FinTrack
//
//  Created by Edgar Arlindo on 11/02/25.
//

import UIKit

final class AddCategoryCell: UITableViewCell {
    static let reuseIdentifier = String(describing: AddCategoryCell.self)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let addCategoryButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.title = "Add Category"
        configuration.image = UIImage(systemName: "plus.circle.fill")
        configuration.baseForegroundColor = .systemBlue
        configuration.imagePadding = 8
        let button = UIButton(configuration: configuration)
        button.contentHorizontalAlignment = .leading
        return button
    }()
}

extension AddCategoryCell: CodeView {
    func buildViewHierarchy() {
        contentView.addSubview(addCategoryButton)
    }
    
    func setupConstrains() {
        addCategoryButton.fillSuperview(padding: .init(top: 16, left: 16, bottom: 16, right: 16))
    }
    
    func setupAdditionalConfiguration() {
        backgroundColor = .black.withAlphaComponent(0.1)
    }
}
