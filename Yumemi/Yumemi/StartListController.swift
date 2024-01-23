//
//  StartListController.swift
//  Yumemi
//
//  Created by 山本雅浩 on 2024/01/22.
//

import UIKit

class StartListController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    
    @IBOutlet weak var weatherList: UITableView!
    
    let weatherDetailList = WeatherDetailList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherList.delegate = self
        weatherList.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    }
}

