//
//  WeatherService.swift
//  MiniMosaic
//
//  Created by Богдан Тарченко on 05.09.2024.
//

import Alamofire
import CoreLocation

class WeatherService {
    private let apiKey = APIKeys.weatherAPIKey
    
    func fetchWeather(lat: CLLocationDegrees, lon: CLLocationDegrees, completion: @escaping (Result<WeatherModel, Error>) -> Void) {
        let url = "https://api.openweathermap.org/data/2.5/weather"
        let parameters: [String: Any] = [
            "lat": lat,
            "lon": lon,
            "appid": apiKey,
            "units": "metric"
        ]
        
        AF.request(url, parameters: parameters).responseDecodable(of: WeatherModel.self) { response in
            switch response.result {
            case .success(let weatherResponse):
                completion(.success(weatherResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
