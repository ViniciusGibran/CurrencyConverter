//
//  CurrencyConverterViewModel.swift
//  CurrencyConverterModule
//
//  Created by Vinicius Gibran on 06/08/2024.
//

import Combine
import Foundation

public class CurrencyConverterViewModel: ObservableObject {
    @Published public var result: Double?
    @Published public var exchangeRateInfo: String?
    private var cancellables = Set<AnyCancellable>()
    private let repository = CurrencyConverterRepository()

    public init() {}

    public func convertCurrency(amount: Double, from: String, to: String) {
        repository.convertCurrency(amount: amount, from: from, to: to)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error converting currency: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] result in
                self?.result = result.amount
                self?.updateExchangeRateInfo(amount: amount, from: from, to: to, result: result.amount)
            })
            .store(in: &cancellables)
    }
    
    private func updateExchangeRateInfo(amount: Double, from: String, to: String, result: Double) {
        let exchangeRate = result / amount
        self.exchangeRateInfo = "1 \(from) = \(exchangeRate) \(to)"
    }
}
