//
//  CurrencySelectionCoordinator.swift
//  CurrencyConverter
//
//  Created by Vinicius Gibran on 11/08/2024.
//

import SwiftUI
import UIKit

class CurrencySelectionCoordinator: NSObject {
    private var navigationController: UINavigationController?
    private var mainViewModel: CurrencyConverterViewModel

    init(navigationController: UINavigationController?, viewModel: CurrencyConverterViewModel) {
        self.navigationController = navigationController
        self.mainViewModel = viewModel
    }

    func startCurrencySelection(for instance: InstanceFrom) {
        // here review this property use
        let currencyListViewModel = CurrencyListViewModel(instance: instance, adapter: mainViewModel.localStorageAdapter)
        let currencyListView = CurrencyListView(viewModel: currencyListViewModel)
        let hostingController = UIHostingController(rootView: currencyListView)
        navigationController?.present(hostingController, animated: true, completion: nil)
    }
}
