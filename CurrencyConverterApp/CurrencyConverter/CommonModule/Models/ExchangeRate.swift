//
//  ExchangeRate.swift
//  CurrencyConverter
//
//  Created by Vinicius Gibran on 05/08/2024.
//

import Foundation

struct ExchangeRate: Identifiable {
    var id: UUID { currencyDetails?.id ?? UUID() }
    let currency: String
    let rate: Double
    var currencyDetails: Currency?
}
