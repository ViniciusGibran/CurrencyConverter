//
//  ExchangeRatesCoordinator.swift
//  CurrencyConverter
//
//  Created by Vinicius Gibran on 05/08/2024.
//

import UIKit
import SwiftUI

class ExchangeRatesCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let view = ExchangeRatesView()
        let viewController = UIHostingController(rootView: view)
        navigationController.pushViewController(viewController, animated: true)
    }
}
