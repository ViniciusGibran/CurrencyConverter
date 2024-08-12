//
//  CurrencyConverterHeaderView.swift
//  CurrencyConverter
//
//  Created by Vinicius Gibran on 09/08/2024.
//

import UIKit

import UIKit

class CurrencyConverterHeaderView: UIView {

    let amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Amount"
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    let sourceCurrencyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("🇪🇺 EUR", for: .normal) // Default to EUR
        button.titleLabel?.font = .systemFont(ofSize: 40, weight: .semibold)
        return button
    }()
    
    let destinationCurrencyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("🇺🇸 USD", for: .normal) // Default to USD
        button.titleLabel?.font = .systemFont(ofSize: 40, weight: .semibold)
        return button
    }()
    
    let convertButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Convert", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    let toLabel: UILabel = {
        let label = UILabel()
        label.text = "→"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 30, weight: .bold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(amountTextField)
        addSubview(convertButton)
        
        let currencyStackView = UIStackView(arrangedSubviews: [sourceCurrencyButton, toLabel, destinationCurrencyButton])
        currencyStackView.axis = .horizontal
        currencyStackView.distribution = .equalSpacing
        addSubview(currencyStackView)
        
        amountTextField.translatesAutoresizingMaskIntoConstraints = false
        currencyStackView.translatesAutoresizingMaskIntoConstraints = false
        convertButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            amountTextField.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            amountTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            amountTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            amountTextField.heightAnchor.constraint(equalToConstant: 40),
            
            currencyStackView.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 16),
            currencyStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            currencyStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            convertButton.topAnchor.constraint(equalTo: currencyStackView.bottomAnchor, constant: 16),
            convertButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            convertButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            convertButton.heightAnchor.constraint(equalToConstant: 44),
            convertButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
}
