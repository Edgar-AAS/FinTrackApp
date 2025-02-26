//
//  UIView+Ext.swift
//  FinTrack
//
//  Created by Edgar Arlindo on 07/02/25.
//

import UIKit

extension UIView {
    func hideKeyboardOnTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        endEditing(true)
    }
    
    func fillConstraints(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, trailing: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    func fillSuperview(padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        fillConstraints(top: superview?.topAnchor,
                        leading: superview?.leadingAnchor,
                        trailing: superview?.trailingAnchor,
                        bottom: superview?.bottomAnchor,
                        padding: padding)
    }
    
    
    func superviewCenter(size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let superviewCenterY = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: superviewCenterY).isActive = true
        }
        
        if let superviewCenterX = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: superviewCenterX).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    func size(size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    func makeStackView(with views: [UIView],
                       aligment: UIStackView.Alignment = .fill,
                       distribution: UIStackView.Distribution = .fill,
                       spacing: CGFloat = 8.0,
                       axis: NSLayoutConstraint.Axis) -> UIStackView {
        
        let stack = UIStackView(arrangedSubviews: views)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = aligment
        stack.distribution = distribution
        stack.spacing = spacing
        stack.axis = axis
        return stack
    }
    
    func makeSeparatorLine(height: CGFloat = 1) -> UIView {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func makeContainer(backgroundColor: UIColor = UIColor.black.withAlphaComponent(0.1),
                       cornerRadius: CGFloat = 12,
                       clipsToBounds: Bool = true) -> UIView {
        
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = backgroundColor
        container.layer.cornerRadius = cornerRadius
        container.clipsToBounds = clipsToBounds
        return container
    }
    
    func makeLabel(text: String = "",
                   font: UIFont = .systemFont(ofSize: 14),
                   textColor: UIColor = .black,
                   textAlignment: NSTextAlignment = .left,
                   numberOfLines: Int = 1) -> UILabel {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = font
        label.textColor = textColor
        label.textAlignment = textAlignment
        label.numberOfLines = numberOfLines
        return label
    }
    
    func makeButton(title: String,
                    systemImageName: String? = nil,
                    foregroundColor: UIColor = .white,
                    backgroundColor: UIColor = .systemBackground,
                    clipToBounds: Bool = true,
                    fontSize: CGFloat = 14,
                    fontWeight: UIFont.Weight = .regular,
                    imagePadding: CGFloat = 8,
                    cornerRadius: CGFloat = 12,
                    contentHorizontalAlignment: UIControl.ContentHorizontalAlignment = .leading,
                    actionTitle: String,
                    target: AnyObject,
                    actionHandler: @escaping () -> Void) -> UIButton {
        
        var configuration = UIButton.Configuration.plain()
        configuration.title = title
    
        var container = AttributeContainer()
        container.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        configuration.attributedTitle = AttributedString(title, attributes: container)
        
        if let systemImageName = systemImageName {
            configuration.image = UIImage(systemName: systemImageName)
        }
        configuration.baseForegroundColor = foregroundColor
        configuration.imagePadding = imagePadding
        configuration.background.backgroundColor = backgroundColor
        configuration.background.cornerRadius = cornerRadius
        
        let button = UIButton(configuration: configuration)
        button.contentHorizontalAlignment = contentHorizontalAlignment
        button.clipsToBounds = clipToBounds
        
        let tapAction = UIAction(title: actionTitle) { _ in
            actionHandler()
        }
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(tapAction, for: .touchUpInside)
        return button
    }
    
    func makeTextField(placeholder: String? = nil,
                       initialText: String? = nil,
                       fontSize: CGFloat,
                       fontWeight: UIFont.Weight = .regular,
                       textAlignment: NSTextAlignment = .left,
                       borderStyle: UITextField.BorderStyle = .none,
                       keyboardType: UIKeyboardType = .default,
                       becomeFirstResponder: Bool = false,
                       backgroundColor: UIColor = .systemBackground,
                       textColor: UIColor = .darkGray,
                       tintColor: UIColor = .darkGray,
                       delegate: UITextFieldDelegate? = nil,
                       target: Any? = nil,
                       action: Selector? = nil,
                       controlEvent: UIControl.Event = .editingChanged) -> UITextField {
        
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        textField.textAlignment = textAlignment
        textField.keyboardType = keyboardType
        textField.borderStyle = borderStyle
        textField.delegate = delegate
        textField.textColor = textColor
        textField.tintColor = tintColor
        
        if becomeFirstResponder {
            textField.becomeFirstResponder()
        }
        
        if let target = target, let action = action {
            textField.addTarget(target, action: action, for: controlEvent)
        }
        
        textField.text = initialText
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
}

