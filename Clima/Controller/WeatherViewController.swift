//
//  ViewController.swift Clima
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var wm: WeatherManager?
    let lm = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        lm.delegate = self
        wm = WeatherManager(d: self)
        
        lm.requestWhenInUseAuthorization()
        lm.requestLocation()
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let l = locations.last {
            let lat = l.coordinate.latitude
            let long = l.coordinate.longitude
            wm?.fetch(lat: lat, long: long)
        }
        
        print("updated")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("failed with error")
    }
}

extension WeatherViewController: WeatherManagerDelegate {
    @IBAction func currentLocationButtonPressed(_ sender: UIButton) {
        // Requesting location will cause the didUpdateLocation delegate method to be called
        lm.requestLocation()
        print("Location was requested")
    }
    
    func didUpdateWeather(wm: WeatherManager, w: WeatherModel) {
        DispatchQueue.main.async {
            // We need to stop the location manager once we update the weather
            self.lm.stopUpdatingLocation()
            self.temperatureLabel.text = w.temperatureString
            self.conditionImageView.image = UIImage(systemName: w.conditionName)
            self.cityLabel.text = w.name
        }
    }
    
    func didFailWithError(err: Error) {
        print(err)
    }
}

extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print(searchTextField.text)
        return true
    }
    
    @IBAction func search(_ sender: UIButton) {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = textField.text {
            wm?.fetch(city: city)
        }
        
        searchTextField.text = ""
    }
}
