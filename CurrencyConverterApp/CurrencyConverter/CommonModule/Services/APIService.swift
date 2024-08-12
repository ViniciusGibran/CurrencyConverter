//
//  APIService.swift
//  CommonModule
//
//  Created by Vinicius Gibran on 06/08/2024.
//

import Foundation
import Combine

class APIService {
    static let shared = APIService()
    
    private init() {}

    func performRequest<T: Decodable>(with url: URL) async throws -> T {
        let (data, _) = try await URLSession.shared.data(from: url)
        let decodedResponse = try JSONDecoder().decode(T.self, from: data)
        return decodedResponse
    }
}
