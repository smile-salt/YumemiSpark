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
        
        setupWeatherDetailCallbacks()
        
    }
    
    func setupWeatherDetailCallbacks() {
        weatherDetail.onWeatherError = handleWeatherError
        weatherDetail.onWeatherCondition = handleWeatherCondition
        weatherDetail.onMaxTemperature = handleMaxTemperature
        weatherDetail.onMinTemperature = handleMinTemperature
    }
    
    @objc func reloadWeather() {
        Task{
            await weatherDetail.setWeatherInfo()
        }
    }
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func reloadButton(_ sender: Any) {
        indicator.startAnimating()
        Task{
            await weatherDetail.setWeatherInfo()
        }
    }
    
    
}

extension ViewController {
    func handleWeatherError(alert: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: alert, message: "時間をおいてもう一度お試しください", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.indicator.stopAnimating()
        }
        
    }
    
    func handleWeatherCondition(type: String) {
        var weatherName = "sunny"
        var tintColor = UIColor.red
        
        switch type {
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
            self.indicator.stopAnimating()
        }
        
    }
    
    func handleMaxTemperature(max: Int) {
        DispatchQueue.main.async {
            self.maxTemperature.text = String(max)
        }
    }
    
    func handleMinTemperature(min: Int) {
        DispatchQueue.main.async {
            self.minTemperature.text = String(min)
        }
    }
}
