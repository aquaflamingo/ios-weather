import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(wm: WeatherManager, w: WeatherModel)
    func didFailWithError(err: Error)
}
    
struct WeatherModel {
    let conditionId: Int
    let name: String
    let temperature: Double

    var temperatureString: String {
        return String(format: "%.1f",temperature)
    }
    
    // See: https://openweathermap.org/weather-conditions
    var conditionName: String {
        switch conditionId {
        case 200..<300:
            return "cloud.bolt"
        case 300..<400:
            return "cloud.drizzle"
        case 500..<600:
            return "cloud.rain"
        case 600..<700:
            return "cloud.snow"
        case 700..<800:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 800..<900:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}
