//
//  APIService.swift
//  CommonModule
//
//  Created by Vinicius Gibran on 06/08/2024.
//

import Foundation
import Combine

public class APIService {
    public static let shared = APIService()

    private init() {}

    public func performRequest<T: Decodable>(with url: URL) -> AnyPublisher<T, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
