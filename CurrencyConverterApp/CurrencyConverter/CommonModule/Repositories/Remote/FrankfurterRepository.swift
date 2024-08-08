//
//  FrankfurterRepository.swift
//  CurrencyConverter
//
//  Created by Vinicius Gibran on 07/08/2024.
//

import Combine
import Foundation

struct ExchangeRatesResponse: Decodable {
    let rates: [String: Double]
}

class FrankfurterRepository {
    func fetchExchangeRates() -> AnyPublisher<[ExchangeRate], Error> {
        let url = URL(string: "https://api.frankfurter.app/latest?from=EUR")!
        print("Fetching all exchange rates")
        return APIService.shared.performRequest(with: url)
            .map { (response: ExchangeRatesResponse) in
                let allRates = response.rates.map { ExchangeRate(currency: $0.key, rate: $0.value) }
                print("Received \(allRates.count) rates")
                return allRates
            }
            .eraseToAnyPublisher()
    }
    
    func fetchCurrencyNames() -> AnyPublisher<[String: String], Error> {
        let url = URL(string: "https://api.frankfurter.app/currencies")!
        return APIService.shared.performRequest(with: url)
            .map { (response: [String: String]) in
                response
            }
            .eraseToAnyPublisher()
    }
}
