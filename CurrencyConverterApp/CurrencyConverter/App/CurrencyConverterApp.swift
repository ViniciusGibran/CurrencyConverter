//
//  CurrencyConverterApp.swift
//  CurrencyConverter
//
//  Created by Vinicius Gibran on 04/08/2024.
//

import SwiftUI
import Combine
import CoreData

@main
struct CurrencyConverterApp: App {
    @StateObject private var persistenceController = PersistenceController.shared
    @StateObject private var remoteConfigLoader: BootstrapLoader
    
    init() {
        let context = PersistenceController.shared.container.viewContext
        let loader = BootstrapLoader(context: context)
        
        Task { await loader.loadRemoteConfigAndCurrencyNames() }
        _remoteConfigLoader = StateObject(wrappedValue: loader)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

struct ContentView: View {
    var body: some View {
        MainTabView()
    }
}

struct MainTabView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        TabView {
            ExchangeRatesView(context: viewContext)
                .tabItem {
                    Image(systemName: "list.dash")
                }
            
            CurrencyConverterTableViewContainer()
                .tabItem {
                    Image(systemName: "arrow.left.arrow.right")
                }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

class BootstrapLoader: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let remoteConfigRepository = RemoteConfigRepository()
    private let frankfurterRepository = FrankfurterRepository()
    private let localStorageAdapter: LocalStorageAdapter
    
    init(context: NSManagedObjectContext) {
        self.localStorageAdapter = LocalStorageAdapter(context: context)
    }
    
    func loadRemoteConfigAndCurrencyNames() async {
        do {
            let (currencies, currencyNames) = try await (
                remoteConfigRepository.fetchRemoteConfig(),
                frankfurterRepository.fetchCurrencyNames()
            )
            
            var updatedCurrencies = currencies
            for (currencyCode, currencyName) in currencyNames {
                if let index = updatedCurrencies.firstIndex(where: { $0.currencyCode == currencyCode }) {
                    updatedCurrencies[index].currencyName = currencyName
                }
            }
            
            localStorageAdapter.saveCurrencies(updatedCurrencies)
            
        } catch {
            print("Error fetching data: \(error)")
        }
    }
}

