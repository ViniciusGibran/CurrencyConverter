//
//  LocalStorageAdapter.swift
//  CurrencyConverter
//
//  Created by Vinicius Gibran on 07/08/2024.
//

import Combine
import CoreData

class LocalStorageAdapter {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func loadCurrencies(for currencyCodes: [String]) async throws -> [Currency] {
        let fetchRequest: NSFetchRequest<CurrencyMO> = CurrencyMO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "currencyCode IN %@", currencyCodes)
        
        do {
            let currencyMOs = try context.fetch(fetchRequest)
            return currencyMOs.map { Currency(from: $0) }
        } catch {
            throw error
        }
    }
    
    func loadCurrencies() async throws -> [Currency] {
        let fetchRequest: NSFetchRequest<CurrencyMO> = CurrencyMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "currencyName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        do {
            let currencyMOs = try await context.perform {
                try self.context.fetch(fetchRequest)
            }
            return currencyMOs.map { Currency(from: $0) }
        } catch {
            throw error
        }
    }
    
    func loadConversionHistory() async throws -> [Conversion] {
        let fetchRequest: NSFetchRequest<ConversionMO> = ConversionMO.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        fetchRequest.relationshipKeyPathsForPrefetching = ["sourceCurrency", "destinationCurrency"]
        
        do {
            let conversionMOs = try await context.perform {
                return try self.context.fetch(fetchRequest)
            }
            return conversionMOs.map { Conversion(fromMO: $0) }
        } catch {
            print("Failed to load conversion history: \(error.localizedDescription)")
            throw error
        }
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
    
    func saveConversion(_ conversion: Conversion) async throws {
        let conversionMO = ConversionMO(context: context)
        conversionMO.id = conversion.id
        conversionMO.timestamp = conversion.timestamp
        conversionMO.amount = conversion.amount
        
        let sourceCurrencyMO = try await loadCurrencyMO(for: conversion.sourceCurrency.currencyCode)
        let destinationCurrencyMO = try await loadCurrencyMO(for: conversion.destinationCurrency.currencyCode)
        
        if let sourceCurrencyMO = sourceCurrencyMO, let destinationCurrencyMO = destinationCurrencyMO {
            conversionMO.sourceCurrency = sourceCurrencyMO
            conversionMO.destinationCurrency = destinationCurrencyMO
            
            try context.save()
        } else {
            throw NSError(domain: "LocalStorageAdapter", code: 0, userInfo: [NSLocalizedDescriptionKey: "CurrencyMO not found"])
        }
    }
    
    private func loadCurrencyMO(for currencyCode: String) async throws -> CurrencyMO? {
        let fetchRequest: NSFetchRequest<CurrencyMO> = CurrencyMO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "currencyCode == %@", currencyCode)
        
        do {
            return try await context.perform {
                try self.context.fetch(fetchRequest).first
            }
        } catch {
            print("Error fetching CurrencyMO for currency code \(currencyCode): \(error)")
            throw error
        }
    }
}
