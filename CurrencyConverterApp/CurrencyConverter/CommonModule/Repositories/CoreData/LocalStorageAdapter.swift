//
//  LocalStorageAdapter.swift
//  CurrencyConverter
//
//  Created by Vinicius Gibran on 07/08/2024.
//

import Combine
import CoreData
import Foundation

class LocalStorageAdapter {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func loadCurrencies(for currencyCodes: [String]) -> AnyPublisher<[Currency], Error> {
        Future { promise in
            let fetchRequest: NSFetchRequest<CurrencyMO> = CurrencyMO.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "currencyCode IN %@", currencyCodes)
            do {
                let currencyMOs = try self.context.fetch(fetchRequest)
                let currencies = currencyMOs.map { mo -> Currency in
                    Currency(
                        id: mo.id ?? UUID(),
                        currencyName: mo.currencyName ?? "",
                        currencyCode: mo.currencyCode ?? "",
                        countryCode: mo.countryCode ?? "",
                        priority: Int(mo.priority),
                        flag: mo.flag ?? "🇫🇲"
                    )
                }
                promise(.success(currencies))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func saveCurrencies(_ currencies: [Currency]) {
        for currency in currencies {
            let fetchRequest: NSFetchRequest<CurrencyMO> = CurrencyMO.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "currencyCode == %@", currency.currencyCode)
            do {
                let existingCurrencies = try context.fetch(fetchRequest)
                let currencyMO = existingCurrencies.first ?? CurrencyMO(context: context)
                currencyMO.id = currency.id
                currencyMO.currencyName = currency.currencyName
                currencyMO.currencyCode = currency.currencyCode
                currencyMO.countryCode = currency.countryCode
                currencyMO.priority = Int16(currency.priority)
                currencyMO.flag = currency.flag
            } catch {
                print("Failed to fetch or save currency: \(error)")
            }
        }
        do {
            try context.save()
        } catch {
            print("Failed to save currencies: \(error)")
        }
    }
}
