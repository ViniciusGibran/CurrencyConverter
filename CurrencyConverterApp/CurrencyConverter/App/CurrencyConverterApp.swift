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
    @StateObject private var remoteConfigLoader = RemoteConfigLoader(context: PersistenceController.shared.container.viewContext)

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onAppear {
                    remoteConfigLoader.loadRemoteConfig()
                }
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
                    Label("Exchange Rates", systemImage: "list.dash")
                }
            
            CurrencyConverterViewContainer()
                .tabItem {
                    Label("Converter", systemImage: "arrow.left.arrow.right")
                }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

class RemoteConfigLoader: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    let remoteConfigRepository = RemoteConfigRepository()
    let localStorageAdapter: LocalStorageAdapter

    init(context: NSManagedObjectContext) {
        self.localStorageAdapter = LocalStorageAdapter(context: context)
    }

    func loadRemoteConfig() {
        remoteConfigRepository.fetchRemoteConfig()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching remote config: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] currencies in
                self?.localStorageAdapter.saveCurrencies(currencies)
            })
            .store(in: &cancellables)
    }
}
