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
    private let apiService = APIService.shared
    
    func fetchRemoteConfig() -> AnyPublisher<[Currency], Error> {
        let url = URL(string: "https://gist.githubusercontent.com/ViniciusGibran/d493707ce253d6556341b7c92a3e19e1/raw/a30541a6507d4b8323e3efaa0f6ca7a76918bbc2/CC_remote_config.json")!
        
        return apiService.performRequest(with: url)
            .map { (config: RemoteConfigResponse) in
                config.currencyInfo.sorted { $0.priority < $1.priority }
            }
            .eraseToAnyPublisher()
    }
}
