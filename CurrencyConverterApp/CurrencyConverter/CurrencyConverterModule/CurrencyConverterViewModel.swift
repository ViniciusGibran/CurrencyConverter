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
    //private let repository = CurrencyConverterRepository()

    public init() {}

    public func convertCurrency(amount: Double, from: String, to: String) { }
    
    private func updateExchangeRateInfo(amount: Double, from: String, to: String, result: Double) {
        let exchangeRate = result / amount
        self.exchangeRateInfo = "1 \(from) = \(exchangeRate) \(to)"
    }
}
