//
//  WeatherCollectionViewController.swift
//  Yumemi
//
//  Created by school06 on 2024/01/25.
//

import UIKit

class WeatherCollectionViewController: UIViewController, UICollectionViewDataSource{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    let weatherDetailList = WeatherDetailList()
    var areas: [AreaResponse] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.hidesWhenStopped = true
        collectionView.delegate = self
        collectionView.dataSource = self
        
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
                collectionView.reloadData()
            case .failure(let error):
                self.showError(alert: "Error: \(error.localizedDescription)")
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return areas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "startCollectionViewCell", for: indexPath) as? WeatherCollectionViewCell else {
            let errorCell = UICollectionViewCell()
            return errorCell
        }
        
        let weatherList = areas[indexPath.row]
        
        switch weatherList.info.weather_condition {
        case "sunny":
            cell.weatherImageView.image = UIImage(named: "sunny")
            cell.weatherImageView.tintColor = UIColor.red
        case "cloudy":
            cell.weatherImageView.image = UIImage(named: "cloudy")
            cell.weatherImageView.tintColor = UIColor.gray
        case "rainy":
            cell.weatherImageView.image = UIImage(named: "rainy")
            cell.weatherImageView.tintColor = UIColor.blue
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
        if segue.identifier == "showDetail" {
            if let indexPath = collectionView.indexPathsForSelectedItems?.first {
                guard let destination = segue.destination as? ViewController else {
                    fatalError("Failed to prepare ViewController.")
                }
                destination.area = areas[indexPath.row]
            }
        }
    }

}

extension WeatherCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 端末サイズの半分のwidthとheightにして2列にする
        let width: CGFloat = collectionView.frame.width / 2
        let height = width
        return CGSize(width: width, height: height)
    }
    
    // 間の線
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
