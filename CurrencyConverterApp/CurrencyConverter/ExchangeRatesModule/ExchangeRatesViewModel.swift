//
//  ExchangeRatesViewModel.swift
//  ExchangeRatesModule
//
//  Created by Vinicius Gibran on 06/08/2024.
//

import Combine
import Foundation

import Combine
import Foundation

public enum ViewState: Equatable {
    case idle
    case loading
    case loadedAll
    case loaded
    case error(String)
}

public class ExchangeRatesViewModel: ObservableObject {
    @Published public var exchangeRates: [ExchangeRate] = []
    @Published public var currencyNames: [String: String] = [:]
    @Published public var state: ViewState = .idle
    private var cancellables = Set<AnyCancellable>()
    private let repository = ExchangeRatesRepository()
    private var currentPage = 0
    private let pageSize = 10
    private var allItemsLoaded = false

    public init() {}

    public func fetchCurrencyNames() {
        repository.fetchCurrencyNames()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching currency names: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] names in
                print("names.count: \(names.count)")
                self?.currencyNames = names
            })
            .store(in: &cancellables)
    }

    public func fetchExchangeRates() {
        guard state != .loading && !allItemsLoaded else { return }
        state = .loading
        repository.fetchExchangeRates(page: currentPage, pageSize: pageSize)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching exchange rates: \(error)")
                    self.state = .error(error.localizedDescription)
                case .finished:
                    if self.allItemsLoaded {
                        self.state = .loadedAll
                    } else {
                        self.state = .loaded
                    }
                }
            }, receiveValue: { [weak self] rates in
                guard let self = self else { return }
                print("rates.count: \(rates.count)")
                if rates.isEmpty {
                    self.allItemsLoaded = true
                } else {
                    self.exchangeRates.append(contentsOf: rates)
                    self.currentPage += 1
                }
            })
            .store(in: &cancellables)
    }
}
