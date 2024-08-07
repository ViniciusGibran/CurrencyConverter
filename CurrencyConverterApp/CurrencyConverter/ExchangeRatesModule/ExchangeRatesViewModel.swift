//
//  ExchangeRatesViewModel.swift
//  ExchangeRatesModule
//
//  Created by Vinicius Gibran on 06/08/2024.
//

import Combine
import CoreData
import Foundation

public enum ViewState: Equatable {
    case idle
    case loading
    case loadedAll
    case loaded
    case error(String)
}

class ExchangeRatesViewModel: ObservableObject {
    @Published var exchangeRates: [ExchangeRate] = []
    @Published var currencies: [Currency] = []
    @Published var state: ViewState = .idle
    @Published var currencyNames: [String: String] = [:]
    private var cancellables = Set<AnyCancellable>()
    private let repository = ExchangeRatesRepository()
    private let localStorageAdapter: LocalStorageAdapter
    private var allItemsLoaded = false
    private var currentPage = 0
    private let pageSize = 10

    init(context: NSManagedObjectContext) {
        self.localStorageAdapter = LocalStorageAdapter(context: context)
        currencies = localStorageAdapter.loadCurrencies()
    }

    func fetchCurrencyNames() {
        repository.fetchCurrencyNames()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching currency names: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] names in
                self?.currencyNames = names
                self?.currencies = self?.currencies.map { currency in
                    var updatedCurrency = currency
                    updatedCurrency.currencyName = names[currency.currencyCode]
                    return updatedCurrency
                } ?? []
            })
            .store(in: &cancellables)
    }

    public func fetchExchangeRates() {
        guard state != .loading && !allItemsLoaded else { return }
        state = .loading
        repository.fetchExchangeRates(page: currentPage, pageSize: pageSize)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching exchange rates: \(error)")
                    self.state = .error(error.localizedDescription)
                case .finished:
                    self.state = self.allItemsLoaded ? .loadedAll : .loaded
                }
            }, receiveValue: { [weak self] rates in
                guard let self = self else { return }
                if self.currentPage == 0 { self.exchangeRates.removeAll() }
                if rates.isEmpty {
                    self.allItemsLoaded = true
                } else {
                    let detailedRates = rates.map { rate -> ExchangeRate in
                        var detailedRate = rate
                        detailedRate.currencyDetails = self.currencies.first { $0.currencyCode == rate.currency }
                        return detailedRate
                    }
                    
                    // Append new rates and sort by priority
                    self.exchangeRates.append(contentsOf: detailedRates)
                    //self.exchangeRates.sort { ($0.currencyDetails?.priority ?? 0) < ($1.currencyDetails?.priority ?? 0) }
                    /*self.exchangeRates.sort { (firstRate, secondRate) -> Bool in
                        let firstPriority = firstRate.currencyDetails?.priority ?? Int.max
                        let secondPriority = secondRate.currencyDetails?.priority ?? Int.max
                        return firstPriority < secondPriority
                    }*/
                    
                    self.currentPage += 1
                }
            })
            .store(in: &cancellables)
    }

    func filteredExchangeRates(searchText: String) -> [ExchangeRate] {
        if searchText.isEmpty {
            return exchangeRates
        } else {
            return exchangeRates.filter {
                $0.currency.uppercased().contains(searchText.uppercased()) ||
                $0.currencyDetails?.currencyName?.uppercased().contains(searchText.uppercased()) ?? false
            }
        }
    }
}
