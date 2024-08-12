//
//  ExchangeRatesView.swift
//  CurrencyConverter
//
//  Created by Vinicius Gibran on 05/08/2024.
//

import SwiftUI
import Combine
import CoreData

struct ExchangeRatesView: View {
    @ObservedObject var viewModel: ExchangeRatesViewModel
    
    public init(context: NSManagedObjectContext) {
        self.viewModel = ExchangeRatesViewModel(context: context)
    }
    
    public var body: some View {
        NavigationView {
            VStack {
                if viewModel.state == .loading {
                    ProgressView().padding()
                } else if viewModel.filteredRates.isEmpty {
                    Text("No results found")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        ForEach(viewModel.filteredRates) { rate in
                            HStack {
                                Text(rate.currencyDetails?.flag ?? "")
                                    .font(.largeTitle)
                                    .padding(.trailing, 8)
                                VStack(alignment: .leading) {
                                    Text(rate.currency)
                                        .font(.headline)
                                    Text(rate.currencyDetails?.currencyName ?? "")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Text(String(format: "%.4f", rate.rate))
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Euro Exchange Rates")
            .searchable(text: $viewModel.searchText)
            .onAppear {
                Task { await viewModel.fetchExchangeRates() }
            }
            .alert(isPresented: Binding<Bool>(
                get: { viewModel.state == .error("") },
                set: { _ in viewModel.state = .idle }
            )) {
                Alert(title: Text("Error"), message: Text("Failed to load exchange rates"), dismissButton: .default(Text("OK")))
            }
        }
    }
}
