//
//  CurrencyConverterTableViewController.swift
//  CurrencyConverter
//
//  Created by Vinicius Gibran on 09/08/2024.
//

import UIKit
import Combine

class CurrencyConverterTableViewController: UITableViewController {
    
    private let viewModel: CurrencyConverterViewModel
    private var headerView: CurrencyConverterHeaderView?
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: CurrencyConverterViewModel) {
        self.viewModel = viewModel
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupTableHeaderView()
        
        // Setting the header view
        let headerView = CurrencyConverterHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 200))
        tableView.tableHeaderView = headerView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchConversionHistory()
    }
    
    private func fetchConversionHistory() {
        viewModel.fetchConversionHistory()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching conversion history: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] _ in
                self?.updateHeaderView() // here todo:
                self?.tableView.reloadData()
            })
            .store(in: &cancellables)
    }
    
    private func setupTableView() {
        tableView.register(ConversionHistoryCell.self, forCellReuseIdentifier: "ConversionHistoryCell")
    }
    
    private func setupTableHeaderView() {
        headerView = CurrencyConverterHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 200))
        guard let headerView = headerView else { return }
        
        headerView.sourceCurrencyButton.publisher
            .sink { [weak self] in
                // handle sourceCurrencyButton action
                self?.tableView.reloadData() // just to avoid warnings
            }
            .store(in: &cancellables)
        
        headerView.destinationCurrencyButton.publisher
            .sink { [weak self] in
                // handle destinationCurrencyButton
                self?.tableView.reloadData() // just to avoid warnings
            }
            .store(in: &cancellables)
        
        headerView.convertButton.publisher
            .sink { [weak self] in
                // handle convertButton action
                self?.tableView.reloadData() // just to avoid warnings
            }
            .store(in: &cancellables)
        
        tableView.tableHeaderView = headerView
    }
    
    // here todo: improve this to send the objects to the view instead
    private func updateHeaderView() {
        guard let headerView = headerView else { return }
        headerView.sourceCurrencyButton.setTitle("\(viewModel.sourceCurrency?.flag ?? "") \(viewModel.sourceCurrency?.currencyCode ?? "")", for: .normal)
        headerView.destinationCurrencyButton.setTitle("\(viewModel.destinationCurrency?.flag ?? "") \(viewModel.destinationCurrency?.currencyCode ?? "")", for: .normal)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.conversionHistory.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversionHistoryCell", for: indexPath) as! ConversionHistoryCell
        
        let conversion = viewModel.conversionHistory[indexPath.row]
        cell.sourceCurrencyLabel.text = "\(conversion.sourceCurrency.flag) \(conversion.sourceCurrency.currencyCode)"
        cell.destinationCurrencyLabel.text = "\(conversion.destinationCurrency.flag) \(conversion.destinationCurrency.currencyCode)"
        cell.convertedAmountLabel.text = "\(conversion.amount)"
        
        return cell
    }
}
