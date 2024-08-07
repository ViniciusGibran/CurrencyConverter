//
//  ExchangeRatesView.swift
//  CurrencyConverter
//
//  Created by Vinicius Gibran on 05/08/2024.
//

import SwiftUI
import Combine
import CoreData

public struct ExchangeRatesView: View {
    @ObservedObject var viewModel: ExchangeRatesViewModel
    @State private var searchText = ""

    public init(context: NSManagedObjectContext) {
        self.viewModel = ExchangeRatesViewModel(context: context)
    }

    public var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                List {
                    ForEach(viewModel.filteredExchangeRates(searchText: searchText)) { rate in
                        HStack {
                            if let currencyDetails = rate.currencyDetails {
                                Text(currencyDetails.flag)
                                    .font(.largeTitle)
                                    .padding(.trailing, 8)
                                VStack(alignment: .leading) {
                                    Text(rate.currency)
                                        .font(.headline)
                                    if let currencyName = currencyDetails.currencyName {
                                        Text(currencyName)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                }
                            } else {
                                Text("🏳️")
                                    .font(.largeTitle)
                                    .padding(.trailing, 8)
                                VStack(alignment: .leading) {
                                    Text(rate.currency)
                                        .font(.headline)
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
}

struct SearchBar: UIViewRepresentable {
    @Binding var text: String

    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }

    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text
    }
}
