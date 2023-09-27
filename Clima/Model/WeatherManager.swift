
import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=cce6fc65fae46135c639b555da6068bc&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    // URL mit CityName
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    // URL mit GPS-Daten
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        // 01:  Create URL
        if let url = URL(string: urlString) {
            
        // 02: Create URL-Session
            let session = URLSession(configuration: .default)
            
        // 03: Create Task --- Beispiel für Closure (Anderes Func-Format) 
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
        // 04: Start Task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let description = decodedData.weather[0].description
            let feels_like = decodedData.main.feels_like
            let temp = decodedData.main.temp
            let tempMin = decodedData.main.temp_min
            let tempMax = decodedData.main.temp_max
            let name = decodedData.name
            let sunrise = decodedData.sys.sunrise
            let sunset = decodedData.sys.sunset
            let humidity = decodedData.main.humidity
            let pressure = decodedData.main.pressure
            let speed = decodedData.wind.speed

            
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp, temperatureMin: tempMin, temperatureMax: tempMax, descr: description, feels_like: feels_like, sunrise: sunrise, sunset: sunset, humidity: humidity, pressure: pressure, windspeed: speed)
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}


