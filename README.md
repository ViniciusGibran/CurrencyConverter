
# Currency Converter App

## Description

The Currency Converter App is an application that provides up-to-date exchange rates and allows users to convert between different currencies. The app is designed with a clean architecture and modular organization to ensure scalability, maintainability, and ease of testing.

## Features

- **Exchange Rates List**: Displays the current exchange rates between the EUR and the major currencies of the world (USD, BRL, GBP, etc.).
- **Currency Converter**: Allows users to input an amount, select the source and destination currencies, and see the converted amount.
- **Country Flags**: Displays country flags next to currency codes for better user experience.
- **Pagination and Lazy Loading**: Efficiently handles large lists of exchange rates.

## Project Organization

The project is organized into the following modules:
CurrencyConverter/
    ├── App/
    │   ├── CurrencyConverterApp.swift
    │   ├── AppCoordinator.swift
    │   └── TabBarCoordinator.swift
    ├── CommonModule/
    │   ├── Services/
    │   │   ├── CurrencyAPIClient.swift
    │   │   └── APIService.swift
    │   ├── CoreData/
    │   │   ├── CurrencyConverter.xcdatamodeld
    │   │   ├── PersistenceController.swift
    │   │   ├── CurrencyConverterStore.swift
    │   │   ├── CurrencyConverter+CoreDataClass.swift
    │   │   └── CurrencyConverter+CoreDataProperties.swift
    │   └── Utilities/
    ├── ExchangeRatesModule/
    │   ├── Repositories/
    │   │   └── ExchangeRatesRepository.swift
    │   ├── Models/
    │   │   └── ExchangeRate.swift
    │   ├── ExchangeRatesCoordinator.swift
    │   ├── ExchangeRatesView.swift
    │   └── ExchangeRatesViewModel.swift
    ├── CurrencyConverterModule/
    │   ├── Repositories/
    │   │   └── CurrencyConverterRepository.swift
    │   ├── Models/
    │   │   └── ConversionResult.swift
    │   ├── CurrencyConverterViewController.swift
    │   ├── CurrencyConverterCoordinator.swift
    │   ├── CurrencyConverterViewContainer.swift
    │   └── CurrencyConverterViewModel.swift
    └── Resources/
        ├── Assets.xcassets
        └── Localization.strings# CurrencyConverter

