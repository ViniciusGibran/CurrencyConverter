//
//  ConversionResultViewModel.swift
//  CurrencyConverter
//
//  Created by Vinicius Gibran on 12/08/2024.
//

import Combine
import Foundation

class ConversionResultViewModel: ObservableObject {
    @Published var sourceCurrency: Currency
    @Published var destinationCurrency: Currency
    @Published var conversionAmount: Double
    @Published var conversionResult: Double?

    private let repository: FrankfurterRepository
    private let localStorageAdapter: LocalStorageAdapter
    private var cancellables = Set<AnyCancellable>()

    init(sourceCurrency: Currency,
         destinationCurrency: Currency,
         conversionAmount: Double = 1.0,
         repository: FrankfurterRepository,
         localStorageAdapter: LocalStorageAdapter
    ) {
        self.sourceCurrency = sourceCurrency
        self.destinationCurrency = destinationCurrency
        self.conversionAmount = conversionAmount
        self.repository = repository
        self.localStorageAdapter = localStorageAdapter
    }

    @MainActor
    func convertCurrency() async {
        do {
            let rate = try await repository.getConversionRate(from: sourceCurrency.currencyCode, to: destinationCurrency.currencyCode)
            conversionResult = conversionAmount * rate
            await saveConversion()
        } catch {
            print("Error converting currency: \(error)")
        }
    }

    private func saveConversion() async {
        guard let result = conversionResult else { return }
        let conversion = Conversion(amount: conversionAmount,
                                    sourceCurrency: sourceCurrency,
                                    destinationCurrency: destinationCurrency,
                                    result: result,
                                    timestamp: Date())
        do {
            try await localStorageAdapter.saveConversion(conversion)
        } catch {
            print("Error saving conversion: \(error)")
        }
    }
}
