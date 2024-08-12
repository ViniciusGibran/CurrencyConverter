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
    func fetchExchangeRates() async throws -> [ExchangeRate] {
        let url = URL(string: "https://api.frankfurter.app/latest?from=EUR")!
        let response: ExchangeRatesResponse = try await APIService.shared.performRequest(with: url)
        return response.rates.map { ExchangeRate(currency: $0.key, rate: $0.value) }
    }

    func fetchCurrencyNames() async throws -> [String: String] {
        let url = URL(string: "https://api.frankfurter.app/currencies")!
        let response: [String: String] = try await APIService.shared.performRequest(with: url)
        return response
    }
    
    func getConversionRate(from sourceCurrency: String, to destinationCurrency: String) async throws -> Double {
        let url = URL(string: "https://api.frankfurter.app/latest?from=\(sourceCurrency)&to=\(destinationCurrency)")!
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(ExchangeRatesResponse.self, from: data)
        
        guard let rate = response.rates[destinationCurrency] else {
            throw NSError(domain: "FrankfurterRepository", code: 0, userInfo: [NSLocalizedDescriptionKey: "Rate not found"])
        }
        
        return rate
    }
}
