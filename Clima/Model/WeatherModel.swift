
import Foundation


struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    let temperatureMin: Double
    let temperatureMax: Double
    let descr: String
    let feels_like: Double
    let sunrise: Double
    let sunset: Double
    let humidity: Double
    let pressure: Double
    let windspeed: Double
    
    var temperatureString: String {
        return String(format: "%.0f", temperature)
    }
    
    var temperatureMinString: String {
        return String(format: "%.0f", temperatureMin)
    }
    
    var temperatureMaxString: String {
        return String(format: "%.0f", temperatureMax)
    }
    
    var feelsLikeString: String {
        let feelslikeStringFormatted = String(format: "%.0f", feels_like)
            return feelslikeStringFormatted + "°C"
        }
    
    var sunriseString: String {
        let sunriseTime = Date(timeIntervalSince1970: sunrise)
        let dateFormatter = DateFormatter()
        dateFormatter .dateFormat = "HH:mm"
        print(dateFormatter.string(from: sunriseTime))
        return dateFormatter.string(from: sunriseTime)
    }
    
    var sunsetString: String {
        let sunsetTime = Date(timeIntervalSince1970: sunset)
        let dateFormatter = DateFormatter()
        dateFormatter .dateFormat = "HH:mm"
        print(dateFormatter.string(from: sunsetTime))
        return dateFormatter.string(from: sunsetTime)
    }
     
    var humidityString: String {
        let humidityStringFormatted = String(format: "%.0f", humidity)
        return humidityStringFormatted + "%"
    }
    
    var pressureString: String {
        let pressureStringFormatted = String(format: "%.0f", pressure)
        return pressureStringFormatted + " hpa"
    }
    
    // let windKmh = windspeed *1,6
    var windspeedString: String {
        let windspeedStringFormatted = String(format: "%.2f", windspeed)
        return windspeedStringFormatted + " m/s"
    }
    
    func unixTimestampToTimeString(unixTimestamp: Double) -> String {
        let date = Date(timeIntervalSince1970: unixTimestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm" // "HH" für 24-Stunden-Format, "hh" für 12-Stunden-Format mit AM/PM
        
        return dateFormatter.string(from: date)
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
    }

