//
//  CurrencyConverterViewModel.swift
//  CurrencyConverter
//
//  Created by Vinicius Gibran on 11/08/2024.
//

import Combine

class CurrencyConverterViewModel {
    var sourceCurrency: Currency?
    var destinationCurrency: Currency?
    var conversionHistory: [Conversion] = []

    private let localStorageAdapter: LocalStorageAdapter
    private var cancellables = Set<AnyCancellable>()

    init(localStorageAdapter: LocalStorageAdapter) {
        self.localStorageAdapter = localStorageAdapter
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
                        self.fetchDefaultCurrencies()
                    }
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    private func fetchDefaultCurrencies() {
        // Default currency fetching logic
    }
}
