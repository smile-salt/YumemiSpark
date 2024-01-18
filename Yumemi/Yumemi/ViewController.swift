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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherDetail.delegate = self
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reloadWeather),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        
    }
    
    @objc func reloadWeather() {
        weatherDetail.setWeatherInfo()
    }
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func reloadButton(_ sender: Any) {
        weatherDetail.setWeatherInfo()
    }
    
}

extension ViewController: YumemiDelegate {
    
    func setWeatherError(alert: String) {
        let alert = UIAlertController(title: alert, message: "時間をおいてもう一度お試しください", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }
    
    func setWeatherCondition(type: String) {
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
        weatherImage.image = UIImage(named: weatherName)
        weatherImage.tintColor = tintColor
        
    }
    
    func setMaxTemperature(max: Int) {
        maxTemperature.text = String(max)
    }
    
    func setMinTemperature(max: Int) {
        minTemperature.text = String(max)
    }
    
}
