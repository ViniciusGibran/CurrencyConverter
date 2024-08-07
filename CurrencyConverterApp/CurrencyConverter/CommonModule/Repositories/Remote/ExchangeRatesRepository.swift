//
//  ExchangeRatesRepository.swift
//  ExchangeRatesModule
//
//  Created by Vinicius Gibran on 06/08/2024.
//

import Foundation
import Combine

import Foundation
import Combine

struct ExchangeRatesResponse: Decodable {
    let rates: [String: Double]
}

public class ExchangeRatesRepository {
    private let apiService = APIService.shared

    init() {}
    
    func fetchExchangeRates(page: Int, pageSize: Int) -> AnyPublisher<[ExchangeRate], Error> {
        let url = URL(string: "https://api.frankfurter.app/latest?from=EUR&page=\(page)&pageSize=\(pageSize)")!
        print("page: \(page)")
        return apiService.performRequest(with: url)
            .map { (response: ExchangeRatesResponse) in
                let allRates = response.rates.map { ExchangeRate(currency: $0.key, rate: $0.value) }
                let startIndex = page * pageSize
                let endIndex = min(startIndex + pageSize, allRates.count)
                guard startIndex < endIndex else {
                    return []
                }
                return Array(allRates[startIndex..<endIndex])
            }
            .eraseToAnyPublisher()
    }
    
    func fetchCurrencyNames() -> AnyPublisher<[String: String], Error> {
        let url = URL(string: "https://api.frankfurter.app/currencies")!
        return apiService.performRequest(with: url)
            .map { (response: [String: String]) in
                response
            }
            .eraseToAnyPublisher()
    }
}
