//
//  Conversion.swift
//  CurrencyConverterModule
//
//  Created by Vinicius Gibran on 06/08/2024.
//

import CoreData

struct Conversion: Identifiable {
    var id = UUID()
    let amount: Double
    let sourceCurrency: Currency
    let destinationCurrency: Currency
    let result: Double
    let timestamp: Date
    
    init(id: UUID = UUID(),
         amount: Double,
         sourceCurrency: Currency,
         destinationCurrency: Currency,
         result: Double,
         timestamp: Date
    ) {
        self.id = id
        self.amount = amount
        self.sourceCurrency = sourceCurrency
        self.destinationCurrency = destinationCurrency
        self.result = result
        self.timestamp = timestamp
    }
    
    init(fromMO: ConversionMO) {
        self.id = fromMO.id ?? UUID()
        self.amount = fromMO.amount
        self.sourceCurrency = Currency(from: fromMO.sourceCurrency ?? CurrencyMO())
        self.destinationCurrency = Currency(from: fromMO.destinationCurrency ?? CurrencyMO())
        self.result = fromMO.result
        self.timestamp = fromMO.timestamp ?? Date()
    }
}
