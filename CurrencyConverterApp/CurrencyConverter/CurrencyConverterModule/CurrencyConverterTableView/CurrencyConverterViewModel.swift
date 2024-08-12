//
//  CurrencyConverterViewModel.swift
//  CurrencyConverter
//
//  Created by Vinicius Gibran on 11/08/2024.
//

import Combine
import UIKit

class CurrencyConverterViewModel {
    var sourceCurrency: Currency?
    var destinationCurrency: Currency?
    var conversionAmount: Double
    private(set) var conversionHistory: [Conversion]

    private let localStorageAdapter: LocalStorageAdapter
    private let coordinator: CurrencyConverterCoordinator
    
    private var cancellables = Set<AnyCancellable>()
    var reloadDataSubject = PassthroughSubject<Void, Never>()

    init(localStorageAdapter: LocalStorageAdapter, coordinator: CurrencyConverterCoordinator) {
        self.localStorageAdapter = localStorageAdapter
        self.coordinator = coordinator
        self.conversionAmount = 0.0
        self.conversionHistory = []
    }

    @MainActor
    func fetchConversionHistory() -> AnyPublisher<Void, Error> {
        Future { [weak self] promise in
            Task {
                do {
                    guard let self else { return }
                    let history = try await self.localStorageAdapter.loadConversionHistory()
                    self.conversionHistory = history
                    if let latestConversion = history.first {
                        self.sourceCurrency = latestConversion.sourceCurrency
                        self.destinationCurrency = latestConversion.destinationCurrency
                    } else {
                        try await self.fetchDefaultCurrencies()
                    }
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    private func fetchDefaultCurrencies() async throws {
        let defaultCurrencyCodes = ["EUR", "USD"]
        let currencies = try await localStorageAdapter.loadCurrencies(for: defaultCurrencyCodes)
        
        if let euro = currencies.first(where: { $0.currencyCode == "EUR" }),
           let usd = currencies.first(where: { $0.currencyCode == "USD" }) {
            self.sourceCurrency = euro
            self.destinationCurrency = usd
        } else {
            self.sourceCurrency = Currency(id: UUID(), currencyName: "Euro", currencyCode: "EUR", countryCode: "EU", priority: 1, flag: "🇪🇺")
            self.destinationCurrency = Currency(id: UUID(), currencyName: "US Dollar", currencyCode: "USD", countryCode: "US", priority: 2, flag: "🇺🇸")
        }
    }
    
    func didSelectCurrencyOptionFor(instanceFrom: CurrencyListViewModel.InstanceType) {
        switch instanceFrom {
        case .sourceCurrency:
            coordinator.presentCurrencySelection(sourceOrDestination: .sourceCurrency(ignoreCurrency: self.destinationCurrency), delegate: self)
        case .destinationCurrency:
            coordinator.presentCurrencySelection(sourceOrDestination: .destinationCurrency(ignoreCurrency: self.sourceCurrency), delegate: self)
        }
    }
    
    func didSelectConversion() {
        guard let sourceCurrency = sourceCurrency,
              let destinationCurrency = destinationCurrency
        else { return }
        coordinator.presentConversionView(sourceCurrency: sourceCurrency, destinationCurrency: destinationCurrency, conversionAmount: conversionAmount)
    }
}

extension CurrencyConverterViewModel: CurrencySelectionDelegate {
    func didSelectCurrency(_ currency: Currency, for instance: CurrencyListViewModel.InstanceType) {
        switch instance {
        case .sourceCurrency:
            self.sourceCurrency = currency
        case .destinationCurrency:
            self.destinationCurrency = currency
        }
        
        reloadDataSubject.send()
    }
}
