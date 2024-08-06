//
//  CurrencyConverterViewContainer.swift
//  CurrencyConverter
//
//  Created by Vinicius Gibran on 06/08/2024.
//

import SwiftUI

struct CurrencyConverterViewContainer: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: CurrencyConverterViewController())
        return navigationController
    }

     func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}
