//
//  ViewController.swift
//  Yumemi
//
//  Created by school06 on 2024/01/18.
//

import UIKit

class ViewController: UIViewController {
    
    let weatherDetail = WeatherDetail()
    var area: AreaResponse?
    
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var maxTemperature: UILabel!
    @IBOutlet weak var minTemperature: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicator.hidesWhenStopped = true
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        if let areaName = area?.area {
            navigationItem.title = areaName.rawValue
        }
        showData()
    }
    
    func showData() {
        guard let area = self.area else { return }
        
        var weatherName = "sunny"
        var tintColor = UIColor.red
        switch area.info.weather_condition {
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
        self.weatherImage.image = UIImage(named: weatherName)
        self.weatherImage.tintColor = tintColor
        self.maxTemperature.text = String(area.info.max_temperature)
        self.minTemperature.text = String(area.info.min_temperature)
    }
    
    @objc func appForeground() {
        Task{
            await reloadWeather()
        }
    }
    
    func reloadWeather() async {
        indicator.startAnimating()
        let result = await weatherDetail.setWeatherInfo()
        
        self.indicator.stopAnimating()
        
        switch result {
        case .success(let (weather, max, min)):
            self.completionWeather(weather: weather, max: max, min: min)
        case .failure(let error):
            self.completionWeatherError(alert: "Error: \(error.localizedDescription)")
        }
        
    }
    
    @IBAction func closeButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func reloadButton(_ sender: Any) {
        Task{
            await reloadWeather()
        }
    }
    
    func completionWeatherError(alert: String) {
        let alert = UIAlertController(title: alert, message: "時間をおいてもう一度お試しください", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func completionWeather(weather: String, max: Int, min: Int) {
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
        
        self.weatherImage.image = UIImage(named: weatherName)
        self.weatherImage.tintColor = tintColor
        self.maxTemperature.text = String(max)
        self.minTemperature.text = String(min)
        
    }
    
}
