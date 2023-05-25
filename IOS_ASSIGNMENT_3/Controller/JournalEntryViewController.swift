import UIKit

class JournalEntryViewController: UIViewController, UITextViewDelegate {
    
    
    @IBOutlet weak var currentDateLabel: UILabel!
//    @IBOutlet weak var entryTextBox: UITextField!
    @IBOutlet weak var entryTextBox: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var unhappyButton: UIButton!
    @IBOutlet weak var sadButton: UIButton!
    @IBOutlet weak var neutralButton: UIButton!
    @IBOutlet weak var goodButton: UIButton!
    @IBOutlet weak var joyButton: UIButton!
    
    @IBOutlet weak var textBox: UITextField!
    
    var selectedButton: UIButton?
    var selectedMood: String?
    var currentDate: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.isEnabled = false
        entryTextBox.delegate = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        let today = Date()
        let formattedDate = dateFormatter.string(from: today)
        
        currentDateLabel.text = "Today is \(formattedDate)"
        
        let dateShortFormatter = DateFormatter()
        dateShortFormatter.dateFormat = "dd/MM/yyyy"
        currentDate = dateShortFormatter.string(from: today)
       
        entryTextBox.layer.borderWidth = 1.5
              entryTextBox.layer.borderColor = UIColor.black.cgColor
        
        // Add button actions
        unhappyButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        sadButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        neutralButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        goodButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        joyButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
           if text == "\n" {
               textView.resignFirstResponder() // Close the keyboard when Return is pressed
               updateSaveButtonState()
               return false
           }
        updateSaveButtonState()
           return true
      
       }
    
    func updateSaveButtonState() {
            if entryTextBox.text?.isEmpty == true || selectedMood == nil {
                saveButton.isEnabled = false
            } else if entryTextBox.text?.isEmpty == false && selectedMood != nil {
                    saveButton.isEnabled = true
            }
        }
    
    @objc func buttonTapped(_ sender: UIButton) {
        if let selectedButton = selectedButton {
            // Deselect the previously selected button
            selectedButton.backgroundColor = UIColor.systemBackground
            
        }
        
        
            // Tapped a different button, update the selected button and its background color
        self.selectedButton = sender
            
        
        
        switch sender.titleLabel!.text! {
        case "😡":
         selectedMood = "Unhappy"
            sender.backgroundColor = UIColor.systemOrange
        case "☹️":
         selectedMood = "Sad"
        sender.backgroundColor = UIColor.systemTeal
        case "😐":
        selectedMood = "Neutral"
        sender.backgroundColor = UIColor.systemPurple
        case "😄":
        selectedMood = "Good"
        sender.backgroundColor = UIColor.systemGreen
        case "🤩":
        selectedMood = "Joy"
        sender.backgroundColor = UIColor.systemYellow
        default:
        selectedMood = "Error"
        }
       
        updateSaveButtonState()
        print(sender.titleLabel!.text!)
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDRecap" {
            let VC = segue.destination as! DRecapViewController
            VC.textE = entryTextBox.text!
            VC.moodE = selectedMood ?? "no mood selected (TODO)"
            VC.formmattedDate = currentDate;
        }
    }
}
