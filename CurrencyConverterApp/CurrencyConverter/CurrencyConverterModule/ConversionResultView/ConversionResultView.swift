//
//  ConversionView.swift
//  CurrencyConverter
//
//  Created by Vinicius Gibran on 12/08/2024.
//

import SwiftUI

struct ConversionResultView: View {
    @ObservedObject var viewModel: ConversionResultViewModel

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            Spacer()
            VStack {
                Text("Conversion Result")
                    .font(.headline)
                    .padding()
                HStack {
                    Text(viewModel.sourceCurrency.flag)
                    Text(viewModel.sourceCurrency.currencyCode)
                    Text("→")
                    Text(viewModel.destinationCurrency.flag)
                    Text(viewModel.destinationCurrency.currencyCode)
                }
                .font(.title)
                .padding()
                Text("\(viewModel.conversionResult ?? 0.00, specifier: "%.2f")")
                    .font(.system(size: 48, weight: .bold, design: .default))
                    .padding()
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear() {
            Task { await viewModel.convertCurrency() }
        }
    }
}
