
//  IOS_ASSIGNMENT_3
//
//  Created by Alex Tran on 12/5/2023.
//


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
        entriesTable.reloadData() //refresh entries table
    }


    func numberOfSections(in tableView: UITableView) -> Int { //populate entry tableiew
        return filteredEntries[formmattedDate!]?.count ?? 0
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {//make each entry as a section for spacing
        return 1
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { //heading height (spacing between each entry
    return 40
    }


  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {  //use heading as spacing by making them cleaar
      let headerView = UIView()
      headerView.backgroundColor = UIColor.clear
      return headerView
  }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { //set up entry height
        let entryArrays = self.entries[formmattedDate!]
        let currentEntry = entryArrays![indexPath.section]
        
        let text = currentEntry.text as NSString
           let labelWidth = tableView.frame.width - 32 //label width
           let titleLabelHeight: CGFloat = 20 //title height
           let font = UIFont.systemFont(ofSize: 18) //font size
            let entryHeight = text.height(withConstrainedWidth: labelWidth, font: font)
           let cellHeight = titleLabelHeight + entryHeight + 44 //padding

           return cellHeight //dynamic height based on text
       }
    
    
    @objc func deleteButtonTapped(_ sender: UIButton) { //handle delete button
        let section = sender.tag // get corresponding entry index from button
        let entryArrays = self.entries[formmattedDate!]

        if var sectionEntries = entryArrays, sectionEntries.indices.contains(section) {
            sectionEntries.remove(at: section) //remove entry from array

            // update entries dict
            entries[formmattedDate!] = sectionEntries
            filteredEntries[formmattedDate!] = sectionEntries

            // if there are no remaining entries for a date, remove the date itself from the dict
            if sectionEntries.isEmpty {
                entries.removeValue(forKey: formmattedDate!)
                filteredEntries.removeValue(forKey: formmattedDate!)
            }

            // update to database
            entryManager.writeEntry(entries: entries)

            // refresh tableview
            entriesTable.reloadData()
        }
    }



    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //set up cells
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! CustomTableViewCell
        let entryArrays = filteredEntries[formmattedDate!]
        let entry = entryArrays![indexPath.section]
        
        cell.titleLabel.text = entry.mood //set up entry labels
        cell.entryLabel.text = entry.text
        cell.titleLabel.textColor = UIColor.label
        cell.entryLabel.textColor = UIColor.label
        
        cell.layer.borderColor = setBorderColor(entryMood: entry.mood)
        cell.backgroundColor = UIColor(named: "lightDarkColor")
        cell.layer.borderWidth = 4
        cell.layer.cornerRadius = 14
        cell.contentView.clipsToBounds = true
        
        
        // add "x" button (delete button)
        let button = UIButton(type: .system)
        let deleteImage = UIImage(systemName: "xmark") // use system icon
        button.setImage(deleteImage, for: .normal)
        button.tintColor = UIColor.label //color
        button.frame = CGRect(x: cell.bounds.width - 30, y: 10, width: 20, height: 20) //size and positioning
        button.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
        button.tag = indexPath.section //add entry tag so we can use for later
        cell.addSubview(button)
        
        return cell
    }
    
    func setBorderColor(entryMood:String) -> CGColor { //set border color 
        switch entryMood{
        case "Unhappy":
           return UIColor.systemRed.cgColor
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
