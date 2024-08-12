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
        let navigationController = UINavigationController(rootViewController: CurrencyConverterTableViewController(viewModel: CurrencyConverterViewModel(localStorageAdapter: LocalStorageAdapter(context: viewContext))))
        return navigationController
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}
