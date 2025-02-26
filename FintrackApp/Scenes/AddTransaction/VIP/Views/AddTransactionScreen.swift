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
            amountTextField.textColor = isIncome ? UIColor(hexString: "4CAF50") : UIColor(hexString: "CD5C5C")
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
            let categoryTitle = categories[index].title
            setCategoryTitle(with: categoryTitle)
        }
        categoryTextField.resignFirstResponder()
    }
    
    
    private let customScrollView = CustomScrollView()
    
    private lazy var dateContainer = makeContainer()
    private lazy var timeContainer = makeContainer()
    private lazy var amountContainer = makeContainer()
    private lazy var detailsContainer = makeContainer()
    
    private lazy var dateLabel = makeLabel(font: UIFont.systemFont(ofSize: 16), textColor: .black, textAlignment: .center)
    private lazy var timeLabel = makeLabel(font: UIFont.systemFont(ofSize: 16), textColor: .black, textAlignment: .center)
    private lazy var transactionTitleLabel = makeLabel(text: "Title", font: UIFont.systemFont(ofSize: 16, weight: .semibold), textColor: .lightGray)
    private lazy var transactionDescriptionLabel = makeLabel(text: "Description", font: UIFont.systemFont(ofSize: 16, weight: .semibold), textColor: .lightGray)
    private lazy var categoryDetailsLabel = makeLabel(text: "Details", font: UIFont.systemFont(ofSize: 16, weight: .semibold), textColor: .lightGray)
    private lazy var categoryLabel = makeLabel(text: "Category", font: UIFont.systemFont(ofSize: 16, weight: .semibold), textColor: .black)
    
    private lazy var transactionTitleBottomLine = makeSeparatorLine()
    private lazy var transactionDescriptionBottomLine = makeSeparatorLine()
    private lazy var categorySeparator = makeSeparatorLine()
    
    private lazy var dateAndTimeStackView = makeStackView(with: [dateContainer, timeContainer], distribution: .fillEqually, spacing: 8, axis: .horizontal)
    private lazy var amountStackView = makeStackView(with: [segmentControl, amountTextField, dateAndTimeStackView], aligment: .center, axis: .vertical)
    private lazy var selectionCategoryStackView = makeStackView(with: [categoryLabel, categoryTextField], aligment: .center, axis: .horizontal)
    private lazy var detailsStackView = makeStackView(with: [selectionCategoryStackView, categorySeparator, addCategoryButton], axis: .vertical)
    
    private lazy var segmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Income", "Expenses"])
        control.translatesAutoresizingMaskIntoConstraints = false
        control.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        return control
    }()
    
    private lazy var amountTextField = makeTextField(
        placeholder: "Amount",
        initialText: String().currencyInputFormatting(),
        fontSize: 28,
        fontWeight: .bold,
        textAlignment: .center,
        borderStyle: .none,
        keyboardType: .decimalPad,
        becomeFirstResponder: true,
        textColor: .darkGray,
        tintColor: .darkGray,
        target: self,
        action: #selector(textFieldEditingChanged(_:)),
        controlEvent: .editingChanged
    )
    
    private lazy var transactionTitleTextField = makeTextField(
        placeholder: "Title",
        fontSize: 16,
        borderStyle: .none,
        textColor: .lightGray
    )
    
    private lazy var transactionDescriptionTextField = makeTextField(
        placeholder: "Description",
        fontSize: 16,
        borderStyle: .none,
        textColor: .lightGray
    )
    
    private lazy var categoryTextField = makeTextField(
        initialText: "Uncategorized ▼",
        fontSize: 16,
        textAlignment: .right,
        borderStyle: .none,
        textColor: .lightGray,
        tintColor: .clear
    )
    
    private lazy var addCategoryButton = makeButton(
        title: "Add Category",
        systemImageName: "plus.circle.fill",
        foregroundColor: .systemBlue,
        backgroundColor: .clear,
        fontSize: 16,
        fontWeight: .semibold,
        actionTitle: "addCategoryTap",
        target: self) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.didAddCategoryTap(strongSelf)
        }
    
    private lazy var addTransactionButton = makeButton(
        title: "Add Transaction",
        foregroundColor: .white,
        backgroundColor: .systemBlue,
        fontSize: 16,
        fontWeight: .bold,
        cornerRadius: 30,
        contentHorizontalAlignment: .center,
        actionTitle: "addTransactionTap",
        target: self) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.didAddTransactionTap(strongSelf)
        }
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        isIncome = sender.selectedSegmentIndex == 0
    }
    
    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        if let amountString = textField.text?.currencyInputFormatting() {
            textField.text = amountString
        }
    }
    
    func setCategoryTitle(with title: String) {
        categoryTextField.text = title + " ▼"
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
    
    func getAddTransactionRequest() -> AddTransactionRequest {
        return AddTransactionRequest(
            categoryId: categories?[categoryPickerView.selectedRow(inComponent: 0)].id,
            title: transactionTitleTextField.text,
            amount: amountTextField.text,
            description: transactionDescriptionTextField.text,
            date: FormatDate.format(fromFormat: "dd MMM, yyyy HH:mm", toFormat: "dd-MM-yyyy HH:mm", dateString: dateAndTime ?? ""),
            isIncome: isIncome
        )
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
        backgroundColor = Colors.lightBackground
        amountStackView.layer.cornerRadius = 12
        amountStackView.clipsToBounds = true
    }
}
