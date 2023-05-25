//
//  ViewController.swift
//  IOS_ASSIGNMENT_3
//
//  Created by Alex Tran on 18/5/2023.
//

import UIKit

extension NSString {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.height)
    }
}


class DRecapViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var moodE:String?
    var textE:String?
    var formmattedDate:String?
    
    struct Entry: Codable{
        var mood:String
        var text:String
    }
    var entries = [String: [Entry]]()
    let KEY_DAILY_ENTRIES = "dailyEntries"
    
    
    var filteredEntries = [String: [Entry]]()
    let cellReuseIdentifier = "cell"
    let cellSpacingHeight: CGFloat = 5
 
    
    @IBOutlet weak var entriesTable: UITableView!
    @IBOutlet weak var filterTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        entries = readEntries()
        writeEntry();
        
        filteredEntries = entries

        filterTextField.delegate = self
        filterTextField.addTarget(self, action: #selector(filterTextFieldDidChange(_:)), for: .editingChanged)
            
     
        self.entriesTable.register(CustomTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
              entriesTable.delegate = self
              entriesTable.dataSource = self
    }
    
    
    // Filter entries when the filter text field value changes
    @objc func filterTextFieldDidChange(_ textField: UITextField) {
        let searchText = textField.text ?? ""
        if searchText.isEmpty {
            filteredEntries = entries
        } else {
            filteredEntries = entries.mapValues { $0.filter { $0.text.contains(searchText) } }
        }
        entriesTable.reloadData()
    }
    
    
    func writeEntry() {
        let userDefaults = UserDefaults.standard
        let newEntry = Entry(mood: moodE!, text: textE!)

        if entries[formmattedDate!] != nil {
            entries[formmattedDate!]!.append(newEntry)
        } else {
            entries[formmattedDate!] = [newEntry]
        }

        userDefaults.set(try? PropertyListEncoder().encode(entries), forKey: KEY_DAILY_ENTRIES)
    }

    

    //retrieve entries from the database
    func readEntries()-> [String: [Entry]]{
        let defaults = UserDefaults.standard
        
        if let savedArrayData = defaults.value(forKey: KEY_DAILY_ENTRIES) as? Data{ if let array = try? PropertyListDecoder().decode([String: [Entry]].self,from: savedArrayData) {
            return array
        } else {
            return [:]
        }
        } else{
            return [:]
        }
    }

    
    // Set the spacing between sections
   
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        filterTextField.resignFirstResponder()
        return true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredEntries[formmattedDate!]?.count ?? 0
        }
        
        // There is just one row in every section
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    // Make the background color show through
      func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
          let headerView = UIView()
          headerView.backgroundColor = UIColor.clear
          return headerView
      }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let entryArrays = self.entries[formmattedDate!]
        let currentEntry = entryArrays![indexPath.section]
        
        let text = currentEntry.text as NSString
           let labelWidth = tableView.frame.width - 32 // Adjust the width as per your layout
           let titleLabelHeight: CGFloat = 20 // Adjust the height of the title label as per your preference
           let font = UIFont.systemFont(ofSize: 17) // Adjust the font size as per your preference
        let entryHeight = text.height(withConstrainedWidth: labelWidth, font: font)
           let cellHeight = titleLabelHeight + entryHeight + 44 // Add extra padding as per your preference

           return cellHeight
       }
    
    @objc func deleteButtonTapped(_ sender: UIButton) {
        let section = sender.tag // Get the section index from the button's tag
        let entryArrays = self.entries[formmattedDate!]
        
        if var sectionEntries = entryArrays, sectionEntries.indices.contains(section) {
            sectionEntries.remove(at: section) // Remove the entry from the array
            
            // Update the entries and filteredEntries dictionaries
            entries[formmattedDate!] = sectionEntries
            filteredEntries[formmattedDate!] = sectionEntries
            
            // Save the updated entries to UserDefaults or any other storage mechanism
            let userDefaults = UserDefaults.standard
            userDefaults.set(try? PropertyListEncoder().encode(entries), forKey: KEY_DAILY_ENTRIES)
            
            // Reload the table view
            entriesTable.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! CustomTableViewCell
        let entryArrays = self.entries[formmattedDate!]
        let entry = entryArrays![indexPath.section]
        cell.titleLabel.text = entry.mood
        cell.entryLabel.text = entry.text
        
        cell.backgroundColor = UIColor.white
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 14
       
        cell.contentView.frame = cell.contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 100, bottom: 0, right: 100))
           cell.contentView.clipsToBounds = true
        
        // Add "X" button
        let button = UIButton(type: .system)
        let deleteImage = UIImage(systemName: "xmark") // Use the system icon "xmark"
        button.setImage(deleteImage, for: .normal)
        button.tintColor = UIColor.black // Set the tint color to black
        button.frame = CGRect(x: cell.bounds.width - 30, y: 10, width: 20, height: 20) // Adjust the button's frame as per your preference
        button.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside) // Add target action
        button.tag = indexPath.section // Set the tag to identify the button

        cell.addSubview(button)
        
        return cell
    }







}
