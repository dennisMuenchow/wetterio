
import UIKit
import CoreLocation
import Dispatch

class WeatherViewController: UIViewController, WeatherManagerDelegate {
    
    // Outlets für UI-Elemente
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tempMinLabel: UILabel!
    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var blurEffectView: UIVisualEffectView!
    
    // Daten- und Manager-Variablen
    private var weather: WeatherModel?
    private var weatherManager = WeatherManager()
    private let locationManager = CLLocationManager()
    
    // Arrays für Labels und Icons
    private let labelArray = ["DETAILS", "GEFÜHLT", "SONNENAUFGANG", "SONNENUNTERGANG", "LUFTDRUCK", "FEUCHTIGKEIT", "WINDGESCHWINDIGKEIT"]
    private let iconArray = ["","thermometer.sun", "sunrise", "sunset", "barometer", "drop", "wind"]
    private var detailsArray = Array(repeating: "", count: 7)
    
    // Funktion zum Aktivieren/Deaktivieren des Blur-Effekts
    func toggleBlurEffect(_ isEnabled: Bool) {
        if isEnabled {
            let blurEffect = UIBlurEffect(style: .regular)
            blurEffectView.effect = blurEffect
            blurEffectView.alpha = 0.5
        } else {
            blurEffectView.effect = nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TableView-Konfiguration
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 20
        tableView.backgroundColor = UIColor.clear
        
        // Aktiviere den Blur-Effekt im tableView-Hintergrund
        toggleBlurEffect(true)
        
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = tableView.bounds
        blurEffectView.alpha = 1
        tableView.backgroundView = blurEffectView
        
        // Standortverfolgung initialisieren
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        // Delegate-Zuweisungen und Datenquelle für die Suche
        weatherManager.delegate = self
        searchTextField.delegate = self
        
        // Aktualisierung tableView
        tableView.reloadData()
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    // Funktionen für das WeatherManagerDelegate-Protokoll
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)  {
        
        // Aktualisiere die UI mit den Wetterdaten
        DispatchQueue.main.async {
    
            self.temperatureLabel.text = weather.temperatureString
            self.tempMinLabel.text = "\(weather.temperatureMinString)°"
            self.tempMaxLabel.text = "\(weather.temperatureMaxString)°"
            
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.backgroundImage.image = UIImage(named: weather.conditionName)
            self.cityLabel.text = weather.cityName
            self.descriptionLabel.text = weather.descr
            
            let feelslikeValue = weather.feelsLikeString
            let sunriseValue = weather.sunriseString
            let sunsetValue = weather.sunsetString
            let pressureValue = weather.pressureString
            let humidityValue = weather.humidityString
            let windspeedValue = weather.windspeedString
            self.detailsArray = ["", feelslikeValue, sunriseValue, sunsetValue, pressureValue, humidityValue, windspeedValue]
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])  {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
             weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate{
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true) //Keyboard ausblenden
    }
    
    // Funktion die ausgeführt wird, wenn Return-Button auf dem Keyboard gedrückt wird
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    // Test, ob User etwas eingegeben hat
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        } else {
            textField.placeholder = "bitte Stadt eingeben"
            return false
        }
    }
    
    // Textfield leeren nach Eingabe
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
}

//MARK: - UITableView

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "feelslikeCell", for: indexPath)
        cell.textLabel?.text = labelArray[indexPath.row]
        cell.imageView?.image = UIImage(systemName: iconArray[indexPath.row])
        cell.backgroundColor = UIColor.clear
        cell.detailTextLabel?.text = detailsArray[indexPath.row]
        return cell
    }
}
