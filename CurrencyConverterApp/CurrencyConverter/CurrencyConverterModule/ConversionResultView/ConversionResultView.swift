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
        VStack(alignment: .center, spacing: 20) {
            Text("Conversion Result")
                .font(.title)
                .bold()
                .padding(.top, 40)

            HStack(spacing: 8) {
                Text(viewModel.sourceCurrency.flag)
                    .font(.largeTitle)
                Text(viewModel.sourceCurrency.currencyCode)
                    .font(.headline)

                Text("→")
                    .font(.title)
                    .padding(.horizontal, 8)

                Text(viewModel.destinationCurrency.flag)
                    .font(.largeTitle)
                Text(viewModel.destinationCurrency.currencyCode)
                    .font(.headline)
            }
            .padding()

            Text(String(format: "%.2f", viewModel.conversionResult ?? 1.00))
                .font(.system(size: 48))
                .bold()
                .padding(.top, 40)

            Spacer()
                .onAppear() {
                    Task {
                        await viewModel.convertCurrency()
                    }
                }
            
        }
        .padding()
        .background(Color(.systemGroupedBackground))
        .cornerRadius(12)
    }
}
