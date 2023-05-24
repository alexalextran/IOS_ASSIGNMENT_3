//
//  ViewController.swift
//  IOS_ASSIGNMENT_3
//
//  Created by Alex Tran on 18/5/2023.
//

import UIKit

class GetEntriesViewController: UIViewController {
    var date:Date?
    var formattedDate: String?
    @IBOutlet weak var dateLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        dateLabel.text = formattedDate
    }
   
 


}

