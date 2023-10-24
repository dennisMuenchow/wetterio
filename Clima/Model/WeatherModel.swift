
import Foundation


struct WeatherModel {
    // Eigenschaften zur Speicherung von Wetterdaten
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
        let temperatureMinStringFormatted = String(format: "%.0f", temperatureMin)
        return "T:" + temperatureMinStringFormatted
    }
    
    var temperatureMaxString: String {
        let temperatureMaxStringFormatted = String(format: "%.0f", temperatureMax)
        return "H:" + temperatureMaxStringFormatted
    }
    
    var feelsLikeString: String {
        let feelslikeStringFormatted = String(format: "%.0f", feels_like)
        return feelslikeStringFormatted + "°C"
    }
    
    var humidityString: String {
        let humidityStringFormatted = String(format: "%.0f", humidity)
        return humidityStringFormatted + "%"
    }
    
    var pressureString: String {
        let pressureStringFormatted = String(format: "%.0f", pressure)
        return pressureStringFormatted + " hpa"
    }
    
    var windspeedString: String {
        let windspeedStringFormatted = String(format: "%.2f", windspeed)
        return windspeedStringFormatted + " m/s"
    }
    
    // Konvertiert Unix-Timestamp in Uhrzeit-String
    func unixTimestampToTimeString(unixTimestamp: Double) -> String {
        let date = Date(timeIntervalSince1970: unixTimestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm" // "HH" für 24-Stunden-Format, "hh" für 12-Stunden-Format mit AM/PM
        return dateFormatter.string(from: date)
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
    
    
    // Bestimmung WetterBedingung-ID
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud"
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
            return "cloud"
        default:
            return "cloud"
        }
    }
}

