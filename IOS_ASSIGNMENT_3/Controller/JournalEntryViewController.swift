import UIKit

class JournalEntryViewController: UIViewController, UITextViewDelegate {
    
    
    @IBOutlet weak var currentDateLabel: UILabel!
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
        
        let dateFormatter = DateFormatter() //set current date label to current month as in May
        dateFormatter.dateFormat = "d MMMM yyyy"
        let today = Date()
        let formattedDate = dateFormatter.string(from: today)
        currentDateLabel.text = "Today is \(formattedDate)"
        
        let dateShortFormatter = DateFormatter()  //set current date e.g 04/03/2023
        dateShortFormatter.dateFormat = "dd/MM/yyyy"
        currentDate = dateShortFormatter.string(from: today)
        
        entryTextBox.layer.cornerRadius = 14
        entryTextBox.layer.masksToBounds = true
       
        entryTextBox.layer.borderWidth = 0
        entryTextBox.layer.borderColor = UIColor.gray.cgColor
        
        // Add button actions
       addActionButtons()
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
                saveButton.isEnabled = false // if either selectedMood is empty or the text is empty disable button
            } else if entryTextBox.text?.isEmpty == false && selectedMood != nil {
                    saveButton.isEnabled = true // else if selected mood and text is not empty enable save button
            }
        }
    
    @objc func buttonTapped(_ sender: UIButton) {
        
        if let selectedButton = selectedButton {
            // Deselect the previously selected button
            selectedButton.backgroundColor = UIColor.clear
        }
        self.selectedButton = sender
        handleMoods(button: sender)
        updateSaveButtonState()
        
    }
    
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        // Clear the text and reset the selected mood
        entryTextBox.text = ""
        selectedMood = nil
        unhappyButton.backgroundColor = UIColor.clear
        sadButton.backgroundColor = UIColor.clear
        neutralButton.backgroundColor = UIColor.clear
        goodButton.backgroundColor = UIColor.clear
        joyButton.backgroundColor = UIColor.clear
        updateSaveButtonState()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDRecap" { //send over text, mood and date data to Drecap controller
            let VC = segue.destination as! DRecapViewController
            VC.textE = entryTextBox.text!
            VC.moodE = selectedMood!
            VC.formmattedDate = currentDate;
        }
    }
    
    func handleMoods(button: UIButton){
        switch button.titleLabel!.text! { //update SelectedMood and background color for mood buttons
        case "😡":
         selectedMood = "Unhappy"
            button.backgroundColor = UIColor.systemRed
        case "☹️":
         selectedMood = "Sad"
            button.backgroundColor = UIColor.systemTeal
        case "😐":
        selectedMood = "Neutral"
            button.backgroundColor = UIColor.systemPurple
        case "😄":
        selectedMood = "Good"
            button.backgroundColor = UIColor.systemGreen
        case "🤩":
        selectedMood = "Joy"
            button.backgroundColor = UIColor.systemYellow
        default:
        selectedMood = nil
            button.backgroundColor = UIColor.clear
        }
    }
    
    func addActionButtons(){
        unhappyButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        sadButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        neutralButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        goodButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        joyButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }
}
