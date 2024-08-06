//
//  CurrencyConverter+CoreDataProperties.swift
//  CurrencyConverter
//
//  Created by Vinicius Gibran on 05/08/2024.
//

import Foundation
import CoreData

extension CurrencyConverter {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrencyConverter> {
        return NSFetchRequest<CurrencyConverter>(entityName: "CurrencyConverter")
    }

    @NSManaged public var amount: Double
    @NSManaged public var fromCurrency: String
    @NSManaged public var toCurrency: String
    @NSManaged public var convertedAmount: Double
}
