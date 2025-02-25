//  AddTransactionHeader.swift
//  FinTrack
//
//  Created by Edgar Arlindo on 10/02/25.
//

import UIKit

final class CategorySelectionCell: UITableViewCell {//  AddTransactionHeader.swift
    static let reuseIdentifier = String(describing: CategorySelectionCell.self)
    private let categories = ["Food", "Transport", "Entertainment", "Bills", "Other"]
    private let pickerView = UIPickerView()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Category"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.text = "Uncategorized ▼"
        textField.textAlignment = .right
        textField.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        textField.textColor = .black
        textField.tintColor = .clear
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .none
        return textField
    }()
    
    private lazy var selectionCategoryStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [categoryLabel, textField])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupPickerView()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "OK", style: .done, target: self, action: #selector(donePressed))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        
        textField.inputView = pickerView
        textField.inputAccessoryView = toolbar
    }
    
    @objc private func donePressed() {
        textField.resignFirstResponder()
    }
}

extension CategorySelectionCell: CodeView {
    func buildViewHierarchy() {
        contentView.addSubview(selectionCategoryStackView)
    }
    
    func setupConstrains() {
        selectionCategoryStackView.fillSuperview(padding: .init(top: 16, left: 16, bottom: 16, right: 16))
    }
    
    func setupAdditionalConfiguration() {
        backgroundColor = .black.withAlphaComponent(0.1)
    }
}

extension CategorySelectionCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCategory = categories[row]
        textField.text = "\(selectedCategory) ▼"
    }
}
