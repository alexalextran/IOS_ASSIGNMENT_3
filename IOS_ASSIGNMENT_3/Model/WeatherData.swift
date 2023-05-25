//
//  WeatherData.swift
//  IOS_ASSIGNMENT_3
//
//  Created by Sill Wmith on 26/5/2023.
//

import Foundation

struct WeatherData: Codable{
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable{
    let temp: Double
}

struct Weather: Codable{
    let description: String
    let id: Int
}
