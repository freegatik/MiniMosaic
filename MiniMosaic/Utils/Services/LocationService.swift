//
//  LocationService.swift
//  MiniMosaic
//
//  Created by Богдан Тарченко on 07.09.2024.
//

import Foundation
import CoreLocation

class LocationService {
    private let geocoder = CLGeocoder()
    
    func reverseGeocode(location: CLLocation, completion: @escaping (Result<LocationModel, Error>) -> Void) {
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let placemark = placemarks?.first else {
                completion(.failure(NSError(domain: "LocationService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Не удалось получить данные"])))
                return
            }
            
            let city = placemark.locality ?? "Неизвестное местоположение"
            let coordinates = "Широта: \(String(format: "%.2f", location.coordinate.latitude)), Долгота: \(String(format: "%.2f", location.coordinate.longitude))"
            
            let locationModel = LocationModel(city: city, coordinates: coordinates)
            completion(.success(locationModel))
        }
    }
}

