import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
}

struct Main: Decodable {
    let temp: Double
}
