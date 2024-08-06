//
//  ExchangeRatesView.swift
//  CurrencyConverter
//
//  Created by Vinicius Gibran on 05/08/2024.
//

import SwiftUI
import Combine

public struct ExchangeRatesView: View {
    @ObservedObject var viewModel = ExchangeRatesViewModel()

    public var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.exchangeRates) { rate in
                    HStack {
                        Text(flag(for: rate.currency))
                            .font(.largeTitle)
                            .padding(.trailing, 8)
                        VStack(alignment: .leading) {
                            Text(rate.currency)
                                .font(.headline)
                            if let currencyName = viewModel.currencyNames[rate.currency] {
                                Text(currencyName)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        Spacer()
                        Text(String(format: "%.4f", rate.rate))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                if viewModel.state == .loading {
                    ProgressView()
                        .onAppear {
                            viewModel.fetchExchangeRates()
                        }
                } else if viewModel.state == .loaded {
                    Color.clear
                        .onAppear {
                            viewModel.fetchExchangeRates()
                        }
                }
            }
            .navigationTitle("Exchange Rates")
            .onAppear {
                if viewModel.state == .idle {
                    viewModel.fetchCurrencyNames()
                    viewModel.fetchExchangeRates()
                }
            }
            .alert(isPresented: Binding<Bool>(
                get: { viewModel.state == .error("") },
                set: { _ in viewModel.state = .idle }
            )) {
                Alert(title: Text("Error"), message: Text("Failed to load exchange rates"), dismissButton: .default(Text("OK")))
            }
        }
    }

    let currencyToCountryCode: [String: String] = [
        "AUD": "AU",
        "BGN": "BG",
        "BRL": "BR",
        "CAD": "CA",
        "CHF": "CH",
        "CNY": "CN",
        "CZK": "CZ",
        "DKK": "DK",
        "EUR": "EU",
        "GBP": "GB",
        "HKD": "HK",
        "HUF": "HU",
        "IDR": "ID",
        "ILS": "IL",
        "INR": "IN",
        "ISK": "IS",
        "JPY": "JP",
        "KRW": "KR",
        "MXN": "MX",
        "MYR": "MY",
        "NOK": "NO",
        "NZD": "NZ",
        "PHP": "PH",
        "PLN": "PL",
        "RON": "RO",
        "SEK": "SE",
        "SGD": "SG",
        "THB": "TH",
        "TRY": "TR",
        "USD": "US",
        "ZAR": "ZA",
        // Add more mappings as needed
    ]

    func flag(for currencyCode: String) -> String {
        guard let countryCode = currencyToCountryCode[currencyCode] else {
            return "🇫🇲" // Default flag if not found
        }
        return flagEmoji(for: countryCode)
    }

    private func flagEmoji(for countryCode: String) -> String {
        let base: UInt32 = 127397
        var s = ""
        for scalar in countryCode.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + scalar.value)!)
        }
        return String(s)
    }
}
