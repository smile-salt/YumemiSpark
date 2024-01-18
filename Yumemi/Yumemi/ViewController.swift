//
//  ViewController.swift
//  Yumemi
//
//  Created by school06 on 2024/01/18.
//

import UIKit
import YumemiWeather

class ViewController: UIViewController {

    @IBOutlet weak var weatherImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func reloadButton(_ sender: Any) {
        setWeatherImage()
    }
    
    func setWeatherImage() {
        let responseWeatherString = YumemiWeather.fetchWeatherCondition()
        
        var weatherName = "sunny"
        var tintColor = UIColor.red
        
        switch responseWeatherString {
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
}

