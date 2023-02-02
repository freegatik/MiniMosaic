//
//  ServiceProtocols.swift
//  MiniMosaic
//
//  Created by Anton Solovev on 18.01.2023.
//

import CoreLocation
import Foundation

protocol WeatherProviding: AnyObject {
    func fetchWeather(
        lat: CLLocationDegrees,
        lon: CLLocationDegrees,
        completion: @escaping (Result<WeatherModel, Error>) -> Void
    )
}

protocol NewsProviding: AnyObject {
    func fetchTopHeadlines(completion: @escaping (Result<NewsResponse, Error>) -> Void)
}

protocol LocationGeocodingProviding: AnyObject {
    func reverseGeocode(location: CLLocation, completion: @escaping (Result<LocationModel, Error>) -> Void)
}
