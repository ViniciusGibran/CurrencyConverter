//
//  CurrencyListViewModel.swift
//  CurrencyConverter
//
//  Created by Vinicius Gibran on 11/08/2024.
//

import Foundation
import Combine

class CurrencyListViewModel: ObservableObject {
    
    enum InstanceType {
        case sourceCurrency(ignoreCurrency: Currency?)
        case destinationCurrency(ignoreCurrency: Currency?)
    }
    
    @Published var currencies: [Currency] = []
    private var instanceFrom: InstanceType
    private let adapter: LocalStorageAdapter
    
    var currencySelectedSubject = PassthroughSubject<Currency, Never>()
    
    var viewTitle: String {
        switch instanceFrom {
        case .sourceCurrency:
            return "Select Source Currency"
        case .destinationCurrency:
            return "Select Destination Currency"
        }
    }
    
    init(instance: InstanceType, adapter: LocalStorageAdapter) {
        self.adapter = adapter
        self.instanceFrom = instance
    }
    
    func fetchCurrencies() async {
        do {
            let currencies = try await adapter.loadCurrencies()
            let filteredCurrencies: [Currency]
            
            switch self.instanceFrom {
            case .sourceCurrency(let ignoreCurrency):
                filteredCurrencies = currencies.filter { $0 != ignoreCurrency }
            case .destinationCurrency(let ignoreCurrency):
                filteredCurrencies = currencies.filter { $0 != ignoreCurrency }
            }
            
            DispatchQueue.main.async {
                self.currencies = filteredCurrencies
            }
        } catch {
            print("Error fetching currencies: \(error)")
        }
    }
    
    func didSelectCurrency(_ currency: Currency) {
        currencySelectedSubject.send(currency)
    }
}
