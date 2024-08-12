//
//  CurrencyConverterTableViewContainer.swift
//  CurrencyConverter
//
//  Created by Vinicius Gibran on 06/08/2024.
//

import SwiftUI

struct CurrencyConverterTableViewContainer: UIViewControllerRepresentable {
    @Environment(\.managedObjectContext) private var viewContext

    func makeUIViewController(context: Context) -> UINavigationController {
        let localStorageAdapter = LocalStorageAdapter(context: viewContext)
        let navigationController = UINavigationController()
        let coordinator = CurrencyConverterCoordinator(navigationController: navigationController, localStorageAdapter: localStorageAdapter)
        let viewModel = CurrencyConverterViewModel(localStorageAdapter: localStorageAdapter, coordinator: coordinator)

        navigationController.viewControllers = [CurrencyConverterTableViewController(viewModel: viewModel)]
        
        return navigationController
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}
