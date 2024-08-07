//
//  CurrencyConverterRepository.swift
//  CurrencyConverter
//
//  Created by Vinicius Gibran on 06/08/2024.
//

import Foundation
import Combine

public class CurrencyConverterRepository {
    private let apiService = APIService.shared

    public init() {}

    public func convertCurrency(amount: Double, from: String, to: String) -> AnyPublisher<ConversionResult, Error> {
        var components = URLComponents(string: "https://api.frankfurter.app/convert")!
        components.queryItems = [
            URLQueryItem(name: "amount", value: "\(amount)"),
            URLQueryItem(name: "from", value: from),
            URLQueryItem(name: "to", value: to)
        ]
        
        let url = components.url!
        return apiService.performRequest(with: url)
    }
}
