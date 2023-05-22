//
//  ViewController.swift
//  IOS_ASSIGNMENT_3
//
//  Created by Alex Tran on 18/5/2023.
//
import UIKit

class EntryRecapViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up the collection view
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // Implement UICollectionViewDataSource methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Return the number of days in the month
        return 31 // Implement your own logic to determine the number of days
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as! DateCell
        let day = indexPath.item + 1
        cell.dateLabel.text = "\(day)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedDay = indexPath.item + 1
        let selectedMonth = 5 // Assuming May for this example
        let selectedYear = 2023 // Assuming the current year for this example
        
        // Create a date using the selected day, month, and year
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = selectedYear
        dateComponents.month = selectedMonth
        dateComponents.day = selectedDay
        selectedDate = calendar.date(from: dateComponents)
        
        performSegue(withIdentifier: "ShowDateDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDateDetail" {
            if let destinationVC = segue.destination as? DateDetailViewController {
                destinationVC.selectedDate = selectedDate
            }
        }
    }
}

class DateDetailViewController: UIViewController {
    @IBOutlet weak var dateLabel: UILabel!
    
    var selectedDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectedDate = selectedDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy"
            let formattedDate = dateFormatter.string(from: selectedDate)
            dateLabel.text = formattedDate
        }
    }
}

import UIKit

class DateCell: UICollectionViewCell {
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        // Customize the appearance of the cell
        // For example, you can set the label's font, text color, etc.
    }
}


