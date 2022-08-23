import Foundation
import CoreLocation

struct WeatherManager {
    // See
    // https://www.reddit.com/r/learnpython/comments/mipvy3/invalid_api_key_error_for_open_weather_free_api/
    
    let appId = "FIXME: add your app id here"
    var url: String
    let delegate: WeatherManagerDelegate?
    
    init(d: WeatherManagerDelegate) {
        self.url = "https://api.openweathermap.org/data/2.5/weather?appid=\(appId)"
        self.delegate = d
    }
    
    func fetch(lat: CLLocationDegrees, long: CLLocationDegrees) {
        print("Fetch with latitude and longitude")
        let urlString = "\(url)&lat=\(lat)&lon=\(long)&units=metric"
        
        performRequest(with: urlString)
    }

    func fetch(city: String) {
        print("Fetch with city")
        let urlString = "\(url)&q=\(city)&units=metric"
        
        performRequest(with: urlString)
    }
    
    func performRequest(with: String) {
        print("Performing HTTP request \(with)")

        if let u = URL(string: with) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: u) { (data, response, error) in
                if error != nil {
                    print("Received error: \(error!)")
                    
                    delegate?.didFailWithError(err: error!)
                    return
                }
                
                if let d = data {
                    print("Data was OK.")
                    print("DATA: \(String(data: d, encoding: String.Encoding.utf8))")
                          
                    if let w = self.parseJSON(weatherData: d) {
                        print("JSON was parsed.")
                        self.delegate?.didUpdateWeather(wm: self, w: w)
                    }
                }
                
            }
            
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        
        do {
            let result = try decoder.decode(WeatherData.self, from: weatherData)
            let id = result.weather[0].id
            let temp = result.main.temp
            let name = result.name
            
            let weather = WeatherModel(conditionId: id, name: name, temperature: temp)
            
            return weather
        } catch {
            print("Got error decoding JSON \(error)")
            delegate?.didFailWithError(err: error)
            return nil
        }
    }
}
