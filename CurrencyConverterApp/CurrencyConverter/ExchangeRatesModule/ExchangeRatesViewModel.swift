//
//  ExchangeRatesViewModel.swift
//  ExchangeRatesModule
//
//  Created by Vinicius Gibran on 06/08/2024.
//

import Foundation
import Combine

public class ExchangeRatesViewModel: ObservableObject {
    @Published public var exchangeRates: [ExchangeRate] = []
    @Published public var currencyNames: [String: String] = [:]
    private var cancellables = Set<AnyCancellable>()
    private let repository = ExchangeRatesRepository()

    public init() {}

    public func fetchExchangeRates() {
        repository.fetchExchangeRates()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching exchange rates: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] rates in
                self?.exchangeRates = rates
            })
            .store(in: &cancellables)
        
        repository.fetchCurrencyNames()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching currency names: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] names in
                self?.currencyNames = names
            })
            .store(in: &cancellables)
    }
}
