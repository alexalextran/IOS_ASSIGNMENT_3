import UIKit
import Foundation

class JournalEntryViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var entryTextBox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        entryTextBox.delegate = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        let today = Date()
        let formattedDate = dateFormatter.string(from: today)
        
        currentDateLabel.text = "Today is \(formattedDate)"
               
      
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        entryTextBox.resignFirstResponder()
        return true;
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToDRecap"){
            let VC = segue.destination as! DRecapViewController
            VC.entry = entryTextBox.text!
            
        }
    }
}
