//
//  CurrencyConverterApp.swift
//  CurrencyConverter
//
//  Created by Vinicius Gibran on 04/08/2024.
//

import SwiftUI

@main
struct CurrencyConverterApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        MainTabView()
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            ExchangeRatesView()
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
