import UIKit

class JournalEntryViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var entryTextBox: UITextField!
    //lol
    @IBOutlet weak var unhappyButton: UIButton!
    @IBOutlet weak var sadButton: UIButton!
    @IBOutlet weak var neutralButton: UIButton!
    @IBOutlet weak var goodButton: UIButton!
    @IBOutlet weak var joyButton: UIButton!
    
    var selectedButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        entryTextBox.delegate = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        let today = Date()
        let formattedDate = dateFormatter.string(from: today)
        
        currentDateLabel.text = "Today is \(formattedDate)"
        
        // Set default background color for buttons
        unhappyButton.backgroundColor = .lightGray
        sadButton.backgroundColor = .lightGray
        neutralButton.backgroundColor = .lightGray
        goodButton.backgroundColor = .lightGray
        joyButton.backgroundColor = .lightGray
        
        // Add button actions
        unhappyButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        sadButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        neutralButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        goodButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        joyButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        entryTextBox.resignFirstResponder()
        return true
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        guard let selectedButton = selectedButton else {
            // No previously selected button, set the tapped button as selected
            sender.backgroundColor = .darkGray
            self.selectedButton = sender
            return
        }
        
        if selectedButton == sender {
            // Tapped the selected button again, deselect it
            sender.backgroundColor = .lightGray
            self.selectedButton = nil
        } else {
            // Tapped a different button, update the selected button and its background color
            selectedButton.backgroundColor = .lightGray
            sender.backgroundColor = .darkGray
            self.selectedButton = sender
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDRecap" {
            let VC = segue.destination as! DRecapViewController
            VC.entry = entryTextBox.text!
        }
    }
}
