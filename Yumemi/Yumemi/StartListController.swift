//
//  StartListController.swift
//  Yumemi
//
//  Created by 山本雅浩 on 2024/01/22.
//

import UIKit

class StartListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var weatherList: UITableView!
    
    let weatherDetail = WeatherDetail()
    var weatherData = Array<WeatherList>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherList.delegate = self
        weatherList.dataSource = self
        
        getWeatherData()
    }
    
    func reloadWeather() async {
        indicator.startAnimating()
        let result = await weatherDetail.setWeatherInfo()
        
        self.indicator.stopAnimating()
        
        switch result {
        case .success(let (weather, max, min)):
            self.complitionWeather(weather: weather, max: max, min: min)
        case .failure(let error):
            self.completionWeatherError(alert: "Error: \(error.localizedDescription)")
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        //n番目のセルに表示するデータを取得する
        let weatherList = weatherData[indexPath.row]
        cell.textLabel?.text = weatherList.area
        let maxTemp = weatherList.info.max_temperature
        let minTemp = weatherList.info.min_temperature
        cell.detailTextLabel?.text = "最高気温: \(maxTemp)度, 最低気温: \(minTemp)度"
        
        //天気によって表示させる画像を変える
        var weatherName = "sunny"
        var tintColor = UIColor.red
        
        switch weather {
        case "sunny":
            weatherName = "sunny"
            cell.tintColor = UIColor.red
        case "cloudy":
            weatherName = "cloudy"
            cell.tintColor = UIColor.gray
        case "rainy":
            weatherName = "rainy"
            cell.tintColor = UIColor.blue
        default:
            break
        }
        return cell
    }
    func setWeatherError(alertMessage: String) {
        let alert = UIAlertController(title: "エラー", message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
            self.getWeatherData()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedWeatherList = weatherData[indexPath.row]
        performSegue(withIdentifier: "Cell", sender: selectedWeatherList)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Cell" {
            if let destinationVC = segue.destination as? ViewController,
               let selectedWeatherList = sender as? StartListController {
                destinationVC.selectedWeatherList = selectedWeatherList
            }
        }
    }
}

