//
//  AddTransactionScreen.swift
//  FintrackApp
//
//  Created by Edgar Arlindo on 14/02/25.
//

import UIKit

protocol AddTransactionScreenDelegate: AnyObject {
    func didAddTransactionTap(_ view: AddTransactionScreen)
    func didAddCategoryTap(_ view: AddTransactionScreen)
}

final class AddTransactionScreen: UIView {
    private var categories: [CategoryViewModel]?
    private var dateAndTime: String?
    
    weak var delegate: AddTransactionScreenDelegate?
    
    private lazy var categoryPickerView: UIPickerView = {
        let pickerview = UIPickerView()
        pickerview.delegate = self
        pickerview.dataSource = self
        pickerview.backgroundColor = .white
        return pickerview
    }()
    
    private var isIncome: Bool = true {
        didSet {
            segmentControl.selectedSegmentIndex = isIncome ? 0 : 1
            amountTextField.textColor = isIncome ? .systemGreen : .systemRed
        }
    }
    
    init(delegate: AddTransactionScreenDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        setupPickerView()
        setupView()
        hideKeyboardOnTap()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPickerView() {
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelButton, flexibleSpace, doneButton], animated: false)
        
        categoryTextField.inputView = categoryPickerView
        categoryTextField.inputAccessoryView = toolbar
    }
    
    @objc private func cancelPressed() {
        categoryTextField.resignFirstResponder()
    }
    
    @objc private func donePressed() {
        if let categories, !categories.isEmpty {
            let index = categoryPickerView.selectedRow(inComponent: 0)
            categoryTextField.text = categories[index].title
        }
        categoryTextField.resignFirstResponder()
    }
    
    private let customScrollView = CustomScrollView()
    
    private let dateContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.2)
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private let timeContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.2)
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private let amountContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.1)
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var segmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Income", "Expenses"])
        control.translatesAutoresizingMaskIntoConstraints = false
        control.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        return control
    }()
    
    private lazy var amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Amount"
        textField.font = UIFont.boldSystemFont(ofSize: 28)
        textField.textAlignment = .center
        textField.keyboardType = .decimalPad
        textField.becomeFirstResponder()
        textField.textColor = .darkGray
        textField.tintColor = .darkGray
        textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        textField.text = String().currencyInputFormatting()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.layer.cornerRadius = 12
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.layer.cornerRadius = 12
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dateContainer, timeContainer])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var amountStackView: UIStackView = {
        let stackView = makeStackView(with: [segmentControl, amountTextField, dateStackView], aligment: .center, axis: .vertical)
        stackView.layer.cornerRadius = 12
        stackView.clipsToBounds = true
        return stackView
    }()
    
    private let transactionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let transactionTitleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Transaction title"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .gray
        textField.borderStyle = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var transactionTitleBottomLine = makeSeparatorLine()
    
    private let transactionDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let transactionDescriptionTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Description"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .gray
        textField.borderStyle = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var transactionDescriptionBottomLine = makeSeparatorLine()
    
    private let categoryDetailsLabel: UILabel = {
        let label = UILabel()
        label.text = "Details"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Category"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let categoryTextField: UITextField = {
        let textField = UITextField()
        textField.text = "Uncategorized ▼"
        textField.textAlignment = .right
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .lightGray
        textField.tintColor = .clear
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .none
        return textField
    }()
    
    private let transactionNoteLabel: UILabel = {
        let label = UILabel()
        label.text = "NOTE"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let transactionNoteTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Transaction note"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .gray
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 12
        textField.clipsToBounds = true
        textField.backgroundColor = .black.withAlphaComponent(0.1)
        return textField
    }()
    
    private let detailsContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.1)
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var addCategoryButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.title = "Add Category"
        configuration.image = UIImage(systemName: "plus.circle.fill")
        configuration.baseForegroundColor = .systemBlue
        configuration.imagePadding = 8
        let button = UIButton(configuration: configuration)
        button.contentHorizontalAlignment = .leading
        
        let tapAction = UIAction(title: "addCategoryTap") { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.didAddCategoryTap(strongSelf)
        }
        button.addAction(tapAction, for: .touchUpInside)
        return button
    }()
    
    private lazy var categorySeparator = makeSeparatorLine()
    private lazy var selectionCategoryStackView = makeStackView(with: [categoryLabel, categoryTextField], aligment: .center, axis: .horizontal)
    private lazy var detailsStackView = makeStackView(with: [selectionCategoryStackView, categorySeparator, addCategoryButton], axis: .vertical)
    
    private lazy var addTransactionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add Transaction", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.clipsToBounds = true
        button.layer.cornerRadius = 30
        
        let tapAction = UIAction(title: "addTransactionTap") { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.didAddTransactionTap(strongSelf)
        }
        button.addAction(tapAction, for: .touchUpInside)
        return button
    }()
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        isIncome = sender.selectedSegmentIndex == 0
    }
    
    func setupUI(with viewModel: AddTransactionScreenViewModel) {
        isIncome = viewModel.isIncome
        dateAndTime = viewModel.dateAndTime
        
        let dateOnly = FormatDate.format(fromFormat: "dd MMM, yyyy HH:mm", toFormat: "dd MMM, YYYY", dateString: viewModel.dateAndTime)
        let timeOnly = FormatDate.format(fromFormat: "dd MMM, yyyy HH:mm", toFormat: "HH:mm", dateString: viewModel.dateAndTime)
        
        dateLabel.text = dateOnly
        timeLabel.text = timeOnly
    }
    
    func updateCategoriesData(categories: [CategoryViewModel]) {
        self.categories = categories
        categoryPickerView.reloadAllComponents()
    }
    
    func getAddTransactionRequest() -> AddTransactionRequest? {
        if let categoryId = categories?[categoryPickerView.selectedRow(inComponent: 0)].id,
           let amount = amountTextField.text?.removeCurrencyInputFormatting(),
           let title = transactionTitleTextField.text,
           let dateAndTime = dateAndTime,
           let dateAndTime = FormatDate.format(fromFormat: "dd MMM, yyyy HH:mm", toFormat: "dd-MM-yyyy HH:mm", dateString: dateAndTime){
            
            return .init(categoryId: categoryId,
                         title: title,
                         amount: amount,
                         description: transactionDescriptionTextField.text,
                         date: dateAndTime,
                         transactionTitle: title,
                         isIncome: isIncome)
        }
        return nil
    }
    
    @objc func textFieldEditingChanged(_ textField: UITextField) {
        if let amountString = textField.text?.currencyInputFormatting() {
            textField.text = amountString
        }
    }
}

extension AddTransactionScreen: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories?[row].title
    }
}

extension AddTransactionScreen: CodeView {
    func buildViewHierarchy() {
        addSubview(customScrollView)
        dateContainer.addSubview(dateLabel)
        timeContainer.addSubview(timeLabel)
        
        amountContainer.addSubview(amountStackView)
        detailsContainer.addSubview(detailsStackView)
        
        customScrollView.addSubview(amountContainer)
        
        customScrollView.addSubview(transactionTitleLabel)
        customScrollView.addSubview(transactionTitleTextField)
        customScrollView.addSubview(transactionTitleBottomLine)
        
        customScrollView.addSubview(transactionDescriptionLabel)
        customScrollView.addSubview(transactionDescriptionTextField)
        customScrollView.addSubview(transactionDescriptionBottomLine)
        
        customScrollView.addSubview(categoryDetailsLabel)
        customScrollView.addSubview(detailsContainer)
        addSubview(addTransactionButton)
    }
    
    func setupConstrains() {
        customScrollView.fillConstraints(
            top: topAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            bottom: nil
        )
        
        amountContainer.fillConstraints(
            top: customScrollView.container.topAnchor,
            leading: customScrollView.container.leadingAnchor,
            trailing: customScrollView.container.trailingAnchor,
            bottom: nil,
            padding: .init(top: 16, left: 16, bottom: 16, right: 16),
            size: .init(width: 0, height: 200)
        )
        
        amountStackView.fillSuperview(padding: .init(top: 8, left: 8, bottom: 8, right: 8))
        dateLabel.fillSuperview(padding: .init(top: 8, left: 8, bottom: 8, right: 8))
        timeLabel.fillSuperview(padding: .init(top: 8, left: 8, bottom: 8, right: 8))
        
        transactionTitleLabel.fillConstraints(
            top: amountContainer.bottomAnchor,
            leading: customScrollView.container.leadingAnchor,
            trailing: customScrollView.container.trailingAnchor,
            bottom: nil,
            padding: .init(top: 16, left: 16, bottom: 0, right: 16)
        )
        
        transactionTitleTextField.fillConstraints(
            top: transactionTitleLabel.bottomAnchor,
            leading: customScrollView.container.leadingAnchor,
            trailing: customScrollView.container.trailingAnchor,
            bottom: nil,
            padding: .init(top: 16, left: 16, bottom: 0, right: 16)
        )
        
        transactionTitleBottomLine.fillConstraints(
            top: transactionTitleTextField.bottomAnchor,
            leading: customScrollView.container.leadingAnchor,
            trailing: customScrollView.container.trailingAnchor,
            bottom: nil,
            padding: .init(top: 8, left: 16, bottom: 0, right: 16)
        )
        
        transactionDescriptionLabel.fillConstraints(
            top: transactionTitleTextField.bottomAnchor,
            leading: customScrollView.container.leadingAnchor,
            trailing: customScrollView.container.trailingAnchor,
            bottom: nil,
            padding: .init(top: 24, left: 16, bottom: 0, right: 16)
        )
        
        transactionDescriptionTextField.fillConstraints(
            top: transactionDescriptionLabel.bottomAnchor,
            leading: customScrollView.container.leadingAnchor,
            trailing: customScrollView.container.trailingAnchor,
            bottom: nil,
            padding: .init(top: 16, left: 16, bottom: 0, right: 16)
        )
        
        transactionDescriptionBottomLine.fillConstraints(
            top: transactionDescriptionTextField.bottomAnchor,
            leading: customScrollView.container.leadingAnchor,
            trailing: customScrollView.container.trailingAnchor,
            bottom: nil,
            padding: .init(top: 8, left: 16, bottom: 0, right: 16)
        )
        
        categoryDetailsLabel.fillConstraints(
            top: transactionDescriptionBottomLine.bottomAnchor,
            leading: customScrollView.container.leadingAnchor,
            trailing: customScrollView.container.trailingAnchor,
            bottom: nil,
            padding: .init(top: 24, left: 16, bottom: 0, right: 16)
        )
        
        detailsContainer.fillConstraints(
            top: categoryDetailsLabel.bottomAnchor,
            leading: customScrollView.container.leadingAnchor,
            trailing: customScrollView.container.trailingAnchor,
            bottom: customScrollView.container.bottomAnchor,
            padding: .init(top: 16, left: 16, bottom: 0, right: 16)
        )
        
        detailsStackView.fillSuperview(padding: .init(top: 8, left: 8, bottom: 8, right: 8))
        selectionCategoryStackView.size(size: .init(width: 0, height: 50))
        addCategoryButton.size(size: .init(width: 0, height: 50))
        
        addTransactionButton.fillConstraints(
            top: customScrollView.bottomAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            bottom: safeAreaLayoutGuide.bottomAnchor,
            padding: .init(top: 0, left: 16, bottom: 0, right: 16),
            size: .init(width: 0, height: 60)
        )
    }
    
    func setupAdditionalConfiguration() {
        backgroundColor = .white
    }
}
