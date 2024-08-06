//
//  CurrencyConverterViewController.swift
//  CurrencyConverter
//
//  Created by Vinicius Gibran on 05/08/2024.
//

import Combine
import UIKit

public class CurrencyConverterViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel = UILabel()
    private let amountTextField = UITextField()
    private let fromCurrencyButton = UIButton(type: .system)
    private let toCurrencyButton = UIButton(type: .system)
    private let convertButton = UIButton(type: .system)
    private let resultLabel = UILabel()
    private let rateInfoLabel = UILabel()
    
    private var selectedSourceCurrency: String = "EUR"
    private var selectedDestinationCurrency: String = "USD"
    private let viewModel = CurrencyConverterViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        setupKeyboardObservers()
        setupTapGesture()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "Currency Converter"
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
        
        titleLabel.text = "Currency Converter"
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        amountTextField.placeholder = "Enter amount"
        amountTextField.keyboardType = .decimalPad
        amountTextField.borderStyle = .roundedRect
        amountTextField.translatesAutoresizingMaskIntoConstraints = false
        
        fromCurrencyButton.setTitle("EUR", for: .normal)
        fromCurrencyButton.setImage(UIImage(systemName: "eurosign.circle"), for: .normal)
        fromCurrencyButton.addTarget(self, action: #selector(selectFromCurrency), for: .touchUpInside)
        fromCurrencyButton.translatesAutoresizingMaskIntoConstraints = false
        
        toCurrencyButton.setTitle("USD", for: .normal)
        toCurrencyButton.setImage(UIImage(systemName: "dollarsign.circle"), for: .normal)
        toCurrencyButton.addTarget(self, action: #selector(selectToCurrency), for: .touchUpInside)
        toCurrencyButton.translatesAutoresizingMaskIntoConstraints = false
        
        convertButton.setTitle("Convert", for: .normal)
        convertButton.addTarget(self, action: #selector(convertCurrency), for: .touchUpInside)
        convertButton.translatesAutoresizingMaskIntoConstraints = false
        
        resultLabel.textAlignment = .center
        resultLabel.font = .systemFont(ofSize: 18)
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        
        rateInfoLabel.textAlignment = .center
        rateInfoLabel.font = .systemFont(ofSize: 14)
        rateInfoLabel.textColor = .gray
        rateInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(amountTextField)
        contentView.addSubview(fromCurrencyButton)
        contentView.addSubview(toCurrencyButton)
        contentView.addSubview(convertButton)
        contentView.addSubview(resultLabel)
        contentView.addSubview(rateInfoLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            amountTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            amountTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            amountTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            fromCurrencyButton.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 20),
            fromCurrencyButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            fromCurrencyButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            toCurrencyButton.topAnchor.constraint(equalTo: fromCurrencyButton.bottomAnchor, constant: 20),
            toCurrencyButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            toCurrencyButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            convertButton.topAnchor.constraint(equalTo: toCurrencyButton.bottomAnchor, constant: 20),
            convertButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            resultLabel.topAnchor.constraint(equalTo: convertButton.bottomAnchor, constant: 20),
            resultLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            resultLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            rateInfoLabel.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 10),
            rateInfoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            rateInfoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            rateInfoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupBindings() {
        viewModel.$result
            .sink { [weak self] result in
                self?.resultLabel.text = result.map { "\($0)" } ?? ""
            }
            .store(in: &cancellables)
        
        viewModel.$exchangeRateInfo
            .sink { [weak self] info in
                self?.rateInfoLabel.text = info
            }
            .store(in: &cancellables)
    }
    
    @objc private func selectFromCurrency() {
        // Present a view controller to select from currency
    }
    
    @objc private func selectToCurrency() {
        // Present a view controller to select to currency
    }
    
    @objc private func convertCurrency() {
        guard let amountText = amountTextField.text, let amount = Double(amountText) else {
            return
        }
        viewModel.convertCurrency(amount: amount, from: selectedSourceCurrency, to: selectedDestinationCurrency)
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardSize.cgRectValue.height
            scrollView.contentInset.bottom = keyboardHeight
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = 0
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
}
