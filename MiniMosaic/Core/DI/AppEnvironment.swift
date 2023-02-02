//
//  AppEnvironment.swift
//  MiniMosaic
//
//  Created by Anton Solovev on 12.01.2023.
//

import Foundation

struct AppEnvironment {
    let weather: WeatherProviding
    let news: NewsProviding
    let geocoding: LocationGeocodingProviding

    static let live = AppEnvironment(
        weather: WeatherService(),
        news: NewsService(),
        geocoding: LocationService()
    )
}
