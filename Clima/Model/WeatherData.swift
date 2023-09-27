
import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let wind: Wind
    let sys: Sys
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
    let humidity: Double
    let pressure: Double
    let feels_like: Double
}

struct Wind: Codable {
    let speed: Double
}

struct Sys: Codable {
    let sunrise: Double
    let sunset: Double
}

struct Weather: Codable {
    let description: String
    let id: Int
}
