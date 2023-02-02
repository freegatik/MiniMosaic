//
//  MiniAppFactory.swift
//  MiniMosaic
//
//  Created by Anton Solovev on 20.01.2023.
//

import UIKit

struct MiniAppFactory {
    let environment: AppEnvironment

    func makeRandomMiniApp() -> BaseMiniAppView {
        switch Int.random(in: 0...2) {
        case 0:
            return WeatherMiniAppView(weatherService: environment.weather)
        case 1:
            return LocationMiniAppView(geocoding: environment.geocoding)
        default:
            return NewsMiniAppView(newsService: environment.news)
        }
    }
}
