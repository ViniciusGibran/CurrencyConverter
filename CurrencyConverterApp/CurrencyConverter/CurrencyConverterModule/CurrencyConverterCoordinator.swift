//
//  CurrencyConverterCoordinator.swift
//  CurrencyConverter
//
//  Created by Vinicius Gibran on 11/08/2024.
//

import Combine
import SwiftUI
import UIKit

protocol CurrencySelectionDelegate: AnyObject {
    func didSelectCurrency(_ currency: Currency, for instance: CurrencyListViewModel.InstanceType)
}

class CurrencyConverterCoordinator {
    private weak var navigationController: UINavigationController?
    private let localStorageAdapter: LocalStorageAdapter
    private var cancellables = Set<AnyCancellable>()
    
    weak var delegate: CurrencySelectionDelegate?
    
    init(navigationController: UINavigationController, localStorageAdapter: LocalStorageAdapter) {
        self.navigationController = navigationController
        self.localStorageAdapter = localStorageAdapter
    }
    
    func presentCurrencySelection(sourceOrDestination: CurrencyListViewModel.InstanceType, delegate: CurrencySelectionDelegate) {
        self.delegate = delegate
        
        let currencyListViewModel = CurrencyListViewModel(instance: sourceOrDestination, adapter: localStorageAdapter)
        currencyListViewModel.currencySelectedSubject
            .sink { [weak self] selectedCurrency in
                guard let self = self else { return }
                self.delegate?.didSelectCurrency(selectedCurrency, for: sourceOrDestination)
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
            .store(in: &cancellables)
        
        let currencyListView = CurrencyListView(viewModel: currencyListViewModel)
        let currencyListVC = UIHostingController(rootView: currencyListView)
        navigationController?.present(currencyListVC, animated: true, completion: nil)
    }
    
    func presentConversionView(sourceCurrency: Currency, destinationCurrency: Currency, conversionAmount: Double) {
        let conversionViewModel = ConversionResultViewModel(sourceCurrency: sourceCurrency,
                                                            destinationCurrency: destinationCurrency,
                                                            conversionAmount: conversionAmount,
                                                            repository: FrankfurterRepository(),
                                                            localStorageAdapter: localStorageAdapter)
        
        let conversionView = ConversionResultView(viewModel: conversionViewModel)
        let conversionVC = UIHostingController(rootView: conversionView)
        navigationController?.present(conversionVC, animated: true, completion: nil)
    }
}
