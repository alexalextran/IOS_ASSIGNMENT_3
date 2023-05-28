//  IOS_ASSIGNMENT_3
//
//  Created by Jason Vu on 12/5/2023.
//


import UIKit
import CoreLocation

class GuidanceViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var adviceLabel: UILabel!
    @IBOutlet weak var topStackView: UIStackView!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    var loadingTimer: Timer?
    var loadingCounter: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        
        topStackView.layer.cornerRadius = 8
        topStackView.clipsToBounds = true
        
        startLoadingAnimation()
    }
    
    func startLoadingAnimation() {
        loadingTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateCityLoadingLabel), userInfo: nil, repeats: true)
    }
    
    func stopLoadingAnimation() {
        loadingTimer?.invalidate()
        loadingTimer = nil
    }
    
    @objc func updateCityLoadingLabel() {
        var loadingText = "GATHERING STORM"
        
        for _ in 0..<loadingCounter {
            loadingText += "."
        }
        
        cityLabel.text = loadingText
        
        loadingCounter += 1
        if loadingCounter > 3 {
            loadingCounter = 0
        }
    }
}

extension GuidanceViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel){
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
            self.adviceLabel.text = weather.conditionAdvice
            
            self.stopLoadingAnimation()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
        DispatchQueue.main.async {
            self.cityLabel.text = "GATHERING STORM"
            self.stopLoadingAnimation()
        }
    }
}

extension GuidanceViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Got location data")
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitute: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        DispatchQueue.main.async {
            self.cityLabel.text = "GATHERING STORM"
            self.stopLoadingAnimation()
        }
    }
}
