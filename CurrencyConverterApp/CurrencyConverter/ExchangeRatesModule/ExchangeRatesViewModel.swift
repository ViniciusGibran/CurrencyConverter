//
//  ExchangeRatesViewModel.swift
//  ExchangeRatesModule
//
//  Created by Vinicius Gibran on 06/08/2024.
//

import Combine
import CoreData
import Foundation

public enum ViewState: Equatable {
    case idle
    case loading
    case loadedAll
    case loaded
    case error(String)
}

class ExchangeRatesViewModel: ObservableObject {
    @Published public var exchangeRates: [ExchangeRate] = []
    @Published var searchText = ""
    @Published public var state: ViewState = .idle
    private var cancellables = Set<AnyCancellable>()
    private let repository = FrankfurterRepository()
    private let localStorageAdapter: LocalStorageAdapter
    
    var filteredRates: [ExchangeRate] {
        guard !searchText.isEmpty else { return exchangeRates }
        return exchangeRates.filter {
            $0.currency.uppercased().contains(searchText.uppercased()) ||
            $0.currencyDetails?.currencyName?.uppercased().contains(searchText.uppercased()) ?? false
        }
    }
    
    init(context: NSManagedObjectContext) {
        self.localStorageAdapter = LocalStorageAdapter(context: context)
    }
    
    @MainActor
    public func fetchExchangeRates() async {
        guard state != .loading else { return }
        state = .loading
        
        do {
            
            // Add a delay of 1.0 seconds to allow showing the loader
            try await Task.sleep(nanoseconds: 1_000_000_000)
            
            let rates = try await repository.fetchExchangeRates()
            let currencyCodes = rates.map { $0.currency }
            let currencies = try await localStorageAdapter.loadCurrencies(for: currencyCodes)
            
            let detailedRates = rates.map { rate -> ExchangeRate in
                var detailedRate = rate
                detailedRate.currencyDetails = currencies.first { $0.currencyCode == rate.currency }
                return detailedRate
            }
            
            // self.exchangeRates.append(contentsOf: detailedRates) // in case of pagination
            self.exchangeRates = detailedRates
            self.exchangeRates.sort { ($0.currencyDetails?.priority ?? 0) < ($1.currencyDetails?.priority ?? 0) }
            self.state = .loaded
        } catch {
            self.state = .error(error.localizedDescription)
        }
    }
}
