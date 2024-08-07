//
//  LocalStorageAdapter.swift
//  CurrencyConverter
//
//  Created by Vinicius Gibran on 07/08/2024.
//

import Foundation
import CoreData

class LocalStorageAdapter {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func saveCurrencies(_ currencies: [Currency]) {
        currencies.forEach { currency in
            let currencyMO = CurrencyMO(context: context)
            currencyMO.id = currency.id
            currencyMO.currencyCode = currency.currencyCode
            currencyMO.currencyName = currency.currencyName
            currencyMO.flag = currency.flag
            currencyMO.priority = Int16(currency.priority)
        }
        do {
            try context.save()
        } catch {
            print("Failed to save currencies: \(error)")
        }
    }
    
    func loadCurrencies() -> [Currency] {
        let fetchRequest: NSFetchRequest<CurrencyMO> = CurrencyMO.fetchRequest()
        do {
            let currencyMOs = try context.fetch(fetchRequest)
            return currencyMOs.map {
                Currency(
                    id: $0.id ?? UUID(),
                    currencyName: $0.currencyName ?? "",
                    currencyCode: $0.currencyCode ?? "",
                    countryCode: $0.countryCode ?? "",
                    priority: Int($0.priority),
                    flag: $0.flag ?? "🇺🇳"
                    
                )
            }
        } catch {
            print("Failed to fetch currencies: \(error)")
            return []
        }
    }
}
