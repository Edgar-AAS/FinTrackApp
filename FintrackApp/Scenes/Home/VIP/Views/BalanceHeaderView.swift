//
//  BalanceHeaderView.swift
//  FinTrack
//
//  Created by Edgar Arlindo on 07/02/25.
//

import UIKit

protocol BalanceHeaderViewDelegate: AnyObject {
    func didTapAddTransaction(_ view: BalanceHeaderView, type: TransactionType)
}

final class BalanceHeaderView: UIView {
    weak var delegate: BalanceHeaderViewDelegate?
    
    private let greetingLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, Edgar!"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .black
        return label
    }()

    private let balanceContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 6
        return view
    }()

    private let balanceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Balance"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        return label
    }()

    private let balanceLabel: UILabel = {
        let label = UILabel()
        label.text = "2350,45".currencyInputFormatting()
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = UIColor.systemBlue
        return label
    }()
        
    private lazy var incomeView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.89, green: 1.0, blue: 0.89, alpha: 1.0)
        view.layer.cornerRadius = 12
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(incomeViewTap))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    private lazy var expenseView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 1.0, green: 0.89, blue: 0.89, alpha: 1.0)
        view.layer.cornerRadius = 12
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(expenseViewTap))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
        
    private let incomeIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "plus.circle")
        imageView.tintColor = UIColor(red: 0.0, green: 0.6, blue: 0.0, alpha: 1.0)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let expenseIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "minus.circle")
        imageView.tintColor = UIColor.red
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var incomeLabelStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [incomeLabel, incomeSubtitle])
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    private lazy var expenseLabelStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [expenseLabel, expenseSubtitle])
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    private let incomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Add income"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let incomeSubtitle: UILabel = {
        let label = UILabel()
        label.text = "Create an income manually"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private let expenseLabel: UILabel = {
        let label = UILabel()
        label.text = "Add expense"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let expenseSubtitle: UILabel = {
        let label = UILabel()
        label.text = "Create an expense manually"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [incomeView, expenseView])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func expenseViewTap() {
        delegate?.didTapAddTransaction(self, type: .expanses)
    }
    
    @objc private func incomeViewTap() {
        delegate?.didTapAddTransaction(self, type: .income)
    }
}


extension BalanceHeaderView: CodeView {
    func buildViewHierarchy() {
        addSubview(greetingLabel)
        addSubview(balanceContainer)
        
        balanceContainer.addSubview(balanceTitleLabel)
        balanceContainer.addSubview(balanceLabel)
        
        addSubview(mainStackView)
        incomeView.addSubview(incomeIcon)
        incomeView.addSubview(incomeLabelStack)
        expenseView.addSubview(expenseIcon)
        expenseView.addSubview(expenseLabelStack)
    }

    func setupConstrains() {
        greetingLabel.fillConstraints(
            top: topAnchor,
            leading: leadingAnchor,
            trailing: nil,
            bottom: nil,
            padding: .init(top: 16, left: 16, bottom: 0, right: 0)
        )

        balanceContainer.fillConstraints(
            top: greetingLabel.bottomAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            bottom: nil,
            padding: .init(top: 16, left: 16, bottom: 0, right: 16),
            size: CGSize(width: 0, height: 120)
        )
        
        balanceTitleLabel.fillConstraints(
            top: balanceContainer.topAnchor,
            leading: balanceContainer.leadingAnchor,
            trailing: balanceContainer.trailingAnchor,
            bottom: nil,
            padding: .init(top: 16, left: 16, bottom: 0, right: 16)
        )
        
        balanceLabel.fillConstraints(
            top: balanceTitleLabel.bottomAnchor,
            leading: balanceContainer.leadingAnchor,
            trailing: balanceContainer.trailingAnchor,
            bottom: balanceContainer.bottomAnchor,
            padding: .init(top: 16, left: 16, bottom: 0, right: 16)
        )
        
        mainStackView.fillConstraints(
            top: balanceContainer.bottomAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            bottom: bottomAnchor,
            padding: .init(top: 24, left: 16, bottom: 0, right: 16),
            size: .init(width: 0, height: 100)
        )
        
        incomeIcon.fillConstraints(
            top: incomeView.topAnchor,
            leading: incomeView.leadingAnchor,
            trailing: nil,
            bottom: nil,
            padding: .init(top: 16, left: 16, bottom: 0, right: 0),
            size: CGSize(width: 24, height: 24)
        )
        
        incomeLabelStack.fillConstraints(
            top: incomeView.topAnchor,
            leading: incomeIcon.trailingAnchor,
            trailing: incomeView.trailingAnchor,
            bottom: incomeView.bottomAnchor,
            padding: .init(top: 16, left: 8, bottom: 16, right: 16)
        )
        
        expenseIcon.fillConstraints(
            top: expenseView.topAnchor,
            leading: expenseView.leadingAnchor,
            trailing: nil,
            bottom: nil,
            padding: .init(top: 16, left: 16, bottom: 0, right: 0),
            size: CGSize(width: 24, height: 24)
        )
        
        expenseLabelStack.fillConstraints(
            top: expenseView.topAnchor,
            leading: expenseIcon.trailingAnchor,
            trailing: expenseView.trailingAnchor,
            bottom: expenseView.bottomAnchor,
            padding: .init(top: 16, left: 8, bottom: 16, right: 16)
        )
    }

    func setupAdditionalConfiguration() {
        backgroundColor = Colors.lightBackground
    }
}
