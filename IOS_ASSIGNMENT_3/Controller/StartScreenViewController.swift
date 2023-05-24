//
//  ViewController.swift
//  IOS_ASSIGNMENT_3
//
//  Created by Alex Tran on 18/5/2023.
//

import UIKit

class StartScreenViewController: UIViewController {
    /*override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait // Set the desired orientation to portrait only
    }*/
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
 
    override var shouldAutorotate: Bool {
        return false // Disable auto rotation
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait // Set the desired orientation (e.g., portrait)
    }


}

