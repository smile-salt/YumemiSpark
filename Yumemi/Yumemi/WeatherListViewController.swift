//
//  StartListController.swift
//  Yumemi
//
//  Created by 山本雅浩 on 2024/01/22.
//

import UIKit

class StartListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var weatherList: UITableView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    let weatherDetailList = WeatherDetailList()
    var areas: [AreaResponse] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: UIControl.Event.valueChanged)
        weatherList.refreshControl = refreshControl
        
        weatherList.delegate = self
        weatherList.dataSource = self
        
        indicator.hidesWhenStopped = true
        fetchWeatherList()
        
    }
    
    @objc func refreshTableView() {
        weatherList.refreshControl?.endRefreshing()
        fetchWeatherList()
    }
    
    func fetchWeatherList() {
        Task {
            indicator.startAnimating()
            let result = await weatherDetailList.setWeatherList()
            indicator.stopAnimating()
            switch result {
            case .success(let areas):
                self.areas = areas
                weatherList.reloadData()
            case .failure(let error):
                self.showError(alert: "Error: \(error.localizedDescription)")
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return areas.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let weatherList = areas[indexPath.row]
        cell.textLabel?.text = weatherList.area.rawValue
        let maxTemp = weatherList.info.max_temperature
        let minTemp = weatherList.info.min_temperature
        cell.detailTextLabel?.text = "最高気温: \(maxTemp)度, 最低気温: \(minTemp)度"
        
        switch weatherList.info.weather_condition {
        case "sunny":
            cell.imageView?.image = UIImage(named: "sunny")
            cell.imageView?.tintColor = UIColor.red
        case "cloudy":
            cell.imageView?.image = UIImage(named: "cloudy")
            cell.imageView?.tintColor = UIColor.gray
        case "rainy":
            cell.imageView?.image = UIImage(named: "rainy")
            cell.imageView?.tintColor = UIColor.blue
        default:
            break
        }
        return cell
        
    }
    
    func showError(alert: String) {
        let alert = UIAlertController(title: alert, message: "時間をおいてもう一度お試しください", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "リトライ", style: .default, handler: { action in
            self.fetchWeatherList()
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail",
           let indexPath = weatherList.indexPathForSelectedRow,
           let destination = segue.destination as? ViewController {
            destination.area = areas[indexPath.row]
        }
    }
    
}

