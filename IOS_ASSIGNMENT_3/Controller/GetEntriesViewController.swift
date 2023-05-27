import UIKit

class GetEntriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    var date: Date?
    var formmattedDate: String?
    let cellReuseIdentifier = "cell"

    @IBOutlet weak var entriesTable: UITableView!
    @IBOutlet weak var filterTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!

    var entries = [String: [EntryManager.Entry]]()
    var filteredEntries = [String: [EntryManager.Entry]]()
    var entryManager =  EntryManager()


    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        // Do any additional setup after loading the view.

        dateLabel.text = formmattedDate
        self.entriesTable.register(CustomTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        entriesTable.delegate = self
        entriesTable.dataSource = self
        entries = entryManager.readEntries()
        filteredEntries = entries
        filterTextField.delegate = self
        filterTextField.addTarget(self, action: #selector(filterTextFieldDidChange(_:)), for: .editingChanged)
        entriesTable.layer.cornerRadius = 14.0
        entriesTable.layer.masksToBounds = true
        entriesTable.reloadData()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true //make sure keyboard disapears when return key pressed on mobile
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


    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredEntries[formmattedDate!]?.count ?? 0 //return number entries if entires do not exist return 0
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // There is just one row in every section
        return 1
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { //header height
    return 40
    }


  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {   // Make the background color show through
      let headerView = UIView()
      headerView.backgroundColor = UIColor.clear
      return headerView
  }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let entryArrays = self.entries[formmattedDate!]
        let currentEntry = entryArrays![indexPath.section]
        
        let text = currentEntry.text as NSString
           let labelWidth = tableView.frame.width - 32 //label width
           let titleLabelHeight: CGFloat = 20 //title height
           let font = UIFont.systemFont(ofSize: 17) //font size
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

            // Check if there are any remaining entries for that date
            if sectionEntries.isEmpty {
                entries.removeValue(forKey: formmattedDate!)
                filteredEntries.removeValue(forKey: formmattedDate!)
            }

            // Save the updated entries to UserDefaults or any other storage mechanism
            entryManager.writeEntry(entries: entries)

            // Reload the table view
            entriesTable.reloadData()
        }
    }



    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! CustomTableViewCell
        let entryArrays = filteredEntries[formmattedDate!]
        let entry = entryArrays![indexPath.section]
        cell.titleLabel.text = entry.mood
        cell.entryLabel.text = entry.text
        
        cell.layer.borderColor = setBorderColor(entryMood: entry.mood)
        
        let customColor = UIColor(red: 250.0/255.0, green: 250.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        cell.backgroundColor = customColor
        cell.layer.borderWidth = 2.2
        cell.layer.cornerRadius = 14
        cell.contentView.clipsToBounds = true
        
        
        // Add "X" button
        let button = UIButton(type: .system)
        let deleteImage = UIImage(systemName: "xmark") // Use the system icon "xmark"
        button.setImage(deleteImage, for: .normal)
        button.tintColor = UIColor.black //color
        button.frame = CGRect(x: cell.bounds.width - 30, y: 10, width: 20, height: 20) //size and positioning
        button.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
        button.tag = indexPath.section
        cell.addSubview(button)
        
        return cell
    }
    
    func setBorderColor(entryMood:String) -> CGColor {
        switch entryMood{
        case "Unhappy":
           return UIColor.systemOrange.cgColor
        case "Sad":
            return UIColor.systemTeal.cgColor
        case "Neutral":
            return UIColor.systemPurple.cgColor
        case "Good":
            return UIColor.systemGreen.cgColor
        case "Joy":
            return UIColor.systemYellow.cgColor
        default:
            return UIColor.black.cgColor
        }
        
    }
}
