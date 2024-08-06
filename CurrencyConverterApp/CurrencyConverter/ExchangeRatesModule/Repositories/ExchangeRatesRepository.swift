//
//  ExchangeRatesRepository.swift
//  ExchangeRatesModule
//
//  Created by Vinicius Gibran on 06/08/2024.
//

import Foundation
import Combine

public class ExchangeRatesRepository {
    private let apiService = APIService.shared

    public init() {}

    public func fetchExchangeRates() -> AnyPublisher<[ExchangeRate], Error> {
        let url = URL(string: "https://api.frankfurter.app/latest?from=EUR")!
        return apiService.performRequest(with: url)
            .map { (response: ExchangeRatesResponse) in
                response.rates.map { ExchangeRate(currency: $0.key, rate: $0.value) }
            }
            .eraseToAnyPublisher()
    }
    
    public func fetchCurrencyNames() -> AnyPublisher<[String: String], Error> {
        let url = URL(string: "https://api.frankfurter.app/currencies")!
        return apiService.performRequest(with: url)
            .map { (response: [String: String]) in
                response
            }
            .eraseToAnyPublisher()
    }
}
