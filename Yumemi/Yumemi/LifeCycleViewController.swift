//
//  LifeCycleViewController.swift
//  Yumemi
//
//  Created by school06 on 2024/01/18.
//

import UIKit

class LifeCycleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        performSegue(withIdentifier: "toMain", sender: nil)
        
    }


}
