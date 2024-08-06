//
//  CurrencyAPIClient.swift
//  CurrencyConverter
//
//  Created by Vinicius Gibran on 05/08/2024.
//

/*import Foundation

class CurrencyAPIClient {
    private let baseURL = URL(string: "https://api.frankfurter.app")!
    
    func fetchExchangeRates() -> AnyPublisher<[ExchangeRate], Error> {
        var components = URLComponents(url: baseURL.appendingPathComponent("latest"), resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "from", value: "EUR")
        ]
        
        guard let url = components.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response -> Data in
                if let httpResponse = response as? HTTPURLResponse {
                    print("HTTP Response Status Code: \(httpResponse.statusCode)")
                    print("HTTP Response Headers: \(httpResponse.allHeaderFields)")
                }
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    if let httpResponse = response as? HTTPURLResponse {
                        print("Error Response Data: \(String(decoding: data, as: UTF8.self))")
                    }
                    throw URLError(.badServerResponse)
                }
                print("Fetched data: \(String(decoding: data, as: UTF8.self))")
                return data
            }
            .decode(type: ExchangeRateResponse.self, decoder: JSONDecoder())
            .map { $0.rates.map { ExchangeRate(currency: $0.key, rate: $0.value) } }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func convert(amount: Double, from: String, to: String) -> AnyPublisher<Double, Error> {
        var components = URLComponents(url: baseURL.appendingPathComponent("convert"), resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "amount", value: "\(amount)"),
            URLQueryItem(name: "from", value: from),
            URLQueryItem(name: "to", value: to)
        ]
        
        guard let url = components.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response -> Data in
                if let httpResponse = response as? HTTPURLResponse {
                    print("HTTP Response Status Code: \(httpResponse.statusCode)")
                    print("HTTP Response Headers: \(httpResponse.allHeaderFields)")
                }
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    if let _ = response as? HTTPURLResponse {
                        print("Error Response Data: \(String(decoding: data, as: UTF8.self))")
                    }
                    throw URLError(.badServerResponse)
                }
                print("Fetched data: \(String(decoding: data, as: UTF8.self))")
                return data
            }
            .decode(type: ConversionResponse.self, decoder: JSONDecoder())
            .map { $0.amount }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}*/
