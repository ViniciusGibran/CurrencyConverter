//
//  CurrencyConverterStore.swift
//  CurrencyConverter
//
//  Created by Vinicius Gibran on 05/08/2024.
//

import Foundation
import CoreData

import Foundation
import CoreData

import CoreData

class CurrencyConverterStore {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }

    func fetchAll() -> [CurrencyConverter] {
        let request: NSFetchRequest<CurrencyConverter> = CurrencyConverter.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching CurrencyConverter objects: \(error)")
            return []
        }
    }

    func save(amount: Double, fromCurrency: String, toCurrency: String, convertedAmount: Double) {
        let newConversion = CurrencyConverter(context: context)
        newConversion.amount = amount
        newConversion.fromCurrency = fromCurrency
        newConversion.toCurrency = toCurrency
        newConversion.convertedAmount = convertedAmount
        do {
            try context.save()
        } catch {
            print("Error saving CurrencyConverter object: \(error)")
        }
    }
}
