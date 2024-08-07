//
//  Currency.swift
//  CurrencyConverter
//
//  Created by Vinicius Gibran on 07/08/2024.
//

import Foundation

struct Currency: Identifiable, Decodable {
    var id: UUID
    var currencyName: String?
    let currencyCode: String
    let countryCode: String
    let priority: Int
    let flag: String

    enum CodingKeys: String, CodingKey {
        case currencyName
        case currencyCode
        case countryCode
        case priority
        case flag
    }

    init(id: UUID = UUID(), currencyName: String?, currencyCode: String, countryCode: String, priority: Int, flag: String) {
        self.id = id
        self.currencyName = currencyName
        self.currencyCode = currencyCode
        self.countryCode = countryCode
        self.priority = priority
        self.flag = flag
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = UUID()
        currencyName = try container.decodeIfPresent(String.self, forKey: .currencyName)
        currencyCode = try container.decode(String.self, forKey: .currencyCode)
        countryCode = try container.decode(String.self, forKey: .countryCode)
        priority = try container.decode(Int.self, forKey: .priority)
        flag = try container.decode(String.self, forKey: .flag)
    }
}
