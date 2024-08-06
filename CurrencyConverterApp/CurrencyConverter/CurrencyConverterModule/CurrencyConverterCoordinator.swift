//
//  CurrencyConverterCoordinator.swift
//  CurrencyConverter
//
//  Created by Vinicius Gibran on 05/08/2024.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}

class CurrencyConverterCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = CurrencyConverterViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}
