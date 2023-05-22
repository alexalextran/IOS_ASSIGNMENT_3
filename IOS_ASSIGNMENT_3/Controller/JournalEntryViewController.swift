import UIKit
import Foundation

class JournalEntryViewController: UIViewController {
    @IBOutlet weak var currentDateLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        let today = Date()
        let formattedDate = dateFormatter.string(from: today)
        
        currentDateLabel.text = "Today is \(formattedDate)"
               
                

      
    }
}
