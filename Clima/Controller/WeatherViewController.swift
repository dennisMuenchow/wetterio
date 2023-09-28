
import UIKit
import CoreLocation
import Dispatch

class WeatherViewController: UIViewController, WeatherManagerDelegate, UITableViewDelegate, UITableViewDataSource  {
    
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tempMinLabel: UILabel!
    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var View0101: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ButtonTest: UIButton!
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        tableView.reloadData()
    }
    
    
    var weather: WeatherModel?
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    let labelArray = ["DETAILS", "GEFÜHLT", "SONNENAUFGANG", "SONNENUNTERGANG", "LUFTDRUCK", "FEUCHTIGKEIT", "WINDGESCHWINDIGKEIT"]
    let iconArray = ["","thermometer.sun", "sunrise", "sunset", "barometer", "drop", "wind"]
    
    var detailsArray: [String] = ["1","2","3","4","5","6","7"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 20
        tableView.backgroundColor = UIColor.clear
        
        let blurEffect = UIBlurEffect(style: .regular) // Du kannst den Stil anpassen
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = tableView.bounds
        blurEffectView.alpha = 1
        
        tableView.backgroundView = blurEffectView
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        weatherManager.delegate = self
        searchTextField.delegate = self
        tableView.reloadData()
        
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)  {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.tempMinLabel.text = "\(weather.temperatureMinString)°"
            self.tempMaxLabel.text = "\(weather.temperatureMaxString)°"
            
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.backgroundImage.image = UIImage(named: weather.conditionName)
            //self.backgroundImage.image = UIImage(named: "cloud.fog")
            self.cityLabel.text = weather.cityName
            self.descriptionLabel.text = weather.descr
            
            var feelslikeValue = weather.feelsLikeString
            var sunriseValue = weather.sunriseString
            var sunsetValue = weather.sunsetString
            var pressureValue = weather.pressureString
            var humidityValue = weather.humidityString
            var windspeedValue = weather.windspeedString
            
            self.detailsArray = ["", feelslikeValue, sunriseValue, sunsetValue, pressureValue, humidityValue, windspeedValue]
            //self.detailsArray = ["1", "2", "3", "4", "5", "6", "7", "8", "1", "2", "3", "4", "5", "6", "7", "8", "1", "2", "3", "4", "5", "6", "7", "8"]
            
            
            //print(self.feelslikeValue)

            
            //print(self.cityName2)
            self.tableView.reloadData()
            print(self.detailsArray)

            
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you tapped me")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labelArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "feelslikeCell", for: indexPath)
        cell.textLabel?.text = labelArray[indexPath.row]
        cell.imageView?.image = UIImage(systemName: iconArray[indexPath.row])
        cell.backgroundColor = UIColor.clear
        cell.detailTextLabel?.text = detailsArray[indexPath.row]
        //print(detailsArray[0])
        return cell

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

// UITextFieldDelegate ist ein Protokoll --> erlaubt uns, hier vorgefertige Funktionen zu nutzen
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
