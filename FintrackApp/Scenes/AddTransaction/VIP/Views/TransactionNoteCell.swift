//
//  TransactionNoteCell.swift
//  FinTrack
//
//  Created by Edgar Arlindo on 11/02/25.
//

import UIKit

final class TransactionNoteCell: UITableViewCell {
    static let reuseIdentifier = String(describing: TransactionNoteCell.self)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var transactionNoteTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textAlignment = .left
        textView.textColor = .lightGray
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
}

extension TransactionNoteCell: CodeView {
    func buildViewHierarchy() {
        contentView.addSubview(transactionNoteTextView)
    }
    
    func setupConstrains() {
        transactionNoteTextView.fillSuperview(padding: .init(top: 16, left: 16, bottom: 16, right: 16))
    }
    
    func setupAdditionalConfiguration() {
        backgroundColor = .black.withAlphaComponent(0.1)
    }
}
