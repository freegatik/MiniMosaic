//
//  LocationService.swift
//  MiniMosaic
//
//  Created by Anton Solovev on 18.01.2023.
//

import Foundation
import CoreLocation

final class LocationService: LocationGeocodingProviding {
    private let geocoder = CLGeocoder()

    func reverseGeocode(location: CLLocation, completion: @escaping (Result<LocationModel, Error>) -> Void) {
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let placemark = placemarks?.first else {
                let message = "Не удалось получить данные"
                let err = NSError(
                    domain: "LocationService",
                    code: 0,
                    userInfo: [NSLocalizedDescriptionKey: message]
                )
                completion(.failure(err))
                return
            }

            let city = placemark.locality ?? "Неизвестное местоположение"
            let lat = String(format: "%.2f", location.coordinate.latitude)
            let lon = String(format: "%.2f", location.coordinate.longitude)
            let coordinates = "Широта: \(lat), Долгота: \(lon)"

            let locationModel = LocationModel(city: city, coordinates: coordinates)
            completion(.success(locationModel))
        }
    }
}
