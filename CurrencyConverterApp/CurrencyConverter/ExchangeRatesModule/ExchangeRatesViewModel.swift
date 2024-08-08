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
    @Published public var exchangeRates: [ExchangeRate] = []
    @Published public var state: ViewState = .idle
    private var cancellables = Set<AnyCancellable>()
    private let repository = FrankfurterRepository()
    private let localStorageAdapter: LocalStorageAdapter

    init(context: NSManagedObjectContext) {
        self.localStorageAdapter = LocalStorageAdapter(context: context)
    }

    /*
    func fetchExchangeRates() {
        guard state != .loading && !allItemsLoaded else { return }
        state = .loading

        repository.fetchExchangeRates(page: currentPage, pageSize: pageSize)
            .flatMap { [weak self] rates -> AnyPublisher<[ExchangeRate], Error> in
                guard let self = self else { return Empty().eraseToAnyPublisher() }
                let currencyCodes = rates.map { $0.currency }
                return self.localStorageAdapter.loadCurrencies(for: currencyCodes)
                    .map { currencies -> [ExchangeRate] in
                        rates.map { rate -> ExchangeRate in
                            print("")
                            print("rates.map coredata rate ids")
                            print("rate.id \(rate.id)")
                            var detailedRate = rate
                            detailedRate.currencyDetails = currencies.first { $0.currencyCode == rate.currency }
                            return detailedRate
                        }
                    }
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching exchange rates: \(error)")
                    self.state = .error(error.localizedDescription)
                case .finished:
                    self.state = self.allItemsLoaded ? .loadedAll : .loaded
                }
            }, receiveValue: { [weak self] detailedRates in
                guard let self = self else { return }
                
                print("")
                print("receiveValue rate ids")
                for rate in detailedRates {
                    print("ExchangeRate ID: \(rate.id)")
                }
                
                if self.currentPage == 0 { self.exchangeRates.removeAll() }
                self.allItemsLoaded = detailedRates.count < pageSize
                
                guard !detailedRates.isEmpty else { return }
                self.exchangeRates.append(contentsOf: detailedRates)
                //self.exchangeRates.sort { ($0.currencyDetails?.priority ?? 0) < ($1.currencyDetails?.priority ?? 0) }
                self.currentPage += 1
            })
            .store(in: &cancellables)
    }*/
    
    public func fetchExchangeRates() {
            guard state != .loading else { return }
            state = .loading

            repository.fetchExchangeRates()
                .flatMap { [weak self] rates -> AnyPublisher<[ExchangeRate], Error> in
                    guard let self = self else { return Empty().eraseToAnyPublisher() }
                    let currencyCodes = rates.map { $0.currency }
                    return self.localStorageAdapter.loadCurrencies(for: currencyCodes)
                        .map { currencies -> [ExchangeRate] in
                            rates.map { rate -> ExchangeRate in
                                var detailedRate = rate
                                detailedRate.currencyDetails = currencies.first { $0.currencyCode == rate.currency }
                                return detailedRate
                            }
                        }
                        .eraseToAnyPublisher()
                }
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("Error fetching exchange rates: \(error)")
                        self.state = .error(error.localizedDescription)
                    case .finished:
                        self.state = .loaded
                    }
                }, receiveValue: { [weak self] detailedRates in
                    guard let self = self else { return }
                    
                    print("Fetched \(detailedRates.count) rates")
                    for rate in detailedRates {
                        print("ExchangeRate ID: \(rate.id)")
                    }
                    
                    self.exchangeRates = detailedRates
                    self.exchangeRates.sort { ($0.currencyDetails?.priority ?? 0) < ($1.currencyDetails?.priority ?? 0) }
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
