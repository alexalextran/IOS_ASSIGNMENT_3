//  IOS_ASSIGNMENT_3
//
//  Created by Alex Tran on 12/5/2023.
//

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
    let dateFunctions = DateFunctions()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.isEnabled = false
        entryTextBox.delegate = self
        
        currentDateLabel.text = "Today is \(dateFunctions.getCurrentDate())"
        currentDate = dateFunctions.getCurrentDate()
        
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
    
    
    func updateSaveButtonState() { //ensures users cannot submit empty entries
            if entryTextBox.text?.isEmpty == true || selectedMood == nil {
                saveButton.isEnabled = false // if either selectedMood is empty or the text is empty disable button
            } else if entryTextBox.text?.isEmpty == false && selectedMood != nil {
                    saveButton.isEnabled = true // else if selected mood and text is not empty enable save button
            }
        }
    
    
    
    @objc func buttonTapped(_ sender: UIButton) { //handles mood buttons
        
        if let selectedButton = selectedButton {
            // deselect previous button
            selectedButton.backgroundColor = UIColor.clear
        }
        self.selectedButton = sender
        handleMoods(button: sender) //change selected mood depending on the button title
        updateSaveButtonState()
        
    }
    
    
    @IBAction func saveButtonTapped(_ sender: UIButton) { //resets everything, once submitted
        //clear all selected moods, textbox and selected buttons
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
    
    func handleMoods(button: UIButton){ //update SelectedMood and background color for mood buttons
        switch button.titleLabel!.text! {
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
