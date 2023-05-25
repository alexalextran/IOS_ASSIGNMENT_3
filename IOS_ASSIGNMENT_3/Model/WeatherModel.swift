//
//  WeatherModel.swift
//  IOS_ASSIGNMENT_3
//
//  Created by Sill Wmith on 26/5/2023.
//

import Foundation

struct WeatherModel{
    let conditionId: Int
    let cityName: String
    let temperature: Double
    
    var temperatureString: String{
        return String(format: "%.1f", temperature)
    }
    
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
    
    var conditionAdvice: String {
        switch conditionId {
        case 200...232:
            return "THUNDERSTORM! Beware of power surges, limit your electrical usage or perhaps take a nap to the sounds of nature"
        case 300...321:
            return "Drizzle happiness wherever you go"
        case 500...531:
            return "It's raining outside, maybe this is a good time to coze in or perhaps study"
        case 600...622:
            return "Every avalanche begins with the movement of a single snowflake, and my hope is to move a snowflake"
        case 701...781:
            return "Sometimes we need the fog to remind ourselves that all of life is not black and white"
        case 800:
            return "Today is a good day to get your Vitamin D!"
        case 801...804:
            return "Affections are like lightning. You can't tell where they will strike until they have fallen"
        default:
            return "Even on a cloudy day, the blue sky is stil there"
        }
    }
    
}
