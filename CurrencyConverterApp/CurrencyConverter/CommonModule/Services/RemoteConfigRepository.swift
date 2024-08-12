//
//  RemoteConfigRepository.swift
//  CurrencyConverter
//
//  Created by Vinicius Gibran on 07/08/2024.
//

import Foundation
import Combine

struct RemoteConfigResponse: Decodable {
    let configVersion: String
    let currencyInfo: [Currency]
}

class RemoteConfigRepository {
    func fetchRemoteConfig() async throws -> [Currency] {
        let url = URL(string: "https://gist.githubusercontent.com/ViniciusGibran/d493707ce253d6556341b7c92a3e19e1/raw/f2265bb6493806fe3444b59e784882c3bc84fcf3/CC_remote_config.json")!

        let (data, _) = try await URLSession.shared.data(from: url)
        let config = try JSONDecoder().decode(RemoteConfigResponse.self, from: data)
        return config.currencyInfo.sorted { $0.priority < $1.priority }
    }
}
