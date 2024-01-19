//
//  ViewController.swift
//  Yumemi
//
//  Created by school06 on 2024/01/18.
//

import UIKit

class ViewController: UIViewController {
    
    let weatherDetail = WeatherDetail()
    
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var maxTemperature: UILabel!
    @IBOutlet weak var minTemperature: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicator.hidesWhenStopped = true
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reloadWeather),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        
        weatherDetail.handleWeatherCondition = {weatherImage, maxTemperature, minTemperature
            in
            self.complitionWeather(weather: weatherImage, max: maxTemperature, min: minTemperature)
        }
        
        weatherDetail.handleWeatherErrorMessage = {errormessage
            in
            self.complitionWeatherError(alert: errormessage)
        }
        
    }
    
    @objc func reloadWeather() {
        weatherDetail.setWeatherInfo(handle: complitionWeather(weather:max:min:))
    }
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func reloadButton(_ sender: Any) {
        indicator.startAnimating()
        weatherDetail.setWeatherInfo(handle: complitionWeather(weather:max:min:))
    }
    
}

extension ViewController {
    func complitionWeatherError(alert: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: alert, message: "時間をおいてもう一度お試しください", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.indicator.stopAnimating()
        }
        
    }
    
    func complitionWeather(weather: String, max: Int, min: Int) {
        var weatherName = "sunny"
        var tintColor = UIColor.red
        
        switch weather {
        case "sunny":
            weatherName = "sunny"
            tintColor = UIColor.red
        case "cloudy":
            weatherName = "cloudy"
            tintColor = UIColor.gray
        case "rainy":
            weatherName = "rainy"
            tintColor = UIColor.blue
        default:
            break
        }
        DispatchQueue.main.async {
            self.weatherImage.image = UIImage(named: weatherName)
            self.weatherImage.tintColor = tintColor
            self.maxTemperature.text = String(max)
            self.minTemperature.text = String(min)
            self.indicator.stopAnimating()
        }
        
    }
}
