//
//  WeatherModel.swift
//  MiniMosaic
//
//  Created by Богдан Тарченко on 03.09.2024.
//

import Foundation

struct WeatherModel: Decodable {
    let main: Main
    let weather: [Weather]
    let name: String
    
    struct Main: Decodable {
        let temp: Double
    }
    
    struct Weather: Decodable {
        let description: String
    }
}
