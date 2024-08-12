//
//  CurrencyListView.swift
//  CurrencyConverter
//
//  Created by Vinicius Gibran on 11/08/2024.
//

import Foundation
import SwiftUI

struct CurrencyListView: View {
    @ObservedObject var viewModel: CurrencyListViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(viewModel.viewTitle)
                .font(.title)
                .padding()
            List(viewModel.currencies) { currency in
                Button(action: {
                    viewModel.didSelectCurrency(currency)
                }) {
                    HStack {
                        Text(currency.flag)
                            .font(.title)
                        Text(currency.currencyName ?? "")
                        Spacer()
                        Text(currency.currencyCode)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .onAppear {
                Task { await viewModel.fetchCurrencies() }
            }
        }
        .background(Color(.systemGroupedBackground))
    }
}
