
import Foundation
import CoreLocation


// Protokoll für die Wetterdaten-Verarbeitung
protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=" + K.apiKey
    
    var delegate: WeatherManagerDelegate?
    
    // Lädt Wetterdaten basierend auf dem Stadtnamen
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    // Lädt Wetterdaten basierend auf GPS-Daten (Breiten- und Längengrad)
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    // Netzwerkanfrage
    func performRequest(with urlString: String)  {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
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
            task.resume()
        }
    }
    
    // Parst JSON-Daten und erstellt WeatherModel
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
            
            let weather = WeatherModel(conditionId: id,
                                       cityName: name,
                                       temperature: temp,
                                       temperatureMin: tempMin,
                                       temperatureMax: tempMax,
                                       descr: description,
                                       feels_like: feels_like,
                                       sunrise: sunrise,
                                       sunset: sunset,
                                       humidity: humidity,
                                       pressure: pressure,
                                       windspeed: speed)
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
