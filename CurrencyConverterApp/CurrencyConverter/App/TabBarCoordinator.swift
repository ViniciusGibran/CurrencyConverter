//
//  TabBarCoordinator.swift
//  CurrencyConverter
//
//  Created by Vinicius Gibran on 05/08/2024.
//

import UIKit
import SwiftUI

class TabBarCoordinator: Coordinator {
    var navigationController: UINavigationController
    private var tabBarController: UITabBarController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
    }
    
    func start() {
        let exchangeRatesViewController = UIHostingController(rootView: ExchangeRatesView())
        exchangeRatesViewController.tabBarItem = UITabBarItem(title: "Rates", image: UIImage(systemName: "list.dash"), tag: 0)
        
        let currencyConverterView = CurrencyConverterViewContainer()
        let currencyConverterViewController = UIHostingController(rootView: currencyConverterView)
        currencyConverterViewController.tabBarItem = UITabBarItem(title: "Converter", image: UIImage(systemName: "arrow.left.arrow.right"), tag: 1)
        
        tabBarController.viewControllers = [exchangeRatesViewController, currencyConverterViewController]
        
        navigationController.pushViewController(tabBarController, animated: true)
    }
}
