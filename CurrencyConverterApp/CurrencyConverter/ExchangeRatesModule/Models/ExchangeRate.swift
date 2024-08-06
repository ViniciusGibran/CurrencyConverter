//
//  ExchangeRate.swift
//  CurrencyConverter
//
//  Created by Vinicius Gibran on 05/08/2024.
//

import UIKit
import Combine

struct ExchangeRatesResponse: Decodable {
    let rates: [String: Double]
}

struct ConversionResponse: Decodable {
    let amount: Double
}

public struct ExchangeRate: Identifiable {
    public let id = UUID()
    public let currency: String
    public let rate: Double
}
